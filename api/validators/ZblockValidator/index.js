/*
 * To verify a block we simply put it on `enter`. `enter` will crawl
 * the zchain that is connected to the zblock we got. If it fails for
 * any reason we can check `logfollow` for that.
 * 
 * We send the data tested and the exit code to continuethings()
 *
 */
module.exports = (ch, res) => {
    const command = spawn("ak-enter",[ch]);
    response_string = "";
    command.stdout.on("data", data => {
        response_string = response_string + data;
        console.log(`${data}`);
    });

    command.stderr.on("data", data => {
            console.log(`stderr: ${data}`);
    });

    command.on('error', (error) => {
            console.log(`error: ${error.message}`);
    });

    command.on("close", code => {
        console.log(`child process exited with code ${code}`);
        continuethings(code,ch,res);
    });
};
