-- The accumulated sales should always be equal to or greater than the previous day.
-- We use the LAG function to compare the current total with the previous one.
with validation as (
    select
        order_date,
        total_accumulated_orders,
        lag(total_accumulated_orders) over (order by order_date) as previous_total
    from {{ ref('fct_daily_accumulated_sales') }}
)

select *
from validation
where total_accumulated_orders < previous_total