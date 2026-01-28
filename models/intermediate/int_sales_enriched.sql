with orders as (
    select * from  {{ref('stg_orders')}}
),

order_details as (
    select * from {{ref('stg_order_details')}}
),

products as (
    select * from {{ref('stg_products')}}
),

customers as (
    select * from {{ref('stg_customers')}}
),

joined as (
    select 
        -- Chaves (IDs)
        od.order_id,
        od.product_id,
        o.customer_id,
        o.employee_id,

        -- Datas e Detalhes do pedido
        o.order_date,
        o.required_date,
        o.ship_country,
        o.ship_city,

        -- detalhes do produto e do cliente
        p.product_name,
        c.company_name as customer_name,

        -- metricas
        od.unit_price,
        od.quantity,
        od.discount,

        -- Regra de negócio: calculo do dotal (preco x qtd - desconto)
        (od.unit_price * od.quantity) as gross_revenue,
        (od.unit_price * od.quantity * (1 - od.discount)) as net_revenue
    from order_details od
    left join orders o on od.order_id = o.order_id
    left join products p on od.product_id = p.product_id
    left join customers c on o.customer_id = c.customer_id
)
select * from joined