
    
    

select
    id_cliente as unique_field,
    count(*) as n_records

from "ecommerce_dw"."staging_staging"."stg_clientes"
where id_cliente is not null
group by id_cliente
having count(*) > 1


