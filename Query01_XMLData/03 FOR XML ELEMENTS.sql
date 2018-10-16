USE	[ContosoRetailDW]
GO

--	ELEMENTS
--	If the ELEMENTS option is specified, the columns are returned as subelements. 
--	Otherwise, they are mapped to XML attributes. This option is supported in RAW, AUTO, and PATH modes only. 

--	You can optionally specify XSINIL or ABSENT when you use this directive. 
--	XSINIL specifies that an element that has an xsi:nil attribute set to True be created for NULL column values. 
--	By default or when ABSENT is specified together with ELEMENTS, no elements are created for NULL values. 
--	For a working sample, see Use RAW Mode with FOR XML and Use AUTO Mode with FOR XML.

----------------------------------------------------
--	jedna tabela
----------------------------------------------------

	SELECT	[AccountLabel]
		,	[AccountName]
		,	[AccountDescription]
		,	[AccountType]
		,	[CustomMembers]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	;

	SELECT	[AccountLabel]
		,	[AccountName]
		,	[AccountDescription]
		,	[AccountType]
		,	[CustomMembers]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account'), ROOT('Accounts')
	;

	SELECT	[AccountLabel]
		,	[AccountName]
		,	[AccountDescription]
		,	[AccountType]
		,	ISNULL([CustomMembers], '') AS [CustomMembers]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account'), ROOT('Accounts')
	;

	SELECT	[AccountLabel]
		,	[AccountName]
		,	[AccountDescription]
		,	[AccountType]
		,	[CustomMembers]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account'), ROOT('Accounts'), ELEMENTS
	;

	SELECT	[AccountLabel]
		,	[AccountName]
		,	[AccountDescription]
		,	[AccountType]
		,	[CustomMembers]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account'), ROOT('Accounts'), ELEMENTS XSINIL
	;

	SELECT	[AccountLabel]
		,	[AccountName]
		,	[AccountDescription]
		,	[AccountType]
		,	ISNULL([CustomMembers], '') AS [CustomMembers]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	ORDER BY [AccountName]
	FOR XML RAW('Account'), ROOT('Accounts'), ELEMENTS XSINIL
	;


----------------------------------------------------
--	kilka tabel
----------------------------------------------------

	SELECT 
		[p].[ProductLabel]
	,	[p].[ProductName]
	,	[p].[Manufacturer]
	,	[s].[ProductSubcategoryLabel]
	,	[s].[ProductSubcategoryName]
	FROM 
				[dbo].[DimProduct]				AS p
	INNER JOIN	[dbo].[DimProductSubcategory]	AS s ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	WHERE	[BrandName] = 'Litware'
	FOR XML RAW('Product'), ROOT('Products')

	SELECT 
		[p].[ProductLabel]
	,	[p].[ProductName]
	,	[p].[Manufacturer]
	,	[s].[ProductSubcategoryLabel]
	,	[s].[ProductSubcategoryName]
	FROM 
				[dbo].[DimProduct]				AS p
	INNER JOIN	[dbo].[DimProductSubcategory]	AS s ON [s].[ProductSubcategoryKey] = [p].[ProductSubcategoryKey]
	WHERE	[BrandName] = 'Litware'
	FOR XML RAW('Product'), ROOT('Products'), ELEMENTS

	SELECT 
		[product].[ProductLabel]
	,	[product].[ProductName]
	,	[product].[Manufacturer]
	,	[subcat].[ProductSubcategoryLabel]
	,	[subcat].[ProductSubcategoryName]
	FROM 
				[dbo].[DimProduct]				AS product
	INNER JOIN	[dbo].[DimProductSubcategory]	AS subcat ON [subcat].[ProductSubcategoryKey] = [product].[ProductSubcategoryKey]
	WHERE	[BrandName] = 'Litware'
	FOR XML AUTO, ROOT('Products'), ELEMENTS