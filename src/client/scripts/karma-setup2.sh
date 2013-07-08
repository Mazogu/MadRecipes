#!/bin/bash

npm install -g karma@canary
npm install -g karma-coverage
npm install -g karma-phantomJS-launcher
npm install -g karma-junit-reporter
npm install -g PhantomJS

cd ~/AppData/Roaming/npm/node_modules
rm -rf karma-ng-html2js-preprocessor
git clone https://github.com/karma-runner/karma-ng-html2js-preprocessor.git
