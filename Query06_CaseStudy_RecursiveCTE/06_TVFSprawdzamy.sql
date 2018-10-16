USE [TestDB]
GO

--	sprawdzamy czy dzia³a
--	wywo³uj¹c funkcjê z ró¿nymi parametrami (pracownikiem startowym)

	SELECT *
	FROM [dbo].[utf_EmployeeList] (1)
	GO

	SELECT *
	FROM [dbo].[utf_EmployeeList] (2)
	GO

	SELECT *
	FROM [dbo].[utf_EmployeeList] (3)
	GO

	SELECT *
	FROM [dbo].[utf_EmployeeList] (5)
	GO