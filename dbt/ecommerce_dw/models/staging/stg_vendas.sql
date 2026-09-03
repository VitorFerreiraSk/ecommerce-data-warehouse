with fonte as (
    select * from {{ source('raw', 'vendas') }}
)

select
    id_venda,
    id_pedido,
    id_cliente,
    id_produto,
    id_loja,
    data_venda,
    quantidade,
    preco_unitario::numeric(10,2)   as preco_unitario,
    coalesce(valor_desconto, 0)::numeric(10,2) as valor_desconto,
    trim(forma_pagamento)           as forma_pagamento,
    (quantidade * preco_unitario - coalesce(valor_desconto, 0))::numeric(10,2) as valor_total
from fonte
where id_venda is not null
  and quantidade > 0
