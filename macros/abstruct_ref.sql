{%- macro abstruct_ref(name) %}
    {{ return("{{ dbt_inheritance.concreate_ref('" ~ name ~ "') }}") }}
{%- endmacro %}

{%- macro concreate_ref(name) %}
    {%- if execute %}
        {%- set resolver = config.get('abstruct_ref_resolver', none) %}
        {%- if resolver is none %}
            {{ exceptions.raise_compiler_error("`abstruct_ref_resolver` config not found in "~model['unique_id']~", please call dbt_inheritance.resolve_abstruct_ref macro") }}
        {%- endif %}
        {%- if name not in resolver %}
            {{ exceptions.raise_compiler_error("`abstruct_ref_resolver` config not include `"~name~"` in "~model['unique_id']) }}
        {%- endif %}
        {{ ref(resolver[name]) }}
    {%- endif %}
{%- endmacro %}

{%- macro resolve_abstruct_ref() %}
    -- abstruct_ref resolver
    {%- for key, value in kwargs.items() %}
    --    depends on: dbt_inheritance.concreate_ref('{{ key }}') as {{ ref(value) }}
    {%- endfor %}
    {%- if not execute %}
        {%- do config.set('abstruct_ref_resolver', kwargs) %}
    {%- endif %}
{%- endmacro %}
