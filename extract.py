import json
import sys

with open(r'C:\Users\Pongo\.gemini\antigravity-ide\brain\ae61b880-a62f-4930-8b38-a34253dd839e\.system_generated\logs\transcript.jsonl', 'r', encoding='utf-8') as f:
    for line in f:
        try:
            data = json.loads(line)
            if data.get('source') == 'USER_EXPLICIT' and data.get('type') == 'USER_INPUT':
                print("---------------------")
                print(data.get('content'))
        except:
            pass
