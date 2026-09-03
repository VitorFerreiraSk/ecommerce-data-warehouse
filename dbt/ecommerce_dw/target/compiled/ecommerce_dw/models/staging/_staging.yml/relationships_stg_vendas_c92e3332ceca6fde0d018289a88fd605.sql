
    
    

with child as (
    select id_cliente as from_field
    from "ecommerce_dw"."staging_staging"."stg_vendas"
    where id_cliente is not null
),

parent as (
    select id_cliente as to_field
    from "ecommerce_dw"."staging_staging"."stg_clientes"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


