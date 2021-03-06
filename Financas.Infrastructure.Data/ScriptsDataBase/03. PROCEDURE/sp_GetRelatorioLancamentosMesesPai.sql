USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRelatorioLancamentosMesesPai]    Script Date: 20/01/2017 19:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_GetRelatorioLancamentosMesesPai] -- 1, 2017
(
	@UsuarioId INT,
	@Ano INT
) 

AS


SELECT
	   ISNULL(cp.cat_id,0) AS CategoriaIdPai,
	   ISNULL(cp.cat_tipo,'R') AS CategoriaTipoPai,
	   ISNULL(cp.cat_nome,'Receitas') AS CategoriaNomePai,
	   c.cat_id AS CategoriaIdFilho,
	   c.cat_nome AS CategoriaNomeFilho
FROM tb_lancamento l
INNER JOIN tb_categoria c ON l.cat_id = c.cat_id 
LEFT JOIN tb_categoria cp ON c.cat_id_pai = cp.cat_id
WHERE l.usu_id = @UsuarioId AND
	  YEAR(l.lanc_data) = @Ano
GROUP BY cp.cat_id, cp.cat_nome, cp.cat_tipo, c.cat_id, c.cat_nome






