{{ audit_helper.compare_relation_columns(
    a_relation = source('tpch', 'customer'),
    b_relation = ref('control_customer')
) }}