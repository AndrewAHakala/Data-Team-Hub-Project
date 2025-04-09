select *
,'hello world' as col
FROM {{ ref('my_second_model') }}