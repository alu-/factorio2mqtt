import chokidar from 'chokidar';
import fs from "fs";
import {basename} from "path";
import mqtt from "mqtt";

const client = mqtt.connect("mqtt://test.mosquitto.org");

const args = process.argv.slice(2);
if (args.length === 0) {
    console.log("Please run with path to script-output directory.");
    process.exit(1);
}

if (!fs.existsSync(args[0])) {
    console.log("Provided path doesn't exist.");
    process.exit(1);
}

async function handle(path)
{
    fs.readFile(path, function(err, data) {
        if (err) throw err;

        const transaction = JSON.parse(data);
        console.log(transaction);
        client.publish("factorio", JSON.stringify(transaction));
    });

}

chokidar
    .watch(
        args[0],
        {
            depth: 0,
            awaitWriteFinish: true
        })
    .on('add', (path) => {
        const filename = basename(path);
        if (filename.startsWith('factorio2mqtt_')) {
            console.log(path);
            handle(path);
        }
    }
);

