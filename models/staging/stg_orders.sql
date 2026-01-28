with source as (
    select * from {{source('northwind', 'orders')}}
), 

renamed as (
    select
        order_id,
        customer_id,
        employee_id,
        order_date,
        required_date,
        shipped_date,
        ship_via as shipper_id,      
        freight as shipping_cost,    
        ship_name,
        ship_city,
        ship_country
    from source
)

select * from renamed