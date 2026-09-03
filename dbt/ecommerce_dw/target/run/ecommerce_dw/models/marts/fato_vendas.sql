
  
    

  create  table "ecommerce_dw"."staging_marts"."fato_vendas__dbt_tmp"
  
  
    as
  
  (
    with vendas as (
    select * from "ecommerce_dw"."staging_staging"."stg_vendas"
),

dim_cliente as (
    select sk_cliente, id_cliente from "ecommerce_dw"."staging_marts"."dim_cliente"
),

dim_produto as (
    select sk_produto, id_produto, custo_unitario from "ecommerce_dw"."staging_marts"."dim_produto"
),

dim_loja as (
    select sk_loja, id_loja from "ecommerce_dw"."staging_marts"."dim_loja"
),

final as (
    select
        v.id_venda,
        v.id_pedido,
        c.sk_cliente,
        p.sk_produto,
        l.sk_loja,
        to_char(v.data_venda, 'YYYYMMDD')::int as sk_tempo,
        v.quantidade,
        v.preco_unitario,
        v.valor_desconto,
        v.valor_total,
        round(v.quantidade * p.custo_unitario, 2)                    as custo_total,
        round(v.valor_total - (v.quantidade * p.custo_unitario), 2)  as margem_bruta,
        v.forma_pagamento
    from vendas v
    left join dim_cliente c on v.id_cliente = c.id_cliente
    left join dim_produto p on v.id_produto = p.id_produto
    left join dim_loja l    on v.id_loja    = l.id_loja
)

select * from final
  );
  