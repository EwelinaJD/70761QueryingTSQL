USE [TestDB]
GO

--	Problem 2: mamy listê pracowników, trzeba pobraæ koszty

--	Funkcje tabelaryczne zachowuj¹ siê tak samo jak tabele
--	u¿ywamy ich w zapytaniach, piszemy JOINy itd...

		SELECT *
		FROM [dbo].[utf_EmployeeList] (2) AS el
		INNER JOIN [dbo].[Costs] AS c ON [c].[EmpId] = [el].[EmpId]

	--------------------------------

--	Teraz wynik trzeba odpowiednio pogrupowaæ, zgodnie z wymaganiami z pierszego skryptu:

	--	"	zestawienie mam prezentowaæ: sumê TOTAL wszystkich kosztów
	--		sumê w podziale na daty
	--		sumê w podziale na datê i pracownika (Id + Nazwa)	"

		SELECT
			[c].[DateId]
		,   [el].[EmpId]
		,   [el].[EmpName]
		,   SUM([c].[CostValue])
		,	GROUPING_ID([c].[DateId],  [el].[EmpId],  [el].[EmpName])
		FROM
					[dbo].[utf_EmployeeList] (2)	AS [el]
		INNER JOIN	[dbo].[Costs]					AS [c] ON [c].[EmpId] = [el].[EmpId]
		GROUP BY GROUPING SETS(		()
								,	([c].[DateId])
								,	([c].[DateId],  [el].[EmpId],  [el].[EmpName])
								)

	--------------------------------

--	...	oznaczyæ jakoœ, którego podzia³u dotycz¹ konkrente wiersze, posortowaæ, ...

		SELECT
			CASE GROUPING_ID([c].[DateId],  [el].[EmpId],  [el].[EmpName])
				WHEN 7	THEN	'TOTAL'
				WHEN 3	THEN	'ByDate'
				WHEN 0	THEN	'---'
				END		AS [Aggregation]
		,	[c].[DateId]	
		,   [el].[EmpId]	
		,   [el].[EmpName]	
		,   SUM([c].[CostValue])
		FROM
					[dbo].[utf_EmployeeList] (2) AS [el]
		INNER JOIN	[dbo].[Costs] AS [c] ON [c].[EmpId] = [el].[EmpId]
		GROUP BY GROUPING SETS(		()
								,	([c].[DateId])
								,	([c].[DateId],  [el].[EmpId],  [el].[EmpName])
								)
		ORDER BY	GROUPING_ID(	[c].[DateId]
								,	[el].[EmpId]
								,	[el].[EmpName]
								) DESC, 
					DateId ASC, 
					EmpId ASC	

