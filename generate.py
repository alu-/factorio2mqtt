#!/usr/bin/env python3
import json
from pprint import pprint

print("Loading JSON")
with open("runtime-api.json") as f:
    data = json.load(f)

entities = []
for factorio_defines in data.get('defines'):
    if factorio_defines.get('name') == "prototypes":
        for subkey in factorio_defines.get('subkeys'):
            if subkey.get('name') == 'entity':
                entities = subkey.get('values')

print("Writing entities.lua")
with open("./src/addon/entities.lua", "w") as f:
    f.write("local entities = {\n");
    for entity in entities:
        f.write("\t[\"{}\"] = {},\n".format(entity.get("name"), "{\"greger\"}"))

    
    f.write("}")
    f.write("""
return entities
    """)
    

print("Done!")
