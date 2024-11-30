# factorio2mqtt

> Note: This is an early release of this mod so there might be issues

This mod when combined with a helper script will publish Factorio events to a MQTT message queue.
Want to turn some light on in Home Assistant when a biter destroys something? Then this is the mod for you.

## Setup

Install the mod and go into Mod Settings and type in the events you want to publish. Some events are prefilled but a complete [list of events can be found here](https://lua-api.factorio.com/latest/events.html).
> You can leave the field for events empty which will subscribe to all events. This isn't recommended though, there are **a lot** of events generated by Factorio.

This mod by itself will do nothing but generate json files in Factorio's script-output directory. To find this directory you can refer to [the Wiki](https://wiki.factorio.com/Application_directory).
You will now need to run the supplied script, or why not write your own publisher. The script is included in the mod's zipfile and is also available in [Github](https://github.com/alu-/factorio2mqtt/tree/main/src/server).
It requires nodejs but there is also a docker image available to use.

### Docker image

A docker image containing node and all packages to run the helper script is available at the [Docker hub](https://hub.docker.com/r/alu87/factorio2mqtt).
You need to provide it with a few environment variables to make it run correctly.

> docker run \
> -e SCRIPT_OUTPUT_PATH=/path/to/factorio/script-output
> -e MQTT_HOST=mqtt://192.168.1.2:1883 \
> -e MQTT_USERNAME=username \
> -e MQTT_PASSWORD=password \
> -d
> alu87/factorio2mqtt:latest

The docker image uses polling instead of file system events as this works better in a container. Should you want more performance you can try to turn it off by supplying *CHOKIDAR_USEPOLLING=false* as an environment variable.

There is also a *docker-compose.yml* and *.env* file [in Github](https://github.com/alu-/factorio2mqtt/tree/main/src/server). If you don't have an MQTT server already than this compose file is an excellent place to add one.

### Run the script manually

You need to edit the .env file and supply it with all MQTT_ variables. You can ignore SCRIPT_OUTPUT_PATH as this is used by docker-compose.
You will need to run the following:
> npm install
> node --env-file=.env index.js /my/path/to/factorio/script-output

If the script suddenly stops sending events you can try by turning on polling by supplying entering *CHOKIDAR_USEPOLLING=true* in the .env file.

## Issues, bugs and feature requests

Should you find an issue, have a feature request or anything else please raise an [issue in Github](https://github.com/alu-/factorio2mqtt/issues).

- This mod hasn't been tested in multiplayer yet
- Some events likely aren't hydrated - meaning that they appear as null even though they should contain more data. If you need them to be please raise an issue in Github, or why not contribute. I accept pull requests gladly, if they are sane.
- Unsure if this mod is compatible with other mods that are using custom events
