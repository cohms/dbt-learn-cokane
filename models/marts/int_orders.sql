with orders as (
    select * from {{ref('stg_orders')}}
)

, payments as (
    select * from {{ref('stg_stripe__payments')}}
    where status <> 'fail'
)


, joined as (
    Select 
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        sum(amount) as order_total

    from orders 
        left join payments 
            on orders.order_id = payments.order_id
    group by 1,2,3,4       
)

select *
from joined