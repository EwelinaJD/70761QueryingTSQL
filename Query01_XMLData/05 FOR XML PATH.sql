USE	[ContosoRetailDW]
GO

--	With the last two flavors of the FOR XML clause —the EXPLICIT and PATH options—you can
--	manually define the XML returned. With these two options, you have total control of the
--	XML document returned. The EXPLICIT mode is included for backward compatibility only;
--	it uses proprietary T-SQL syntax for formatting XML. The PATH mode uses standard XML
--	XPath expressions to define the elements and attributes of the XML you are creating.

--	Provides a simpler way to mix elements and attributes, and to introduce additional nesting for representing complex properties. 
--	You can use FOR XML EXPLICIT mode queries to construct this kind of XML from a rowset, 
--	but the PATH mode provides a simpler alternative to the possibly cumbersome EXPLICIT mode queries. 
--	PATH mode, together with the ability to write nested FOR XML queries and the TYPE directive to return xml type instances, 
--	allows you to write queries with less complexity. It provides an alternative to writing most EXPLICIT mode queries. 
--	By default, PATH mode generates a <row> element wrapper for each row in the result set. 
--	You can optionally specify an element name. If you do, the specified name is used as the wrapper element name. 
--	IF you provide an empty string (FOR XML PATH ('')), no wrapper element is generated. For more information, see Use PATH Mode with FOR XML.

	SELECT [AccountLabel]			AS [Label]
		,  [AccountName]			AS [Name]
		,  [AccountDescription]		AS [Description]
		,  [AccountType]			AS [Type]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML PATH
	;

	SELECT [AccountLabel]			AS [@Label]
		,  [AccountName]			AS [@Name]
		,  [AccountDescription]		AS [@Description]
		,  [AccountType]			AS [@Type]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML PATH
	;
	
	SELECT [AccountLabel]			AS [@Label]
		,  [AccountName]			AS [@Name]
		,  [AccountDescription]		AS [Description]
		,  [AccountType]			AS [Type]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML PATH
	;
	
	SELECT [AccountLabel]			AS [@Label]
		,  [AccountName]			AS [@Name]
		,  [AccountDescription]		AS [Description]
		,  [AccountType]			AS [Type]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML PATH('Account'), ROOT('Accounts')
	;
	
	SELECT [AccountLabel]			AS [@Label]
		,  [AccountName]			AS [@Name]
		,  [AccountDescription]		AS [Attributes/Description]
		,  [AccountType]			AS [Attributes/Type]
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML PATH('Account'), ROOT('Accounts')
	;

	SELECT TOP 3
		[AccountKey]			AS [@AccountKey]
    ,	[AccountLabel]			AS [AccountLabel]
    ,	[AccountName]			AS [AccountName]
    ,	[AccountDescription]	AS [Additional/AccountDescription]
    ,	[AccountType]			AS [Additional/AccountType]		
    ,	[Operator]				AS [Additional/Operator]			
    ,	[CustomMembers]			AS [Additional/CustomMembers]		
    ,	[ValueType]				AS [Additional/ValueType]			
    ,	[CustomMemberOptions]	AS [Additional/CustomMemberOptions]
    ,	[ETLLoadID]				AS [Audit/ETLLoadID]	
    ,	[LoadDate]				AS [Audit/LoadDate]	
    ,	[UpdateDate]			AS [Audit/UpdateDate]	
	FROM [dbo].[DimAccount]
	WHERE [AccountType] = 'Expense'
	FOR XML PATH('Account'), ROOT('Accounts')
	;

--	³¹czenie tekstu za pomoc¹ FOR XML PATH
----------------------------------------------------	
	
	DECLARE @list NVARCHAR(MAX)
	;

	SELECT @list = list
	FROM
	(
		SELECT [AccountLabel] + '; '
		FROM [dbo].[DimAccount]
		WHERE [AccountType] = 'Expense'
		FOR XML PATH('')
	)	AS a(list)
	;

	PRINT @list
	;

