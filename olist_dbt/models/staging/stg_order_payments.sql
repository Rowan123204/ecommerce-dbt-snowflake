with source as (
    select * from {{ source('raw', 'order_payments') }}
),

renamed as (
    select
        -- Keys
        order_id,
        payment_sequential,

        -- Payment Details
        lower(trim(payment_type))      as payment_type,
        payment_installments,
        payment_value                  as payment_amount_brl,

        -- Feature Engineering: تحديد ما إذا كانت المعاملة ببطاقة الائتمان بنعم/لا
        case
            when lower(trim(payment_type)) = 'credit_card' then true
            else false
        end as is_credit_card

    from source
)

select * from renamed
