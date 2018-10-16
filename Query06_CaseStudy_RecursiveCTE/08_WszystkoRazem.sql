USE [TestDB]
GO

--	³¹czymy wszystko w ca³oœæ i zapisujemy w postaci funkcji:

--	uwaga: tworz¹c widok/funkcjê nie mo¿emy u¿yæ w œrodku ORDER BY
--	wyniki nie bêd¹ posortowane
--	¿eby to jakoœ obejœæ dorzucamy kolumnê [OrderColumn], która oznaczy wiersze w odpowiedniej kolejnoœci
--	kolumny u¿yjemy na nastêpnym skrypcie i posortujemy dane po ich odczytaniu z funkcji

IF OBJECT_ID('dbo.utf_CostReport') IS NOT NULL DROP FUNCTION [dbo].[utf_CostReport]
GO

CREATE FUNCTION [dbo].[utf_CostReport] (@RootEmpId INT)
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
	SELECT
		[Aggregation]	=	CASE GROUPING_ID([c].[DateId],  [el].[EmpId],  [el].[EmpName])
								WHEN 7	THEN	'TOTAL'
								WHEN 3	THEN	'ByDate'
								WHEN 0	THEN	'---'
								END
	,	[DateId]		=	[c].[DateId]	
	,	[EmpId]			=	[el].[EmpId]	
	,	[EmpName]		=	[el].[EmpName]	
	,	[CostValue]		=	SUM([c].[CostValue])	
	,	[OrderColumn]	=	ROW_NUMBER() OVER (ORDER BY	GROUPING_ID(	[c].[DateId]
																	,	[el].[EmpId]
																	,	[el].[EmpName]
																	) DESC, 
														[c].[DateId]	ASC, 
														[el].[EmpId]	ASC	
														)
	FROM
				CTE AS [el]
	INNER JOIN	[dbo].[Costs] AS [c] ON [c].[EmpId] = [el].[EmpId]
	GROUP BY GROUPING SETS(		()
							,	([c].[DateId])
							,	([c].[DateId],  [el].[EmpId],  [el].[EmpName])
							)
GO

