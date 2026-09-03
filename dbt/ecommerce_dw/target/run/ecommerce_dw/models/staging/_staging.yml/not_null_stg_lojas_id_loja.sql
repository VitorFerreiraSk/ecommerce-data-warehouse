
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_loja
from "ecommerce_dw"."staging_staging"."stg_lojas"
where id_loja is null



  
  
      
    ) dbt_internal_test