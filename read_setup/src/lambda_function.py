import json
import boto3

s3_client = boto3.client('s3')

def read_json_file(s3_Bucket_Name, s3_File_Name):
    """
    Fetch the JSON file from S3 and return it as a Python dictionary.
    """
    try:
        obj = s3_client.get_object(Bucket=s3_Bucket_Name, Key=s3_File_Name)
        body = obj['Body'].read().decode('utf-8')
        return json.loads(body)
    except Exception as e:
        raise Exception(f"Error reading file from S3: {str(e)}")

def read_sql_file(s3_bucket_name, sql_file_path):
    """
    Fetch the SQL file from S3 and return its content as a string.
    """
    try:
        obj = s3_client.get_object(Bucket=s3_bucket_name, Key=sql_file_path)
        return obj['Body'].read().decode('utf-8')
    except Exception as e:
        raise Exception(f"Error reading SQL file from S3: {str(e)}")

def distribute_sql_files(s3_bucket_name, stage_content, sql_content):
    """
    Distribute SQL files into 4 groups based on the stages and add 'sql_text' property.
    """
    groups = {
        'group_1': [],
        'group_2': [],
        'group_3': [],
        'group_4': []
    }

    # Group 1: Distribute all files from bronze_stage
    for stage_name in stage_content['bronze_stage']:
        if stage_name in sql_content:
            # Read the SQL text from S3 and add it to 'sql_text'
            sql_file_path = sql_content[stage_name]['sql_file']
            sql_text = read_sql_file(s3_bucket_name, sql_file_path)
            sql_content[stage_name]['sql_text'] = sql_text
            groups['group_1'].append(sql_content[stage_name])
    
    # Group 2: Distribute files from dimension_stage
    for stage_name in stage_content['dimension_stage']:
        if stage_name in sql_content:
            sql_file_path = sql_content[stage_name]['sql_file']
            sql_text = read_sql_file(s3_bucket_name, sql_file_path)
            sql_content[stage_name]['sql_text'] = sql_text
            groups['group_2'].append(sql_content[stage_name])
    
    # Group 3: Distribute files from fact_stage
    for stage_name in stage_content['fact_stage']:
        if stage_name in sql_content:
            sql_file_path = sql_content[stage_name]['sql_file']
            sql_text = read_sql_file(s3_bucket_name, sql_file_path)
            sql_content[stage_name]['sql_text'] = sql_text
            groups['group_3'].append(sql_content[stage_name])
    
    # Group 4: Distribute files from complex_transformation_stage
    for stage_name in stage_content['complex_transformation_stage']:
        if stage_name in sql_content:
            sql_file_path = sql_content[stage_name]['sql_file']
            sql_text = read_sql_file(s3_bucket_name, sql_file_path)
            sql_content[stage_name]['sql_text'] = sql_text
            groups['group_4'].append(sql_content[stage_name])
    
    return groups

def lambda_handler(event, context):
    """
    AWS Lambda handler function for reading the setup and distributing SQL files into groups.
    """
    s3_Bucket_Name = 'glue-repo-code'
    s3_stage_File_Name = 'bookings/etl_stages.json'
    s3_sql_File_Name = 'bookings/sql_queries.json'
    
    # Read stage content and SQL content from S3
    stage_content = read_json_file(s3_Bucket_Name, s3_stage_File_Name)
    sql_content = read_json_file(s3_Bucket_Name, s3_sql_File_Name)
    
    # Distribute SQL files into groups based on stages
    groups = distribute_sql_files(s3_Bucket_Name, stage_content, sql_content)
    
    # Return the groups for further processing
    return {
        'group_1': groups['group_1'],
        'group_2': groups['group_2'],
        'group_3': groups['group_3'],
        'group_4': groups['group_4']
    }
