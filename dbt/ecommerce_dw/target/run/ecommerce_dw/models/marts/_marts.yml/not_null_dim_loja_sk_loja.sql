
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sk_loja
from "ecommerce_dw"."staging_marts"."dim_loja"
where sk_loja is null



  
  
      
    ) dbt_internal_test