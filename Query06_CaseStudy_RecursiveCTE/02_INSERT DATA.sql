USE [TestDB]
GO

--	³adujemy przyk³adowe dane:
--		Dwa zespo³y w dyrekcji
--		Ka¿y zespó³ podzielony jest na sekcje, zespo³em zrz¹dza kierownik, sekcj¹ koordynator
--		³adujemy testowe dane za dwa miesi¹ce Sty/Lut 2017

--		wa¿ne:
--		koszty mog¹ byæ przypisane na ka¿dym poziomie, tzn: do dyrektora/kierownika/koordynatora/szeregowego pracownika

INSERT INTO [dbo].[Units]
(
	UnitId		
,	UnitName	
,	ParentEmpId	
)
VALUES
(	1,	'Dyrekcja'	,	NULL),
(	2,	'Zespó³ A'	,	1),
(	3,	'Zespó³ B'	,	1)

GO


INSERT INTO [dbo].[Employees]
(
	EmpId		
,	EmpName		
,	UnitId		
,	ParentEmpId	
)
VALUES
(	1,	'Dyrektor'					,	1	,	NULL	),
(	2,	'Kierownik Zespo³u A'		,	2	,	1		),
(	3,	'Kierownik Zespo³u B'		,	3	,	1		),
(	4,	'Koordynator Sekcji A1'		,	2	,	2		),
(	5,	'Koordynator Sekcji A2'		,	2	,	2		),
(	6,	'Koordynator Sekcji B1'		,	3	,	3		),
(	7,	'Pracownik Szeregowy A1_01'	,	2	,	4		),
(	8,	'Pracownik Szeregowy A1_02'	,	2	,	4		),
(	9,	'Pracownik Szeregowy A1_03'	,	2	,	4		),
(	10,	'Pracownik Szeregowy A1_04'	,	2	,	4		),
(	11,	'Pracownik Szeregowy A1_05'	,	2	,	4		),
(	12,	'Pracownik Szeregowy A2_01'	,	2	,	5		),
(	13,	'Pracownik Szeregowy A2_02'	,	2	,	5		),
(	14,	'Pracownik Szeregowy A2_03'	,	2	,	5		),
(	15,	'Pracownik Szeregowy A2_04'	,	2	,	5		),
(	16,	'Pracownik Szeregowy A2_05'	,	2	,	5		),
(	17,	'Pracownik Szeregowy B1_01'	,	3	,	6		),
(	18,	'Pracownik Szeregowy B1_02'	,	3	,	6		),
(	19,	'Pracownik Szeregowy B1_03'	,	3	,	6		)
GO

INSERT INTO [dbo].[Costs]
(
	DateId				
,	EmpId				
,	CostDescription		
,	CostValue			
)
VALUES
(	'20170101', 1	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Dyrektor'					,	13000	),
(	'20170101', 2	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Kierownik Zespo³u A'			,	8500	),
(	'20170101', 3	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Kierownik Zespo³u B'			,	8500	),
(	'20170101', 4	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator A1'				,	5900	),
(	'20170101', 5	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator A2'				,	6500	),
(	'20170101', 6	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Koordynator B1'				,	6000	),
(	'20170101', 7	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_01'	,	4000	),
(	'20170101', 8	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_02'	,	4200	),
(	'20170101', 9	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_03'	,	4200	),
(	'20170101', 10	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_04'	,	4200	),
(	'20170101', 11	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A1_05'	,	4200	),
(	'20170101', 12	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_01'	,	4000	),
(	'20170101', 13	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_02'	,	4300	),
(	'20170101', 14	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_03'	,	4300	),
(	'20170101', 15	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_04'	,	4300	),
(	'20170101', 16	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy A2_05'	,	4000	),
(	'20170101', 17	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_01'	,	4000	),
(	'20170101', 18	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_02'	,	4500	),
(	'20170101', 19	,	'Wynagrodzenie Podstawowe,Styczeñ2017, Pracownik Szeregowy B1_03'	,	4500	),

(	'20170101', 1	,	'Bonus,Styczeñ2017, Dyrektor'					,	2000	),
(	'20170101', 2	,	'Bonus,Styczeñ2017, Kierownik Zespo³u A'		,	1000	),
(	'20170101', 3	,	'Bonus,Styczeñ2017, Kierownik Zespo³u B'		,	1000	),
(	'20170101', 4	,	'Bonus,Styczeñ2017, Koordynator A1'				,	750		),
(	'20170101', 5	,	'Bonus,Styczeñ2017, Koordynator A2'				,	750		),
(	'20170101', 6	,	'Bonus,Styczeñ2017, Koordynator B1'				,	750		),
(	'20170101', 7	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_01'	,	350		),
(	'20170101', 8	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_02'	,	350		),
(	'20170101', 9	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_03'	,	350		),
(	'20170101', 10	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_04'	,	350		),
(	'20170101', 11	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A1_05'	,	350		),
(	'20170101', 12	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_01'	,	350		),
(	'20170101', 13	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_02'	,	350		),
(	'20170101', 14	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_03'	,	350		),
(	'20170101', 15	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_04'	,	350		),
(	'20170101', 16	,	'Bonus,Styczeñ2017, Pracownik Szeregowy A2_05'	,	350		),
(	'20170101', 17	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_01'	,	350		),
(	'20170101', 18	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_02'	,	350		),
(	'20170101', 19	,	'Bonus,Styczeñ2017, Pracownik Szeregowy B1_03'	,	350		),

(	'20170101', 1	,	'Koszty Dyrekcji'							,	10000	),
(	'20170101', 1	,	'Koszty Wynajmu Biura'						,	20000	),
(	'20170101', 2	,	'Koszty Wspólne Zespo³u A'					,	10000	),
(	'20170101', 3	,	'Koszty Wspólne Zespo³u B'					,	10000	),
(	'20170101', 4	,	'Koszty Wspólne Sekcji - Koordynator A1'	,	10000	),
(	'20170101', 5	,	'Koszty Wspólne Sekcji - Koordynator A2'	,	10000	),
(	'20170101', 6	,	'Koszty Wspólne Sekcji - Koordynator B1'	,	10000	)
GO

INSERT INTO [dbo].[Costs]
(
	DateId				
,	EmpId				
,	CostDescription		
,	CostValue			
)
VALUES
(	'20170201', 1	,	'Wynagrodzenie Podstawowe,Luty2017, Dyrektor'					,	13000	),
(	'20170201', 2	,	'Wynagrodzenie Podstawowe,Luty2017, Kierownik Zespo³u A'		,	8500	),
(	'20170201', 3	,	'Wynagrodzenie Podstawowe,Luty2017, Kierownik Zespo³u B'		,	8500	),
(	'20170201', 4	,	'Wynagrodzenie Podstawowe,Luty2017, Koordynator A1'				,	5900	),
(	'20170201', 5	,	'Wynagrodzenie Podstawowe,Luty2017, Koordynator A2'				,	6500	),
(	'20170201', 6	,	'Wynagrodzenie Podstawowe,Luty2017, Koordynator B1'				,	6000	),
(	'20170201', 7	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A1_01'	,	4000	),
(	'20170201', 8	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A1_02'	,	4200	),
(	'20170201', 9	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A1_03'	,	4200	),
(	'20170201', 10	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A1_04'	,	4200	),
(	'20170201', 11	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A1_05'	,	4200	),
(	'20170201', 12	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A2_01'	,	4000	),
(	'20170201', 13	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A2_02'	,	4300	),
(	'20170201', 14	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A2_03'	,	4300	),
(	'20170201', 15	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A2_04'	,	4300	),
(	'20170201', 16	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy A2_05'	,	4000	),
(	'20170201', 17	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy B1_01'	,	4000	),
(	'20170201', 18	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy B1_02'	,	4500	),
(	'20170201', 19	,	'Wynagrodzenie Podstawowe,Luty2017, Pracownik Szeregowy B1_03'	,	4500	),

(	'20170201', 1	,	'Bonus,Luty2017, Dyrektor'					,	2500	),
(	'20170201', 2	,	'Bonus,Luty2017, Kierownik Zespo³u A'		,	1500	),
(	'20170201', 3	,	'Bonus,Luty2017, Kierownik Zespo³u B'		,	1500	),
(	'20170201', 4	,	'Bonus,Luty2017, Koordynator A1'			,	200		),
(	'20170201', 5	,	'Bonus,Luty2017, Koordynator A2'			,	200		),
(	'20170201', 6	,	'Bonus,Luty2017, Koordynator B1'			,	200		),
(	'20170201', 7	,	'Bonus,Luty2017, Pracownik Szeregowy A1_01'	,	200		),
(	'20170201', 8	,	'Bonus,Luty2017, Pracownik Szeregowy A1_02'	,	200		),
(	'20170201', 9	,	'Bonus,Luty2017, Pracownik Szeregowy A1_03'	,	200		),
(	'20170201', 10	,	'Bonus,Luty2017, Pracownik Szeregowy A1_04'	,	200		),
(	'20170201', 11	,	'Bonus,Luty2017, Pracownik Szeregowy A1_05'	,	200		),
(	'20170201', 12	,	'Bonus,Luty2017, Pracownik Szeregowy A2_01'	,	200		),
(	'20170201', 13	,	'Bonus,Luty2017, Pracownik Szeregowy A2_02'	,	200		),
(	'20170201', 14	,	'Bonus,Luty2017, Pracownik Szeregowy A2_03'	,	200		),
(	'20170201', 15	,	'Bonus,Luty2017, Pracownik Szeregowy A2_04'	,	200		),
(	'20170201', 16	,	'Bonus,Luty2017, Pracownik Szeregowy A2_05'	,	200		),
(	'20170201', 17	,	'Bonus,Luty2017, Pracownik Szeregowy B1_01'	,	200		),
(	'20170201', 18	,	'Bonus,Luty2017, Pracownik Szeregowy B1_02'	,	200		),
(	'20170201', 19	,	'Bonus,Luty2017, Pracownik Szeregowy B1_03'	,	200		),

(	'20170201', 1	,	'Koszty Dyrekcji'							,	11000	),
(	'20170201', 1	,	'Koszty Wynajmu Biura'						,	21000	),
(	'20170201', 2	,	'Koszty Wspólne Zespo³u A'					,	11000	),
(	'20170201', 3	,	'Koszty Wspólne Zespo³u B'					,	11000	),
(	'20170201', 4	,	'Koszty Wspólne Sekcji - Koordynator A1'	,	11000	),
(	'20170201', 5	,	'Koszty Wspólne Sekcji - Koordynator A2'	,	11000	),
(	'20170201', 6	,	'Koszty Wspólne Sekcji - Koordynator B1'	,	11000	)
GO