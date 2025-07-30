select *
,'col' as column
from {{ ref('my_second_model') }}