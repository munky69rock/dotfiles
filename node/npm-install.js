#!/usr/bin/env node

"use strict";

var pkgs = JSON.parse(require('fs').readFileSync('package.json').toString());

var commands = ['npm', 'install', '-g'];
for (var pkg in pkgs.dependencies) {
  commands.push(pkg);
}
var exec = require('child_process').exec;
var ci = exec(commands.join(' '), function (err, stdout, stderr) {
  console.log('stderr: '  + stderr);
  console.log('stdout: '  + stdout);
  if (err !== null) {
    console.log('[ERROR] ' + err);
  }
});
