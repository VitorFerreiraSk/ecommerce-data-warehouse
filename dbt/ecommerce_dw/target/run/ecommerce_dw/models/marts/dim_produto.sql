
  
    

  create  table "ecommerce_dw"."staging_marts"."dim_produto__dbt_tmp"
  
  
    as
  
  (
    with produtos as (
    select * from "ecommerce_dw"."staging_staging"."stg_produtos"
)

select
    md5(cast(coalesce(cast(id_produto as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as sk_produto,
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
  );
  