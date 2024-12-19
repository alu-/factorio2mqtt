#!/usr/bin/env python3
import json
import re
from functools import cache
import luadata
from pprint import pprint


"""
Write entity and class data into separate files.
"""
def main():
    entities()
    class_definitions()


"""
1. Get a list of all entities with dashed names (straight-rail, spider-vehicle, etc)
2. Get a list of entity classes, including parents.
3. Get a list of all attributes
4. Compile a entities.lua file
"""
def entities():
    entities = load_entities()
    entity_to_classes = dict((el, get_classes_for_entity(el)) for el in entities)
    output = dict((entity, get_attributes_for_classes(classes)) for entity, classes in entity_to_classes.items())
    luadata.write("./src/addon/entities.lua", output, encoding="utf-8", indent="\t", prefix="return ")


def class_definitions():
    classes = read_runtime_api().get("classes")
    def _collect_class_with_parents(class_name, methods=None, attributes=None, depth=0):
        if methods is None:
            methods = {}
        if attributes is None:
            attributes = {}

        for factorio_class in classes:
            if factorio_class.get("name") == class_name:
                for method in factorio_class.get("methods", []):
                    methods[method.get("name")] = method.get("subclasses", [])
                for attribute in factorio_class.get("attributes", []):
                    if attribute.get("read_type", None):
                        attributes[attribute.get("name")] = attribute.get("subclasses", [])

                if factorio_class.get("parent"):
                    methods, attributes = _collect_class_with_parents(factorio_class.get("parent"), methods, attributes, (depth + 1))

        return methods, attributes

    data = {}
    for factorio_class in classes:
        methods, attributes = _collect_class_with_parents(factorio_class.get("name"))
        data[factorio_class.get("name")] = {
            "methods": methods,
            "attributes": attributes
        }

    luadata.write("./src/addon/classes.lua", data, encoding="utf-8", indent="\t", prefix="return ")


@cache
def read_runtime_api():
    return json.load(open("runtime-api.json"))


@cache
def read_prototype_api():
    return json.load(open("prototype-api.json"))


def load_entities():
    defines = read_prototype_api().get("defines")
    prototypes = [x for x in defines if x['name'] == 'prototypes']
    subkeys = prototypes[0].get("subkeys")
    entities = [x for x in subkeys if x['name'] == 'entity']

    return [x['name'] for x in entities[0].get("values")]


def get_classes_for_entity(entity: str) -> list:
    for p in read_prototype_api().get("prototypes"):
        if p.get("typename", None) == entity:
            mainClass = p
            break

    def recurse_parents(prototype_name, result=[]):
        for p in read_prototype_api().get("prototypes"):
            if p.get("name") == prototype_name:
                name = p.get("name")
                if not name in result:
                    result.append(name)

                parent = p.get("parent", None)
                if parent:
                    recurse_parents(parent, result)
                break

        return result


    return recurse_parents(mainClass.get("name"))


def get_attributes_for_classes(classes) -> list:
    attributes = []
    for class_name in classes:
        subclass_name = class_name.removesuffix("Prototype") if class_name != "Prototype" else class_name
        for factorio_class in read_runtime_api().get('classes'):
            if factorio_class.get("name") == "LuaEntity": # or LuaEntityPrototype?
                for attribute_data in factorio_class.get('attributes'):
                    subclasses = attribute_data.get('subclasses', [])
                    if subclass_name in subclasses:
                        attribute_name = attribute_data.get("name")
                        if attribute_name not in attributes:
                            attributes.append(attribute_name)

    return attributes


if __name__ == "__main__":
    main()
