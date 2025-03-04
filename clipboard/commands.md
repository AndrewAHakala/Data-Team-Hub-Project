### kicking out a dbt model
dbt run --select monthly_gross_revenue

### list all SL metrics 
dbt sl list metrics

### list SL dimensions for a metric 
dbt sl list dimensions --metrics order_total

### list SL entities for a metric 
dbt sl list entities --metrics order_total

### list all value for a given dimensions
dbt sl list dimensions --metrics order_total

### viewing a SL metric SQL
dbt sl query --metrics order_total --group-by customer__customer_state --order-by order_total --compile

### querying a SL metric by a dimension 
dbt sl query --metrics order_total --group-by customer__customer_state --order-by order_total

### querying a SL metric by multiple dimensions
dbt sl query --metrics order_total --group-by customer__customer_state,customer__customer_gender

### running a SL export cc
dbt sl export --saved-query order_metrics

### query a cumulative metric
dbt sl query --metrics cumulative_orders --group-by transaction_id__purchase_datetime__day

### query a cumulative metric w/ filter
dbt sl query --metrics cumulative_orders --group-by transaction_id__purchase_datetime__day --where "{{ TimeDimension('transaction_id__purchase_datetime', 'year') }} = '2023-01-01'"