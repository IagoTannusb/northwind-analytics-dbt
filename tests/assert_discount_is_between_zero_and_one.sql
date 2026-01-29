-- Discount should be a percentage between 0 and 1.
-- This test catches cases where someone might have entered '15' instead of '0.15'.

select
    order_id, 
    discount
from {{ ref('fct_sales')}}
where discount < 0 or discount > 1