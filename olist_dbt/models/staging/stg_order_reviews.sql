with source as (
    select * from {{ source('raw', 'order_reviews') }}
),

renamed as (
    select
        -- Primary Key
        review_id,

        -- Foreign Key
        order_id,

        -- Score (1-5)
        review_score,

        -- Text fields
        trim(review_comment_title)     as review_title,
        trim(review_comment_message)   as review_message,

        -- Timestamps
        review_creation_date           as review_created_at,
        review_answer_timestamp        as review_answered_at,

        -- Feature Engineering 1: classify review score into sentiment buckets
        case
            when review_score >= 4 then 'positive'
            when review_score = 3  then 'neutral'
            else 'negative'
        end as sentiment,

        -- Feature Engineering 2: boolean flag for reviews that include a written comment
        case
            when review_comment_message is not null
             and trim(review_comment_message) != '' then true
            else false
        end as has_comment

    from source
)

select * from renamed