import json
import re
import os
import random
import csv


def extract_plain_text(message):
    """
    Extract plain text from the message. If the message is a string, return it as is.
    If the message is a list of dictionaries or strings, concatenate the plain text parts
    and remove special symbols.
    """
    if isinstance(message, str):
        plain_text = message
    elif isinstance(message, list):
        plain_text = ""
        for part in message:
            if isinstance(part, dict) and part.get('type') == 'plain':
                plain_text += part.get('text', '')
            elif isinstance(part, str):
                plain_text += part
    else:
        return ""

    # Remove special symbols using regular expressions
    plain_text = re.sub(r'[^\w\s.,?!]', '', plain_text)
    return plain_text


def process_json_files(folder_path, label, sample_size):
    """
    Process JSON files in the specified folder and return a list of messages with the specified label.
    """
    messages = []
    for filename in os.listdir(folder_path):
        if filename.endswith('.json'):
            with open(os.path.join(folder_path, filename), 'r', encoding='utf-8') as file:
                data = json.load(file)
                for message in data.get('messages', []):
                    plain_text = extract_plain_text(message.get('text'))
                    if plain_text:
                        messages.append((plain_text.strip(), label))

    # Check if the number of messages is less than the sample size
    if len(messages) < sample_size:
        sample_size = len(messages)

    return random.sample(messages, sample_size)


# Paths to the folders containing the JSON files
fake_folder_path = 'data-tg/FAKE'
positive_folder_path = 'data-tg/POSITIVE'

# Sample size
sample_size = 5000

# Process the FAKE and POSITIVE folders
fake_messages = process_json_files(fake_folder_path, False, sample_size)
positive_messages = process_json_files(positive_folder_path, True, sample_size * 3)

# Save to CSV files
with open('/Users/viktorsovyak/education/Mohyla/23-24/summer/ml-ios/python-script/new/NEW_FAKE.csv', 'w', encoding='utf-8', newline='') as fake_file:
    writer = csv.writer(fake_file)
    writer.writerow(['Text', 'Label'])
    writer.writerows(fake_messages)

with open('/Users/viktorsovyak/education/Mohyla/23-24/summer/ml-ios/python-script/new/NEW_POSITIVE.csv', 'w', encoding='utf-8', newline='') as positive_file:
    writer = csv.writer(positive_file)
    writer.writerow(['Text', 'Label'])
    writer.writerows(positive_messages)

print(f"FAKE.csv contains {len(fake_messages)} rows")
print(f"POSITIVE.csv contains {len(positive_messages)} rows")