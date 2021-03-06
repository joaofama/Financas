USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetDashboardTotalizacao]    Script Date: 20/01/2017 23:41:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_GetDashboardHomeTotalizacao] -- 1, 1, 2017
(
	@UsuarioId  INT,
	@Mes		INT,
	@Ano		INT
) 
 
AS

BEGIN

DECLARE 
@SaldoInicial				NUMERIC(18,2),
@TotalReceitas				NUMERIC(18,2),
@TotalDespesas				NUMERIC(18,2),
@SaldoAtual					NUMERIC(18,2)


SELECT @SaldoInicial = [dbo].[func_SaldoInicial](@UsuarioId,1,@Mes,@Ano) 

SELECT @TotalReceitas = ISNULL(SUM(lanc_valor), 0 )  FROM tb_lancamento WHERE usu_id = @UsuarioId AND MONTH(lanc_data) = @Mes AND YEAR(lanc_data) = @Ano AND lanc_tipo = 'R'
          
SELECT @TotalDespesas = ISNULL(SUM(lanc_valor), 0 )  FROM tb_lancamento WHERE usu_id = @UsuarioId AND MONTH(lanc_data) = @Mes AND YEAR(lanc_data) = @Ano AND lanc_tipo = 'D'
            
SET  @SaldoAtual = @SaldoInicial + (@TotalReceitas - @TotalDespesas)


SELECT @SaldoInicial AS SaldoInicial, @TotalReceitas AS TotalReceitas, @TotalDespesas AS TotalDespesas, @SaldoAtual AS SaldoAtual

END


