with daily_metrics as (
    select
        order_date,
        count(distinct order_id) as daily_order_count,
        sum(net_revenue) as daily_revenue
    from {{ ref('fct_sales') }}
    group by 1
),

accumulated as (
    select
        order_date,
        daily_order_count,
        daily_revenue,
        sum(daily_order_count) over (order by order_date rows between unbounded preceding and current row) as total_accumulated_orders,
        sum(daily_revenue) over (order by order_date rows between unbounded preceding and current row) as total_accumulated_revenue
    from daily_metrics
)

select * from accumulated