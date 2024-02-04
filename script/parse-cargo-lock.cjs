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
 * @param {string} repo github 仓库名
 * @returns {Promise<string>}
 */
const fetchCragoLock = async (repo, commit) => {
    const path = require("node:path");
    const pathName = path.join(repo, commit, "Cargo.lock");
    const url = new URL(pathName, "https://raw.githubusercontent.com/").toString();
    if (global.fetch) {
        const resp = await global.fetch(url, { method: "GET", mode: "cors" });
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
const repoPrefix = "-r";

const showUsage = () => {
    const { basename } = require('node:path');
    const usage = `Usage: ${basename(__filename)} ${repoPrefix} <github repo> ${commitPrefix} <commit_full_hash | branch | tag> [${outputPrefix} output_file_path]`;
    console.error(usage);
}

const parseCmdArgs = () => {
    const argStartIndex = process.argv.indexOf(__filename) + 1;
    const args = process.argv.slice(argStartIndex);
    if (args.length !== 4 && args.length !== 6) {
        showUsage();
        return;
    }

    const repoIndex = args.indexOf(repoPrefix);
    if (repoIndex === -1) {
        showUsage();
        return;
    }
    const repo = args.at(repoIndex + 1);
    if (!repo) {
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

    const cmdArgs = { repo, commit, output: '' };
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
    const repo = cmdArgs?.repo;
    const commit = cmdArgs?.commit;
    const output = cmdArgs?.output;
    if (!repo || !commit) return;

    try {
        const content = await fetchCragoLock(repo, commit);
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
