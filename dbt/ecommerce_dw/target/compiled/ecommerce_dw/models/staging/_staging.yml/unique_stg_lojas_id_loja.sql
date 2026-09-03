
    
    

select
    id_loja as unique_field,
    count(*) as n_records

from "ecommerce_dw"."staging_staging"."stg_lojas"
where id_loja is not null
group by id_loja
having count(*) > 1


