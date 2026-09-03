
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sk_produto
from "ecommerce_dw"."staging_marts"."dim_produto"
where sk_produto is null



  
  
      
    ) dbt_internal_test