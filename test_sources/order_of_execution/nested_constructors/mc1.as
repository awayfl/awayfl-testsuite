package  {
	
	import flash.display.MovieClip;
	
	
	public class mc1 extends MovieClip {
		
		
		public function mc1() {
			// constructor code
			trace("constructor mc "+this.name);
			gotoAndStop(2);
			trace("end constructor mc "+this.name);
		}
	}
	
}
