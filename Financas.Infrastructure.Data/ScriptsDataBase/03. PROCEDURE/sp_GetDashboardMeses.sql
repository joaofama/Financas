USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRelatorioLancamentosPeriodo]    Script Date: 21/01/2017 01:14:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[sp_GetDashboardMeses]  --1, 2016
(
	@UsuarioId   INT,
	@Ano		 INT
) 

AS



CREATE TABLE #tbMeses
(
	Mes		INT,
	Tipo    CHAR(1),
	Total NUMERIC(18,2)
)
CREATE INDEX IDX_TEMP ON #tbMeses(Mes)

INSERT INTO #tbMeses
SELECT MONTH(l.lanc_data) AS Mes, l.lanc_tipo, SUM(l.lanc_valor) AS Total
FROM tb_lancamento l
WHERE l.usu_id = @UsuarioId AND
	  YEAR(l.lanc_data) = @Ano
GROUP BY MONTH(l.lanc_data), l.lanc_tipo

CREATE TABLE #tbDashboardMeses
(
	Mes			INT,
	Receita     NUMERIC(18,2),
	Despesa		NUMERIC(18,2)
)

CREATE INDEX IDX_TEMP ON #tbDashboardMeses(Mes)

DECLARE @Mes INT = 1;
DECLARE @ReceitaMes NUMERIC(18,2);
DECLARE @DespesaMes NUMERIC(18,2);

WHILE @Mes < 13
BEGIN
	SET @ReceitaMes = ISNULL((SELECT Total FROM #tbMeses WHERE Mes = @Mes AND Tipo = 'R'),0)
	SET @DespesaMes = ISNULL((SELECT Total FROM #tbMeses WHERE Mes = @Mes AND Tipo = 'D'),0)

	INSERT INTO #tbDashboardMeses (Mes, Receita, Despesa) VALUES (@Mes, @ReceitaMes, @DespesaMes)

    SET @Mes = @Mes + 1;
END;

SELECT Mes, Receita, Despesa FROM #tbDashboardMeses

 
DROP TABLE #tbMeses
DROP TABLE #tbDashboardMeses


