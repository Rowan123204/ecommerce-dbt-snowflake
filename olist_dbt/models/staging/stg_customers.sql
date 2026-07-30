with source as (
    select * from {{ source('raw', 'customers') }}
),

renamed as (
    select
        -- Primary Keys
        customer_id,
        customer_unique_id,

        -- Location fields (normalized)
        customer_zip_code_prefix  as zip_code_prefix,
        lower(customer_city)      as customer_city,
        upper(customer_state)     as customer_state

    from source
)

select * from renamed