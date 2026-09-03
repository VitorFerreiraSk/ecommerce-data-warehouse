
    
    

select
    id_venda as unique_field,
    count(*) as n_records

from "ecommerce_dw"."staging_marts"."fato_vendas"
where id_venda is not null
group by id_venda
having count(*) > 1


