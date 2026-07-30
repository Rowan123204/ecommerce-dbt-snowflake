with source as (
    select * from {{ source('raw', 'listings') }}
),

renamed as (
    select
        -- Primary Key
        product_id,

        -- Category
        lower(trim(product_category_name))                  as product_category,

        -- Physical attributes
        product_weight_g                                    as weight_grams,
        product_length_cm                                   as length_cm,
        product_height_cm                                   as height_cm,
        product_width_cm                                    as width_cm,
        product_photos_qty                                  as photos_count,

        -- Fix source typos (lenght -> length)
        product_name_lenght                                 as product_name_length,
        product_description_lenght                          as product_description_length,

        -- Feature Engineering: calculate product volume
        (product_length_cm * product_height_cm * product_width_cm) as volume_cm3

    from source
)

select * from renamed