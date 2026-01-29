-- Gross revenue must equal quantity * unit_price.
-- We use a small threshold (0.01) to account for floating point rounding issues.
select
    order_id, 
    quantity,
    unit_price,
    gross_revenue,
    abs(gross_revenue - (quantity * unit_price)) as difference
from {{ref('fct_sales')}}
where abs(gross_revenue - (quantity * unit_price)) > 0.01