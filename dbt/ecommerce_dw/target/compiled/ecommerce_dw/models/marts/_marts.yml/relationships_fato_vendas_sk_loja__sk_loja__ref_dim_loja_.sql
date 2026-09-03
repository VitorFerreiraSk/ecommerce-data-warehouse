
    
    

with child as (
    select sk_loja as from_field
    from "ecommerce_dw"."staging_marts"."fato_vendas"
    where sk_loja is not null
),

parent as (
    select sk_loja as to_field
    from "ecommerce_dw"."staging_marts"."dim_loja"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


