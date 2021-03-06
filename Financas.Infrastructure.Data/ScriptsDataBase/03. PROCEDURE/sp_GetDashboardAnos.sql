USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetDashboardMeses]    Script Date: 21/01/2017 14:51:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[sp_GetDashboardAnos] -- 1, 2014, 2017
(
	@UsuarioId		INT,
	@AnoInicial		INT,
	@AnoFinal		INT
) 

AS

CREATE TABLE #tbAnos
(
	Ano		INT,
	Tipo    CHAR(1),
	Total NUMERIC(18,2)
)
CREATE INDEX IDX_TEMP ON #tbAnos(Ano)

INSERT INTO #tbAnos
SELECT YEAR(l.lanc_data) AS Ano, l.lanc_tipo, SUM(l.lanc_valor) AS Total
FROM tb_lancamento l
WHERE l.usu_id = @UsuarioId AND
	  YEAR(l.lanc_data) >= @AnoInicial AND
	  YEAR(l.lanc_data) <= @AnoFinal 
GROUP BY YEAR(l.lanc_data), l.lanc_tipo

CREATE TABLE #tbDashboardAnos
(
	Ano			INT,
	Receita     NUMERIC(18,2),
	Despesa		NUMERIC(18,2)
)

CREATE INDEX IDX_TEMP ON #tbDashboardAnos(Ano)

DECLARE @Ano INT = @AnoInicial;
DECLARE @ReceitaAno NUMERIC(18,2);
DECLARE @DespesaAno NUMERIC(18,2);

WHILE @Ano <= @AnoFinal
BEGIN
	SET @ReceitaAno = ISNULL((SELECT Total FROM #tbAnos WHERE Ano = @Ano AND Tipo = 'R'),0)
	SET @DespesaAno = ISNULL((SELECT Total FROM #tbAnos WHERE Ano = @Ano AND Tipo = 'D'),0)

	INSERT INTO #tbDashboardAnos (Ano, Receita, Despesa) VALUES (@Ano, @ReceitaAno, @DespesaAno)

    SET @Ano = @Ano + 1;
END;

SELECT Ano, Receita, Despesa FROM #tbDashboardAnos

 
DROP TABLE #tbAnos
DROP TABLE #tbDashboardAnos


