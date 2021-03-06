USE [Financas]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetRelatorioLancamentosPeriodo]    Script Date: 21/01/2017 01:14:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[sp_GetRelatorioLancamentosPeriodo]
(
	@UsuarioId   INT,
	@DataInicial DATETIME,
	@DataFinal   DATETIME
) 

AS


SELECT l.lanc_data AS Data,
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
	  l.lanc_data >= @DataInicial AND
	  l.lanc_data <= @DataFinal
ORDER BY l.lanc_data



