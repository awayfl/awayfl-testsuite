package {
// NOT THE REAL THING!!
	/*
	Quaternion class
	Adapted from http://www.adobe.com/devnet/flash/articles/3d_classes_04.html
	Converted to use Vector3D throughout, RB 12/2010

	Class properties:
	x, y, z, w
	
	Class methods:
	setFromPoint
	setFromAway3DQuaternion
	setFromAxisAngleDeg
	concatWithQuat
	invertSelf
	setFromHeadingAttitudeBank
	getHeadingAttitudeBank
	toString
	
	Static methods:
	concat
	rotatePoint
	inverse
	
	*/
	//import com.satprof.lib.*;
	import flash.geom.*; // For Vector3D

	public class QuatV {
  		private var $x, $y, $z, $w:Number;
		private var tracePrec:int = 3;
	
  		function QuatV() {
			// Create a new quaternion.  Default is no rotation.
			$x = 0;
			$y = 0;
			$z = 0;
			$w = 1;  // The scalar
		}
	
  		public function get x():Number {
			return $x;
		}
	
  		public function get y():Number {
			return $y;
		}
	
  		public function get z():Number {
			return $z;
		}

  		public function get w():Number {
			return $w;
		}

  		public function setFromPoint(a:Number, b:Number, c:Number):void {
			$x = a;
			$y = b;
			$z = c;
			$w = 0;
		}
		public function setFromAway3DQuaternion( aq ){
			$x = aq.x;
			$y = aq.y;
			$z = aq.z;
			$w = aq.w;
		}
				
  		public function setFromAxisAngleDeg(a:Number, b:Number, c:Number, d:Number):void{
			// Sets the quaternion based on the rotation axis vector (a,b,c),
			// and the angle of rotation (degrees) around this vector (d).
			// Returns a normalized quaternion.
			var ca = Math.cos( Util3.radians(d)/2); 
			var sa = Math.sin(Util3.radians(d)/2);
			var m = Math.sqrt(a*a + b*b + c*c);
			$x = a/m * sa;
			$y = b/m * sa;
			$z = c/m * sa;
			$w = ca;
		}
				
  		public function concatWithQuat(q:QuatV):QuatV {
			// Concatenates this quaternion with argument q
			// Returns this . q
			var w2 = q.w; var x2 = q.x; var y2 = q.y; var z2 = q.z;
			var wret = $w*w2 - $x*x2 - $y*y2 - $y*z2;
			var xret = $w*x2 + $x*w2 + $y*z2 - $y*y2;
			var yret = $w*y2 + $y*w2 + $y*x2 - $x*z2;
			var zret = $w*z2 + $y*w2 + $x*y2 - $y*x2;
			
			var Qret:QuatV = new QuatV();
			Qret.$x = xret;
			Qret.$y = yret;
			Qret.$z = zret;
			Qret.$w = wret;
			return Qret;
		}
  		public static function concat(p:QuatV, q:QuatV):QuatV {
			// Concatenates this quaternion p with quaternion q
			// Returns p . q
			var w1 = p.w; var x1 = p.x; var y1 = p.y; var z1 = p.z;
			var w2 = q.w; var x2 = q.x; var y2 = q.y; var z2 = q.z;
			var wret = w1*w2 - x1*x2 - y1*y2 - z1*z2;
			var xret = w1*x2 + x1*w2 + y1*z2 - z1*y2;
			var yret = w1*y2 + y1*w2 + z1*x2 - x1*z2;
			var zret = w1*z2 + z1*w2 + x1*y2 - y1*x2;
			
			var Qret:QuatV = new QuatV();
			Qret.$x = xret;
			Qret.$y = yret;
			Qret.$z = zret;
			Qret.$w = wret;
			return Qret;
		}
	
		public static function rotatePoint( Q:QuatV, a:Vector3D ):Vector3D {
			// Returns point A rotated by Q
			// B = Q . A . Q'
			// where Q = this quaternion
			//       A = quaternion, w=0, x = ax, y = ay, z = az
			//       Q' = inverse of Q
			
			var A:QuatV = new QuatV();
			A.setFromPoint(a.x, a.y, a.z);
			var Qinv:QuatV = inverse(Q);  // Q'
 			var AQinv:QuatV = concat( A, Qinv );
			var B:QuatV = concat( Q, AQinv );
			var b:Vector3D = new Vector3D( B.x, B.y, B.z );
			return b;
		}
		
  		public function invertSelf():void {
			$x = -$x;
			$y = -$y;
			$z = -$z;
		}
  		public static function inverse(P:QuatV):QuatV {
			var Q:QuatV = new QuatV();
			Q.$x = -P.x;
			Q.$y = -P.y;
			Q.$z = -P.z;
			Q.$w = P.w;
			return Q;
		}
		
		public function setFromHeadingAttitudeBank(hab:Vector3D):void{
			/* From http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/index.htm
			and http://www.euclideanspace.com/maths/standards/index.htm
				Heading = rotation about y axis
				Attitude = rotation about z axis
				Bank = rotation about x axis
			*/
			
			var heading = -Util3.radians(hab.x);// Made negative RB 9/19/2012
			var attitude = Util3.radians(hab.y);
			var bank = Util3.radians(hab.z);

    		var c1 = Math.cos(heading/2);
    		var s1 = Math.sin(heading/2);
    		var c2 = Math.cos(attitude/2);
    		var s2 = Math.sin(attitude/2);
    		var c3 = Math.cos(bank/2);
    		var s3 = Math.sin(bank/2);
    		var c1c2 = c1*c2;
    		var s1s2 = s1*s2;
    		$w =c1c2*c3 - s1s2*s3;
  			$x =c1c2*s3 + s1s2*c3;
			$y =s1*c2*c3 + c1*s2*s3;
			$z =c1*s2*c3 - s1*c2*s3;
			return;
  		}
 		public function getHeadingAttitudeBank():Vector3D {
			// Returns equivalent heading, attitude, & bank of this quaternion.
			// Result is in a Vector 3d as h, a, b.
 			// From http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/index.htm
			// But heading sense is reversed there. Positive heading should be negative rotation when rotation vector is pointing straight up.
     		var sqw = $w * $w;
    		var sqx = $x * $x;
    		var sqy = $y * $y;
    		var sqz = $z * $z;
			var unit = sqx + sqy + sqz + sqw; // if normalised is one, otherwise is correction factor
			var test = $x*$y + $z*$w;
			var heading;
			var attitude;
			var bank;
			/*
			if (test > 0.4999999*unit) { // singularity at north pole
				heading = 2 * Math.atan2($x, $w);
				attitude = Math.PI/2;
				bank = 0;
				trace("WARNING: in getHeadingAttitudeBank, north pole singularity.");
			} else 	if (test < -0.4999999*unit) { // singularity at south pole
				heading = -2 * Math.atan2($x, $w);
				attitude = -Math.PI/2;
				bank = 0;
				trace("WARNING: in getHeadingAttitudeBank, south pole singularity.");
			} else {
    			heading = Math.atan2( (2*$y*$w - 2*$x*$z) , (sqx - sqy - sqz + sqw) );
			 	attitude = Math.asin(2*test/unit);
				bank = Math.atan2(2*$x*$w-2*$y*$z , -sqx + sqy - sqz + sqw);
			}
			*/
			if (test > 0.4999999*unit) { // singularity at north pole
				trace("WARNING: in getHeadingAttitudeBank, at or near north pole singularity.");
			}
			if (test < -0.4999999*unit) { // singularity at south pole
				trace("WARNING: in getHeadingAttitudeBank, at or near south pole singularity.");
			} 
    		heading = -Math.atan2( (2*$y*$w - 2*$x*$z) , (sqx - sqy - sqz + sqw) ); // Made negative RB 9/19/2012
			attitude = Math.asin(2*test/unit);
			bank = Math.atan2(2*$x*$w-2*$y*$z , -sqx + sqy - sqz + sqw);
																							   
			var hab:Vector3D = new Vector3D( Util3.degrees(heading), Util3.degrees(attitude), Util3.degrees(bank) );
			return hab;
		}

		public function toString(){
			var ps = "%8."+tracePrec+"f";
			var hab:Vector3D = getHeadingAttitudeBank();
			// w = cos(theta/2)
			var theta = Util3.degrees(2*Math.acos($w));
			var s = "x = "+Util3.sprintf3(ps, $x)+", y = "+Util3.sprintf3(ps, $y)+", z = "+Util3.sprintf3(ps, $z)+
			", w = "+Util3.sprintf3(ps, $w)+"; "+
			"theta = "+Util3.sprintf3(ps, theta)+"; "+
			"HAB = "+Util3.sprintf3(ps, hab.x)+"/"+Util3.sprintf3(ps, hab.y)+"/"+Util3.sprintf3(ps, hab.z);
			return s;
		}
	}
}