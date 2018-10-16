USE [TestDB]
GO

--	W systemie do analizy koszt�w dane trzymane s� w 3 tabelach
--		Pracownicy - wraz z informacj� o prze�o�onym: ParentEmpId
--		Zespo�y
--		Koszty	- ka�dorazowe zdarzenie powstania koszt�w jest przypisane do daty oraz pracownika
------------------------------------------------------------------

CREATE TABLE [dbo].[Employees]
(
	EmpId		INT
,	EmpName		VARCHAR(30)
,	UnitId		INT
,	ParentEmpId	INT
)

CREATE TABLE [dbo].[Units]
(
	UnitId		INT
,	UnitName	VARCHAR(30)
,	ParentEmpId	INT
)

CREATE TABLE [dbo].[Costs]
(
	CostId				INT	IDENTITY(1,1)
,	DateId				DATE 
,	EmpId				INT
,	CostDescription		VARCHAR(200)
,	CostValue			FLOAT
)