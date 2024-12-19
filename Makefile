.PSEUDO: test monitor generate

test:
	rm /opt/factorio/script-output/factorio2mqtt_*.json
	rm -rf /opt/factorio/mods/factorio2mqtt
	mkdir -p /opt/factorio/mods/factorio2mqtt
	cp -r src/mod/* /opt/factorio/mods/factorio2mqtt/
	/opt/factorio/bin/x64/factorio --load-game world

monitor:
	inotifywait -m /opt/factorio/script-output -e create -e moved_to | while read -r dir action file; do cat "$${dir}$${file}" | jq; done

prototype-api.json:
	wget https://lua-api.factorio.com/stable/prototype-api.json

runtime-api.json:
	wget https://lua-api.factorio.com/stable/runtime-api.json

generate: prototype-api.json runtime-api.json
	python3 generate.py
