test:
	rm -rf /opt/factorio/mods/factorio2mqtt/*
	cp -r src/addon/* /opt/factorio/mods/factorio2mqtt/
	/opt/factorio/bin/x64/factorio --load-game test
