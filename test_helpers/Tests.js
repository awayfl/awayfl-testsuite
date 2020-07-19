
const fs = require('fs');
const path = require('path');
const PNG = require('pngjs').PNG;
const pixelmatch = require('pixelmatch');

//todo: this will not work when using testsuite in another project:
const TestConfig = require('../TestServerConfig');

var port = 1111;
var onlogMessageDelegate = null;


function loadTestResults(testData) {

	var targetPath = path.join(testData.targetPath, "testData.json");
	if (!fs.existsSync(targetPath)) {
		expect(false).toBeTruthy();
		return;
	}
	let rawdata = fs.readFileSync(targetPath);
	testData.testData = JSON.parse(rawdata);
}
function onTestFinish(page, done, testData) {

	loadTestResults(testData);

	expect(testData.testData.result == "success").toBeTruthy();

	done();
}
async function onLogMessage(message, page, done, testData) {
	//console.log(`${message.type().toUpperCase()} ${message.text()}`)

	// todo: use other message.type like warn and err 

	//console.log(message.text());
	if (message.type().toUpperCase() == "LOG") {
		//console.log(message.text());
		// if browser outputs "AWAYFLTEST END", the test is done
		if (message.text() == "AWAYFLTEST END" ||
			message.text() == "%cAVM1 trace: %c AWAYFLTEST END  color: #054996 background: #eee; color: #054996") {
			page.removeListener('console', onlogMessageDelegate);
			onTestFinish(page, done, testData);
		}
		else {
			//	for now, browser saves flash-traces on server
			//	if we would want to capture all browser-logs or error logs, this would be the place
		}
	}
}
let runTestsOnFolder = function (parentPath, folderName) {

	let recordetDataPath = "";
	let folderPath = parentPath;
	if (folderName) {
		recordetDataPath = path.join(parentPath, folderName, "recordetData.json");
		folderPath = path.join(parentPath, folderName);
	}
	else {
		recordetDataPath = path.join(parentPath, "recordetData.json");
	}

	if (fs.existsSync(recordetDataPath)) {
		// "recordetData.json" found. we run the test:

		let testData = {
			targetPath: folderPath
		};
		let rawdata = fs.readFileSync(recordetDataPath);
		testData.recordedData = JSON.parse(rawdata);
		//console.log("testData", testData);
		describe(path.join(parentPath, folderName), () => {
			test("run swf and compare output", async done => {
				expect(testData.recordedData.url != null).toBeTruthy();
				expect(testData.recordedData.swf != null).toBeTruthy();
				expect(testData.recordedData.test != null).toBeTruthy();
				let url=`http://localhost:${TestConfig.jestPath}${testData.recordedData.url}.html?swf=${testData.recordedData.swf}&test=${testData.recordedData.test}&port=${TestConfig.port}`;
				await page.goto(url);
				onlogMessageDelegate = (message) => onLogMessage(message, page, done, testData)
				await page.on('console', onlogMessageDelegate);
			});

		});
	}
	else {
		// no "recordetData.json" found. we iterate the folder and keep looking
		//console.log("parentPath", parentPath);
		let files = fs.readdirSync(folderPath);
		for (let i = 0; i < files.length; i++) {
			let dirPath = path.join(folderPath, files[i]);
			if (fs.lstatSync(dirPath).isDirectory()) {
				runTestsOnFolder(folderPath, files[i]);
			}
		}
	}
}

module.exports = runTestsOnFolder;


