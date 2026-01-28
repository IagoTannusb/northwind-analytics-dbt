with enriched_data as (
    select * from {{ ref('int_sales_enriched') }}
)

select
    order_id,
    product_id,
    customer_id,
    employee_id,
    order_date,
    ship_country,
    product_name,
    customer_name,
    quantity,
    unit_price,
    discount,
    gross_revenue,
    net_revenue
from enriched_data