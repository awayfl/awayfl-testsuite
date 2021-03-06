﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Child2 extends MovieClip {
		
		
		public function Child2() {
			// constructor code
			trace("constructor", this, this.parent, this.name);
			this.addEventListener(Event.ADDED, onAdded);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			//this.addEventListener(Event.REMOVED, onAdded);
			//this.addEventListener(Event.REMOVED_FROM_STAGE, onAdded);
			this.addEventListener(Event.ENTER_FRAME, onEnter);
			//this.addEventListener(Event.FRAME_CONSTRUCTED, onConstructed);
			//this.addEventListener(Event.EXIT_FRAME, onExit);
								  
		}
		private function onAdded(evt){
			trace(evt.type, this, this.name, evt.target);
		}
		private var enterCnt:Number=0;
		private function onEnter(evt){
			trace(evt.type, this, this.name, this.currentFrame);
			enterCnt++;
			if(enterCnt>=3){
				this.removeEventListener(Event.ENTER_FRAME, onEnter);				
			}
		}
		private var exitCnt:Number=0;
		private function onExit(evt){
			trace(evt.type, this, this.name, this.currentFrame);
			exitCnt++;
			if(exitCnt>=3){
				//this.removeEventListener(Event.EXIT_FRAME, onExit);				
			}
		}
		private var conrtuctedCnt:Number=0;
		private function onConstructed(evt){
			trace(evt.type, this, this.name);
			conrtuctedCnt++;
			if(conrtuctedCnt>=3){
				//this.removeEventListener(Event.FRAME_CONSTRUCTED, onConstructed);				
			}
		}
	}
	
}
