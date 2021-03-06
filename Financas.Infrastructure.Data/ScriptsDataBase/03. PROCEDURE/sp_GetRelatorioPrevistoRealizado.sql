USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRelatorioPrevistoRealizado]    Script Date: 20/01/2017 19:31:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[sp_GetRelatorioPrevistoRealizado] -- 1, 1, 2017
(
	@UsuarioId INT,
	@Mes INT,
	@Ano INT
) 

AS

SELECT	CategoriaIdPai,
		CategoriaNomePai,
		CategoriaTipoPai,
		CategoriaIdFilho,
		CategoriaNomeFilho,
		Previsto,
		Realizado,
		(Previsto - Realizado) AS Diferenca
FROM
(
SELECT
	   ISNULL(cp.cat_id,0) AS CategoriaIdPai,
	   ISNULL(cp.cat_nome,'Receitas') AS CategoriaNomePai,
	   ISNULL(cp.cat_tipo,'R') AS CategoriaTipoPai,
	   c.cat_id AS CategoriaIdFilho,
	   c.cat_nome AS CategoriaNomeFilho,
	   ISNULL((SELECT orc_valor FROM tb_orcamento o where o.usu_id = @UsuarioId AND o.orc_mes = @Mes AND o.orc_ano = @Ano AND o.cat_id = c.cat_id),0) AS Previsto,
	   SUM(l.lanc_valor) AS Realizado
FROM tb_lancamento l
INNER JOIN tb_categoria c ON l.cat_id = c.cat_id 
LEFT JOIN tb_categoria cp ON c.cat_id_pai = cp.cat_id
WHERE l.usu_id = @UsuarioId AND
	  MONTH(l.lanc_data) = @Mes AND
	  YEAR(l.lanc_data) = @Ano 
GROUP BY cp.cat_id, cp.cat_nome, cp.cat_tipo, c.cat_id, c.cat_nome 
) Qry




