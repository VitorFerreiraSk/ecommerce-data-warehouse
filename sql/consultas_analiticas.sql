-- =========================================================
-- Consultas Analíticas Avançadas — Data Warehouse E-commerce
-- Rodar após `dbt run` (schemas marts.* já existem)
-- =========================================================

-- 1) Receita, margem e ticket médio por trimestre, com crescimento QoQ
select
    t.trimestre_ano,
    sum(f.valor_total)                                  as receita_total,
    sum(f.margem_bruta)                                 as margem_total,
    round(sum(f.valor_total) / count(distinct f.id_pedido), 2) as ticket_medio,
    round(
        (sum(f.valor_total) - lag(sum(f.valor_total)) over (order by min(t.data)))
        / nullif(lag(sum(f.valor_total)) over (order by min(t.data)), 0) * 100, 2
    ) as crescimento_qoq_pct
from marts.fato_vendas f
join marts.dim_tempo t on f.sk_tempo = t.sk_tempo
group by t.trimestre_ano
order by min(t.data);


-- 2) Cubo de vendas: receita por região x categoria x tipo de loja (ROLLUP)
select
    coalesce(l.regiao, 'TOTAL GERAL')          as regiao,
    coalesce(p.categoria, 'TODAS CATEGORIAS')  as categoria,
    coalesce(l.tipo_loja, 'TODOS OS TIPOS')    as tipo_loja,
    sum(f.valor_total)                         as receita_total
from marts.fato_vendas f
join marts.dim_loja l    on f.sk_loja    = l.sk_loja
join marts.dim_produto p on f.sk_produto = p.sk_produto
group by rollup (l.regiao, p.categoria, l.tipo_loja)
order by regiao, categoria, tipo_loja;


-- 3) Participação percentual de cada categoria na receita total (window function)
with receita_categoria as (
    select
        p.categoria,
        sum(f.valor_total) as receita
    from marts.fato_vendas f
    join marts.dim_produto p on f.sk_produto = p.sk_produto
    group by p.categoria
)
select
    categoria,
    receita,
    round(receita / sum(receita) over () * 100, 2) as participacao_pct,
    rank() over (order by receita desc)             as ranking
from receita_categoria
order by ranking;


-- 4) Coorte de clientes: retenção mês a mês desde a primeira compra
with primeira_compra as (
    select
        c.sk_cliente,
        date_trunc('month', min(t.data)) as mes_coorte
    from marts.fato_vendas f
    join marts.dim_cliente c on f.sk_cliente = c.sk_cliente
    join marts.dim_tempo t   on f.sk_tempo   = t.sk_tempo
    group by c.sk_cliente
),
compras_mensais as (
    select distinct
        c.sk_cliente,
        date_trunc('month', t.data) as mes_compra
    from marts.fato_vendas f
    join marts.dim_cliente c on f.sk_cliente = c.sk_cliente
    join marts.dim_tempo t   on f.sk_tempo   = t.sk_tempo
),
coorte as (
    select
        pc.mes_coorte,
        cm.mes_compra,
        (date_part('year', cm.mes_compra) - date_part('year', pc.mes_coorte)) * 12
            + (date_part('month', cm.mes_compra) - date_part('month', pc.mes_coorte)) as mes_indice,
        cm.sk_cliente
    from compras_mensais cm
    join primeira_compra pc on cm.sk_cliente = pc.sk_cliente
)
select
    mes_coorte,
    mes_indice,
    count(distinct sk_cliente) as clientes_ativos
from coorte
group by mes_coorte, mes_indice
order by mes_coorte, mes_indice;


-- 5) Top 10 clientes por valor gasto, com percentual acumulado (curva de Pareto)
with gasto_cliente as (
    select
        c.nome,
        sum(f.valor_total) as valor_total
    from marts.fato_vendas f
    join marts.dim_cliente c on f.sk_cliente = c.sk_cliente
    group by c.nome
)
select
    nome,
    valor_total,
    round(
        sum(valor_total) over (order by valor_total desc)
        / sum(valor_total) over () * 100, 2
    ) as pct_acumulado
from gasto_cliente
order by valor_total desc
limit 10;


-- 6) Produtos com queda de vendas mês a mês (usando LAG + filtro)
with vendas_produto_mes as (
    select
        p.nome_produto,
        t.ano_mes,
        sum(f.quantidade) as unidades
    from marts.fato_vendas f
    join marts.dim_produto p on f.sk_produto = p.sk_produto
    join marts.dim_tempo t   on f.sk_tempo   = t.sk_tempo
    group by p.nome_produto, t.ano_mes
),
com_variacao as (
    select
        *,
        lag(unidades) over (partition by nome_produto order by ano_mes) as unidades_mes_anterior
    from vendas_produto_mes
)
select
    nome_produto,
    ano_mes,
    unidades,
    unidades_mes_anterior,
    unidades - unidades_mes_anterior as variacao
from com_variacao
where unidades_mes_anterior is not null
  and unidades < unidades_mes_anterior
order by variacao asc
limit 20;


-- 7) Distribuição de vendas por forma de pagamento e dia da semana
select
    t.nome_dia_semana,
    f.forma_pagamento,
    count(*)            as numero_vendas,
    sum(f.valor_total)  as receita_total
from marts.fato_vendas f
join marts.dim_tempo t on f.sk_tempo = t.sk_tempo
group by t.dia_semana_num, t.nome_dia_semana, f.forma_pagamento
order by t.dia_semana_num, receita_total desc;
