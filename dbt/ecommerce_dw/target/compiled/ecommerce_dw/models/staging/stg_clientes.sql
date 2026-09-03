with fonte as (
    select * from "ecommerce_dw"."raw"."clientes"
)

select
    id_cliente,
    trim(nome)                     as nome,
    lower(trim(email))             as email,
    trim(cidade)                   as cidade,
    upper(trim(estado))            as estado,
    trim(segmento)                 as segmento,
    data_cadastro
from fonte
where id_cliente is not null