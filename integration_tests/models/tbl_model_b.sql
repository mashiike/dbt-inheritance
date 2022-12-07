{{
    config(
        materialized='table',
    )
}}
{{
    dbt_inheritance.resolve_abstruct_ref(
        base='yyyyyy',
    )
}}

with data as (
    select * from {{ ref('eph_model_a') }}
)
select *
from data
