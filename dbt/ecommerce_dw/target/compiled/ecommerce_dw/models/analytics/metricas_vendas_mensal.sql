with vendas_tempo as (
    select
        t.ano,
        t.mes,
        t.ano_mes,
        f.valor_total,
        f.margem_bruta,
        f.quantidade
    from "ecommerce_dw"."staging_marts"."fato_vendas" f
    join "ecommerce_dw"."staging_marts"."dim_tempo" t on f.sk_tempo = t.sk_tempo
),

agregado as (
    select
        ano_mes,
        ano,
        mes,
        sum(valor_total)   as receita_total,
        sum(margem_bruta)  as margem_total,
        sum(quantidade)    as itens_vendidos,
        count(*)           as numero_vendas
    from vendas_tempo
    group by 1, 2, 3
)

select
    *,
    lag(receita_total) over (order by ano_mes)                              as receita_mes_anterior,
    round(
        (receita_total - lag(receita_total) over (order by ano_mes))
        / nullif(lag(receita_total) over (order by ano_mes), 0) * 100, 2
    )                                                                       as crescimento_mom_pct,
    round(avg(receita_total) over (
        order by ano_mes rows between 2 preceding and current row
    ), 2)                                                                   as media_movel_3_meses
from agregado
order by ano_mes