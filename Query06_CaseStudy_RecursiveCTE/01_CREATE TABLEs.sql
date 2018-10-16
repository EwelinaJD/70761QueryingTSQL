USE [TestDB]
GO

--	W systemie do analizy kosztów dane trzymane s¹ w 3 tabelach
--		Pracownicy - wraz z informacj¹ o prze³o¿onym: ParentEmpId
--		Zespo³y
--		Koszty	- ka¿dorazowe zdarzenie powstania kosztów jest przypisane do daty oraz pracownika
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