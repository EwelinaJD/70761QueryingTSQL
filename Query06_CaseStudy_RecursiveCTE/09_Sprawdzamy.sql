USE [TestDB]
GO

--	sprawdzamy czy dzia�a dla Kierownika zespo�u A:

	SELECT [Aggregation]
		,  [DateId]
		,  [EmpId]
		,  [EmpName]
		,  [CostValue]
	FROM [dbo].[utf_CostReport](2)
	ORDER BY [OrderColumn]

--	sprawdzamy czy dzia�a dla Kierownika zespo�u B:

	SELECT [Aggregation]
		,  [DateId]
		,  [EmpId]
		,  [EmpName]
		,  [CostValue]
	FROM [dbo].[utf_CostReport](3)
	ORDER BY [OrderColumn]