with customers as (
    select * from {{ ref('stg_customers') }}
),

bookings as (
    select * from {{ ref('stg_bookings') }}
),

-- تجميع بيانات الحجوزات لكل عميل على حدة
customer_bookings as (
    select
        customer_id,
        count(order_id)    as total_orders,
        min(ordered_at)    as first_order_at,
        max(ordered_at)    as last_order_at
    from bookings
    group by customer_id
),

-- الدمج النهائي لبيانات العميل مع إحصائياته
final as (
    select
        c.customer_unique_id,
        c.zip_code_prefix,
        c.customer_city,
        c.customer_state,
        coalesce(b.total_orders, 0) as total_orders,
        b.first_order_at,
        b.last_order_at
    from customers c
    left join customer_bookings b on c.customer_id = b.customer_id
)

select * from final