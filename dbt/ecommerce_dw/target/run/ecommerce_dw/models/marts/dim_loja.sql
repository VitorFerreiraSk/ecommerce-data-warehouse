
  
    

  create  table "ecommerce_dw"."staging_marts"."dim_loja__dbt_tmp"
  
  
    as
  
  (
    with lojas as (
    select * from "ecommerce_dw"."staging_staging"."stg_lojas"
)

select
    md5(cast(coalesce(cast(id_loja as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as sk_loja,
    id_loja,
    nome_loja,
    cidade,
    estado,
    regiao,
    tipo_loja
from lojas
  );
  