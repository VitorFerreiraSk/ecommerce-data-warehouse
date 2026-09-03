with vendas_produto as (
    select
        p.categoria,
        p.nome_produto,
        f.valor_total,
        f.quantidade
    from {{ ref('fato_vendas') }} f
    join {{ ref('dim_produto') }} p on f.sk_produto = p.sk_produto
),

agregado as (
    select
        categoria,
        nome_produto,
        sum(valor_total)  as receita_total,
        sum(quantidade)   as unidades_vendidas
    from vendas_produto
    group by 1, 2
),

ranqueado as (
    select
        *,
        rank() over (partition by categoria order by receita_total desc) as ranking_na_categoria
    from agregado
)

select *
from ranqueado
where ranking_na_categoria <= 5
order by categoria, ranking_na_categoria
