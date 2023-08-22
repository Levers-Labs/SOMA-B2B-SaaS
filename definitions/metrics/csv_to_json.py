import csv
import json
import os
import re

# Function to sanitize the file name
def sanitize_filename(value):
    # Remove any character that is not a letter, number, underscore, or hyphen
    return re.sub(r'[^\w\-]', '', value)

# Path to the CSV file
csv_file_path = 'metrics.csv'

# Read the CSV file
with open(csv_file_path, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    
    # Iterate through the rows and convert each to JSON
    for row in reader:
        # Get the value from the first column and sanitize it to create the JSON file name
        json_file_name = f'{sanitize_filename(row[list(row.keys())[0]])}.json'
        
        # Write the row to the JSON file
        with open(os.path.join(os.path.dirname(csv_file_path), json_file_name), 'w', encoding='utf-8') as jsonfile:
            json.dump(row, jsonfile, ensure_ascii=False, indent=4)
            
print("JSON files created successfully.")