package  {
	
	import flash.display.MovieClip;
	
	
	public class child extends MovieClip {
		
		
		public function child() {
			// constructor code
			trace("constructor child "+this.parent.name+" /" +this.name);
			gotoAndStop(2);
			trace("end constructor child "+this.parent.name+" /" +this.name);
		}
	}
	
}
