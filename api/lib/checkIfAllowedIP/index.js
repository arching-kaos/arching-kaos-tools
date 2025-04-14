function checkIfAllowedIP(address)
{
    var test_cjdns = /^fc[0-9a-z]{1,2}:([0-9a-z]{1,4}:){1,6}[0-9a-z]{1,4}/
    var test_yggdrasil = /^2[0-9a-z]{1,2}:([0-9a-z]{1,4}:){1,6}[0-9a-z]{1,4}/
    var test_yggdrasil_sub = /^3[0-9a-z]{1,2}:([0-9a-z]{1,4}:){1,6}[0-9a-z]{1,4}/
    return (test_cjdns.test(address) || test_yggdrasil.test(address) || test_yggdrasil_sub.test(address)) ? true : false;
};

module.exports = checkIfAllowedIP;
