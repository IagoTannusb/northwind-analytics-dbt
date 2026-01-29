-- A receita acumulada deve ser sempre maior ou igual à do dia anterior.
with validation as (
    select
        order_date,
        total_accumulated_revenue,
        lag(total_accumulated_revenue) over (order by order_date) as previous_revenue_total
    from {{ ref('fct_daily_accumulated_sales') }}
)

select *
from validation
where total_accumulated_revenue < previous_revenue_total