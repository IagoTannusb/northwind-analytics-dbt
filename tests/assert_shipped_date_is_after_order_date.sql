-- Shipped date must be greater than or equal to order date.
-- If this fails, there is a data entry error in the source system.
select 
    order_id,
    order_date,
    shipped_date
from {{ref('stg_orders')}}
where shipped_date < order_date