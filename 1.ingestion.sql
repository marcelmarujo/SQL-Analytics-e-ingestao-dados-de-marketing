-- Código para criar o banco de dados e tabelas e ingerir os dados

CREATE DATABASE IF NOT EXISTS marketing_analysis;
USE marketing_analysis;

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_cadastro DATE NOT NULL
);

-- Tabela de Campanhas
CREATE TABLE IF NOT EXISTS campanhas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_lancamento DATE NOT NULL,
    tipo VARCHAR(50) NOT NULL
);

-- Tabela de Interações
CREATE TABLE IF NOT EXISTS interacoes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    campanha_id INT NOT NULL,
    data_abertura DATETIME,
    data_clique DATETIME,
    CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    CONSTRAINT fk_campanha FOREIGN KEY (campanha_id) REFERENCES campanhas(id)
);

-- Abaixo, é a simulação de ingestão de dados de uma API

-- Dados fictícios para clientes (simulação de uma API)
SET @clientes_json = '[
    {"nome": "Alice Silva", "email": "alice@example.com", "data_cadastro": "2023-01-10"},
    {"nome": "Bruno Oliveira", "email": "bruno@example.com", "data_cadastro": "2023-01-12"},
    {"nome": "Carla Mendes", "email": "carla@example.com", "data_cadastro": "2023-01-15"},
    {"nome": "David Santos", "email": "david@example.com", "data_cadastro": "2023-01-18"},
    {"nome": "Eva Lima", "email": "eva@example.com", "data_cadastro": "2023-01-20"}
]';

-- Inserindo dados fictícios para clientes a partir do JSON
INSERT INTO clientes (nome, email, data_cadastro)
SELECT
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.nome')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.email')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.data_cadastro'))
FROM JSON_TABLE(@clientes_json, '$[*]' COLUMNS (value JSON PATH '$')) AS clientes_data;

-- Dados fictícios para campanhas (simulação de uma API)
SET @campanhas_json = '[
    {"nome": "Promoção de Verão", "data_lancamento": "2023-06-01", "tipo": "E-mail"},
    {"nome": "Desconto de Natal", "data_lancamento": "2023-12-01", "tipo": "E-mail"},
    {"nome": "Black Friday", "data_lancamento": "2023-11-20", "tipo": "E-mail"}
]';

-- Inserindo dados fictícios para campanhas a partir do JSON
INSERT INTO campanhas (nome, data_lancamento, tipo)
SELECT
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.nome')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.data_lancamento')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.tipo'))
FROM JSON_TABLE(@campanhas_json, '$[*]' COLUMNS (value JSON PATH '$')) AS campanhas_data;

-- Dados fictícios para interações (simulação de uma API)
SET @interacoes_json = '[
    {"cliente_id": 1, "campanha_id": 1, "data_abertura": "2023-06-02 10:00:00", "data_clique": "2023-06-02 10:05:00"},
    {"cliente_id": 1, "campanha_id": 2, "data_abertura": "2023-12-02 09:00:00", "data_clique": null},
    {"cliente_id": 2, "campanha_id": 1, "data_abertura": "2023-06-02 11:00:00", "data_clique": "2023-06-02 11:10:00"},
    {"cliente_id": 3, "campanha_id": 1, "data_abertura": "2023-06-03 08:30:00", "data_clique": null},
    {"cliente_id": 4, "campanha_id": 3, "data_abertura": "2023-11-21 15:00:00", "data_clique": "2023-11-21 15:05:00"},
    {"cliente_id": 5, "campanha_id": 3, "data_abertura": "2023-11-21 16:00:00", "data_clique": null}
]';

-- Inserindo dados fictícios para interações a partir do JSON
INSERT INTO interacoes (cliente_id, campanha_id, data_abertura, data_clique)
SELECT
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.cliente_id')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.campanha_id')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.data_abertura')),
    JSON_UNQUOTE(JSON_EXTRACT(value, '$.data_clique'))
FROM JSON_TABLE(@interacoes_json, '$[*]' COLUMNS (value JSON PATH '$')) AS interacoes_data;
