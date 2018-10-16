USE TestDB
GO

----------------------------------------------------------------
--	Chc�c zestawi� ze sob� wykonanie/bud�et/target na poziomie miesi�cy
--	musimy dane zbiorcze rozbi�, np:
--
--	a)	po r�wno
--	b)	proporcjonalnie uwzgl�dniaj�c liczb� dni w miesi�cu
--	c)	proporcj� wykonania zesz�ego roku/kwarta�u (w rzeczywisto�ci bud�et/target otrzymujemy na pocz�tku, wi�c rozbicie aktualnym mo�e by� niemo�liwe)
--	d)	... dowoln� inn� struktur�, kt�ra wg naszej wiedzy jest odpowiednia dla prowadzonego biznesu
----------------------------------------------------------------

----------------------------------------------------------------	
--	a)	bud�et, po r�wno
----------------------------------------------------------------
	
		SELECT
			[dd].[MonthLabel]
		,	[dd].[QuarterLabel]
		,	[dd].[YearLabel]
		,	[fa].[Amount]		AS [AmountActuals]
		,	[fb].[Amount]/3		AS [AmountBudget]
		FROM 
					[dbo].[DimDate]		AS dd
		INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
		INNER JOIN	[dbo].[FactBudget]	AS fb ON [fb].[QuarterKey]	= [dd].[QuarterKey]
		WHERE dd.[YearKey] = '20170101'
		;

	--	rozwi�zanie ma jeden du�y minus - liczba 3 wpisana na sztywno
	--	o ile przy kwarta�ach zawsze si� sprawdzi, to przy dniach/tygodniach nie podstawimy tak prosto liczby element�w ni�szego elementu hierarchii 
	
		SELECT 
			[dd].[MonthLabel]
		,	[dd].[QuarterLabel]
		,	[dd].[YearLabel]
		,	[AmountActuals]	=	[fa].[Amount]		
		,	[AmountBudget]	=	[fb].[Amount]		
		,	[cnt]			=	COUNT(*)	OVER (PARTITION BY	[fb].[QuarterKey])
		FROM 
					[dbo].[DimDate]		AS dd
		INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
		INNER JOIN	[dbo].[FactBudget]	AS fb ON [fb].[QuarterKey]	= [dd].[QuarterKey]
		WHERE dd.[YearKey] = '20170101'
		;

	--	dodajemy r�nice, zmieniamy formaty liczb, �eby �adniej wygl�da�o

		WITH Cte_bdg
		AS (
				SELECT 
					[dd].[MonthLabel]
				,	[dd].[QuarterLabel]
				,	[dd].[YearLabel]
				,	[AmountActuals]	=	[fa].[Amount]		
				,	[AmountBudget]	=	[fb].[Amount]	/	COUNT(*)	OVER (PARTITION BY	[fb].[QuarterKey])		
				FROM 
							[dbo].[DimDate]		AS dd
				INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
				INNER JOIN	[dbo].[FactBudget]	AS fb ON [fb].[QuarterKey]	= [dd].[QuarterKey]
				WHERE dd.[YearKey] = '20170101'
		)
		SELECT 
			[c].[MonthLabel]
		,	[c].[QuarterLabel]
		,	[c].[YearLabel]
		,	[c].[AmountActuals]
		,	[AmountBudget]	=	CAST([c].[AmountBudget]	AS NUMERIC(10,2))
		,	[Realization]	=	CAST(([c].[AmountActuals]	-	[c].[AmountBudget])							AS NUMERIC(10,2))
		,	[Realization%]	=	CAST(([c].[AmountActuals]	-	[c].[AmountBudget])	/ [c].[AmountBudget]	AS NUMERIC(10,2))
		FROM [Cte_bdg] AS c
		;

----------------------------------------------------------------	
--	b)	proporcjonalnie uwzgl�dniaj�c liczb� dni pracuj�cych w miesi�cu
----------------------------------------------------------------

	--	problem pierwszy, sk�d wzi�� liczb� dni - pomog� funkcje EOMONTH(), DAY()
	--	w wymiarze czasu w hurtowniach kluczami okres�w (miesi�c, tydzie�, kwarta�...) s� zazwyczaj daty pierwszego dnia okresu
	--	... tak jak poni�ej
	--	sprawdzamy ostatni dzien miesiaca, jego numer to ilo�� dni w miesi�cu

			SELECT	
				[dd].[MonthKey]
			,	EOMONTH([dd].[MonthKey])
			,	DAY(EOMONTH([dd].[MonthKey]))
			FROM	[dbo].[DimDate]		AS dd
			WHERE	dd.[YearKey] = '20170101'
			;

	--	dorzucamy kod do zapytania z punktu a)

			SELECT 
				[dd].[MonthLabel]
			,	[dd].[QuarterLabel]
			,	[dd].[YearLabel]
			,	[AmountActuals]	=	[fa].[Amount]		
			,	[AmountBudget]	=	[fb].[Amount]
			,	[DniWMsc]	=	DAY(EOMONTH([dd].[MonthKey]))
			,	[DniWQrt]	=	SUM(DAY(EOMONTH([dd].[MonthKey])))	OVER (PARTITION BY	[dd].[QuarterKey])		
			FROM 
						[dbo].[DimDate]		AS dd
			INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
			INNER JOIN	[dbo].[FactBudget]	AS fb ON [fb].[QuarterKey]	= [dd].[QuarterKey]
			WHERE dd.[YearKey] = '20170101'
			;

	--	i wszystko razem:

		WITH Cte_bdg
		AS (
				SELECT 
					[dd].[MonthLabel]
				,	[dd].[QuarterLabel]
				,	[dd].[YearLabel]
				,	[AmountActuals]	=	[fa].[Amount]		
				,	[AmountBudget]	=	[fb].[Amount]	
										*	DAY(EOMONTH([dd].[MonthKey]))
										/	SUM(DAY(EOMONTH([dd].[MonthKey])))	OVER (PARTITION BY	[dd].[QuarterKey])		
				FROM 
							[dbo].[DimDate]		AS dd
				INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
				INNER JOIN	[dbo].[FactBudget]	AS fb ON [fb].[QuarterKey]	= [dd].[QuarterKey]
				WHERE dd.[YearKey] = '20170101'
		)
		SELECT 
			[c].[MonthLabel]
		,	[c].[QuarterLabel]
		,	[c].[YearLabel]
		,	[c].[AmountActuals]
		,	[AmountBudget]	=	CAST([c].[AmountBudget]	AS NUMERIC(10,2))
		,	[Realization]	=	CAST(([c].[AmountActuals]	-	[c].[AmountBudget])							AS NUMERIC(10,2))
		,	[Realization%]	=	CAST(([c].[AmountActuals]	-	[c].[AmountBudget])	/ [c].[AmountBudget]	AS NUMERIC(10,2))
		FROM [Cte_bdg] AS c

----------------------------------------------------------------
--	c)	proporcj� wykonania zesz�ego roku	- tutaj mo�na podej�� na dwa sposoby:
	--	dzieli� proporcj� poprzedniego kwarta�u - czyli Q2 u�ywamy dla alokacji Q3
	--	dzieli� proporcj� odpowiadaj�cego kwarta�u poprzedniego roku - dzyli Q3 2016 dla Q3 2017
	--	nie ma odpowiedzi co jest lepisze - jak przychody s� r�wno roz�o�one w roku i prognozujemy na kwarta� do przodu to pierwsze wydaje si� dobre
	--	jak w firmie jest mocna sezonowo��, to drugie

	--	myz u�yjemy drugiego
----------------------------------------------------------------

	--	tabela wsp�czynnik�w alokacji:

			SELECT 
				[dd].[MonthKey]
			,	[dd].[QuarterKey]
			,	[dd].[YearKey]
			,	[QrtRatio]	=	[fa].[Amount] / SUM([fa].[Amount])	OVER (	PARTITION BY [dd].[QuarterKey])

			FROM 
						[dbo].[DimDate]		AS dd
			INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
			;

	--	rozdzielamy bud�et:

		WITH cte_coeffs
		AS
		(
			SELECT 
				[dd].[MonthKey]
			,	[dd].[QuarterKey]
			,	[dd].[YearKey]
			,	[QrtRatio]	=	[fa].[Amount] / SUM([fa].[Amount])	OVER (	PARTITION BY [dd].[QuarterKey])

			FROM 
						[dbo].[DimDate]		AS dd
			INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
		)
		SELECT 
			[dd].[MonthLabel]
		,	[dd].[QuarterLabel]
		,	[dd].[YearLabel]
		,	[AmountActuals]	=	[fa].[Amount]		
		,	[AmountBudget]	=	[fb].[Amount]	* co.[QrtRatio]
			
		FROM 
					[dbo].[DimDate]		AS dd
		INNER JOIN	[dbo].[FactActuals] AS fa	ON	[fa].[MonthKey]						=	[dd].[MonthKey]
		INNER JOIN	[dbo].[FactBudget]	AS fb	ON	[fb].[QuarterKey]					=	[dd].[QuarterKey]
		INNER JOIN	cte_coeffs			AS co	ON	DATEADD(YEAR, -1, dd.[MonthKey])	=	co.[MonthKey]	--	<< to jest wa�ne!, join uwzgl�dnia przesuni�cie o rok!
		WHERE dd.[YearKey] = '20170101'
		;

	--	i na koniec raport:

		WITH cte_coeffs
		AS
		(
			SELECT 
				[dd].[MonthKey]
			,	[dd].[QuarterKey]
			,	[dd].[YearKey]
			,	[QrtRatio]	=	[fa].[Amount] / SUM([fa].[Amount])	OVER (	PARTITION BY [dd].[QuarterKey])

			FROM 
						[dbo].[DimDate]		AS dd
			INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
		),
		[Cte_bdg]	
		AS
		(
		SELECT 
			[dd].[MonthLabel]
		,	[dd].[QuarterLabel]
		,	[dd].[YearLabel]
		,	[AmountActuals]	=	[fa].[Amount]		
		,	[AmountBudget]	=	[fb].[Amount]	* co.[QrtRatio]
			
		FROM 
					[dbo].[DimDate]		AS dd
		INNER JOIN	[dbo].[FactActuals] AS fa	ON	[fa].[MonthKey]						=	[dd].[MonthKey]
		INNER JOIN	[dbo].[FactBudget]	AS fb	ON	[fb].[QuarterKey]					=	[dd].[QuarterKey]
		INNER JOIN	cte_coeffs			AS co	ON	DATEADD(YEAR, -1, dd.[MonthKey])	=	co.[MonthKey]	--	<< to jest wa�ne!, join uwzgl�dnia przesuni�cie o rok!
		WHERE dd.[YearKey] = '20170101'
		
		)
		SELECT 
			[c].[MonthLabel]
		,	[c].[QuarterLabel]
		,	[c].[YearLabel]
		,	[c].[AmountActuals]
		,	[AmountBudget]	=	CAST([c].[AmountBudget]	AS NUMERIC(10,2))
		,	[Realization]	=	CAST(([c].[AmountActuals]	-	[c].[AmountBudget])							AS NUMERIC(10,2))
		,	[Realization%]	=	CAST(([c].[AmountActuals]	-	[c].[AmountBudget])	/ [c].[AmountBudget]	AS NUMERIC(10,2))
		FROM [Cte_bdg] AS c