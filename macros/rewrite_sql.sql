{%- macro use_abstruct_ref(model) %}
    {%- if 'macro.dbt_inheritance.abstruct_ref' in model['depends_on']['macros'] %}
        {{ return(True) }}
    {%- endif %}
    {%- if not model['extra_ctes_injected'] %}
        {{ return(False) }}
    {%- endif %}
    {%- for extra_cte in model['extra_ctes'] %}
        {%- set cte_node = graph.nodes[extra_cte.id] %}
        {%- if 'macro.dbt_inheritance.abstruct_ref' in cte_node['depends_on']['macros'] %}
            {{ return(True) }}
        {%- endif %}
    {%- endfor %}
    {{ return(False) }}
{%- endmacro %}

{%- macro rewrite_sql(sql) %}
    {%- if dbt_inheritance.use_abstruct_ref(model) %}
        {{ return(render(sql)) }}
    {%- endif %}
    {{ return(sql) }}
{%- endmacro %}
