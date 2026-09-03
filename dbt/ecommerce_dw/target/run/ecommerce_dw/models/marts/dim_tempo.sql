
  
    

  create  table "ecommerce_dw"."staging_marts"."dim_tempo__dbt_tmp"
  
  
    as
  
  (
    with spine as (
    





with rawdata as (

    

    

    with p as (
        select 0 as generated_number union all select 1
    ), unioned as (

    select

    
    p0.generated_number * power(2, 0)
     + 
    
    p1.generated_number * power(2, 1)
     + 
    
    p2.generated_number * power(2, 2)
     + 
    
    p3.generated_number * power(2, 3)
     + 
    
    p4.generated_number * power(2, 4)
     + 
    
    p5.generated_number * power(2, 5)
     + 
    
    p6.generated_number * power(2, 6)
     + 
    
    p7.generated_number * power(2, 7)
     + 
    
    p8.generated_number * power(2, 8)
     + 
    
    p9.generated_number * power(2, 9)
     + 
    
    p10.generated_number * power(2, 10)
    
    
    + 1
    as generated_number

    from

    
    p as p0
     cross join 
    
    p as p1
     cross join 
    
    p as p2
     cross join 
    
    p as p3
     cross join 
    
    p as p4
     cross join 
    
    p as p5
     cross join 
    
    p as p6
     cross join 
    
    p as p7
     cross join 
    
    p as p8
     cross join 
    
    p as p9
     cross join 
    
    p as p10
    
    

    )

    select *
    from unioned
    where generated_number <= 1826
    order by generated_number



),

all_periods as (

    select (
        

    cast('2022-01-01' as date) + ((interval '1 day') * (row_number() over (order by generated_number) - 1))


    ) as date_day
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_day <= cast('2027-01-01' as date)

)

select * from filtered


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
  );
  