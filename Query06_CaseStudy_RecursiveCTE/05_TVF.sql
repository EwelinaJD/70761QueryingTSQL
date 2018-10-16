USE [TestDB]
GO

--	kod bêdzie u¿ywany wielokrotnie
--	wrzucamy go do osobnego obiektu (funkcji) i parametryzujemy

	IF OBJECT_ID('dbo.utf_EmployeeList') IS NOT NULL DROP FUNCTION [dbo].[utf_EmployeeList]
	GO

	CREATE FUNCTION [dbo].[utf_EmployeeList] (@RootEmpId INT)
	RETURNS TABLE
	AS
	RETURN

	WITH CTE
	AS
	(
		SELECT	[e1].[EmpId]	AS [RootEmpId]
			,	1				AS [lvl]
			,	[e1].[EmpId]
			,	[e1].[EmpName]
			,	[e1].[UnitId]
			,	[e1].[ParentEmpId]
		FROM [dbo].[Employees] AS e1
		WHERE e1.[EmpId] = @RootEmpId

		UNION ALL

		SELECT	[e2].[RootEmpId]	AS [RootEmpId]
			,	[e2].[lvl] + 1		AS [lvl]
			,	[e1].[EmpId]
			,	[e1].[EmpName]
			,	[e1].[UnitId]
			,	[e1].[ParentEmpId]
		FROM [dbo].[Employees] AS e1
		INNER JOIN CTE AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	)
	SELECT [c].[RootEmpId]
		,  [c].[lvl]
		,  [c].[EmpId]
		,  [c].[EmpName]
		,  [c].[UnitId]
		,  [c].[ParentEmpId]
	FROM CTE AS c
	GO