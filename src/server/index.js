import chokidar from 'chokidar';
import fs from "fs";
import { basename, resolve } from "path";
import mqtt from "mqtt";
import { createLogger, LogContexts, LogLevels } from 'bs-logger';

const logger = createLogger({ 
    [LogContexts.application]: 'factorio2mqtt',
    targets: "stdout:" + (process.env.LOG_TARGETS || LogLevels.info)
});

const args = process.argv.slice(2);
if (args.length === 0) {
    logger.fatal("Please run with path to script-output directory.");
    process.exit(1);
}

if (!fs.existsSync(args[0])) {
    logger.fatal("Provided path to script-output doesn't exist.");
    process.exit(1);
}

// @todo handle files containing faulty json, they might not have been fully written yet
// @todo test slow writes
async function handle(path) {
    fs.readFile(path, function (err, data) {
        if (err) throw err;

        const transaction = JSON.parse(data);
        client.publish(
            "factorio/" + transaction.name, 
            JSON.stringify(transaction)
        );

        fs.unlink(path, (err) => {
            if (err) throw err;
            logger.debug("Unlinked: " + path);
        });
    });

}
logger("Connecting to MQTT");
const client = mqtt.connect(process.env.MQTT_HOST, {
    "username": process.env.MQTT_USERNAME,
    "password": process.env.MQTT_PASSWORD,
});

client.on("connect", () => {
    logger("Connected to MQTT server");
    chokidar
        .watch(
            args[0],
            {
                persistent: true,
                depth: 0,
                //awaitWriteFinish: true // @todo test if this is needed with Factorio..
                followSymlinks: false,
                alwaysStat: false,
            })
        .on('add', (path) => {
            logger.debug("Found new file", path);
            const filename = basename(path);
            if (filename.startsWith('factorio2mqtt_')) {
                handle(path);
            }
        });
})
    .on("reconnect", () => {
        logger.info("Reconnecting to MQTT")
    })
    .on("error", function (error) {
        console.info("Error with MQTT: ", error);
    });