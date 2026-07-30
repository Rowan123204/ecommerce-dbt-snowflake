with source as (
    select * from {{ source('raw', 'bookings') }}
),

renamed as (
    select
        -- 1. الكود الأساسي (الـ Keys)
        order_id,
        customer_id,

        -- 2. تنظيف حالة الطلب (نخليه حروف صغيرة وممسوح منه أي مسافات زيادة)
        lower(trim(order_status)) as order_status,

        -- 3. التواريخ (مترتبة وجاهزة)
        order_purchase_timestamp       as ordered_at,
        order_approved_at              as approved_at,
        order_delivered_carrier_date   as shipped_at,
        order_delivered_customer_date  as delivered_at,
        order_estimated_delivery_date  as estimated_delivery_at,

        -- 4. عملية حسابية: حساب فرق الأيام الفعلي بين تاريخ الشراء وتاريخ التوصيل
        datediff(
            'day',
            order_purchase_timestamp,
            order_delivered_customer_date
        ) as actual_delivery_days

    from source
)

select * from renamed