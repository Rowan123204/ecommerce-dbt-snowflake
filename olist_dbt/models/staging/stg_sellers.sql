with source as (
    select * from {{ source('raw', 'sellers') }}
),

renamed as (
    select
        -- Primary Key
        seller_id,

        -- Location
        seller_zip_code_prefix                as zip_code_prefix,
        lower(trim(seller_city))              as seller_city,
        upper(trim(seller_state))             as seller_state

    from source
)

select * from renamed
