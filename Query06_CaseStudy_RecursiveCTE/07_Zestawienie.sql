USE [TestDB]
GO

--	Problem 2: mamy list� pracownik�w, trzeba pobra� koszty

--	Funkcje tabelaryczne zachowuj� si� tak samo jak tabele
--	u�ywamy ich w zapytaniach, piszemy JOINy itd...

		SELECT *
		FROM [dbo].[utf_EmployeeList] (2) AS el
		INNER JOIN [dbo].[Costs] AS c ON [c].[EmpId] = [el].[EmpId]

	--------------------------------

--	Teraz wynik trzeba odpowiednio pogrupowa�, zgodnie z wymaganiami z pierszego skryptu:

	--	"	zestawienie mam prezentowa�: sum� TOTAL wszystkich koszt�w
	--		sum� w podziale na daty
	--		sum� w podziale na dat� i pracownika (Id + Nazwa)	"

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

--	...	oznaczy� jako�, kt�rego podzia�u dotycz� konkrente wiersze, posortowa�, ...

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

