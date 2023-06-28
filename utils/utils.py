import json

def get_value_from_json(json_string):
    open_data = open(json_string, encoding='utf-8')
    data = json.load(open_data)
    return data
