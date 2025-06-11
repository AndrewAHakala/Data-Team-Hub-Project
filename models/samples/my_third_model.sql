SELECT *
,'col1' as col
FROM {{ ref('my_second_model') }}