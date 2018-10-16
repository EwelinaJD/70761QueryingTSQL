USE	[ContosoRetailDW]
GO

--	FOR XML RAW
--	The first option for creating XML from a query result is the RAW option. The XML created is
--	quite close to the relational (tabular) presentation of the data. In RAW mode, every row from
--	returned rowsets converts to a single element named row, and columns translate to the attributes
--	of this element. Here is an example of an XML document created with the FOR XML RAW option.

--	The FOR XML clause comes after the ORDER BY clause in a query.


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
	FOR XML RAW
	;

	SELECT [AccountLabel]
		,  [AccountName]
		,  [AccountDescription]
		,  [AccountType]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW
	;

	SELECT [AccountLabel]			AS [Label]		
		,  [AccountName]			AS [Name]		
		,  [AccountDescription]		AS [Description]	
		,  [AccountType]			AS [Type]		
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW
	;

	SELECT [AccountLabel]			AS [Label]		
		,  [AccountName]			AS [Name]		
		,  [AccountDescription]		AS [Description]	
		,  [AccountType]			AS [Type]		
	FROM [dbo].[DimAccount] AS [Account]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account')
	;

--	You can enhance the RAW mode by renaming the row element, adding a root element,
--	including namespaces, and making the XML returned element-centric. The following is an
--	example of enhanced XML created with the FOR XML RAW option.

	SELECT [AccountLabel]
		,  [AccountName]
		,  [AccountDescription]
		,  [AccountType]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML RAW, ROOT
	;

	SELECT [AccountLabel]
		,  [AccountName]
		,  [AccountDescription]
		,  [AccountType]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML RAW, ROOT('root_node_name')
	;

	SELECT [AccountLabel]			AS [Label]		
		,  [AccountName]			AS [Name]		
		,  [AccountDescription]		AS [Description]	
		,  [AccountType]			AS [Type]		
	FROM [dbo].[DimAccount] AS [Account]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account'), ROOT('Accounts')
	;

----------------------------------------------------------

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
	FOR XML RAW
	;

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
	FOR XML RAW('Product'), ROOT('Products')
	;
