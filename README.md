# dbt-inheritance

これはTwitterで たきもさんが呟いていたもののPoCコードです。

https://twitter.com/takimo/status/1596108180668366848?s=20&t=eGWiRIYSDY-ExfXIUINbog

## 使い方

dbtのbuiltinされているcreate_table_asというマクロを書き換えます。　

macros/override.sql
```sql
{% macro default__create_table_as(temporary, relation, sql) -%}
    {{ dbt.default__create_table_as(temporary, relation, dbt_inheritance.rewrite_sql(sql)) }}
{%- endmacro %}
```

その後、クラス定義（ephemeral）に該当するものを以下のように書く
```sql
{{
    config(
        materialized='ephemeral'
    )
}}

select *
from {{ dbt_inheritance.abstruct_ref('base') }}
```

refを書き換えるのではなく、専用の抽象的なrefを用意することにした。

コレを外部（呼び出し側）では
```sql
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
```

というように 呼び出し側のモデルで `dbt_inheritance.resolve_abstruct_ref()` マクロを呼び出して、実際のrefを遅延で解決する。

## このままでは実用できない点

- materialization `table` のみでしか動作確認してない。　(基本的には `create_table_as` を使うので多分動くとは思うが)
- ephemeral側でtestが書けない。
- compiled_codeにJinja templateが入っていて、２階建てテンプレートになっている。

