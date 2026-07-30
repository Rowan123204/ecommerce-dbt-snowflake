with source as (
    select * from {{ source('raw', 'order_items') }}
),

renamed as (
    select
        -- Composite Key (order_id + order_item_id)
        order_id,
        order_item_id,

        -- Foreign Keys
        product_id,
        seller_id,

        -- Timestamps
        shipping_limit_date            as shipping_limit_at,

        -- Financials (in BRL currency)
        price                          as item_price_brl,
        freight_value                  as freight_cost_brl,

        -- Feature Engineering: total line cost = item price + freight
        (price + freight_value)        as total_line_item_brl

    from source
)

select * from renamed