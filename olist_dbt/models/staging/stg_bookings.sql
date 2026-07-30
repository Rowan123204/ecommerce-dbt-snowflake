with source as (
    select * from {{ source('raw', 'bookings') }}
),

renamed as (
    select
        -- Primary Keys
        order_id,
        customer_id,

        -- Normalize order status to lowercase for consistency
        lower(trim(order_status)) as order_status,

        -- Rename timestamp columns to cleaner names
        order_purchase_timestamp       as ordered_at,
        order_approved_at              as approved_at,
        order_delivered_carrier_date   as shipped_at,
        order_delivered_customer_date  as delivered_at,
        order_estimated_delivery_date  as estimated_delivery_at,

        -- Feature Engineering: calculate actual delivery duration in days
        datediff(
            'day',
            order_purchase_timestamp,
            order_delivered_customer_date
        ) as actual_delivery_days

    from source
)

select * from renamed