package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Main extends MovieClip {
		
		
		public function Main() {
			// constructor code
			trace("constructor Main parent", this.parent, stage);
			this.addEventListener(Event.ADDED, onAdded);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			//this.addEventListener(Event.REMOVED, onAdded);
			//this.addEventListener(Event.REMOVED_FROM_STAGE, onAdded);
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			//this.addEventListener(Event.FRAME_CONSTRUCTED, onConstructed);
			//this.addEventListener(Event.EXIT_FRAME, onExit);
			/*var dChild1=new Child1();
			dChild1.x=0;
			dChild1.y=250;
			this.addChild(dChild1);*/
								  
		}
		private function onAdded(evt){
			trace(evt.type, this, evt.target, this.currentFrame, this.numChildren);
		}
		private var enterCnt:Number=0;
		private function onEnter(evt){
			trace(evt.type, this, this.currentFrame, this.numChildren);
			for(var i:Number=0; i<this.numChildren; i++){
				trace("child", i, this.getChildAt(i));
			}
			enterCnt++;
			if(enterCnt>=3){
				this.removeEventListener(Event.ENTER_FRAME, onEnter);				
			}
		}
		private var exitCnt:Number=0;
		private function onExit(evt){
			trace(evt.type, this, this.currentFrame);
			exitCnt++;
			if(exitCnt>=3){
				//this.removeEventListener(Event.EXIT_FRAME, onExit);				
			}
		}
		private var conrtuctedCnt:Number=0;
		private function onConstructed(evt){
			trace(evt.type, this);
			conrtuctedCnt++;
			if(conrtuctedCnt>=3){
				//this.removeEventListener(Event.FRAME_CONSTRUCTED, onConstructed);				
			}
		}
	}
	
}
