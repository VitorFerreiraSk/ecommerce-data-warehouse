
    
    

with child as (
    select sk_cliente as from_field
    from "ecommerce_dw"."staging_marts"."fato_vendas"
    where sk_cliente is not null
),

parent as (
    select sk_cliente as to_field
    from "ecommerce_dw"."staging_marts"."dim_cliente"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


