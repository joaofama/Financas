USE [Financas]
GO
/****** Object:  UserDefinedFunction [dbo].[func_SaldoInicial]    Script Date: 21/01/2017 01:14:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_SaldoInicial]
(
    @UsuarioId INT,
	@Dia INT,
    @Mes INT,
    @Ano INT

)
RETURNS NUMERIC(18,2)
AS
BEGIN

DECLARE 
@DataInicial				DATETIME,
@SaldoConta					NUMERIC(18,2),
@SaldoInicial				NUMERIC(18,2),
@TotalReceitas				NUMERIC(18,2),
@TotalDespesas				NUMERIC(18,2)


SET @DataInicial = dbo.func_DateFromParts(@Ano, @Mes, @Dia, 0, 0, 0)

SELECT @SaldoConta = ISNULL(usu_saldoinicial, 0 ) FROM tb_usuario WHERE usu_id = @UsuarioId
 
SELECT @TotalReceitas = ISNULL(SUM(lanc_valor), 0 )  FROM tb_lancamento WHERE usu_id = @UsuarioId AND lanc_data < @DataInicial AND lanc_tipo = 'R'

SELECT @TotalDespesas = ISNULL(SUM(lanc_valor), 0 )  FROM tb_lancamento WHERE usu_id = @UsuarioId AND lanc_data < @DataInicial AND lanc_tipo = 'D'

SET @SaldoInicial = @SaldoConta + (@TotalReceitas - @TotalDespesas)

RETURN @SaldoInicial

END