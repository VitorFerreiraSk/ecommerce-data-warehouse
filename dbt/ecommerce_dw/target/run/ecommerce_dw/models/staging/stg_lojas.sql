
  create view "ecommerce_dw"."staging_staging"."stg_lojas__dbt_tmp"
    
    
  as (
    with fonte as (
    select * from "ecommerce_dw"."raw"."lojas"
)

select
    id_loja,
    trim(nome_loja)         as nome_loja,
    trim(cidade)            as cidade,
    upper(trim(estado))     as estado,
    trim(regiao)            as regiao,
    upper(trim(tipo_loja))  as tipo_loja
from fonte
where id_loja is not null
  );