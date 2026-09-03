with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2022-01-01' as date)",
        end_date="cast('2027-01-01' as date)"
    ) }}
)

select
    to_char(date_day, 'YYYYMMDD')::int          as sk_tempo,
    date_day::date                              as data,
    extract(day from date_day)::int             as dia,
    extract(month from date_day)::int           as mes,
    extract(year from date_day)::int            as ano,
    extract(quarter from date_day)::int         as trimestre,
    extract(isodow from date_day)::int          as dia_semana_num,
    to_char(date_day, 'TMDay')                  as nome_dia_semana,
    to_char(date_day, 'TMMonth')                as nome_mes,
    case when extract(isodow from date_day) in (6, 7) then true else false end as fim_de_semana,
    to_char(date_day, '"Q"Q-YYYY')              as trimestre_ano,
    to_char(date_day, 'YYYY-MM')                as ano_mes
from spine
