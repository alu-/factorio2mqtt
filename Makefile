test:
	rm -rf /opt/factorio/mods/factorio2mqtt/*
	cp -r src/addon/* /opt/factorio/mods/factorio2mqtt/
	/opt/factorio/bin/x64/factorio --load-game world


parse:
	cat runtime-api.json | jq '.classes[] | select( .name == "LuaEntity")' > LuaEntity.json

monitor:
	inotifywait -m . -e create -e moved_to | while read -r d a f; do cat ${f} | jq; done

prototype-api.json:
	wget https://lua-api.factorio.com/latest/prototype-api.json

runtime-api.json:
	wget https://lua-api.factorio.com/latest/runtime-api.json

src/addon/entities: runtime-api.json prototype-api.json
	python3 generate.py