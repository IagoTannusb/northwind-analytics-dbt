with source as (
    select * from {{ source('northwind', 'customers') }}
),

renamed as (
    select
        customer_id,
        company_name,
        contact_name,
        phone,
        city,
        region,
        country
    from source
)

select * from renamed