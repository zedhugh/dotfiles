#!/usr/bin/env node

/**
 * 通过 rust 项目中的 Cargo.lock 文件解析项目依赖及其版本
 * 结果格式为: 包名-版本
 */

/**
 * @param {string} str
 */
const parseItem = (str) => {
    const rows = str.split('\n').filter((row) => {
        return row.startsWith('name') || row.startsWith('version');
    });
    const list = rows.map((row) => {
        return row.split('=').map((arr) => arr.trim());
    });

    let name = '';
    let version = '';
    list.map(([key, val]) => {
        if (key === 'name') {
            name = JSON.parse(val);
        } else if (key === 'version') {
            version = JSON.parse(val);
        }
    });
    if (name && version) {
        return [name, version];
    }
}

/**
 * @param {string} str
 */
const parse = (str) => {
    const pkgSeparator = '[[package]]';
    const idx = str.indexOf(pkgSeparator);
    if (idx >= 0) {
        str = str.slice(idx);
    }

    const arr = str.split(pkgSeparator).filter(Boolean);
    const list = arr.map(parseItem).filter(Boolean).map((item) => item.join("-"));
    const result = list.join('\n');
    return result
}

// parse('./Downloads/Cargo.lock');

/**
 * @param {string} commit 提交 Hash 值
 * @returns {Promise<string>}
 */
const fetchCragoLock = async (commit) => {
    const url = `https://raw.githubusercontent.com/shadowsocks/shadowsocks-rust/${commit}/Cargo.lock`;
    if (global.fetch) {
        const resp = await fetch(url);
        if (resp.status !== 200) {
            const text = await resp.text();
            throw new Error(text);
        }
        return resp.text();
    }

    return new Promise((resolve, reject) => {
        const https = require('node:https');
        const req = https.request(url, (res) => {
            console.log(32, res.statusCode);
            if (res.statusCode !== 200) {
                reject(new Error(res.statusMessage));
                return;
            }

            let str = '';
            res.on('data', (chunk) => {
                str += chunk;
            });
            res.once('end', () => resolve(str));
            res.once('error', reject);
        });
        req.once('error', reject);
        req.end();
    })
};

const commitPrefix = "-c";
const outputPrefix = "-o";

const showUsage = () => {
    const { basename } = require('node:path');
    const usage = `Usage: ${basename(__filename)} ${commitPrefix} <commit_full_hash | branch | tag> [${outputPrefix} output_file_path]`;
    console.error(usage);
}

const parseCmdArgs = () => {
    const argStartIndex = process.argv.indexOf(__filename) + 1;
    const args = process.argv.slice(argStartIndex);
    if (args.length !== 2 && args.length !== 4) {
        showUsage();
        return;
    }

    const commitHashIndex = args.indexOf(commitPrefix);
    if (commitHashIndex === -1) {
        showUsage();
        return;
    }
    const commit = args.at(commitHashIndex + 1);
    if (!commit) {
        showUsage();
        return;
    }

    const cmdArgs = { commit, output: '' };
    const outputIndex = args.indexOf(outputPrefix);
    if (outputIndex === -1) {
        return cmdArgs;
    }
    const output = args.at(outputIndex + 1);
    if (output) {
        cmdArgs.output = output;
    }
    return cmdArgs
};

const doTask = async () => {
    const cmdArgs = parseCmdArgs();
    const commit = cmdArgs?.commit;
    const output = cmdArgs?.output;
    if (!commit) return;

    try {
        const content = await fetchCragoLock(cmdArgs.commit);
        const result = parse(content);
        if (!output) {
            console.log(result);
            return
        }

        const fs = require('node:fs');
        const path = require('node:path');
        const outputPath = path.join(process.cwd(), output);
        const outputDir = path.dirname(outputPath);
        fs.mkdirSync(outputDir, { recursive: true });
        fs.writeFileSync(outputPath, result);
        console.info(`result has writen into "${output}"`)
    } catch (err) {
        console.error(err);
    }
};

doTask();
