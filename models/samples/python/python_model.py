import random 

def model(dbt, session):
    
    # setting configuration
    dbt.config(materialized="table")

    # grabbing a sql model I built in dbt and pushing it to a pandas df
    my_sql_model_df = dbt.ref("pre_model").to_pandas()

    # creating a basic list to use for random colum rand
    num_list = [1, 2, 3, 4, 5]

    # adding a new column which will have a rand number picked from the list
    my_sql_model_df['new_column_rand'] = [random.choice(num_list) for row in my_sql_model_df.index]

    # renaming my model and ordering by the random added column
    final_df = my_sql_model_df.sort_values(by=['new_column_rand'])

    # returning my model
    return final_df