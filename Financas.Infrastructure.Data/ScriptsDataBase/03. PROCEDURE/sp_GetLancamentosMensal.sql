USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRelatorioLancamentosPeriodo]    Script Date: 21/01/2017 15:28:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].sp_GetLancamentosMensal -- 1, 1, 2017
(
	@UsuarioId   INT,
	@Mes		 INT,
	@Ano		 INT
) 

AS


SELECT L.lanc_id As Id,
	   l.lanc_data AS Data,
	  CASE   
		  WHEN l.lanc_desc != '' THEN c.cat_nome + ' - '  + l.lanc_desc
		  ELSE c.cat_nome
	   END AS Descricao,  
	   CASE   
		  WHEN l.lanc_tipo = 'R' THEN l.lanc_valor
		  ELSE 0
	   END AS Entrada,  
	   CASE   
		  WHEN l.lanc_tipo = 'D' THEN l.lanc_valor
		  ELSE 0
	   END AS Saida

FROM tb_lancamento l
INNER JOIN tb_categoria c ON l.cat_id = c.cat_id 
WHERE l.usu_id = @UsuarioId AND
	  MONTH(l.lanc_data) = @Mes AND
	  YEAR(l.lanc_data) = @Ano
ORDER BY l.lanc_data



