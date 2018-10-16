USE [TestDB]
GO


--	Zadanie:
--
--	Przygotowaæ zestawienie, które prezentuje koszty wygenerowane przez wybranego pracownika oraz wszystkich jego podw³adnych
	--
	--	zestawienie mam prezentowaæ: sumê TOTAL wszystkich kosztów
	--	sumê w podziale na daty
	--	sumê w podziale na datê i pracownika (Id + Nazwa)

------------------------------------------------------------------

--	Problem 1: wybieramy Kierownika A, jak wybraæ wszystkich jego podw³adnych?

--	Propozycja 1a:
--	osobne zapytanie dla ka¿dego poziomu:
--	(na dole opisane, dlaczgo to nie jest fajne rozwi¹zanie)

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	WHERE e1.[EmpName] = 'Kierownik Zespo³u A'

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	WHERE e2.[EmpName] = 'Kierownik Zespo³u A'

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	INNER JOIN [dbo].[Employees] AS e3 ON [e2].[ParentEmpId] = e3.[EmpId]
	WHERE e3.[EmpName] = 'Kierownik Zespo³u A'

------------------------------------------------------------------

--	³¹czymy ze sob¹ za pomoc¹ UNION ALL

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	WHERE e1.[EmpName] = 'Kierownik Zespo³u A'

	UNION ALL

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	WHERE e2.[EmpName] = 'Kierownik Zespo³u A'

	UNION ALL

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	INNER JOIN [dbo].[Employees] AS e3 ON [e2].[ParentEmpId] = e3.[EmpId]
	WHERE e3.[EmpName] = 'Kierownik Zespo³u A'

	
------------------------------------------------------------------

--	zrzucamy do tabelki tymczasowej

	SELECT ua.*
	INTO #EmpsA
	FROM 
	(
		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		WHERE e1.[EmpName] = 'Kierownik Zespo³u A'

		UNION ALL

		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
		WHERE e2.[EmpName] = 'Kierownik Zespo³u A'

		UNION ALL

		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
		INNER JOIN [dbo].[Employees] AS e3 ON [e2].[ParentEmpId] = e3.[EmpId]
		WHERE e3.[EmpName] = 'Kierownik Zespo³u A'
	) AS ua

------------------------------------------------------------------
	
	--	sprawdzamy czy jest lista

	SELECT *
	FROM [dbo].[Costs] AS c
	WHERE c.[EmpId] IN (SELECT [EmpId] FROM [#EmpsA])

--	wady rozwi¹zania:

--	1/ du¿o kodowania, gdyby by³o tam 7-8 poziomów to kod siê rozlezie na dwa ekrany
--	2/ musimy wiedzieæ ile jest poziomów hierarchii, jak dojd¹ nowe - np. sta¿yœci - to trzeba dopisaæ do zapytania
	--	dobre rozwi¹nia powinny byæ odporne na takie sytuacje
--	3/ ³atwo o pomy³kê przepisuj¹c t¹ sam¹ logikê ³¹czenia kilka razy

--	... ogólnie, jest to brzydkie ...