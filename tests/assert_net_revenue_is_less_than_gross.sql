-- The net revenue should never exceed the gross revenue.
-- If it does, something is wrong with the discount calculation.
select 
    order_id,
    gross_revenue,
    net_revenue
from {{ref('fct_sales')}}
where net_revenue > gross_revenue
