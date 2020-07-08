const http = require('http');
const express = require('express');
const cors = require('cors')
const fs = require('fs');
const path = require('path');
const formidable = require('formidable');
const rootPath = "tests";
//const util = require('util')
const { PNG } = require('pngjs');
const url = require('url');
const { exec } = require('child_process');
//const ba64 = require("ba64");
const request = require('request');
const { spawn } = require('child_process');
const { chunksToLinesAsync, chomp } = require('@rauschma/stringio');
const WebSocket = require('ws');
const rimraf = require("rimraf");
const pixelmatch = require('pixelmatch');

let root_directory = process.env.INIT_CWD;//, args[0]);
//console.log("root_directory", root_directory);

let TestConfig = require('./TestServerConfig');

function getTestConfig(){
	TestConfig = require('./TestServerConfig');
	try {
		let TestConfig2 = require(path.join(root_directory, 'TestServerConfig'));
		// TestConfig is TestServerConfig loaded from same directory as TestServer.js
		// TestConfig2 is TestServerConfig loaded from project that called TestServer.js
		// if both are the same, we do not need to do anything,
		// if they are different, we overwrite all props on TestConfig with values from TestConfig2
		if (TestConfig === TestConfig2) {
			//console.log("configs are the same");
		}
		else {
			for (var key in TestConfig2) {
				TestConfig[key] = TestConfig2[key];
			}
		}
	
	}
	catch (e) { }
}


let fp_player_path = TestConfig.pathToFPDebugger;
let flashrecorder_swf_path = path.join(root_directory, TestConfig.pathToFlashRecorderSWF);


const testsDirectoryRoot = TestConfig.testsDirectoryRoot;
const testsDirectory = path.join(root_directory, testsDirectoryRoot);
const srcDirectoryRoot = TestConfig.srcDirectoryRoot;
const swfDirectory = path.join(root_directory, srcDirectoryRoot);


function readSrcDirectory(dir, data) {
	if (!fs.existsSync(dir)) {
		fs.mkdirSync(dir, { recursive: true });
	}
	//console.log("readSrcDirectory", data);
	let files = fs.readdirSync(dir);
	for (let i = 0; i < files.length; i++) {
		let filePath = path.join(dir, files[i])
		if (fs.lstatSync(filePath).isDirectory()) {
			readSrcDirectory(filePath, data);
		}
		else if (path.extname(filePath) == ".swf") {
			//console.log("readSrcDirectory", data);
			let swfPath = filePath.replace(".swf", "").replace(swfDirectory, "");
			data.swfs[swfPath] = {
				name: swfPath,
				swfPath: swfPath,
				awayflPlayer: TestConfig.awayflEntryHtml,
				tests: {},
				settings: getTestsSettingsNoMerge(path.join(testsDirectory, swfPath))
			};
			// check if a settings file exists, and read it in if it doesnt

		}
	}
}

/**
 * used when saving a new test. gets the next valid directory name with form "prefix + i" in dir
 * @param {*} dir 
 * @param {*} prefix 
 */
function getNextTestName(dir, prefix) {
	if (!fs.existsSync(dir)) {
		fs.mkdirSync(dir, { recursive: true });
		let newPath = path.join(dir, prefix + 0);
		fs.mkdirSync(newPath, { recursive: true });
		return 0;
	}
	let cnt = 0;
	while (true) {
		let newPath = path.join(dir, prefix + cnt);
		if (fs.existsSync(newPath)) {
			cnt++;
		}
		else {
			fs.mkdirSync(newPath, { recursive: true });
			return cnt;
		}
	}
}
function readTestDirectory2(dir, data, name) {
	//	this is a directory containing data for swf
	//	each test will be in its own directory
	//	we can identify those directories by checking if a recordetData.json exists:

	let files = fs.readdirSync(dir);
	for (let i = 0; i < files.length; i++) {
		let filePath = path.join(dir, files[i])
		if (fs.lstatSync(filePath).isDirectory()) {
			let filePathJson = path.join(filePath, "recordetData.json");
			if (fs.existsSync(filePathJson)) {
				let obj = {};
				data.tests[files[i]] = obj;
				obj.name = name + "/" + files[i];
				obj.swfPath = data.swfPath;
				obj.test = files[i];
				obj.awayflPlayer = data.awayflPlayer;
				obj.recordetData = JSON.parse(fs.readFileSync(filePathJson));
				filePathJson = path.join(filePath, "testData.json");
				if (fs.existsSync(filePathJson)) {
					obj.testData = JSON.parse(fs.readFileSync(filePathJson));
				}
			}
		}
	}
}
function readTestDirectory(dir, data) {
	if (!fs.existsSync(dir)) {
		fs.mkdirSync(dir, { recursive: true });
	}
	let files = fs.readdirSync(dir);
	for (let i = 0; i < files.length; i++) {
		let filePath = path.join(dir, files[i])
		if (fs.lstatSync(filePath).isDirectory()) {
			let name = filePath.replace(testsDirectory, "");
			//console.log("splitname", splitname);
			//if(splitname.length==2){
			if (data.swfs[name]) {
				readTestDirectory2(filePath, data.swfs[name], name);
			}
			else {
				readTestDirectory(filePath, data);
			}
		}
	}
}

function getAllTestsData() {
	getTestConfig();
	let data = {
		swfs: {},
		name: path.basename(root_directory),
		invalidTests: {},
		tree: {
			dirs: {},
			swfs: {}
		},
		config: Object.assign({}, TestConfig),
		defaultSettings: TestConfig.defaultSettings

	};
	//	create a entry for every swf found 
	if (TestConfig.useGameConfigForSrc) {
		//	only use swfs that have a entry in gameconfig
		try {
			const gameConfigPath = path.join(root_directory, "pokiGame.config.js");
			let rootObj = require(gameConfigPath);
			//console.log(gameConfigRaw)
			//var rootObj = JSON.parse(gameConfigRaw);
			for (var i = 0; i < rootObj.fileconfigs.length; i++) {
				data.swfs[path.join(rootObj.fileconfigs[i].rt_filename)] = {
					swfPath: rootObj.fileconfigs[i].rt_filename,
					awayflPlayer: rootObj.fileconfigs[i].rt_filename,
					settings: getTestsSettingsNoMerge(path.join(testsDirectory, rootObj.fileconfigs[i].rt_filename)),
					tests: {}
				}
				//console.log("url",  srcDirectoryRoot, rootObj.fileconfigs[i].rt_filename, path.join(srcDirectoryRoot, rootObj.fileconfigs[i].rt_filename));
			}

		}
		catch (e) {
			console.log("error reading pokiGame.config.js", e)
		}

	}
	else {
		//	search for all SWF in srcDirectoryRoot
		readSrcDirectory(swfDirectory, data);
	}
	//	collect all tests found in testsDirectory and assign them to the corresponding swf-entry
	//	tests-folders that do not have a corresponing swf-entry are considered invalid and are ignored
	//	todo: collect invalideTest-folders, so that we can easy remove them
	readTestDirectory(testsDirectory, data);

	//	from the swf-pathes that are stored for each swf-entry, we rebuild the directory-tree:
	for (var key in data.swfs) {
		let directories = key.split(path.sep);
		let treeNode = data.tree;
		for (let i = 0; i < directories.length - 1; i++) {
			if (directories[i] != "") {
				if (!treeNode.dirs[directories[i]]) {
					treeNode.dirs[directories[i]] = {
						dirs: {},
						swfs: {}
					};
				}
				treeNode = treeNode.dirs[directories[i]];
			}
		}
		treeNode.swfs[directories[directories.length - 1]] = data.swfs[key];
	}
	// remove stuff not needed to send to website:
	delete data.swfs;
	delete data.config.defaultSettings;

	return data;
}
function getTestsSettingsNoMerge(pathToTest) {
	const pathToTestSetting = path.join(pathToTest, "settings.json");
	if (fs.existsSync(pathToTestSetting)) {
		return JSON.parse(fs.readFileSync(pathToTestSetting));
	}
	return {};
}
function getTestsSettings(pathToTest) {
	const settings = require('./TestServerConfig').defaultSettings;
	const pathToTestSetting = path.join(pathToTest, "settings.json");
	if (fs.existsSync(pathToTestSetting)) {
		const testSettings = JSON.parse(fs.readFileSync(pathToTestSetting));
		for (var key in testSettings) {
			settings[key] = testSettings[key];
		}
	}
	return settings;
}

function evaluateTest(testData, recordetData, dir) {

	//console.log("evaluateTest", recordetData, testData, dir);
	if (!testData) {
		testData={
			result:"failed",
			message:"no valid testData"
		}
		console.log("ERROR: can evaluateTest when testData is undefined");
		return;
	}
	if (!recordetData) {
		testData.result = "failed";
		testData.message = "no valid recordetData"
		return;
	}
	if (!testData.frames || testData.frames.length == 0) {
		testData.result = "failed";
		testData.message = "no test frames on testData";
		return;
	}
	if (!recordetData.settings.onlyTraces) {
		if(!recordetData.swfInfos){
			testData.result = "failed";
			testData.message = "no recordet swf-info";
			return;
		}
		if(!testData.swfInfos){
			testData.result = "failed";
			testData.message = "no test swf-info";
			return;
		}
		if(recordetData.swfInfos.frameRate!=testData.swfInfos.frameRate){
			testData.result = "failed";
			testData.message = "reported frameRate does not match";
			return;
		}
		if(recordetData.swfInfos.swfVersion!=testData.swfInfos.swfVersion){
			testData.result = "failed";
			testData.message = "reported swfVersion does not match";
			return;
		}
		if(recordetData.swfInfos.swfVersion!=testData.swfInfos.swfVersion){
			testData.result = "failed";
			testData.message = "reported swfVersion does not match";
			return;
		}
		if(recordetData.swfInfos.asVersion!=testData.swfInfos.asVersion){
			testData.result = "failed";
			testData.message = "reported asVersion does not match";
			return;
		}
		if(recordetData.swfInfos.width!=testData.swfInfos.width){
			testData.result = "failed";
			testData.message = "reported width does not match";
			return;
		}
		if(recordetData.swfInfos.height!=testData.swfInfos.height){
			testData.result = "failed";
			testData.message = "reported height does not match";
			return;
		}
	}
	if (!recordetData.frames || testData.frames.length == 0) {
		testData.result = "failed";
		testData.message = "no test frames on recordetData";
		return;
	}
	testData.result = "success";
	if (recordetData.frames.length != testData.frames.length) {
		testData.result = "failed";
		testData.message = "number of recordet frames do not match";
		return;
	}
	for (let i=0; i<recordetData.frames.length; i++) {
		let frame_rec = recordetData.frames[i];
		let frame_test = testData.frames[i];
		if(!frame_test){
			testData.result = "failed";
			testData.message = "testData has no frame for frameIdx " + frame_rec.frameIdx;
			return;
		}
		if (frame_rec.frameIdx != frame_test.frameIdx) {
			testData.result = "failed";
			testData.message = "frameIdx of frame "+frame_rec.frameIdx+" does not match";
			return;
		}
		if (frame_rec.messages.length != frame_test.messages.length) {
			testData.result = "failed";
			testData.message = "number of messages for frame " + i + " does not match";
			return;
		}
		for (var m = 0; m < frame_rec.messages.length; m++) {
			if (frame_rec.messages[m] != frame_test.messages[m]) {
				testData.result = "failed";
				testData.message = "messages " + m + " for frame " + frame_rec.frameIdx + " does not match";
				return;
			}
			if (frame_rec.messages[m].indexOf("AWAYFLTEST SNAPSHOT ") == 0) {
				// todo: not tested yet
				let snapshotResult=compareSnapshot(dir, frame_rec.messages[m].replace("AWAYFLTEST SNAPSHOT ", ""));
				if (snapshotResult!="") {
					testData.result = "failed";
					testData.message = " frame " + i + " "+snapshotResult;
					return;
				};
			}
		}
	}

}
function compareSnapshot(dir, snapshot) {
	let recordetSnapshotPath = path.join(dir, "recordetSnapshot_" + snapshot + ".png");
	let testSnapshotPath = path.join(dir, "testSnapshot_" + snapshot + ".png");
	if (!fs.existsSync(recordetSnapshotPath))
		return "recordet snapshot "+snapshot+" not found";
	if (!fs.existsSync(testSnapshotPath))
		return "test snapshot "+snapshot+" not found";


	let recSnapShot = PNG.sync.read(fs.readFileSync(recordetSnapshotPath));
	let testSnapShot = PNG.sync.read(fs.readFileSync(testSnapshotPath));

	// all consoleMessages should match
	const { width, height } = recSnapShot;
	const diff = new PNG({ width, height });
	var numDiffPixels = pixelmatch(recSnapShot.data, testSnapShot.data, diff.data, width, height, { threshold: 0.1 });

	if (numDiffPixels != 0) {
		var pngFilePath = path.join(dir, "screenshotDiff_" + snapshot + ".png");
		fs.writeFileSync(pngFilePath, PNG.sync.write(diff));
		return numDiffPixels+ " pixels in snapshot "+snapshot+" do not match ";
	}
	return "";
}


const app = express();
app.use(express.urlencoded({ extended: false }));

app.use(cors());

app.use(express.static('./'))

app.get("/all", function (req, res) {
	res.writeHead(200, { 'Content-Type': 'text/html' });
	res.end(JSON.stringify(getAllTestsData()), 'utf-8');
	return;
});


app.get("/deleteTest", function (req, res) {
	console.log("delete test", req.query.test);
	let pathSplit=req.query.test.split("__");
	let pathToFolder=testsDirectory;
	for(let i=0; i<pathSplit.length; i++){
		if(pathSplit[i]=="dirs" || pathSplit[i]=="tree" || pathSplit[i]=="swfs" || pathSplit[i]=="tests"){

		}
		else{
			pathToFolder=path.join(pathToFolder, pathSplit[i]);
		}

	}
	try{
		rimraf.sync(pathToFolder);

	}
	catch(e){
		console.log("could not delete test", pathToFolder);
	}
	res.end();
});
app.get("/FlashRecorder", function (req, res) {
	// record data from FP player

	// first, try to delete the flash-logs file
	try {
		fs.unlinkSync(TestConfig.pathToFPLogs);
	}
	catch (e) {
		console.log("COULD NOT DELETE FLASHLOG.txt")
	}
	console.log("### open FP Player to record test:", fp_player_path);

	let swfUrl = path.join(srcDirectoryRoot, req.query.swf);
	let swfPath = "http://localhost:" + req.query.port + "/" + swfUrl + ".swf";

	let testPath = path.join(testsDirectory, req.query.swf);
	let settings = getTestsSettings(testPath);
	let startRecTime = Date.now();
	// if no shell is used, we can not apply any settings for recording
	// in this case, we only record the trace-logs and thats all we can do
	if (!settings.onlyTraces) {
		console.log("use swf-shell:", flashrecorder_swf_path);
		// get settings for swf
		swfPath = flashrecorder_swf_path + "?swf=" + swfUrl + "&port=" + req.query.port;
		swfPath += "&settings=" + JSON.stringify(settings);
	}

	console.log("load swf:", swfPath);
	// open FPDebugger.exe and record playback for a swf
	async function main() {
		const childProcess = spawn(fp_player_path, [swfPath],
			{ stdio: ['ignore', 'pipe', process.stderr] });

		await echoReadable(childProcess.stdout);

		// get the output from the FP-Player from the Flash-logs
		try {
			//console.log("log", TestConfig.pathToFPLogs)
			let log = fs.readFileSync(TestConfig.pathToFPLogs, "utf-8");
			//console.log("log", log.toString())
			let logSplit = log.split(/\r\n|\n|\r/);
			let lastFrameIdx = 0;
			let lastValidKey = 0;
			let frames = [];
			let events = {};
			let swfInfos = null;
			// sort the output into frames if possible
			// if swf was loaded directly and not into swf-shell, we will only have one frame
			for (let i = 0; i < logSplit.length; i++) {
				//console.log(logSplit[i]);
				if (!logSplit[i] || logSplit[i] == "")
					continue;
				if (logSplit[i].indexOf("SWFFRAME") == 0) {
					lastFrameIdx = parseInt(logSplit[i].split(" ")[1]);
				}
				else if (logSplit[i].indexOf("SWFTestInfos:") == 0) {
					swfInfos = JSON.parse(logSplit[i].replace("SWFTestInfos:", ""));
				}
				
				else {
					if (logSplit[i].indexOf("AWAYFL_KEYEVENT") == 0) {
						if(!events[lastFrameIdx])
							events[lastFrameIdx]=[];
						events[lastFrameIdx].push(logSplit[i].replace("AWAYFL_KEYEVENT ", ""));
					}
					else if (logSplit[i].indexOf("AWAYFL_MOUSEEVENT") == 0) {
						if(!events[lastFrameIdx])
							events[lastFrameIdx]=[];
						events[lastFrameIdx].push(logSplit[i].replace("AWAYFL_MOUSEEVENT ", ""));
					}
					else {
						if (frames.length==0 || frames[frames.length-1].frameIdx!=lastFrameIdx) {
							frames.push({
								messages: [],
								frameIdx: lastFrameIdx
							});
						}
						frames[frames.length-1].messages.push(logSplit[i]);
					}
				}
			}
			let flashRecordetData = {
				player: "flashplayer",
				duration: Date.now() - startRecTime,
				date: new Date().toLocaleString(),
				url:req.query.testURL,
				swf: req.query.swf,
				settings: settings,
				frames: frames,
				events: events,
				swfInfos:swfInfos
			};
			//console.log("num frames", Object.keys(frames).length);
			//console.log("last frame", lastValidKey);
			//console.log(flashRecordetData);
			try {
				//console.log("outputPath", outputPath);
				let newTestNr = getNextTestName(testPath, "FP_");
				flashRecordetData.test="FP_" + newTestNr;
				testPath = path.join(testPath, "FP_" + newTestNr, "recordetData.json");
				fs.writeFileSync(testPath, JSON.stringify(flashRecordetData));
			}
			catch (e) {
				console.log("COULD NOT WRITE RECORDING RESULT", e);
			}
		}
		catch (e) {
			console.log("COULD NOT READ FLASHLOG.txt", e)
		}
		console.log('### FP Player test recording done');
	}
	async function echoReadable(readable) {
		//  this doesnt work to get the console-output from FlashPlayer
		//  we will get the console.log from the flash-logfile once FlashPlayer is closed
		for await (const line of chunksToLinesAsync(readable)) {
			console.log('LINE: ' + chomp(line))
		}
	}
	res.end();
	main();
})
app.get("/getSettings", function (req, res) {
	res.writeHead(200, { 'Content-Type': 'text/html' });
	if (!req.query.test)
		res.end(JSON.stringify(getTestsSettings(path.join(testsDirectory, req.query.swf))), 'utf-8');
	else {
		res.end(fs.readFileSync(path.join(testsDirectory, req.query.swf, req.query.test, "recordetData.json")), 'utf-8');
	}
	return;
});
app.get("/", function (req, res) {
	res.status(301).redirect(`http://localhost:${TestConfig.port}/${TestConfig.pathToTestSuite}testsuite/TestSuite.html`);
})
app.post('/uploadImage', function (req, res) {
	console.log("uploadImage");
	var form = new formidable.IncomingForm();
	//form.multiples = true;
	form.parse(req, function (err, fields, files) {
		//console.log('File read!', files.file);
		var oldpath = files.file.path;
		//console.log(files.file);
		var newpath = path.join(testsDirectory, "_temp");
		
		fs.mkdirSync(newpath, { recursive: true });
		newpath = path.join(newpath, files.file.name);
		console.log("saved screenshot", newpath);
		let screenshotData = fs.readFileSync(oldpath);
		fs.writeFileSync(newpath, screenshotData);
		fs.unlinkSync(oldpath);
		res.end();

	});
});
app.post('/upload', function (req, res) {
	var form = new formidable.IncomingForm();
	//form.multiples = true;
	form.parse(req, function (err, fields, files) {
		//console.log('File read!', files.file);
		var oldpath = files.file.path;
		let record = fields["record"];
		//console.log(files.file);
		var newpath = path.join(testsDirectory, files.file.name);
		//console.log(newpath);
		if (record == "true") {
			// new recording
			// we create a new folder for "recordetData.json"
			var testNR = getNextTestName(newpath, "AwayFL_");
			newpath = path.join(newpath, "AwayFL_" + testNR);
			fs.mkdirSync(newpath, { recursive: true });
			// save the file, and delete the temporary file
			let data = JSON.parse(fs.readFileSync(oldpath));
			for(let i=0; i<data.frames.length; i++){
				for(let m=0; m<data.frames[i].messages.length; m++){
					//console.log("data.frames[i].messages[m]", data.frames[i].messages[m])
					if(data.frames[i].messages[m].indexOf("AWAYFLTEST SNAPSHOT ")==0){
						let snapShotIdx=data.frames[i].messages[m].replace("AWAYFLTEST SNAPSHOT ", "");
						try{
							let tmpPath = path.join(testsDirectory, "_temp", "snapshot_"+snapShotIdx+".png");
							let snapShotPath = path.join(newpath, "recordetSnapshot_"+snapShotIdx+".png");
							try{
								fs.unlinkSync(snapShotPath);
							}
							catch(e){}
							fs.writeFileSync(snapShotPath, fs.readFileSync(tmpPath));
						}
						catch(e){
							console.log("error saving recordet-snapshot")
						}
					}
				}
			}
			try{
				let tmpPath = path.join(testsDirectory, "_temp");
				rimraf.sync(tmpPath);
			}
			catch(e){
				console.log("could not delete temp folder")
			}
			newpath = path.join(newpath, "recordetData.json");
			data.test="AwayFL_" + testNR;
			fs.writeFileSync(newpath, JSON.stringify(data));
			fs.unlinkSync(oldpath);
			res.end();
			
			console.log("saved recorded data", newpath);
		}
		else {
			// testrun
			// compare recieved data with "recordetData.json" and save as "testData.json"
			let recordetData = JSON.parse(fs.readFileSync(path.join(newpath, "recordetData.json")));
			let testData = JSON.parse(fs.readFileSync(oldpath));

			for(let i=0; i<testData.frames.length; i++){
				for(let m=0; m<testData.frames[i].messages.length; m++){
					//console.log("testData.frames[i].messages[m]", testData.frames[i].messages[m])
					if(testData.frames[i].messages[m].indexOf("AWAYFLTEST SNAPSHOT ")==0){
						let snapShotIdx=testData.frames[i].messages[m].replace("AWAYFLTEST SNAPSHOT ", "");
						try{
							let tmpPath = path.join(testsDirectory, "_temp", "snapshot_"+snapShotIdx+".png");
							let snapShotPath = path.join(newpath, "testSnapshot_"+snapShotIdx+".png");
							try{
								fs.unlinkSync(snapShotPath);
							}
							catch(e){}
							fs.writeFileSync(snapShotPath, fs.readFileSync(tmpPath));
						}
						catch(e){
							console.log("error saving test-snapshot")
						}
					}
				}
			}
			evaluateTest(testData, recordetData, newpath);

			newpath = path.join(newpath, "testData.json")
			fs.writeFileSync(newpath, JSON.stringify(testData));
			fs.unlinkSync(oldpath);
			res.end();
			console.log("saved test data", newpath);

		}

	});
});

// todo: not used anymore (needed for screenshot upload ?):
app.post('/uploadFromFlash', function (req, res) {
	var data = new Buffer.alloc(0);
	req.on('data', chunk => {
		data = Buffer.concat([data, chunk])
	});
	req.on('end', () => {
		var testDataPath = path.join(testDirectory, req.query.filePath);
		fs.writeFileSync(testDataPath, data);
		res.writeHead(200, "OK", { 'Content-Type': 'application/json' });
		res.end();
	});
});
app.post("/saveTestData", function (req, res) {
	console.log("saveTestData");
	var body = "";
	req.on('data', chunk => {
		body += chunk.toString();
	});
	req.on('end', () => {
		body = JSON.parse(body);
		var testDataPath = path.join(testDirectory, "testData.json");
		try {
			if (fs.existsSync(testDataPath)) {
				let rawdata = fs.readFileSync(testDataPath);
				var rootObj = JSON.parse(rawdata);
				var obj = rootObj;
				if (!body.path) {
					console.log("IPathAction provides no path!");
					return;
				}

				for (var i = 0; i < body.path.length - 1; i++) {
					if (!obj[body.path[i]]) {
						console.log("IPathAction provides no valid path!");
						obj[body.path[i]] = {};
					}
					obj = obj[body.path[i]];
				}
				obj[body.path[body.path.length - 1]] = body.value;
				fs.writeFileSync(testDataPath, JSON.stringify(rootObj));
			}
		}
		catch (e) {
			console.log("COULD NOT READ testData.json file");
		}
	});
	res.end();
});


app.listen(TestConfig.port, function () {
	console.log('Server running at http://127.0.0.1:' + TestConfig.port + '/');
});


let wss=new WebSocket.Server({ port: TestConfig.port_ws });
wss.on('connection', function connection(ws, req) {	
	ws.on('message', function incoming(message) {
		console.log("recieved message from ws: ", message);
	});
	ws.on('close',function(){
		console.log("disconnect a ws");
	});
	ws.on('error', function(er) {
		console.log("Error in Websocket connection", er);
	})
});
wss.on('error', function(er) {
	console.log("Error in Websocket connection", er);
});

function broadCastMessageToAllWS(message){
	wss.clients.forEach(function each(client) {
		if (client.readyState === WebSocket.OPEN) {
            ws.send(JSON.stringify(message));
		}
	}); 
}
