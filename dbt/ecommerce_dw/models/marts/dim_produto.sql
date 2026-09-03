with produtos as (
    select * from {{ ref('stg_produtos') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['id_produto']) }} as sk_produto,
    id_produto,
    nome_produto,
    categoria,
    subcategoria,
    marca,
    preco_unitario,
    custo_unitario,
    round(preco_unitario - custo_unitario, 2)               as margem_unitaria,
    round((preco_unitario - custo_unitario) / nullif(preco_unitario, 0) * 100, 2) as margem_percentual
from produtos
