{{
    config(
        materialized='table',
    )
}}

with data as (
    select * from {{ ref('yyyyyy') }}
)
select *
from data
