//IncludeStepByStep5.as
/*
Added autodemo code.  RB 4/15/2011
Added updateTranslationTexts method.  RB 10/21/2014
Renamed and tweaked to make compatible with Animate CC (removed TLF check). RB 7/26/2016
Converted to use EventUtils2. RB 4/16/2018
IncludeStepByStep5.as: Added EventUtils2.reserveGroup() to prevent conflicts with event groups. RB 11/14/2019


For examples, see templates

This serves as the main program for step-by-step tutorials.  The FLA must contain:
	include "../LibAS3/com/satprof/lib/IncludeStepByStep3.as"
	import com.satprof.lib.For_Away3D_3.*; // Select desired Away3D library
	secureMode = false;  // Set to true if swf will be run from within superviewer and running standalone is forbidden.
	lastStep = 16;  // Must to 0 if only one step
	_AllLoadedComponentsAreReady  = true when everything is confirmed loaded and ready.

	Any symbols with the name in format lang_XX will be automatically hidden or shown based on language selection.

    var declarations (Any global variables that the FLA will need)

	function runEveryFrame()
	function preventUnauthorizedViewing()
	function playStep(step)
	function killEverything()  // Use if any movieclips or other functions in the fla have event listeners.
	function changeLanguage()  // Use _language global variable to make any other language changes

The FLA may also contain:
	langEnable("es", true);  // Enable a language
	setLanguage(_language);  // Force immediate updating of all language texts and movieclips

If the FLA needs to force the lang_xx texts to update immediately without waiting for the next step, ot may call changeTextsLanguage()

For auto demo mode, do this in the FLA:
swfName = GetOwnSWFName(this); 
if (swfName == "SeaTelCrossPol3-GT") {  // SWF name can be changed in publish settings, or by simply renaming the swf file.
	autoDemoMode = true; // Mandatory. Default is false
	autoDemoLabel = "Step14"; // Mandatory. Must be the label of the step you want to play.
	autoDemoStep = 14; // Mandatory. You must also do this.
} 

TYPICAL STARTING SEQUENCE:

Include main: declares standard variables and arrays. Instantiates ph (Phrases).  Configures buttons and listeners.
Include main: calls initializeLanguage()
Include initializeLanguage(): Initializes lang parameters for EN
FLA main: instantiates snp; declares common vars; 
FLA main: sets onEnterFrame listener to call waitUntilReady().
FLA waitUntilReady(): Checks if loaded symbols are ready. If not, does nothing.
FLA waitUntilReady(): If ready, then
	removes event listener
	calls setVersion()
		loads snp from actual file name
		may do other stuff
	calls startup()
		does whatever is scripted
		calls jumpTo(0)
	sets _AllLoadedComponentsAreReady = true which enables Include to call runEveryFrame


*/

import com.satprof.lib.*;
///import satprof.*;

var eventUtils2:EventUtils2 = EventUtils2.getInstance();
var igroup:int = eventUtils2.reserveGroup();
///var away3dEventUtils:Away3dEventUtils = Away3dEventUtils.getInstance();

//var ph: Phrases; //= new Phrases();
var ph: Phrases = Phrases.getInstance(); // Access the singleton class instance.
var _AllLoadedComponentsAreReady = false; // Set to true in FLA when simulator and components are all loaded and ready.
var debugTracesOn = false;
var _freeze = false;
var _language = "en";
var _iLanguage = 0;
var _langList: Array = new Array("en", "es", "pt", "fr", "el", "it", "pl", "ru", "de");
var _langEnabled: Array = new Array();
_langEnabled[0] = true;
for (_iLanguage = 1; _iLanguage < _langList.length; _iLanguage++) {
	_langEnabled[_iLanguage] = false;
}
language_btn.visible = false; // Default is only English.
_iLanguage = 0;

var _autoDemoMode = false;
var autoDemoLabel = "Step0";
var autoDemoStep = 0;
var _swfName = "";
var _SWFfileName: String;
var _SWFfullPath: String;
var _SWFlastIndex: uint;

////eventUtils2.addListener(igroup, this, Event.EXIT_FRAME, doEveryFrame);
eventUtils2.addListener(igroup, this, Event.ENTER_FRAME, doEveryFrame);

var nextBtnExists = true;
var prevBtnExists = true;
var replayBtnExists = true;
var stepNoTxtExists = true;
var langBtnExists = true;

try {
	stepNo_txt.visible = true;
} catch (e: Error) {
	stepNoTxtExists = false;
};

try {
	eventUtils2.addListener(igroup, next_btn, MouseEvent.CLICK, nextButtonClick);
} catch (e: Error) {
	nextBtnExists = false;
};
if (nextBtnExists) {
	next_btn.buttonMode = true;
	next_btn.useHandCursor = true;
	next_btn.mouseChildren = false; // Stops hand from appearing over text
	eventUtils2.addListener(igroup, next_btn, MouseEvent.ROLL_OVER, navRollOverHandler);
	eventUtils2.addListener(igroup, next_btn, MouseEvent.ROLL_OUT, navRollOutHandler);
	eventUtils2.addListener(igroup, next_btn, MouseEvent.MOUSE_DOWN, navPressHandler);
	eventUtils2.addListener(igroup, next_btn, MouseEvent.MOUSE_UP, navReleaseHandler);
}


try {
	eventUtils2.addListener(igroup, prev_btn, MouseEvent.CLICK, prevButtonClick);
} catch (e: Error) {
	prevBtnExists = false;
};
if (prevBtnExists) {
	prev_btn.buttonMode = true;
	prev_btn.useHandCursor = true;
	prev_btn.mouseChildren = false; // Stops hand from appearing over text
	eventUtils2.addListener(igroup, prev_btn, MouseEvent.ROLL_OVER, navRollOverHandler);
	eventUtils2.addListener(igroup, prev_btn, MouseEvent.ROLL_OUT, navRollOutHandler);
	eventUtils2.addListener(igroup, prev_btn, MouseEvent.MOUSE_DOWN, navPressHandler);
	eventUtils2.addListener(igroup, prev_btn, MouseEvent.MOUSE_UP, navReleaseHandler);
}


try {
	eventUtils2.addListener(igroup, replay_btn, MouseEvent.CLICK, replayButtonClick);
} catch (e: Error) {
	replayBtnExists = false;
};
if (replayBtnExists) {
	replay_btn.buttonMode = true;
	replay_btn.useHandCursor = true;
	replay_btn.mouseChildren = false; // Stops hand from appearing over text
	eventUtils2.addListener(igroup, replay_btn, MouseEvent.ROLL_OVER, navRollOverHandler);
	eventUtils2.addListener(igroup, replay_btn, MouseEvent.ROLL_OUT, navRollOutHandler);
	eventUtils2.addListener(igroup, replay_btn, MouseEvent.MOUSE_DOWN, navPressHandler);
	eventUtils2.addListener(igroup, replay_btn, MouseEvent.MOUSE_UP, navReleaseHandler);
}

try {
	eventUtils2.addListener(igroup, language_btn, MouseEvent.CLICK, langButtonClick);
} catch (e: Error) {
	langBtnExists = false;
};
if (langBtnExists) {
	language_btn.buttonMode = true;
	language_btn.useHandCursor = true;
	language_btn.mouseChildren = false; // Stops hand from appearing over text
	eventUtils2.addListener(igroup, language_btn, MouseEvent.ROLL_OVER, navRollOverHandler);
	eventUtils2.addListener(igroup, language_btn, MouseEvent.ROLL_OUT, navRollOutHandler);
	eventUtils2.addListener(igroup, language_btn, MouseEvent.MOUSE_DOWN, navPressHandler);
	eventUtils2.addListener(igroup, language_btn, MouseEvent.MOUSE_UP, navReleaseHandler);
}

var lastStep = 99;
var step = 0;


var authorized; // Leave undefined.  Parent swf must set it. Note that may happen BEFORE or AFTER this timeline script runs.
// Set this variable to true in the fla if swf will be run from within superviewer and running standalone is forbidden.
// Set to false to allow swf to run standalone.
// Be sure to set the correct .swf file name in public properties!
var secureMode = false;

initializeLanguage();

// Wait for the main FLA to finish initializing.  It must do the jumpTo(0).	
stop();

//------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------
// The freeze property and kill method are required so 
// that a higher-level SWF can properly stop and unload this SWF.  
// Otherwise it lives on in system memory.
function set freeze(val): void {
	_freeze = val;
}
function get freeze(): Boolean {
	return _freeze;
}
function kill() {
	// Will be called by LP when unloading.
	eventUtils2.kill(igroup); // This will kill ALL events in group 0 created using eventUtils2.addListener in the FLA and in ALL linked classes in all symbols
	killEverything(); // In FLA, in case anything else needs to be closed there 
}
function doEveryFrame(event: Event): void {
	if (_freeze) {
		return;
	}
	updateIfAuthorized();
}
function updateIfAuthorized() {
	if (secureMode) {
		if (authorized == true) {
			run(true);
		} else {
			run(false);
		}
	} else {
		run(true);
	}
}
function run(running) {
	if (running) {
		unAuthCover.visible = false;
		////trace("In Include, running = "+running+", unAuthCover.visible = "+unAuthCover.visible);
		if (_AllLoadedComponentsAreReady) {
			// Put all code required every frame to run the swf normally here:
			runEveryFrame(); // Must be in FLA
		} else {
			trace("WARNING from IncludeStepByStep5: _AllLoadedComponentsAreReady is false.  Waiting for it to be set to True in the FLA in order to proceed.");
		}

	} else {
		unAuthCover.visible = true;
		// Put all code required prevent unauthorized viewing of the swf here:
		preventUnauthorizedViewing(); // Must be in FLA
	}
}
function nextButtonClick(event: MouseEvent) {
	var s = step;
	if (step < lastStep) { // Otherwise stay at the last one
		s = s + 1;
	}
	jumpTo(s);
}
function navRollOverHandler(event: MouseEvent) {
	event.target.gotoAndStop(2);
}
function navRollOutHandler(event: MouseEvent) {
	event.target.gotoAndStop(1);
}
function navPressHandler(event: MouseEvent) {
	event.target.gotoAndStop(3);
}
function navReleaseHandler(event: MouseEvent) {
	event.target.gotoAndStop(2);
}

function prevButtonClick(event: MouseEvent) {
	var s = step - 1;
	if (s < 0) {
		s = 0; // Cycle back to beginning
	}
	jumpTo(s);
}
function replayButtonClick(event: MouseEvent) {
	var s = step;
	jumpTo(s);
}
function langButtonClick(event: MouseEvent) {
	var i = _iLanguage;
	do {
		i++;
		if (i >= _langList.length) {
			i = 0;
		}
	} while (!_langEnabled[i])
	_iLanguage = i;
	/*
	_iLanguage++;
	if (_iLanguage>= _langList.length){
		_iLanguage = 0;
	}
	*/
	setLanguage(_langList[_iLanguage]);
}
function langEnable(lng, enable) {
	language_btn.visible = false;
	for (var i = 0; i < _langList.length; i++) {
		if (lng == _langList[i]) {
			_langEnabled[i] = enable;
		}
		if (_langEnabled[0] && _langEnabled[i]) {
			language_btn.visible = true; // Only show if there is more than just English
		}
	}

}
function jumpTo(s) {
	if (_autoDemoMode) {
		gotoAndPlay(autoDemoLabel);
		step = autoDemoStep;
		lastStep = autoDemoStep;
		changeTextsLanguage();
		if (nextBtnExists & prevBtnExists) {
			prev_btn.visible = false;
			next_btn.visible = false;
		}
		//trace("went to "+autoDemoLabel);
	} else {
		step = s;
		if (debugTracesOn) {
			trace("Jumping to Step" + step)
		};

		if (nextBtnExists & prevBtnExists) {
			if (lastStep == 0) {
				prev_btn.visible = false;
				next_btn.visible = false;
			} else {
				if (step <= 0) {
					prev_btn.visible = false;
					next_btn.visible = true;
				} else if (step >= lastStep) {
					prev_btn.visible = true;
					next_btn.visible = false;
				} else {
					prev_btn.visible = true;
					next_btn.visible = true;
				}
			}
		}
		if (stepNoTxtExists) {
			stepNo_txt.visible = true;
			if (step == 0) {
				stepNo_txt.text = "";
			} else {
				stepNo_txt.text = step;
			}
		}

		var labelName = "Step" + step;
		gotoAndPlay(labelName);
		changeTextsLanguage();

		playStep(step);
		//status_txt.text = "Step = "+step+", nSteps = "+nSteps+", Main label = "+labels[step]+", MC label = "+mclabels[step];

	}
}

function changeTextsLanguage() {
	var nm: String;
	var ln: String;
	//trace("In  changeTextsLanguage(): step = "+step+", _language = "+_language);
	for (var i: uint = 0; i < this.numChildren; i++) {
		try {
			//trace(" type = "+this.getChildAt(i).type );
			//trace ('\t|\t ' +i+'.\t name:' + this.getChildAt(i).name + '\t type:' + typeof (this.getChildAt(i))+ '\t' + this.getChildAt(i));
			nm = this.getChildAt(i).name;
			if (nm.substr(0, 5) == "lang_") {
				ln = nm.substr(5, 2); // e.g. lang_es23
				this.getChildAt(i).visible = (ln == _language);
				//trace("\t|\t\t ' Match; setting "+this.getChildAt(i).name+".visible = "+this.getChildAt(i).visible+"; x = "+this.getChildAt(i).x+", y = "+this.getChildAt(i).y);
			}
		} catch (e: Error) {

			//trace("     Error in changeTextsLanguage():");
			//trace("        i = "+i);
			//trace("        object = "+this.getChildAt(i) );
			//trace("        name = "+this.getChildAt(i).name );
			//trace ('\t|\t ' +i+'.\t name:' + this.getChildAt(i).name + '\t type:' + typeof (this.getChildAt(i))+ '\t' + this.getChildAt(i));

		}

	}

}
function setLanguage(lang) {
	_language = lang;
	_iLanguage = 0;
	for (var iL = 0; iL < _langList.length; iL++) {
		if (_language == _langList[iL]) {
			_iLanguage = iL;
		}
	}
	ph.language = _language;
	changeTextsLanguage();
	changeLanguage(); // Must be in the FLA
	language_btn.legend_txt.text = _language;

	switch (_language) {
		case "es":
			// From Elias
			if (nextBtnExists) {
				next_btn.legend_txt.text = "PROX";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "ATRAS";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "REPETIR";
			}
			break;
		case "pt":
			// From Paulo
			if (nextBtnExists) {
				next_btn.legend_txt.text = "PROX";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "RET";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "REAP";
			}
			break;
		case "it":
			if (nextBtnExists) {
				next_btn.legend_txt.text = "SUCC";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "PREC";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "RIVEDI";
			}
			break;
		case "fr":
			if (nextBtnExists) {
				next_btn.legend_txt.text = "SUIV";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "PREC";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "RECOMM";
			}
			break;
		case "el":
			if (nextBtnExists) {
				next_btn.legend_txt.text = "ΕΠΟΜ";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "Προη";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "ΕΠΑΝ";
			}
			break;
		case "pl":
			if (nextBtnExists) {
				next_btn.legend_txt.text = "NAST";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "POPR";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "POWTÓRKA";
			}
			break;
		case "ru":
			if (nextBtnExists) {
				next_btn.legend_txt.text = "ДАЛЕЕ";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "назад";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "повторить";
			}
			break;
		case "de":
			if (nextBtnExists) {
				next_btn.legend_txt.text = "Weiter";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "Zurück";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "REPLAY";
			}
			break;
		case "en":
		default:
			if (nextBtnExists) {
				next_btn.legend_txt.text = "NEXT";
			}
			if (prevBtnExists) {
				prev_btn.legend_txt.text = "PREV";
			}
			if (replayBtnExists) {
				replay_btn.legend_txt.text = "REPLAY";
			}
			break;
	}
}
function initializeLanguage() {
	_language = "en";
	_iLanguage = 0;
	ph.language = _language;
	language_btn.legend_txt.text = _language;
	//next_btn.legend_txt.text = ph.NEXT;
	//prev_btn.legend_txt.text = ph.SHOWMYRESULTS;
	//replay_btn.legend_txt.text = ph.KEEPWORKING;
}
function set autoDemoMode(val) {
	_autoDemoMode = val;
}
function get autoDemoMode() {
	return _autoDemoMode;
}
function set swfName(val) {
	_swfName = val;
	try {
		swfName_txt.text = _swfName;
	} catch (e: Error) {
		trace("WARNING: swfName_txt does not exist.");
	}
}
function get swfName() {
	return _swfName;
}
function GetOwnSWFName(place: DisplayObjectContainer): String {
	_SWFfullPath = place.loaderInfo.url;
	var f = Util3.extractSWFfromPath(_SWFfullPath)
	trace("In GetOwnSWFName, _SWFfullPath = "+_SWFfullPath+", f = "+f);
	return f;
	/*
	//trace("In GetOwnSWFName:");
	_SWFfullPath = place.loaderInfo.url;
	//trace("  place.loaderInfo.url = "+place.loaderInfo.url);
	//_SWFfullPath = "file:///C|/Users/SatProf/Documents/Satprof/SVNContent/Content/Site3_review-X.swf/[[asdfsdf]]/3/9"; /// for debug only
	//trace("  Test: _SWFfullPath = "+_SWFfullPath);
	//debugTxt("_SWFfullPath = "+_SWFfullPath); ////

	_SWFlastIndex = _SWFfullPath.length-4//_SWFfullPath.lastIndexOf(".swf");
	//debugTxt("  _SWFlastIndex = "+_SWFlastIndex);
	_SWFfileName = _SWFfullPath.slice(0,_SWFlastIndex);  // Chop off everything after last .swf
	//debugTxt("  _SWFfileName = "+_SWFfileName);
	
	_SWFlastIndex = Math.max( _SWFfileName.lastIndexOf("/"), _SWFfileName.lastIndexOf('\\') );
	//debugTxt("  _SWFlastIndex = "+_SWFlastIndex);
	_SWFfileName = _SWFfileName.slice(_SWFlastIndex+1,_SWFfullPath.length);  // Chop off everything before last /
	//debugTxt("  _SWFfileName = "+_SWFfileName);
	_SWFfileName =  _SWFfileName.split("%5F").join("_").split("%2D").join("-"); // Substitute
	//debugTxt("  _SWFfileName = "+_SWFfileName);
	_SWFfileName = decodeURI(_SWFfileName); // Replace escape seqs with characters
	//trace("  _SWFfileName = "+_SWFfileName);
	//_SWFfileName = _SWFfileName.slice(0, _SWFfileName.length-4); // Chop off the .swf
	//debugTxt("  _SWFfileName = "+_SWFfileName);
	return _SWFfileName;
	*/
	/*
	_SWFfullPath = place.loaderInfo.url;
	_SWFlastIndex = _SWFfullPath.lastIndexOf("/");
	_SWFfileName = _SWFfullPath.slice(_SWFlastIndex+1,_SWFfullPath.length).split("%5F").join("_").split("%2D").join("-");
	_SWFfileName = decodeURI(_SWFfileName);
	_SWFfileName = _SWFfileName.slice(0, _SWFfileName.length-4)
	
	
	*/
}
function updateTranslationTexts(obj, transVector) {
	var n: int;
	var str: String;
	var nm: String;
	//var transVector:Vector.<Object> = getChildByName("translations") as Vector.<Object>; 
	//var transVector:Vector.<Object> = getChildByName("translations") as Vector.<Object>; 
	//var transVector:Array = getChildByName("translations") as Array; 

	for (var i: uint = 0; i < obj.numChildren; i++) {
		//trace ('\t|\t ' +i+'.\t name:' + this.getChildAt(i).name + '\t type:' + typeof (this.getChildAt(i))+ '\t' + this.getChildAt(i));
		if (obj.getChildAt(i) is TextField) {
			//trace("This is a Classic text field.");
			nm = obj.getChildAt(i).name;
			if (nm.substr(0, 3) == "tt_") {
				n = int(nm.substr(3, 99));
				try {
					str = transVector[n][_language]; // converts to e.g. translations[n].en
					if (str == null) {
						obj.getChildAt(i).text = _language + "??";
					} else {
						if (str.indexOf("<b>") >= 0 || str.indexOf("<i>") >= 0 || str.indexOf("<br>") >= 0 || str.indexOf("<li>") >= 0) {
							obj.getChildAt(i).htmlText = str;
							//trace("  Using htmlText = "+str);
						} else {
							obj.getChildAt(i).text = str;
							//trace("  Using text = "+str);
						}
					}
					//trace("i = "+i+": Found "+_language+" translation for symbol "+nm+"; text is "+str+"; obj now contains: "+obj.getChildAt(i).text);
				} catch (e: Error) {
					obj.getChildAt(i).text = _language + "??";
					trace("Error finding " + _language + " translation for symbol " + nm);
				}
			}
		}
	}
}
function traceToConsole(str:String){
	trace(str);
	try {
		ExternalInterface.call("absorbScorm.trace", str ); // Only works if running in a browser
	} catch (e:Error){
		
	}
}