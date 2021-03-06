USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetDashboardHomeFluxoCaixa]    Script Date: 20/01/2017 13:24:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[sp_GetDashboardHomeFluxoCaixa] -- 1, 1, 2017
(
	@UsuarioId INT,
	@Mes INT,
	@Ano INT
) 
 

AS 


CREATE TABLE #tbFluxoCaixa
(
	Dia INT,
	Total NUMERIC(18,2)
)



CREATE INDEX IDX_TEMP ON #tbFluxoCaixa(Dia)

INSERT INTO #tbFluxoCaixa
SELECT  Day(l.lanc_data) AS Dia, SUM(l.lanc_valor) AS Total
FROM  dbo.tb_lancamento l
WHERE   l.usu_id = @UsuarioId AND
		Month(l.lanc_data) = @Mes AND
		Year(l.lanc_data) = @Ano AND 
		l.lanc_tipo = 'D'
GROUP BY Day(l.lanc_data) 

DECLARE @cnt INT = 1;

WHILE @cnt < 32
BEGIN
   IF NOT EXISTS(SELECT Dia FROM #tbFluxoCaixa WHERE Dia = @cnt) 
   BEGIN
		INSERT INTO #tbFluxoCaixa (Dia, Total) VALUES (@cnt, 0)
   END
   SET @cnt = @cnt + 1;
END;


SELECT Total FROM #tbFluxoCaixa ORDER BY Dia

-- SELECT * FROM #tbFluxoCaixa
 
DROP TABLE #tbFluxoCaixa

