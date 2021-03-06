USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRelatorioLancamentosMesesFilho]    Script Date: 20/01/2017 19:31:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_GetRelatorioLancamentosMesesFilho] --  1, 2017
(
	@UsuarioId INT,
	@Ano INT
) 

AS


SELECT
	   c.cat_id AS CategoriaIdFilho,
	   MONTH(l.lanc_data) AS Mes,
	   SUM(l.lanc_valor) AS Total
FROM tb_lancamento l
INNER JOIN tb_categoria c ON l.cat_id = c.cat_id 
LEFT JOIN tb_categoria cp ON c.cat_id_pai = cp.cat_id
WHERE l.usu_id = @UsuarioId AND
	  YEAR(l.lanc_data) = @Ano
GROUP BY c.cat_id, c.cat_nome, MONTH(l.lanc_data)

