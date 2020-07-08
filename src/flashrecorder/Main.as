package 
{
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.events.ProgressEvent;

import flash.external.ExternalInterface;
import flash.text.TextField;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.net.URLLoader;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.display.MovieClip;
import flash.geom.Point;
import flash.utils.Dictionary;
import flash.utils.describeType;
import flash.display.Bitmap;
import flash.display.BitmapData;

import com.sociodox.utils.Base64;
import flash.utils.ByteArray;
import flash.geom.Rectangle;
import flash.net.URLVariables;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequestMethod;
import flash.display.PNGEncoderOptions;
import flash.net.URLRequestHeader;
import flash.display.LoaderInfo;
import flash.system.Security;
import flash.system.LoaderContext;
import flash.system.SecurityDomain;
import flash.system.ApplicationDomain;


    public class Main extends Sprite 
    {
		private var _jsonPath:String = "testData.json";
		private var loader:Loader;
		private var urlloader:URLLoader;
		private var bgMC:MovieClip;
		private var frameCnt:Number=0;
		private var lastBitmapData:BitmapData;
		private var swf:String;
		private var port:String;
		private var options:Object;
        //---------------------------------------
 
        public function Main():void 
        {
			Security.allowDomain("*");
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }


        private function init(e:Event = null):void 
        {		
			//trace("init");
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
			stage.color =0xdddddd;
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;			

			this.options={
				snapshotOnEnterFrame:0,
				snapshotOnMouseDown:false,
				captureInput:true
			}
			
			var globalParam = LoaderInfo(this.root.loaderInfo).parameters;
			
			this.swf=globalParam["swf"];
			this.port=globalParam["port"];
				/*		
			var urlloader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest("http://localhost:"+this.port+"/"+_jsonPath);
			trace("init2");
			urlloader.addEventListener(Event.COMPLETE, onLoaderComplete);
			try{
				urlloader.load(request);
			} catch (error:Error) {
				trace("Cannot load : " + error.message);
			}
			onStageResized();
            stage.addEventListener(Event.RESIZE, onStageResized, false, 0, true);

        }
		private function onHudClick(e:Event):void 
		{
			this.hud.startDrag(false, new Rectangle(0,0, this.stage.stageWidth-this.hud.width, this.stage.stageHeight-this.hud.height));			
		}
		private function onLoaderComplete(e:Event):void 
		{
			var data:Object = JSON.parse(e.target.data);
			//trace("The answer is " + data);
			//var jsonArray:Array = JSON.decode(loader.data);
			//trace("loader.data: " + urlloader.data);*/
			var request:URLRequest
			if(this.port && this.swf){
				request = new URLRequest("http://localhost:"+this.port+"/"+this.swf+".swf");
			}
			else{
				
				request = new URLRequest("http://localhost:1111/test.swf?x");
			}
			//var loader_context:LoaderContext = new LoaderContext();
			//if (Security.sandboxType!='localTrusted') 
			//loader_context.securityDomain = SecurityDomain.currentDomain;
			//loader_context.applicationDomain = ApplicationDomain.currentDomain;
            loader = new Loader()
			loader.contentLoaderInfo.addEventListener(Event.INIT, completeHandler);
			//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onprogress);
			this.bgMC=new MovieClip();
			this.addChildAt(this.bgMC,0);
			this.addChildAt(loader, 1);	
            loader.load(request);
		}
 

		public function setSWFInfos(obj:LoaderInfo):void
		{
			var outStr="SWFTestInfos:{";
			outStr+='"frameRate":'+obj.frameRate+",";
			outStr+='"swfVersion":'+obj.swfVersion+",";
			outStr+='"asVersion":'+obj.actionScriptVersion+",";
			outStr+='"width":'+obj.width+",";
			outStr+='"height":'+obj.height+"}";
			trace(outStr);
		}
		/*
		public function onprogress (e:Event):void {
			trace("progress", e.bytesLoaded/e.bytesTotal)
			//if(e.bytesLoaded/e.bytesTotal == 1)
			//	this.captureObject(loader.contentLoaderInfo, "loaderInfo", ["frameRate", "swfVersion", "actionScriptVersion", "width", "height"]);	
			
		}*/
		public function initHandler (e:Event):void {
			trace("Event.INIT")
		}
		public function completeHandler (e:Event):void {
			//trace("Event.COMPLETE")
			this.bgMC.graphics.beginFill(0xffffff, 1.0);
			this.bgMC.graphics.drawRect(0,0, loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
			this.setSWFInfos(loader.contentLoaderInfo);	
			
			this.stage.frameRate=loader.contentLoaderInfo.frameRate;
			//this.stage.stageWidth=loader.contentLoaderInfo.width;
			//this.stage.stageHeight=loader.contentLoaderInfo.height;

	
            addEventListener(Event.ENTER_FRAME, enterFrame);
            addEventListener(Event.EXIT_FRAME, exitFrame);
            addEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent);
            addEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent);
            addEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent);
            addEventListener(MouseEvent.MOUSE_DOWN, captureMouseEvent);
            addEventListener(MouseEvent.MOUSE_UP, captureMouseEvent);
            addEventListener(KeyboardEvent.KEY_DOWN, captureKeyboardEvent, true);
            addEventListener(KeyboardEvent.KEY_UP, captureKeyboardEvent, true);
			
			onStageResized();
			
		}
		public function enterFrame (e:Event):void {
			frameCnt++;		
			trace("SWFFRAME "+frameCnt);
		}
		public function exitFrame (e:Event):void {
							
		}
		public function captureScreen(e:KeyboardEvent):void {
		/*
			var myBitmapData:BitmapData = new BitmapData(loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
			myBitmapData.draw(loader);
			var bmp:Bitmap = new Bitmap(myBitmapData);
			//this.addChild(bmp);
			
			if(this.lastBitmapData!=null){
				var compareResult=myBitmapData.compare(this.lastBitmapData);
				trace("compareResult", compareResult);
				
				var myByteArray:ByteArray=new ByteArray();
				myBitmapData.encode(new Rectangle(0,0,loader.contentLoaderInfo.width, loader.contentLoaderInfo.height), new flash.display.PNGEncoderOptions(), myByteArray);
				 var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream")
				var url_request:URLRequest = new URLRequest();
				 url_request.requestHeaders.push(header)
				url_request.url = "http://localhost:1111/uploadFromFlash?name=something/test/test";
				url_request.contentType = "binary/octet-stream";
				url_request.method = URLRequestMethod.POST;				
				url_request.data = myByteArray;

				var imgLoader:URLLoader = new URLLoader();
				imgLoader.dataFormat = URLLoaderDataFormat.BINARY;
				imgLoader.load(url_request);
				this.lastBitmapData=null;
								
			}
			if(frameCnt==0){
				this.lastBitmapData=myBitmapData;
			}			*/
		}
		public function captureKeyboardEvent (e:KeyboardEvent):void {
			if(this.loader && this.options.captureInput){
				trace("AWAYFL_KEYEVENT "+JSON.stringify({
					type:e.type, 
					charCode:e.charCode, 
					shiftKey:e.shiftKey, 
					altKey:e.shiftKey, 
					ctrlKey:e.ctrlKey }));
			}	
		}
		public function captureMouseEvent (e:Event):void {
			if(this.loader && this.options.captureInput){
				var globalPt:Point=new Point(mouseX,mouseY);
				var localPt:Point = this.loader.globalToLocal(globalPt);
				trace("AWAYFL_MOUSEEVENT "+JSON.stringify({
					type:e.type, 
					x:localPt.x,
					y:localPt.y}));			
			}			
		}



        private function onStageResized(e:Event = null):void
        {
            if(this.loader){
				var scaleWidth=stage.stageWidth/loader.contentLoaderInfo.width;
				var scaleHeight=stage.stageHeight/loader.contentLoaderInfo.height;
				var scale=scaleWidth;
				if(scaleHeight<scaleWidth){
					scale=scaleHeight;
				}
				this.bgMC.scaleX=this.loader.scaleX=(scale);
				this.bgMC.scaleY=this.loader.scaleY=(scale);
				
                this.bgMC.x=this.loader.x=(stage.stageWidth-(scale*loader.contentLoaderInfo.width))/ 2;
                this.bgMC.y=this.loader.y=(stage.stageHeight-(scale*loader.contentLoaderInfo.height))/ 2;
            }
        }
    }
}