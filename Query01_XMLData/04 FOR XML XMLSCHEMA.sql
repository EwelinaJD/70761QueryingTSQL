USE	[ContosoRetailDW]
GO
--	In a FOR XML clause, you can request that your query return an inline schema together with the query results. 
--	IF you want an XDR schema, you use the XMLDATA keyword in the FOR XML clause. 
--	IF you want an XSD schema, you use the XMLSCHEMA keyword.

--	https://msdn.microsoft.com/pl-pl/library/ms176009(v=sql.110).aspx
--------------------------------------------------------------------------------------

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
	FOR XML AUTO, ROOT('Products'), XMLSCHEMA('test_schema')

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
	FOR XML AUTO, XMLDATA