USE [TestDB]
GO


--	Zadanie:
--
--	Przygotowa� zestawienie, kt�re prezentuje koszty wygenerowane przez wybranego pracownika oraz wszystkich jego podw�adnych
	--
	--	zestawienie mam prezentowa�: sum� TOTAL wszystkich koszt�w
	--	sum� w podziale na daty
	--	sum� w podziale na dat� i pracownika (Id + Nazwa)

------------------------------------------------------------------

--	Problem 1: wybieramy Kierownika A, jak wybra� wszystkich jego podw�adnych?

--	Propozycja 1a:
--	osobne zapytanie dla ka�dego poziomu:
--	(na dole opisane, dlaczgo to nie jest fajne rozwi�zanie)

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	WHERE e1.[EmpName] = 'Kierownik Zespo�u A'

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	WHERE e2.[EmpName] = 'Kierownik Zespo�u A'

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	INNER JOIN [dbo].[Employees] AS e3 ON [e2].[ParentEmpId] = e3.[EmpId]
	WHERE e3.[EmpName] = 'Kierownik Zespo�u A'

------------------------------------------------------------------

--	��czymy ze sob� za pomoc� UNION ALL

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	WHERE e1.[EmpName] = 'Kierownik Zespo�u A'

	UNION ALL

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	WHERE e2.[EmpName] = 'Kierownik Zespo�u A'

	UNION ALL

	SELECT e1.*
	FROM [dbo].[Employees] AS e1
	INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
	INNER JOIN [dbo].[Employees] AS e3 ON [e2].[ParentEmpId] = e3.[EmpId]
	WHERE e3.[EmpName] = 'Kierownik Zespo�u A'

	
------------------------------------------------------------------

--	zrzucamy do tabelki tymczasowej

	SELECT ua.*
	INTO #EmpsA
	FROM 
	(
		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		WHERE e1.[EmpName] = 'Kierownik Zespo�u A'

		UNION ALL

		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
		WHERE e2.[EmpName] = 'Kierownik Zespo�u A'

		UNION ALL

		SELECT e1.*
		FROM [dbo].[Employees] AS e1
		INNER JOIN [dbo].[Employees] AS e2 ON [e1].[ParentEmpId] = e2.[EmpId]
		INNER JOIN [dbo].[Employees] AS e3 ON [e2].[ParentEmpId] = e3.[EmpId]
		WHERE e3.[EmpName] = 'Kierownik Zespo�u A'
	) AS ua

------------------------------------------------------------------
	
	--	sprawdzamy czy jest lista

	SELECT *
	FROM [dbo].[Costs] AS c
	WHERE c.[EmpId] IN (SELECT [EmpId] FROM [#EmpsA])

--	wady rozwi�zania:

--	1/ du�o kodowania, gdyby by�o tam 7-8 poziom�w to kod si� rozlezie na dwa ekrany
--	2/ musimy wiedzie� ile jest poziom�w hierarchii, jak dojd� nowe - np. sta�y�ci - to trzeba dopisa� do zapytania
	--	dobre rozwi�nia powinny by� odporne na takie sytuacje
--	3/ �atwo o pomy�k� przepisuj�c t� sam� logik� ��czenia kilka razy

--	... og�lnie, jest to brzydkie ...