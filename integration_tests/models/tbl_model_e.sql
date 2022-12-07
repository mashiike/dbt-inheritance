{{
    config(
        materialized='table',
    )
}}

with data as (
    select * from {{ ref('xxxxxx') }}
)
select *
from data
