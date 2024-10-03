
-- Query para calcular e comparar a performance das campanhas

USE marketing_analysis;

-- CTE para calcular métricas mensais de campanhas
WITH monthly_performance AS (
    SELECT 
        c.nome AS campanha_nome,
        DATE_FORMAT(c.data_lancamento, '%Y-%m') AS mes,
        COUNT(i.data_abertura) AS total_aberturas,
        COUNT(i.data_clique) AS total_cliques,
        COUNT(DISTINCT i.cliente_id) AS total_clientes,
        COUNT(i.data_clique) / NULLIF(COUNT(i.data_abertura), 0) * 100 AS taxa_clique
    FROM campanhas c
    LEFT JOIN interacoes i ON c.id = i.campanha_id
    GROUP BY c.id, mes
)

-- Consulta final para comparar o desempenho das campanhas ao longo do tempo
SELECT 
    campanha_nome,
    mes,
    total_aberturas,
    total_cliques,
    total_clientes,
    taxa_clique
FROM monthly_performance
ORDER BY mes, total_aberturas DESC;
