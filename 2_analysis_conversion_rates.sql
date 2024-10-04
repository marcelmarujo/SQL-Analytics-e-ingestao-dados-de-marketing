-- Query para calcular as cvr (Conversion Rates %)

USE marketing_analysis;

-- CTE para calcular a taxa de abertura e cliques
WITH campanha_metrics AS (
    SELECT 
        c.id AS campanha_id,
        c.nome AS campanha_nome,
        COUNT(i.data_abertura) AS total_aberturas,
        COUNT(i.data_clique) AS total_cliques,
        COUNT(DISTINCT i.cliente_id) AS total_clientes,
        (COUNT(i.data_abertura) / NULLIF(COUNT(DISTINCT i.cliente_id), 0) * 100) AS taxa_abertura,
        (COUNT(i.data_clique) / NULLIF(COUNT(i.data_abertura), 0) * 100) AS taxa_clique
    FROM campanhas c
    LEFT JOIN interacoes i ON c.id = i.campanha_id
    GROUP BY c.id
),

conversoes AS (
    SELECT 
        campanha_id,
        COUNT(cliente_id) AS total_conversoes
    FROM interacoes
    WHERE data_clique IS NOT NULL
    GROUP BY campanha_id
),

retencao AS (
    SELECT 
        cliente_id,
        COUNT(DISTINCT campanha_id) AS num_campanhas
    FROM interacoes
    WHERE data_abertura IS NOT NULL
    GROUP BY cliente_id
),

campanha_retorno AS (
    SELECT 
        cm.campanha_nome,
        COUNT(DISTINCT r.cliente_id) AS clientes_retidos
    FROM campanha_metrics cm
    JOIN retencao r ON r.num_campanhas > 1
    GROUP BY cm.campanha_nome
)

-- Consulta final combinando as métricas
SELECT 
    cm.campanha_nome,
    cm.total_aberturas,
    cm.total_cliques,
    cm.total_clientes,
    cm.taxa_abertura,
    cm.taxa_clique,
    COALESCE(cv.total_conversoes, 0) AS total_conversoes,
    COALESCE(cr.clientes_retidos, 0) AS clientes_retidos
FROM campanha_metrics cm
LEFT JOIN conversoes cv ON cm.campanha_id = cv.campanha_id
LEFT JOIN campanha_retorno cr ON cm.campanha_nome = cr.campanha_nome;

-- Análise por Tipo de Campanha
WITH tipo_metrics AS (
    SELECT 
        c.tipo AS tipo_campanha,
        COUNT(i.data_abertura) AS total_aberturas,
        COUNT(i.data_clique) AS total_cliques,
        COUNT(DISTINCT i.cliente_id) AS total_clientes,
        (COUNT(i.data_abertura) / NULLIF(COUNT(DISTINCT i.cliente_id), 0) * 100) AS taxa_abertura,
        (COUNT(i.data_clique) / NULLIF(COUNT(i.data_abertura), 0) * 100) AS taxa_clique
    FROM campanhas c
    LEFT JOIN interacoes i ON c.id = i.campanha_id
    GROUP BY c.tipo
)

-- Consulta final para análise por tipo de campanha
SELECT 
    tm.tipo_campanha,
    tm.total_aberturas,
    tm.total_cliques,
    tm.total_clientes,
    tm.taxa_abertura,
    tm.taxa_clique
FROM tipo_metrics tm;

-- Comparação entre campanhas com mais métricas
SELECT 
    cm.campanha_nome,
    COUNT(i.data_abertura) AS total_aberturas,
    COUNT(i.data_clique) AS total_cliques,
    COUNT(DISTINCT i.cliente_id) AS total_clientes,
    COALESCE(cv.total_conversoes, 0) AS total_conversoes,
    COUNT(i.data_abertura) / NULLIF(COUNT(DISTINCT i.cliente_id), 0) * 100 AS taxa_abertura,
    COUNT(i.data_clique) / NULLIF(COUNT(i.data_abertura), 0) * 100 AS taxa_clique
FROM campanhas c
LEFT JOIN interacoes i ON c.id = i.campanha_id
LEFT JOIN conversoes cv ON c.id = cv.campanha_id
GROUP BY c.id
ORDER BY total_aberturas DESC;
