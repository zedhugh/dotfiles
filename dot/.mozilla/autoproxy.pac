/* -*- mode: js; -*- */
const proxy_ip = "192.168.0.104"
const PROXY = `SOCKS5 ${proxy_ip}:20170; HTTP ${proxy_ip}:20172; DIRECT`;
const DIRECT = 'DIRECT';

const direct_ip_list = [
    ["192.168.0.0", "255.255.255.0"],
    ["192.168.1.0", "255.255.255.0"],
    ["192.168.2.0", "255.255.255.0"],
];

const direct_domain_list = [
    "zedhugh.fun",
    "codeberg.org",
    "gitweb.gentoo.org",
];

/**
 * @params {string} host
 * @return {boolean}
 */
const host_should_direct = (host) => {
    return direct_ip_list.some(([ip, mask]) => {
        return isInNet(host, ip , mask);
    });
};

/**
 * @params {string} host
 * @return {boolean}
 */
const domain_should_direct = (host) => {
    const domains = direct_domain_list.map((domain) => `*${domain}*`);
    return domains.some((domain) => shExpMatch(host, domain));
};

function FindProxyForURL(url, host) {
    if (host_should_direct(host) || domain_should_direct(host)) {
        alert(`DIRECT: ${url}||${host}`);
        return DIRECT;
    }

    alert(`PROXY: ${url}||${host}`);
    return PROXY;
}
