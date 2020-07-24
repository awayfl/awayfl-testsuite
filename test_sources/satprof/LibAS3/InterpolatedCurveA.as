package  {
	///import com.satprof.lib.*;
	import flash.geom.*;
	
public class InterpolatedCurveA {

	private var _curve = "Linear";
	private var cp:Array;
	private var _endControlPoint:int = 4;
	private var maxControlPoints = 40;
	private var _reverse = false;
	private var _offset:Number = 0; // // Move point away in the direction normal to its rotation, which is the tangent of the curve
	
	public function InterpolatedCurveA() {
		// constructor code
		init(); // With defaults
	}
	function init(){
		cp = new Array();
		for (var i=0; i<maxControlPoints;i++){
			cp[i] = new Point(i*10,100)
		}
	}
	public function set curve(val){
		_curve = val;
	}
	public function get curve(){
		return _curve;
	}

	public function set endControlPoint(val){
		_endControlPoint = Math.min(val, maxControlPoints-1);
	}
	public function get endControlPoint(){
		return _endControlPoint;
	}
	public function set reverse(val){
		_reverse = val;
	}
	public function get reverse(){
		return _reverse;
	}

	public function set offset(val){
		_offset = val;
	}
	public function get offset(){
		return _offset;
	}

	public function setControlPoint(icp, xx, yy){
		cp[icp] = new Point(xx, yy);
	}

	public function interpCurve(p){
		var dp:Vector3D = new Vector3D();
		var rot;
		var dx = 0;
		var dy = 0;
		if (_curve == "linear"){
			dp.x = cp[0].x + p * (cp[3].x - cp[0].x);
			dp.y = cp[0].y + p * (cp[3].y - cp[0].y);
			rot = Util3.degrees(Math.atan2( (cp[3].y - cp[0].y), (cp[3].x - cp[0].x) ) );
			dp.w = rot;
			//trace("x0,y0 = ("+cp[0].x+","+cp[0].y+"), x1,y1 = ("+cp[3].x+","+cp[3].y+"), x,y = ("+dp.x+","+dp.y+"), rot = "+rot+", dx = "+dx+", dy = "+dy);
		} else if (_curve == "cubic"){
			// Formulas are from http://www.vbforums.com/showthread.php?t=481546
			// Re: Parametric Cubic Spline Tutorial
			//Example Problem #3 (Bezier curve)
			// Control points 0 and 3 define the end points of the curve.
			// Control points 1 and 2 are for steering.
			dp.x = (1-p)*(1-p)*(1-p)*cp[0].x + 3*p*(1-p)*(1-p)*cp[1].x + 3*p*p*(1-p)*cp[2].x + p*p*p*cp[3].x;
			dp.y = (1-p)*(1-p)*(1-p)*cp[0].y + 3*p*(1-p)*(1-p)*cp[1].y + 3*p*p*(1-p)*cp[2].y + p*p*p*cp[3].y;

			/*
			Now let's calculate the slope so the dot rotates with the curve:
			x(p) = Ax*p^3 + Bx*p^2 + Cx*p + Dx
			y(p) = Ay*p^3 + By*p^2 + Cy*p + Dy
			Where 
			Ax = -x0 + 3*x1 + -3*x2 + x3
			Bx = 3*x0 + -6*x1 + 3*x2
			Cx = -3*x0 + 3*x1
			Dx = x3
			and
			Ay = -y0 + 3*y1 + -3*y2 + y3
			By = 3*y0 + -6*y1 + 3*y2
			Cy = -3*y0 + 3*y1
			Dy = y3
			
			and
			x0 = cp[0].x, y0 = cp[0].y, etc.
			
			Taking the partial derivatives:
			dx/dp = 3*Ax*p^2 + 2*Bx*p + Cx
			dy/dp = 3*Ay*p^2 + 2*By*p + Cy
			
			So
			dy/dx = dy/dp / dx/dp = (3*Ax*p^2 + 2*Bx*p + Cx) / (3*Ay*p^2 + 2*By*p + Cy)
			
			
			*/
			var Ax = -cp[0].x + 3*cp[1].x + -3*cp[2].x + cp[3].x;
			var Bx = 3*cp[0].x + -6*cp[1].x + 3*cp[2].x;
			var Cx = -3*cp[0].x + 3*cp[1].x;

			var Ay = -cp[0].y + 3*cp[1].y + -3*cp[2].y + cp[3].y;
			var By = 3*cp[0].y + -6*cp[1].y + 3*cp[2].y;
			var Cy = -3*cp[0].y + 3*cp[1].y;
			rot = Util3.degrees(Math.atan2( (3*Ax*p*p + 2*Bx*p + Cx), (3*Ay*p*p + 2*By*p + Cy) ) );
			dp.w = -rot + 90;
		} else if (_curve == "elliptic"){
			/*
			Elliptical path.
			Major axis goes from cp[0] to cp[1].
			Distance from cp[2] to the maxjor axis determines the semi-minor axis.
			*/
			var x0 = (cp[0].x + cp[1].x)/2;  // Center
			var y0 = (cp[0].y + cp[1].y)/2; 
			var a = 0.5 * Math.sqrt( (cp[0].y-cp[1].y)*(cp[0].y-cp[1].y) + (cp[0].x-cp[1].x)*(cp[0].x-cp[1].x) ); // Semi major axis length
			var b = Math.abs( (cp[1].x-cp[0].x)*(cp[0].y-cp[2].y) - (cp[0].x-cp[2].x)*(cp[1].y-cp[0].y) ) / (2*a); // From  http://mathworld.wolfram.com/Point-LineDistance2-Dimensional.html
			//trace("a = "+a+", b = "+b+", cp[0].x = "+cp[0].x+", cp[0].y = "+cp[0].y+", cp[1].x = "+cp[1].x+", cp[1].y = "+cp[1].y+", cp[2].x = "+cp[2].x+", cp[2].y = "+cp[2].y);
			var esq = ( 1 - (b*b)/(a*a) );
			// Weight the angle with a sinusoidal bias term to help make the speed of the dots more uniform for different shaped ellipses.
			// Formula for k was found empirically.  See Excel workbook "Ellipse experiments.xlsx"
			var k = -.3*esq;
			var theta = p * 2*Math.PI + k*Math.sin(2*p*2*Math.PI); // Constant angular velocity
			var theta0 = Math.atan2( (cp[0].y-cp[1].y), (cp[0].x-cp[1].x) );  // Rotation of the major axis
			// 
			var st = Math.sin(theta);
			var ct = Math.cos(theta);
			var rsq = a*a * b*b /( a*a*st*st + b*b*ct*ct);
			var r = Math.sqrt(rsq);
			var tt = theta + theta0;
			dp.x = x0 + r*Math.cos(tt);
			dp.y = y0 + r*Math.sin(tt);
			//dots[iD].rotation = Util3.degrees(Math.atan( (a/b)*Math.tan(tt) ) ) + 90; // From http://mathworld.wolfram.com/Ellipse.html
			var x1 =  r*Math.cos(theta);
			var y1 =  r*Math.sin(theta);
			var offset = 0;
			if ( theta > Math.PI) {
				offset = 0;
			} else {
				offset = 180;
			}
			if (_reverse){ offset += 180; };
			dp.w = -Util3.degrees(Math.atan( (x1*b*b)/(y1*a*a) ) - theta0) + offset; // From http://www.bymath.com/studyguide/angeo/sec/angeo4.htm
			//trace("iD = "+iD+", theta = "+Util3.degrees(theta)+", rot = "+dots[iD].rotation);
			//trace("iD = "+iD+", e = "+e+", cp[0].x = "+cp[0].x+", cp[1].x = "+cp[1].x+", cp[0].y = "+cp[0].y+", cp[1].y = "+cp[1].y+", theta = "+theta+", theta0 = "+theta0);
		} else if (_curve == "catmull"){
			var icpEnd = _endControlPoint;
			var iSeg:int;
			var g:Number;
			if (p>= 1){
				iSeg = icpEnd-1;
				g = 1;
			} else {
				iSeg = Math.floor( p * (icpEnd-1)) + 1;
				g = (p * (icpEnd-1)) - Math.floor( p*(icpEnd-1));
			}
			var px:Vector3D = calculate_catmull(g, cp[iSeg-1].x, cp[iSeg].x, cp[iSeg+1].x, cp[iSeg+2].x);
			var py:Vector3D = calculate_catmull(g, cp[iSeg-1].y, cp[iSeg].y, cp[iSeg+1].y, cp[iSeg+2].y);
			dp.x = px.x;
			dp.y = py.x;
			
			var dXdg = px.y; // First derivative vs. parameter t
			var dYdg = py.y; // First derivative vs. parameter t
			//var dYdX = dYdg / dXdg;
			rot = Util3.degrees(Math.atan2(dYdg, dXdg));
			dp.w = rot;
			//trace("p = "+p+", iSeg = "+iSeg+", _endControlPoint = "+_endControlPoint+", g = "+g+", rot = "+rot); 
		}
		if (_offset != 0){
			// Move point away in the direction normal to its rotation, which is the tangent of the curve
			dx = _offset*Math.sin(Util3.radians(-dp.w)); 
			dy = _offset*Math.cos(Util3.radians(-dp.w));
			dp.x += dx;
			dp.y += dy;
		}
		
		return dp;
	}
	function calculate_catmull(t:Number, p0:Number, p1:Number, p2:Number, p3:Number):Vector3D{
		var t2:Number = t*t;
		var t3:Number = t2 * t;
		var v:Vector3D = new Vector3D();
		// P(t)
		v.x = (0.5 *( (2 * p1) + (-p0 + p2) * t +(2*p0 - 5*p1 + 4*p2 - p3) * t2 +(-p0 + 3*p1- 3*p2 + p3) * t3));
		// P'(t)
		v.y = 0.5 * (-p0 + p2) + t * (2*p0 - 5*p1 + 4*p2 - p3) + t2 * 1.5 * (-p0 + 3*p1 - 3*p2 + p3);
		// P''(t)
		v.z = (2*p0 - 5*p1 + 4*p2 - p3) + t * 3.0 * (-p0 + 3*p1 - 3*p2 + p3);
	return v;
}
} // End class
} // End package