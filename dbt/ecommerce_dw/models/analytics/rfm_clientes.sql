with base as (
    select
        c.sk_cliente,
        c.nome,
        t.data                as data_venda,
        f.valor_total
    from {{ ref('fato_vendas') }} f
    join {{ ref('dim_cliente') }} c on f.sk_cliente = c.sk_cliente
    join {{ ref('dim_tempo') }} t   on f.sk_tempo   = t.sk_tempo
),

agregado_cliente as (
    select
        sk_cliente,
        nome,
        max(data_venda)                          as ultima_compra,
        current_date - max(data_venda)           as recencia_dias,
        count(distinct data_venda)               as frequencia_compras,
        sum(valor_total)                         as valor_monetario
    from base
    group by 1, 2
),

scores as (
    select
        *,
        ntile(5) over (order by recencia_dias desc)   as score_recencia,
        ntile(5) over (order by frequencia_compras)   as score_frequencia,
        ntile(5) over (order by valor_monetario)      as score_monetario
    from agregado_cliente
)

select
    *,
    (score_recencia + score_frequencia + score_monetario) as rfm_score,
    case
        when score_recencia >= 4 and score_frequencia >= 4 and score_monetario >= 4 then 'Champions'
        when score_recencia >= 3 and score_frequencia >= 3 then 'Clientes Fiéis'
        when score_recencia <= 2 and score_frequencia <= 2 then 'Em Risco'
        when score_recencia <= 2 and score_monetario >= 4 then 'Não Pode Perder'
        else 'Regular'
    end as segmento_rfm
from scores
