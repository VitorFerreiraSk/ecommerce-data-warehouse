
    
    

select
    sk_tempo as unique_field,
    count(*) as n_records

from "ecommerce_dw"."staging_marts"."dim_tempo"
where sk_tempo is not null
group by sk_tempo
having count(*) > 1


