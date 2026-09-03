
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select id_cliente
from "ecommerce_dw"."staging_staging"."stg_clientes"
where id_cliente is null



  
  
      
    ) dbt_internal_test