{{
    config(
        materialized='ephemeral'
    )
}}

select *
from {{ dbt_inheritance.abstruct_ref('base') }}
