USE TestDB
GO

----------------------------------------------------------------
--	Odpytanie testowe danych
----------------------------------------------------------------

	SELECT TOP 2 * FROM [dbo].[DimDate]
	SELECT TOP 2 * FROM [dbo].[FactActuals]
	SELECT TOP 2 * FROM [dbo].[FactBudget]
	SELECT TOP 2 * FROM [dbo].[FactTarget]

----------------------------------------------------------------
--	Dane s¹ na ró¿nej granulacji
----------------------------------------------------------------

	SELECT [dd].[MonthLabel]
        ,  [dd].[QuarterLabel]
        ,  [dd].[YearLabel]
        ,  [fa].[Amount]	AS [AmountActuals]
        ,  [fb].[Amount]	AS [AmountBudget]
        ,  [ft].[Amount]	AS [AmountTarget]
	FROM 
				[dbo].[DimDate]		AS dd
	INNER JOIN	[dbo].[FactActuals]	AS fa	ON [fa].[MonthKey]		= [dd].[MonthKey]
	INNER JOIN	[dbo].[FactBudget]	AS fb	ON [fb].[QuarterKey]	= [dd].[QuarterKey]
	INNER JOIN	[dbo].[FactTarget]	AS ft	ON [ft].[YearKey]		= [dd].[YearKey]

----------------------------------------------------------------
--	JOIN na wy¿szych poziomach hierarchii powoduje rozmno¿eni, 
--	widaæ to dobrze po zsumowaniu wyników
----------------------------------------------------------------

	SELECT 
		[dd].[YearLabel]
	,	SUM([fa].[Amount])	AS [AmountActuals]
	,	SUM([fb].[Amount])	AS [AmountBudget]
	,	SUM([ft].[Amount])	AS [AmountTarget]
	FROM 
				[dbo].[DimDate]		AS dd
	INNER JOIN	[dbo].[FactActuals]	AS fa	ON [fa].[MonthKey]		= [dd].[MonthKey]
	INNER JOIN	[dbo].[FactBudget]	AS fb	ON [fb].[QuarterKey]	= [dd].[QuarterKey]
	INNER JOIN	[dbo].[FactTarget]	AS ft	ON [ft].[YearKey]		= [dd].[YearKey]
	GROUP BY 
		[dd].[YearLabel]