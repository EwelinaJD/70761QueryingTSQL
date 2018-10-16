USE	[ContosoRetailDW]
GO

--	The FOR XML AUTO option gives you nice XML documents with nested elements, and it is not
--	complicated to use. 

--	Each table in the FROM clause, from which at least one column is listed in the SELECT clause, is represented as an XML element. 
--	The columns listed in the SELECT clause are mapped to attributes or subelements, if the optional ELEMENTS option is specified in the FOR XML clause.

	SELECT [AccountLabel]
		,  [AccountName]
		,  [AccountDescription]
		,  [AccountType]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	;

	SELECT [AccountLabel]
		,  [AccountName]
		,  [AccountDescription]
		,  [AccountType]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML AUTO
	;

	SELECT [AccountLabel]			AS [Label]
		,  [AccountName]			AS [Name]
		,  [AccountDescription]		AS [Description]
		,  [AccountType]			AS [Type]
	FROM [dbo].[DimAccount] AS [Account]
	WHERE [AccountType] = 'Expense'
	FOR XML AUTO, ROOT('Accounts')
	;

-----------------------------------------------------------------

	SELECT 
		[p].[ProductLabel]
	,	[p].[ProductName]
	,	[p].[Manufacturer]
	,	[s].[ProductSubcategoryLabel]
	,	[s].[ProductSubcategoryName]
	FROM 
				[dbo].[DimProduct] AS p
	INNER JOIN	[dbo].[DimProductSubcategory] AS s ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	WHERE	[BrandName] = 'Litware'
	FOR XML AUTO, ROOT('Products')

	SELECT 
		[p].[ProductLabel]
	,	[p].[ProductName]
	,	[p].[Manufacturer]
	,	[s].[ProductSubcategoryLabel]
	,	[s].[ProductSubcategoryName]
	FROM 
				[dbo].[DimProductSubcategory] AS s
	INNER JOIN	[dbo].[DimProduct] AS p ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	WHERE	[BrandName] = 'Litware'
	FOR XML AUTO, ROOT('Products')
	
	SELECT 
		[s].[ProductSubcategoryLabel]
	,	[s].[ProductSubcategoryName]
	,	[p].[ProductLabel]
	,	[p].[ProductName]
	,	[p].[Manufacturer]
	FROM 
				[dbo].[DimProduct] AS p
	INNER JOIN	[dbo].[DimProductSubcategory] AS s ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	WHERE	[BrandName] = 'Litware'
	FOR XML AUTO, ROOT('Products')
