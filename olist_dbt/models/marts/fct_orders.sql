with bookings as (
    select * from {{ ref('stg_bookings') }}
),
order_items as (
    select * from {{ ref('stg_order_items') }}
),
order_payments as (
    select * from {{ ref('stg_order_payments') }}
),
order_reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

order_items_summary as (
    select
        order_id,
        count(product_id)           as total_items_count,
        sum(item_price_brl)         as total_item_price_brl,
        sum(freight_cost_brl)       as total_freight_cost_brl,
        sum(total_line_item_brl)    as total_order_cost_brl
    from order_items
    group by order_id
),

order_payments_summary as (
    select
        order_id,
        sum(payment_amount_brl)     as total_payment_amount_brl,
        max(is_credit_card)         as paid_by_credit_card
    from order_payments
    group by order_id
),

order_reviews_summary as (
    select
        order_id,
        max(review_score)           as review_score,
        max(sentiment)              as sentiment
    from order_reviews
    group by order_id
),

final as (
    select
        b.order_id,
        b.customer_id,
        b.order_status,
        b.ordered_at,
        b.delivered_at,
        b.actual_delivery_days,
        coalesce(i.total_items_count, 0)        as total_items_count,
        coalesce(i.total_order_cost_brl, 0)     as total_order_cost_brl,
        coalesce(p.total_payment_amount_brl, 0) as total_payment_amount_brl,
        coalesce(p.paid_by_credit_card, false)  as paid_by_credit_card,
        r.review_score,
        r.sentiment
    from bookings b
    left join order_items_summary i    on b.order_id = i.order_id
    left join order_payments_summary p on b.order_id = p.order_id
    left join order_reviews_summary r  on b.order_id = r.order_id
)

select * from final