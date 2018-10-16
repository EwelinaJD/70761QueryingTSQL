USE [TestDB]
GO

--	Propozycja 1b:
--	CTE rekurencyjne

--	pierwsza cz�� zapytania, to pracownik od kt�rego chcemy zacz��
--	druga cz�� to zapytanie rekurencyjne, jest wywo�ane kilkukrotnie

--	w tym przypadku
	--	pierwsza cz�� zwraca jednego kierownika
	--	recursive #1, dla kierownika zwraca jego podw�adnych (koordynator�w)
	--	recursive #2, dla wyniku recursive #1 robi to samo, czyli szuka pod�adnych koordynator�w
	--	recursive #3, dla szeregowych pracowink�w nie ma ju� podw�adnych ... koniec

	WITH CTE
	AS
	(
		--	{anchor: cz�� sta�a CTE}
		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		WHERE e1.[EmpName] = 'Kierownik Zespo�u A'

		UNION ALL
		--	{recursive: cz�� iteracyjna CTE}
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
	--	informacj� o pracowniku od kt�rego zaczynamy [RootEmpId]
	--	poziom w hierarchii, zwi�kszamy o 1 za ka�dym wywo�aniem cz�ci recursive

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
		WHERE e1.[EmpName] = 'Kierownik Zespo�u A'

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