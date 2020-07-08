
const runTestsOnFolder = require('./Tests');
const path = require('path');

runTestsOnFolder(path.join(__dirname, "/../", "tests"));
