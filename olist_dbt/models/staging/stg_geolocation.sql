with source as (
    select * from {{ source('raw', 'geolocation') }}
),

renamed as (
    select
        geolocation_zip_code_prefix     as zip_code_prefix,
        geolocation_lat                 as latitude,
        geolocation_lng                 as longitude,
        lower(trim(geolocation_city))   as city,
        upper(trim(geolocation_state))  as state

    from source
),

-- Feature Engineering: تجميع الرموز البريدية المكررة وأخذ متوسط الإحداثيات لكل رمز
deduplicated as (
    select
        zip_code_prefix,
        avg(latitude)                  as latitude,
        avg(longitude)                 as longitude,
        min(city)                      as city,
        min(state)                     as state
    from renamed
    group by zip_code_prefix
)

select * from deduplicated
