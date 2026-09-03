with clientes as (
    select * from {{ ref('stg_clientes') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['id_cliente']) }} as sk_cliente,
    id_cliente,
    nome,
    email,
    cidade,
    estado,
    segmento,
    data_cadastro,
    date_part('year', age(current_date, data_cadastro)) as anos_como_cliente
from clientes
