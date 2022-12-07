{% macro default__create_table_as(temporary, relation, sql) -%}
    {{ dbt.default__create_table_as(temporary, relation, dbt_inheritance.rewrite_sql(sql)) }}
{%- endmacro %}
