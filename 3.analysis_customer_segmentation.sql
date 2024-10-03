-- Query para calcular e entender a segmentação dos clientes

USE marketing_analysis;

-- CTE para calcular o engajamento dos clientes
WITH customer_engagement AS (
    SELECT 
        c.id AS cliente_id,
        c.nome AS cliente_nome,
        COUNT(i.data_abertura) AS total_aberturas,
        COUNT(i.data_clique) AS total_cliques,
        COUNT(DISTINCT i.campanha_id) AS campanhas_interagidas,
        SUM(CASE WHEN i.data_clique IS NOT NULL THEN 1 ELSE 0 END) AS conversoes
    FROM clientes c
    LEFT JOIN interacoes i ON c.id = i.cliente_id
    GROUP BY c.id
),

-- CTE para categorizar clientes com base no engajamento
customer_categories AS (
    SELECT 
        cliente_id,
        cliente_nome,
        total_aberturas,
        total_cliques,
        campanhas_interagidas,
        conversoes,
        CASE 
            WHEN total_aberturas > 5 AND total_cliques > 3 THEN 'Alto Engajamento'
            WHEN total_aberturas BETWEEN 3 AND 5 AND total_cliques BETWEEN 2 AND 3 THEN 'Engajamento Médio'
            WHEN total_aberturas < 3 THEN 'Baixo Engajamento'
            ELSE 'Sem Interação'
        END AS categoria_engajamento
    FROM customer_engagement
)

-- Consulta final para segmentar clientes
SELECT 
    categoria_engajamento,
    COUNT(cliente_id) AS total_clientes,
    SUM(total_aberturas) AS total_aberturas,
    SUM(total_cliques) AS total_cliques,
    SUM(conversoes) AS total_conversoes
FROM customer_categories
GROUP BY categoria_engajamento
ORDER BY total_clientes DESC;
