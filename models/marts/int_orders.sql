with orders as  (
    select * from {{ ref('stg_orders' )}}
)

, payments as (
    select * from {{ref('stg_stripe__payments')}}
)

, order_payments as (
    select 
        order_id,
        sum(amount) as amount
    from payments
    where status <> 'fail'
    group by 1
)

, final as (
    select 
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount,0) as order_total
    from orders
        left join order_payments
            on orders.order_id = order_payments.order_id
)

select *
from final