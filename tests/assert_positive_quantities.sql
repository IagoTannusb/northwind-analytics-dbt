-- Sales should always have a quantity greater than zero.
select 
    order_id,
    quantity
from {{ ref('fac_sales')}}
where quantity <= 0