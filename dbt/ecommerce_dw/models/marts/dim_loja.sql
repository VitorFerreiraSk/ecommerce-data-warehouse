with lojas as (
    select * from {{ ref('stg_lojas') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['id_loja']) }} as sk_loja,
    id_loja,
    nome_loja,
    cidade,
    estado,
    regiao,
    tipo_loja
from lojas
