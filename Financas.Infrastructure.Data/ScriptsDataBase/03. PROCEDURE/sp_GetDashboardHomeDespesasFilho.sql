USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetDashboardHomeDespesasFilho]    Script Date: 20/01/2017 13:23:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[sp_GetDashboardHomeDespesasFilho] -- 1,1,2017
(
	@UsuarioId INT,
	@Mes INT,
	@Ano INT
) 
 

AS 

SELECT  cp.cat_id AS CategoriaIdPai, cp.cat_nome AS CategoriaNomePai, c.cat_nome AS CategoriaNomeFilho, SUM(l.lanc_valor) AS Total
FROM  dbo.tb_categoria c 
INNER JOIN  dbo.tb_lancamento l ON c.cat_id = l.cat_id 
INNER JOIN dbo.tb_categoria cp ON c.cat_id_pai = cp.cat_id
WHERE   l.usu_id = @UsuarioId AND
		MONTH(l.lanc_data) = @Mes AND 
		YEAR(l.lanc_data) = @Ano AND 
		l.lanc_tipo = 'D'
GROUP BY cp.cat_id, cp.cat_nome, c.cat_nome


