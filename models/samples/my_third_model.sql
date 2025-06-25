SELECT 
*
,'hello world' as col1
FROM {{ ref('my_second_model') }}