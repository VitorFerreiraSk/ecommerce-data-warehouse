
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select id_loja as from_field
    from "ecommerce_dw"."staging_staging"."stg_vendas"
    where id_loja is not null
),

parent as (
    select id_loja as to_field
    from "ecommerce_dw"."staging_staging"."stg_lojas"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test