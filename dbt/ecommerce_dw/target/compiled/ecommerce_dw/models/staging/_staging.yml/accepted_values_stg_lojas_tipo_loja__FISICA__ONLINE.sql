
    
    

with all_values as (

    select
        tipo_loja as value_field,
        count(*) as n_records

    from "ecommerce_dw"."staging_staging"."stg_lojas"
    group by tipo_loja

)

select *
from all_values
where value_field not in (
    'FISICA','ONLINE'
)


