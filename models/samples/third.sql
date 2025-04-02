select *
,t.new_column*100
,'col1' as col
FROM {{ ref('my_second_model') }} t