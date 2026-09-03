
  
    

  create  table "ecommerce_dw"."staging_marts"."dim_cliente__dbt_tmp"
  
  
    as
  
  (
    with clientes as (
    select * from "ecommerce_dw"."staging_staging"."stg_clientes"
)

select
    md5(cast(coalesce(cast(id_cliente as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as sk_cliente,
    id_cliente,
    nome,
    email,
    cidade,
    estado,
    segmento,
    data_cadastro,
    date_part('year', age(current_date, data_cadastro)) as anos_como_cliente
from clientes
  );
  