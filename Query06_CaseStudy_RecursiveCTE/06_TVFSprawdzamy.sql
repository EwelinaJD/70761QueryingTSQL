USE [TestDB]
GO

--	sprawdzamy czy dzia�a
--	wywo�uj�c funkcj� z r�nymi parametrami (pracownikiem startowym)

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