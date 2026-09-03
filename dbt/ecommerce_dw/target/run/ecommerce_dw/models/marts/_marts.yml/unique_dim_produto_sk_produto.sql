
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    sk_produto as unique_field,
    count(*) as n_records

from "ecommerce_dw"."staging_marts"."dim_produto"
where sk_produto is not null
group by sk_produto
having count(*) > 1



  
  
      
    ) dbt_internal_test