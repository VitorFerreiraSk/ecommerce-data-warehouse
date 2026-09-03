with fonte as (
    select * from {{ source('raw', 'produtos') }}
)

select
    id_produto,
    trim(nome_produto)             as nome_produto,
    trim(categoria)                as categoria,
    trim(subcategoria)             as subcategoria,
    trim(marca)                    as marca,
    preco_unitario::numeric(10,2)  as preco_unitario,
    custo_unitario::numeric(10,2)  as custo_unitario
from fonte
where id_produto is not null
  and preco_unitario > 0
