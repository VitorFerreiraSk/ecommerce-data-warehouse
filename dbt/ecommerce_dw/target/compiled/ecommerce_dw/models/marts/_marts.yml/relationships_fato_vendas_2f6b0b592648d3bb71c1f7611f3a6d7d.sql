
    
    

with child as (
    select sk_produto as from_field
    from "ecommerce_dw"."staging_marts"."fato_vendas"
    where sk_produto is not null
),

parent as (
    select sk_produto as to_field
    from "ecommerce_dw"."staging_marts"."dim_produto"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


