with orders as (
    select * from {{ ref('fct_orders') }}
),

monthly_revenue as (
    select
        date_trunc('month', ordered_at)     as order_month,
        count(order_id)                     as total_orders,
        count(distinct customer_id)         as unique_customers,
        sum(total_order_cost_brl)           as total_revenue_brl,
        avg(total_order_cost_brl)           as avg_order_value_brl,
        avg(actual_delivery_days)           as avg_delivery_days,
        sum(case when order_status = 'delivered' then 1 else 0 end) as delivered_orders,
        sum(case when order_status = 'cancelled' then 1 else 0 end) as cancelled_orders
    from orders
    group by date_trunc('month', ordered_at)
)

select * from monthly_revenue
order by order_month