.PHONY: test_client
test_client_linux:
	rm -rf /opt/factorio/mods/factorio2mqtt/*
	cp -r src/addon/* /opt/factorio/mods/factorio2mqtt/
	/opt/factorio/bin/x64/factorio --load-game test

.PHONY: test_server_linux
test_server_linux:
	rm -rf /opt/factorio-server/mods/factorio2mqtt/*
	cp -r src/addon/* /opt/factorio-server/mods/factorio2mqtt/
	rm -rf /opt/factorio/mods/factorio2mqtt/*
	cp -r src/addon/* /opt/factorio/mods/factorio2mqtt/
	cd /opt/factorio-server && bin/x64/factorio --start-server world --server-settings data/server-settings.json
