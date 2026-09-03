-- =========================================================
-- Inicialização do Data Warehouse de E-commerce
-- Schemas: raw (dados brutos carregados pelo Python)
--          staging / marts são criados pelo dbt
-- =========================================================

CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS marts;

-- ---------------------------------------------------------
-- Tabelas RAW (espelham os CSVs gerados pelo Python)
-- ---------------------------------------------------------

CREATE TABLE IF NOT EXISTS raw.clientes (
    id_cliente      INTEGER PRIMARY KEY,
    nome            TEXT,
    email           TEXT,
    cidade          TEXT,
    estado          CHAR(2),
    segmento        TEXT,
    data_cadastro   DATE
);

CREATE TABLE IF NOT EXISTS raw.produtos (
    id_produto      INTEGER PRIMARY KEY,
    nome_produto    TEXT,
    categoria       TEXT,
    subcategoria    TEXT,
    marca           TEXT,
    preco_unitario  NUMERIC(10,2),
    custo_unitario  NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS raw.lojas (
    id_loja         INTEGER PRIMARY KEY,
    nome_loja       TEXT,
    cidade          TEXT,
    estado          CHAR(2),
    regiao          TEXT,
    tipo_loja       TEXT  -- 'FISICA' ou 'ONLINE'
);

CREATE TABLE IF NOT EXISTS raw.vendas (
    id_venda        INTEGER PRIMARY KEY,
    id_pedido       INTEGER,
    id_cliente      INTEGER REFERENCES raw.clientes(id_cliente),
    id_produto      INTEGER REFERENCES raw.produtos(id_produto),
    id_loja         INTEGER REFERENCES raw.lojas(id_loja),
    data_venda      DATE,
    quantidade      INTEGER,
    preco_unitario  NUMERIC(10,2),
    valor_desconto  NUMERIC(10,2),
    forma_pagamento TEXT
);

CREATE INDEX IF NOT EXISTS idx_vendas_data ON raw.vendas(data_venda);
CREATE INDEX IF NOT EXISTS idx_vendas_cliente ON raw.vendas(id_cliente);
CREATE INDEX IF NOT EXISTS idx_vendas_produto ON raw.vendas(id_produto);
