const { spawnSync } = require('child_process');

function get_api_bindToIP_value()
{
    const command = spawnSync("ak-settings", ["--get", "api.bindToIP"]);
    var ip_to_bind_onto = command.stdout;
    if ( command.status !== 0 ) {
        return 1;
    } else {
        return ip_to_bind_onto;
    }
}

function return_settings()
{
    const ip = get_api_bindToIP_value();
    const port = 8610;
    const url_prefix = "/v0";
    const protocol = "http://";

    return JSON.parse(JSON.stringify({
        "DEF_PROTO": `${protocol}`,
        "LOCAL_IP": `${ip}`,
        "PORT": `${port}`,
        "URL_PREFIX": `${url_prefix}`
    }));
}

module.exports = return_settings;
