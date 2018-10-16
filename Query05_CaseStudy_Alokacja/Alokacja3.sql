USE TestDB
GO

----------------------------------------------------------------
--	Chc¹c zestawiæ ze sob¹ wykonanie/bud¿et/target na poziomie miesiêcy
--	musimy dane zbiorcze rozbiæ, np:
--
--	a)	po równo
--	b)	proporcjonalnie uwzglêdniaj¹c liczbê dni w miesi¹cu
--	c)	proporcj¹ wykonania zesz³ego roku/kwarta³u (w rzeczywistoœci bud¿et/target otrzymujemy na pocz¹tku, wiêc rozbicie aktualnym mo¿e byæ niemo¿liwe)
--	d)	... dowoln¹ inn¹ struktur¹, która wg naszej wiedzy jest odpowiednia dla prowadzonego biznesu
----------------------------------------------------------------

----------------------------------------------------------------	
--	a)	bud¿et, po równo
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

	--	rozwi¹zanie ma jeden du¿y minus - liczba 3 wpisana na sztywno
	--	o ile przy kwarta³ach zawsze siê sprawdzi, to przy dniach/tygodniach nie podstawimy tak prosto liczby elementów ni¿szego elementu hierarchii 
	
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

	--	dodajemy ró¿nice, zmieniamy formaty liczb, ¿eby ³adniej wygl¹da³o

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
--	b)	proporcjonalnie uwzglêdniaj¹c liczbê dni pracuj¹cych w miesi¹cu
----------------------------------------------------------------

	--	problem pierwszy, sk¹d wzi¹æ liczbê dni - pomog¹ funkcje EOMONTH(), DAY()
	--	w wymiarze czasu w hurtowniach kluczami okresów (miesi¹c, tydzieñ, kwarta³...) s¹ zazwyczaj daty pierwszego dnia okresu
	--	... tak jak poni¿ej
	--	sprawdzamy ostatni dzien miesiaca, jego numer to iloœæ dni w miesi¹cu

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
--	c)	proporcj¹ wykonania zesz³ego roku	- tutaj mo¿na podejœæ na dwa sposoby:
	--	dzieliæ proporcj¹ poprzedniego kwarta³u - czyli Q2 u¿ywamy dla alokacji Q3
	--	dzieliæ proporcj¹ odpowiadaj¹cego kwarta³u poprzedniego roku - dzyli Q3 2016 dla Q3 2017
	--	nie ma odpowiedzi co jest lepisze - jak przychody s¹ równo roz³o¿one w roku i prognozujemy na kwarta³ do przodu to pierwsze wydaje siê dobre
	--	jak w firmie jest mocna sezonowoœæ, to drugie

	--	myz u¿yjemy drugiego
----------------------------------------------------------------

	--	tabela wspó³czynników alokacji:

			SELECT 
				[dd].[MonthKey]
			,	[dd].[QuarterKey]
			,	[dd].[YearKey]
			,	[QrtRatio]	=	[fa].[Amount] / SUM([fa].[Amount])	OVER (	PARTITION BY [dd].[QuarterKey])

			FROM 
						[dbo].[DimDate]		AS dd
			INNER JOIN	[dbo].[FactActuals] AS fa ON [fa].[MonthKey]	= [dd].[MonthKey]
			;

	--	rozdzielamy bud¿et:

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
		INNER JOIN	cte_coeffs			AS co	ON	DATEADD(YEAR, -1, dd.[MonthKey])	=	co.[MonthKey]	--	<< to jest wa¿ne!, join uwzglêdnia przesuniêcie o rok!
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
		INNER JOIN	cte_coeffs			AS co	ON	DATEADD(YEAR, -1, dd.[MonthKey])	=	co.[MonthKey]	--	<< to jest wa¿ne!, join uwzglêdnia przesuniêcie o rok!
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