USE [TestDB]
GO

--	Propozycja 1b:
--	CTE rekurencyjne

--	pierwsza czêœæ zapytania, to pracownik od którego chcemy zacz¹æ
--	druga czêœæ to zapytanie rekurencyjne, jest wywo³ane kilkukrotnie

--	w tym przypadku
	--	pierwsza czêœæ zwraca jednego kierownika
	--	recursive #1, dla kierownika zwraca jego podw³adnych (koordynatorów)
	--	recursive #2, dla wyniku recursive #1 robi to samo, czyli szuka pod³adnych koordynatorów
	--	recursive #3, dla szeregowych pracowinków nie ma ju¿ podw³adnych ... koniec

	WITH CTE
	AS
	(
		--	{anchor: czêœæ sta³a CTE}
		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		WHERE e1.[EmpName] = 'Kierownik Zespo³u A'

		UNION ALL
		--	{recursive: czêœæ iteracyjna CTE}
		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		INNER JOIN CTE AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	)
	SELECT [c].[ParentEmpId]
		,  [c].[UnitId]
		,  [c].[EmpName]
		,  [c].[EmpId]
	FROM CTE AS c
	GO

----------------------------------------------------------------

	--	dorzucamy dwie kolumny:
	--	informacjê o pracowniku od którego zaczynamy [RootEmpId]
	--	poziom w hierarchii, zwiêkszamy o 1 za ka¿dym wywo³aniem czêœci recursive

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
		WHERE e1.[EmpName] = 'Kierownik Zespo³u A'

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