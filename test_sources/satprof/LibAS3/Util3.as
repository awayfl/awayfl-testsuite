package {

	// TRIMMED BACK VERSION OF THE REAL THING!
	
	import flash.geom.*;
	import flash.text.*;
	import flash.external.*;

	public class Util3 {
		/* Utilities collected and written by R Brooker
		Revisions:
		2/4/08  Added trimSpaces, iSNotANumber functions
		11/6/07 RB Renamed Util3.  Added frame rotation, dot & cross products.
		10/15/07 RB Util_AS3.as adapted for AS3 from Util.as 
		5/30/07 RB  Added function antennaPatternSynth
		6/25/07 RB  Added function parseCSVLine
		
		NOTE: moved Away3D functions to UtilA3D34.as
		
		Functions implemented and tested:
		Constants:
		earthRadiuskm  // Radius of the earth (km)
		geoHeightkm    // Geostationary height (km)
		
		
		Formatting functions:
		sprintf3( format, number)  // Format using the classice sprintf syntax, e.g. Util3.sprintf3("%7.3f", a)  or %07.3f to show leading zeroes
		formatVector3D( n:int, p:int, v:Vector3D)		
		formatSignedInt(number); // Returns text containing number rounded to integer with + or - sign
		formatDecimals( number, nplaces )
		formatFraction( number, denominator)   e.g. 4.25,12 returns "4 3/12"
		roundToFraction( number, denominator ); e.g. 4.26, 12 returns 4.250000
		roundToNplaces(a:Number, N:int); 
		formatLatLong(val, posdir, P);   Format a lat/long, P decimal places.  posdir = "N", "S", "E", "W" indicates positive sense
		formatLatLong2(val, posdir, P);  //Format a lat/long, P decimal places.  posdir = "N", "S", "E", "W" indicates positive sense
		sDigitalClock(secs)		//Returns a string with the time in hh:mm:ss format.  Input in seconds
		formatIntegerWithZeros(num, digits) //format a number as an integer with leading zeros and a specified number total digits
		parseCSVLine( line )	//	Parses a string in Excel CSV format to an array of strings
		trimSpaces // Trims leading and trailing spaces from a string.
		textFieldActualHeight(tf:TextField)	// Finds the actual height of a text field at its current width, which may have multiple lines and autowrap.
		trimChars( str:String, char:String )	// Trims leading and trailing characters from a string.	
		
		removeNonPrintable // Removes non printable characters from a string.
		isNotANumber // Like isNaN, but also works if the string is null or all spaces.
		bit(a, n);  // Returns bit n from number a.
		
		min		Minimum value of an array
		max		Maximum value of an array
		
		Conversion functions:
		W2dBm( x )			//Watts to dBm
		W2dBW( x )Watts to dBW 
		dBW2W( x )dBW to Watts 
		dBm2W( x )dBm to Watts
		log10( x )Log base 10
		Vratio2dB( Vratio )
		dB2Vratio( dB )
		
		clipper (limiter based on voltage clipping)
		
		RL2seriesXL( RLdB )   // COnverts RL (+) in dB to an equivalent series inductive reactance

		sumdBPowers( array )  // Adds powers in dB
		sum2CWsignals( p1dBx, ph1deg, p2dBx, ph2deg); // Sums two CW signals; returns power in dBx
		radians(deg)   // Converts degrees to radians
		degrees(rad)   // Converts radians to degrees
		mod360(ang)    // Shifts angle in degrees to the range 0-360, even if negative.
		pm180(ang)     // Shifts angle in degrees to the range -180- +180, even if negative.
		polDiffAng(a1, a2) // Difference between two pol plane angles. Returns -90 to +90.
 		polPM90(ang)  // Polarization angle normalized to +/- 90 deg.
	    diffAng(a1, a2)  // Difference between two angles (a1-a2), normalized to +/- 180
 		angleIsBetween(a, min, max); // True if angle is between min and max 
		
		
		Waveforms:
		rampWave( t, ramptime, vBottom, vTop, repeating ); //t, ramptime, vBottom, vTop, repeating
		rampDwell( t, ramptime, dwelltime, vBottom, vTop, repeating ); //t, ramptime, dwelltime, vBottom, vTop, repeating
		rampWaveN( t:Number, ramptimeList:Array, pointList:Array, repeating:Boolean ) e,g, v = Util3.rampWaveN( t, [0, 2, 3], [10,20,15], true);
		sineWave( t, period, vAmpl, vAvg, repeating ); //t, period, vAmpl, vAvg, repeating
		triangleWave(  t, period, vAmpl, vAvg, repeating ); //t, period, vAmpl (0-p), vAvg, repeating 
		triangleWave2(  t, period, vBottom, vTop, repeating ); // t, period, vBottom, vTop, repeating
		triangleWave2Dwell( t, period, dwelltime, vBottom, vTop, repeating ): // t, period, dwelltime, vBottom, vTop, repeating
		squareWave(  t, period, vAmpl, vAvg, repeating ); //t, period, vAmpl (0-p), vAvg, repeating 


		Antennas and link budgets::
		antennaPattern(angle_deg, dia_m, freq_MHz, eff, sidelobeLeveldB, type)  Synthesizes a parabolic antenna gain pattern
		patternSpec(angle_deg, type, returnVal ); // type = "ITU580" "FCC" ;  returnVal = "gain" "startAngle"
		loss2beamwidth( L, hb3 )  Converts antenna off-axis loss (positive) to half-beamwidth at that loss.  Requires 3-dB half beamwidth. Uses parabolic assumption.
		beamwidth2loss( hb, hb3 ) Converts antenna half beamwidth angle to off-axis loss.  Requires 3-dB half beamwidth.  Uses parabolic assumption.
		antGaindB( dia_m, freq_MHz, eff ); // On-axis gain
		antBeamwidth( dia_m, freq_MHz, eff ); // 3 dB half beamwidth
		antEllipticalBeamwidth( majorDia_m, minorDia_m, freq_MHz, eff, tiltDeg  )
		antEllipticalGaindB( majorDia_m, minorDia_m, freq_MHz, eff )
		antEllipticalEffectiveDia( majorDia_m, minorDia_m )  // Dia of a circle that has the same area as a given ellipse
		OBSOLETE (use CrossPolCalculator.as): xpol_lp(angle_deg, off_axis_xpr, notch_full_bw_30_dB, notch_center_xpr ); //LP antenna close-in x-pol rejection ratio.  Valid for close angles only.
		OBSOLETE (use CrossPolCalculator.as): xpol_lp2(angle_deg, off_axis_xpr, notch_full_bw_30_dB, notch_center_xpr ); //LP antenna close-in x-pol rejection ratio, plus sin sq for the remainder of the full circle.
		freeSpaceLoss(freq_MHz, distance_km);
		
		Pointing angles:
		pointing_slantrange(ES_long, ES_lat, sat_long)
		pointing_az(ES_long, ES_lat, sat_long); // Returns az in degrees from north (0-360).
		pointing_el(ES_long, ES_lat, sat_long)
		pointing_pol(ES_long, ES_lat, sat_long)
		pointing_discr_angle(ES_long, ES_lat, sat1_long, sat2_long)
		pointing_loss(freq_GHz, dia_m, eff, angle_deg); // Loss (>0) of main beam at an angle off axis
		pointing_angle(freq_GHz, dia_m, eff, loss); // Off axis angle for given loss (>0) in main beam.  Gives the beamwidth at chosen loss
		pointing_angle_rt(Tx_freq_GHz, Rx_freq_GHz, dia_m, eff, loss)
		pointing_diff_angle( az1, el1, az2, el2); // Subtended angled between two vectors in defined by their az-el angles
		pointing_apparent_az_beamwidth( bw, el); // Azimuth width of a beam with beamwidth bw as seen at elevation el
		pointing_feedRotation(ES_long, ES_lat, sat_long, definedSense, actualSense ); // Returns feed rotation in degrees, where positive is CW when looking into the dish.  Senses are "H" or "V"
		pointing_errorBeamBalance( hbw3, L, E); // hbw = 3dB half beamwidth; L = pointing loss to ref level; E = meter error 
		randomESlongitude10(ESlat, satLong); // random longitude for elevation 10 deg or more.
		sunAzEl(param, Lon_deg, Lat_deg, yearNo, monthNo, dayNo, UTC_hrs)   Returns az or el of the sun
		pointing_lossToTarget(az, el, targetAz, targetEl, hb3); // Pointing loss to a target satellite az-el from current antena direction az/el 
		scanTilt2AzEl(A0deg, E0deg, Sdeg, Tdeg)
		pointing_scannedBeamAzEl(mainBeamAz, mainBeamEl, scanBeamDistanceDeg, tiltDeg, scanBeamRadiusDeg, scanBeamAngleDeg)
		polPresetCaseNo(rxPol, az, northernHemisphere); //  Returns case no (1-4) per the diagram in SP-REF-001
		pointingO3b_az
		pointingO3b_el
		
		Standard dish pointing messages:
		NOTE: Use Phrases.as instead for updated, multilanguage messages.
		polSettingResultMessage( targetPolScale, actualPolScale, tolerance); 	// Generates a text message assessing the accuracy of a polarization adjustment.
		polSettingResultMessageHughes( targetPolScale, actualPolScale, tolerance)
		pointingAnglesTextFull(ES_long, ES_lat, sat_long, polDownlinkSense, azNom, elNom, polNom ); 	// Generates a detailed text message defining the satellite location, earth station location, and pointing angles.
		pointingAnglesTextFullHughes(ES_long, ES_lat, sat_long, polDownlinkSense, azNomMag, elNom, polNom ){	
		pointingAnglesTextShort(ES_long, ES_lat, sat_long, polDownlinkSense, azNom, elNom, polNom ); // Generates a short text message defining the satellite location, earth station location, and pointing angles.
		pointingAnglesTextShortHughes(ES_long, ES_lat, sat_long, polDownlinkSense, azNomMag, elNom, polNom ); // Generates a short text message defining the satellite location, earth station location, and pointing angles.
		pointingErrorText( errorAngle, tolerancePass, toleranceExcellent, units, az, el); // Generates a text message assessing the accuracy of a dish fine pointing adjustment.
		findAndPeakErrorText( CNActual, CNSpecification, pointingLossActual, pointingLossSpecification, az, el); // Generates a text message assessing coarse dish pointing accuracy.
		findAndPeakErrorTextHughes( SQFActual, SQFSpecification, SQFThreshold)
		
		Filter responses:
		filterGaussian(w:Number) Gaussian weighting filter net gain - power transfer function. Returns array.
		filterGaussian2(w:Number, b:int)
		filterGaussian3(len:int, b:Number, fc:Number, gain:Number)
		modFilter(frq, symbrate, alph, filtType) Raised cosine or raised root cosine filter for PSK modulation
		
		
		Random functions:
		randGaussian(); // Returns zero-mean Gaussian random number, sigma = 1.  For mean = m sigma = s, multiply by returned value s and add m.
		randRange(min, max); // Returns random number in the range min to max
		randRangeInt(min, max); // Returns random integer in the range min to max
		randRangeWithZeroGap(min, max); // Returns random number in the range -max to -min and +min to +max
		randBool(); // Returns random true/false
		Note: for a seeded random generator, use class RandomWithSeed
		
		Numerical functions:
		sign(x); // Returns +1 or -1
		signChar(x); // Returns "+" or "-"
		minmax(val, min, max); // Returns val bounded by min and max
		ellipseR(thetaDeg, majorDia, minorDia)  // Radius from center to ellipse.		
		ellipseArea(majorDia, minorDia); // Area of ellipse
		ratioAbs(a, b); // Abs value of the ratio, always >= 0.  e.g. ratioAbs(1, 1.2) = 0.2
		rss(a, b);  // sqrt of (a^2 + b^2)
		distanceBetween(a:Point, b:Point)
		equalToNplaces(a, b, N); // Returns true if a and b a equal to N decimal places.
		
		AS3 utilities:
		clearMovieClip(mc);  // Removes all children from a movieclip
		extractSWFfromPath(); // returns file name of the current SWF from a complete path.  Trims of leading folder and trailing extension.
		disableMouseOnAllChildren(obj) // Disables mouse on all children of this object.  Useful to prevent mouse from responding to any text fields in a symbol.
	
		Array utilities:
		clearArray(a);	// Removes all elements from an array.
		fillArray( A:Array, f ); // Fills returns array of same length as A but filled the value f		
		shuffledArray(len); // Returns an array containing integers 0...len in random order (nonrepeating)
		equalArrays(a:Array, b:Array); // Returns true if all elements are equal
		resampleArray(origArray:Array, newLength:int) // Returns resampled (smaller) array. orig can be array of Number or Complex. newLength must be less than orig length.
		insertionSort(values:Array, ascending:Boolean)  // Returns array of indices into values array
		
		Specialized functions:
		iDirectCNtoPWMVolts(CNR, sigLevel, sigLevelBaseline); // Converts CNR and signal level in dB to the PWM voltage dislplayed and output by the iDirect iNFINITY IDU		
		CNR2iDirectVoltage( CNR, CNRlock, tunedToCorrectCarrier, totalWidebandPowerdBm, coldSkyWidebandPowerdBm )		
		SpaceTrackPointingLossToAGC( signaldBm, inputAttendB, thresholdPct ); // Converts signal level to AGC value in Schlumberger SpaceTrack tracking receiver
		DIRECTVdB2IRD(dB)   // Curve fit measured dB down from peak to IRD value.
		DIRECTV_CN2IRD(dB)   // Curve fit of measured IRD value vs. C/N indicated by SuperBuddy
		EsNo2HNSQF  // Curve fit to Hughes HN display when locked to a DVB-S2 signal.
		
		SeaTelSettings2Pointing( azSetting, clSetting, elSetting, cantAngle ); // Returns Vector3D containing heading, attitude, bank
		SeaTelPointing2Settings( hab:Vector3D, cantAngle ); // Returns Vector3D containing AZdeg, ELdeg, CLdeg
		
		skyColor(timeOfDayHrs)
		isInsideTriangle()	Give 3 corners of a triangle and a point; returns true if the point is inside the triangle.

		PhoneElPol(gravity:Vector3D, satelliteDirection:Vector3D, upAxis:Vector3D, elOffset:Number):Vector3D{
			Returns the el and pol (twist) of a phone based on the accelerometer
		AzEl2CamXY(azDeg:Number, elDeg:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
			This function returns the x/y on screen of a point corresponding to az and el.
		CamXY2AzEl(xDegRot:Number, yDegRot:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
			This function returns the az and el of a point corresponding to a point x,y on the screen

		*/
		static public var earthRadiuskm = 6378.16;// Radius of the earth (km)
		static public var geoHeightkm = 35786.24;// Geostationary height (km)
		static public var O3bHeightkm = 8000;// O3b orbit height (km)
		static public var boltzmannConstant_WHz:Number = 1.3806504e-23;
		static public var boltzmannConstant_dBW1Hz:Number = -228.599163;
		
		static private var randGaussian_c_0 = 2.515517;
		static private var randGaussian_c_1 = 0.802853;
		static private var randGaussian_c_2 = 0.010328;
		static private var randGaussian_d_1 = 1.432788;
		static private var randGaussian_d_2 = 0.189269;
		static private var randGaussian_d_3 = 0.001308;
		public static function randGaussian() {
			var x:Number, t:Number, result:Number;
			/*
			From Gaussian distribution FAQ by John D'Errico.
			6. How do you generate a normally distributed random variable?
			
			There are several good ways to do this, some better than others. It is assumed that the user has available a good uniform pseudo-random deviate 
			generator available. This is the starting point	for all such approaches.
			
			A good and logical way to generate a normal random deviate is to look back to the answer to question (5). Simply generate a single 
			uniform [0,1] random deviate X, and then invert the cumulative normal at that point. If the inverse is an accurate one, then that number 
			will indeed be a pseudo-random normal deviate. This method will be as fast and as good as is the approximation you choose for
			the inverse of the cumulative normal.
			
			5. What is a good approximation to the inverse of the cumulative normal distribution function?
			
			Mathematically we can write this as:  Find X such that Q(X) = p for any 0 < p < 1. (Note: this computes an upper tail probability.)
			
			Again, it is not possible to write this as a closed form expression, so we resort to approximations. Because of the symmetry of the normal distribution, 
			we need only consider 0 < p < 0.5. If you have p > 0.5,	then apply the algorithm below to q = 1-p, and then negate the value for X obtained. (This 
			approximation is also from Abramowitz and Stegun.)
			
			t = sqrt[ ln(1/p^2) ]
			
			             c_0 + c_1*t + c_2*t^2
			X = t -  ------------------------------
			         1 + d_1*t + d_2*t^2 + d_3*t^3
			
			c_0 = 2.515517
			c_1 = 0.802853
			c_2 = 0.010328
			
			d_1 = 1.432788
			d_2 = 0.189269
			d_3 = 0.001308
			
			See Abramowitz and Stegun; Press, et al.
			*/
			x = Math.random();
			//for (x=0; x<=1; x += 0.05) {
			t = Math.sqrt((Math.log(1/(x*x))));
			result = -( t-(randGaussian_c_0 + randGaussian_c_1*t + randGaussian_c_2*t*t)/(1 + randGaussian_d_1*t + randGaussian_d_2*t*t + randGaussian_d_3*t*t*t) );
			//trace("x = " + x + ", result = " + result);
			//}
			return result;
		}
		public static function randRange(min, max){
			return min + (max-min)*Math.random();
		}
		public static function randRangeInt(min, max){
			var max1 = max+1;
			var r =  min + (max1-min)*Math.random();
			var ri = Math.floor(r);
			//trace(min+"..."+max+":  "+r+"/"+ri)
			return ri;
		}
		public static function randRangeWithZeroGap(min, max){
			var a = min + (max-min)*Math.random();
			if (Math.random()>0.5){
				return a;
			} else {
				return -a;
			}
		}
		public static function randBool(){
			return ( Math.random() > 0.5 );
		}
		
		public static function sprintf3(format:String, ... args):String {
		
		/*  sprintf(3) implementation in ActionScript 3.0.
		 *
		 *  Author:  Manish Jethani (manish.jethani@gmail.com)
		 *  Date:    April 3, 2006
		 *  Version: 0.1
		 *
		 *  Copyright (c) 2006 Manish Jethani
		 *
		 *  Permission is hereby granted, free of charge, to any person obtaining a
		 *  copy of this software and associated documentation files (the "Software"),
		 *  to deal in the Software without restriction, including without limitation
		 *  the rights to use, copy, modify, merge, publish, distribute, sublicense,
		 *  and/or sell copies of the Software, and to permit persons to whom the
		 *  Software is furnished to do so, subject to the following conditions:
		 *
		 *  The above copyright notice and this permission notice shall be included in
		 *  all copies or substantial portions of the Software.
		 *
		 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
		 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
		 *  DEALINGS IN THE SOFTWARE.  
		 */


		/*  sprintf(3) implementation in ActionScript 3.0.
		 *
		 *  http://www.die.net/doc/linux/man/man3/sprintf.3.html
		 *
		 *  The following flags are supported: '#', '0', '-', '+'
		 *
		 *  Field widths are fully supported.  '*' is not supported.
		 *
		 *  Precision is supported except one difference from the standard: for an
		 *  explicit precision of 0 and a result string of "0", the output is "0"
		 *  instead of an empty string.
		 *
		 *  Length modifiers are not supported.
		 *
		 *  The following conversion specifiers are supported: 'd', 'i', 'o', 'u', 'x',
		 *  'X', 'f', 'F', 'c', 's', '%'
		 *
		 *  Report bugs to manish.jethani@gmail.com
		 */
			var result:String = "";

			var length:int = format.length;
			var str:String;// Declare here to prevent compiler warnings (RB)
			var precision:String = "";
			var next:*;

			for (var i:int = 0; i < length; i++) {
				var c:String = format.charAt(i);

				if (c == "%") {
					var pastFieldWidth:Boolean = false;
					var pastFlags:Boolean = false;

					var flagAlternateForm:Boolean = false;
					var flagZeroPad:Boolean = false;
					var flagLeftJustify:Boolean = false;
					var flagSpace:Boolean = false;
					var flagSign:Boolean = false;

					var fieldWidth:String = "";

					c = format.charAt(++i);

					while (c != "d"
					&& c != "i"
					&& c != "o"
					&& c != "u"
					&& c != "x"
					&& c != "X"
					&& c != "f"
					&& c != "F"
					&& c != "c"
					&& c != "s"
					&& c != "%") {
						if (!pastFlags) {
							if (!flagAlternateForm && c == "#") {
								flagAlternateForm = true;
							} else if (!flagZeroPad && c == "0") {
								flagZeroPad = true;
							} else if (!flagLeftJustify && c == "-") {
								flagLeftJustify = true;
							} else if (!flagSpace && c == " ") {
								flagSpace = true;
							} else if (!flagSign && c == "+") {
								flagSign = true;
							} else {
								pastFlags = true;
							}

						}
						if (!pastFieldWidth && c == ".") {
							pastFlags = true;
							pastFieldWidth = true;

							c = format.charAt(++i);
							continue;
						}

						if (pastFlags) {
							if (!pastFieldWidth) {
								fieldWidth += c;
							} else {
								precision += c;
							}

						}
						c = format.charAt(++i);
					}

					switch (c) {
						case "d" :
						case "i" :
							//var next:* = args.shift();
							//var str:String = String(Math.abs(int(next))); // To prevent compiler warnings
							next = args.shift();
							str = String(Math.abs(int(next)));

							if (precision != "") {
								str = leftPad(str, int(precision), "0");
							}

							if (int(next) < 0) {
								str = "-" + str;
							} else if (flagSign && int(next) >= 0) {
								str = "+" + str;

							}
							if (fieldWidth != "") {
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else if (flagZeroPad && precision == "") {
									str = leftPad(str, int(fieldWidth), "0");
								} else {
									str = leftPad(str, int(fieldWidth));
								}

							}
							result += str;
							break;

						case "o" :
							//var next:* = args.shift();
							next = args.shift();
							//var str:String = uint(next).toString(8); // To prevent compiler warnings
							str = uint(next).toString(8);

							if (flagAlternateForm && str != "0") {
								str = "0" + str;
							}

							if (precision != "") {
								str = leftPad(str, int(precision), "0");
							}

							if (fieldWidth != "") {
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else if (flagZeroPad && precision == "") {
									str = leftPad(str, int(fieldWidth), "0");
								} else {
									str = leftPad(str, int(fieldWidth));
								}

							}
							result += str;
							break;

						case "u" :
							//var next:* = args.shift();
							next = args.shift();
							//var str:String = uint(next).toString(10); // To prevent compiler warnings
							str = uint(next).toString(10);
							if (precision != "") {
								str = leftPad(str, int(precision), "0");
							}

							if (fieldWidth != "") {
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else if (flagZeroPad && precision == "") {
									str = leftPad(str, int(fieldWidth), "0");
								} else {
									str = leftPad(str, int(fieldWidth));
								}

							}
							result += str;
							break;

						case "X" :
							var capitalise:Boolean = true;
						case "x" :
							//var next:* = args.shift();
							next = args.shift();
							//var str:String = uint(next).toString(16);
							str = uint(next).toString(16);// To prevent compiler warnings

							if (precision != "") {
								str = leftPad(str, int(precision), "0");
							}

							var prepend:Boolean = flagAlternateForm && uint(next) != 0;

							if (fieldWidth != "" && !flagLeftJustify
							&& flagZeroPad && precision == "") {
								str = leftPad(str, prepend
								? int(fieldWidth) - 2 : int(fieldWidth), "0");
							}

							if (prepend) {
								str = "0x" + str;
							}

							if (fieldWidth != "") {
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else {
									str = leftPad(str, int(fieldWidth));
								}

							}
							if (capitalise) {
								str = str.toUpperCase();
							}

							result += str;
							break;

						case "f" :
						case "F" :
							//var next:* = args.shift();
							next = args.shift();
							//var str:String = Math.abs(Number(next)).toFixed(           // To prevent compiler warnings (RB)
							//precision != "" ?  int(precision) : 6);
							if ( precision == ""){
								str = (Math.abs(Number(next)).toFixed(6)).toString();
							} else if (int(precision) == 0){
								// No decimal places.
								str = Math.round(Math.abs(Number(next))).toString();  // Work around bug in AS3 toFixed(0)
							} else {
								str = Math.abs(Number(next)).toFixed(int(precision));
							}
							//str = Math.abs(Number(next)).toFixed(precision != "" ?  int(precision) : 6);

							//trace("In sprintf, next = "+next+", str = "+str);
							if (next < 0) {   // Was int(next) < 0 (RB)
								str = "-" + str;
							} else if (flagSign && next >= 0) {  // flagSign && int(next) 
								str = "+" + str;
							}
							//trace("  int(next) = "+int(next)+", then str = "+str);
							if (flagAlternateForm && str.indexOf(".") == -1) {
								str += ".";
							}
							if (fieldWidth != "") {
								//trace("flagZeroPad = "+flagZeroPad+", str = "+str+", precision = "+precision+", fieldWidth = "+fieldWidth);
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else if (flagZeroPad && precision == "") {
									str = leftPad(str, int(fieldWidth), "0");
								} else if (flagZeroPad && precision != "") {
									str = leftPad(str, int(fieldWidth), "0"); // Added by RB to make leading zeroes work
								} else {
									str = leftPad(str, int(fieldWidth));
								}
								//trace("Now str = "+str);
							}
							result += str;
							break;

						case "c" :
							//var next:* = args.shift();
							next = args.shift();
							// var str:String = String.fromCharCode(int(next));
							str = String.fromCharCode(int(next));// To prevent compiler warnings (RB)

							if (fieldWidth != "") {
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else {
									str = leftPad(str, int(fieldWidth));
								}

							}
							result += str;
							break;

						case "s" :
							//var next:* = args.shift();
							next = args.shift();
							//var str:String = String(next);
							str = String(next);// To prevent compiler warnings (RB)

							if (precision != "") {
								str = str.substring(0, int(precision));
							}

							if (fieldWidth != "") {
								if (flagLeftJustify) {
									str = rightPad(str, int(fieldWidth));
								} else {
									str = leftPad(str, int(fieldWidth));
								}

							}
							result += str;
							break;

						case "%" :
							result += "%";
					}
				} else {
					result += c;
				}
			}

			return result;
		}

		// Functions for sprintf3

		public static function leftPad(source:String, targetLength:int, padChar:String = " "):String {
			if (source.length < targetLength) {
				var padding:String = "";

				while (padding.length + source.length < targetLength) {
					padding += padChar;
				}

				return padding + source;
			}

			return source;
		}

		public static function rightPad(source:String, targetLength:int, padChar:String = " "):String {
			while (source.length < targetLength) {
				source += padChar;
			}

			return source;
		}

		
		//-------------------------------------------------------------
		public static function formatVector3D( n:int, p:int, v:Vector3D){
			var fmt:String = "%"+n+"."+p+"f";
			return ( "("+sprintf3(fmt, v.x) +", "+sprintf3(fmt, v.y) +", "+sprintf3(fmt, v.z)+")" );
		}
		public static function formatDecimals(a, n){
			// Form compatibility with old Util function.
			// Assume 8 total spaces with n decimal places.
			var fmt:String = "%8."+n+"f"
			return Util3.sprintf3(fmt, a)
		}
		public static function formatFraction( a, n ){
			// number, denominator)   e.g. 4.25 returns "4 3/12"
			var aa = Math.abs(a);
			var i = Math.floor(aa);
			var r = aa - i;
			var num = Math.round( r * n );
			if ( num == n ){
				num = 0;
				i+= 1;
			}
			
			var s = "";
			if ( i == 0 && r == 0){
				s = "0"
				return s;
			}
			// Non-zero:
			if (a< -(1/n) ){
				s += "-";
			}
			
			if ( num == 0 ){
				// No numerator
				s += i;
				return s;
			} 
			if ( i != 0 ){
				s += i +" ";
			}
			s +=  num + "/" + n;
			return s;

		}
		public static function roundToFraction( a, n ){
			return Math.round(a*n)/n;
		}
		public static function formatLatLong(... args){
			var val = args[0];
			var posdir = args[1];
			var P = args[2];
			var degstr = " deg";
			if (args.length >=4){
				degstr = args[3];
			}
			//Format a lat/long, P decimal places.  posdir = "N", "S", "E", "W" indicates positive sense
			var pos;
			if (sign(val)>0){
				pos = true;
			} else {
				pos = false;
			}
			var fmt = "%"+(P+4)+"."+P+"f"; // 359.123
			var a = sprintf3(fmt, Math.abs(val));
			//var a = formatFloat(Math.abs(val), 5, 1);
			
			switch (posdir){
				case "N":
					if (pos) { 
						return (a + degstr+" N");
					}else{
						return (a + degstr+" S");
					}
					break;
				case "S":
					if (pos) { 
						return (a + degstr+" S");
					}else{
						return (a + degstr+" N");
					}
					break;
				case "E":
					if (pos) { 
						return (a + degstr+" E");
					}else{
						return (a + degstr+" W");
					}
					break;
				case "W":
					if (pos) { 
						return (a + degstr+" W");
					}else{
						return (a + degstr+" E");
					}
					break;
				default:
					return "fmt err";
			}
		}
		public static function formatLatLong2(val, posdir, P){
			//Format a lat/long, P decimal places.  posdir = "N", "S", "E", "W" indicates positive sense
			var pos;
			if (sign(val)>0){
				pos = true;
			} else {
				pos = false;
			}
			var fmt = "%"+(P+4)+"."+P+"f"; // 359.123
			var a = sprintf3(fmt, Math.abs(val));
			//var a = formatFloat(Math.abs(val), 5, 1);
			
			switch (posdir){
				case "N":
					if (pos) { 
						return (a + "°N");
					}else{
						return (a + "°S");
					}
					break;
				case "S":
					if (pos) { 
						return (a + "°S");
					}else{
						return (a + "°N");
					}
					break;
				case "E":
					if (pos) { 
						return (a + "°E");
					}else{
						return (a + "°W");
					}
					break;
				case "W":
					if (pos) { 
						return (a + "°W");
					}else{
						return (a + "°E");
					}
					break;
				default:
					return "fmt err";
			}
		}
		public static function formatLatLongNospace(val, posdir, P){
			//Format a lat/long, P decimal places.  posdir = "N", "S", "E", "W" indicates positive sense
			var pos;
			if (sign(val)>0){
				pos = true;
			} else {
				pos = false;
			}
			var fmt = "%"+(P+4)+"."+P+"f"; // 359.123
			var a = sprintf3(fmt, Math.abs(val));
			//var a = formatFloat(Math.abs(val), 5, 1);
			
			switch (posdir){
				case "N":
					if (pos) { 
						return (a + "N");
					}else{
						return (a + "S");
					}
					break;
				case "S":
					if (pos) { 
						return (a + "S");
					}else{
						return (a + "N");
					}
					break;
				case "E":
					if (pos) { 
						return (a + "E");
					}else{
						return (a + "W");
					}
					break;
				case "W":
					if (pos) { 
						return (a + "W");
					}else{
						return (a + "E");
					}
					break;
				default:
					return "fmt err";
			}
		}		
		public static function formatLatLongLang(val:Number, posdir:String, P:int, lang:String){
			//Format a lat/long, P decimal places.  posdir = "N", "S", "E", "W" indicates positive sense
			var pos;
			if (sign(val)>0){
				pos = true;
			} else {
				pos = false;
			}
			var fmt = "%"+(P+4)+"."+P+"f"; // 359.123
			var a = sprintf3(fmt, Math.abs(val));
			//var a = formatFloat(Math.abs(val), 5, 1);
			
			var deg:String;
			var N:String;
			var S:String;
			var E:String;
			var W:String;
			
			switch (lang){
				case "es":
					N = "N"; S = "S"; E = "E"; W = "O";
					deg = "deg"
					break;
				case "pt":
					N = "N"; S = "S"; E = "L"; W = "W";
					deg = "graus"
					break;
				case "fr":
					N = "N"; S = "S"; E = "L"; W = "O";
					deg = "deg"
					break;
				case "en":
				default:
					N = "N"; S = "S"; E = "E"; W = "W";
					deg = "deg"
					break;
			}
			
			switch (posdir){
				case "N":
					if (pos) { 
						return (a + " "+deg+" "+ N);
					}else{
						return (a + " "+deg+" "+ S);
					}
					break;
				case "S":
					if (pos) { 
						return (a + " "+deg+" "+ S);
					}else{
						return (a + " "+deg+" "+ N);
					}
					break;
				case "E":
					if (pos) { 
						return (a + " "+deg+" "+ E);
					}else{
						return (a + " "+deg+" "+ W);
					}
					break;
				case "W":
					if (pos) { 
						return (a + " "+deg+" "+ W);
					}else{
						return (a + " "+deg+" "+ E);
					}
					break;
				default:
					return "ERROR in formatLatLongLang: invalid posdir = "+posdir;
			}
		}
		public static function formatFloat(a, n, p){
			// For backwards compatibility
			// Util3.sprintf3("%7.3f", a)
			var fmt = "%"+n+"."+p+"f";
			return sprintf3( fmt, a );
		}

		//--------------------------------------------------
		public static function W2dBm( x ) {
			// Converts Watts to dBm
			return 30 + 10 * Math.log(x) / Math.LN10;
		}
		public static function W2dBW( x ) {
			// Converts Watts to dBW
			return 10 * Math.log(x) / Math.LN10;
		}
		public static function dBW2W( x ) {
			// Converts dBW to Watts
			return Math.pow(10,x / 10);
		}
		public static function dBm2W( x ) {
			// Converts dBW to Watts
			return Math.pow(10, (x - 30) / 10);
		}
		public static function log10( x ) {
			// Base 10 log
			return Math.log(x) / Math.LN10;
		}
		public static function tenlog( x ) {
			// 10 x Base 10 log
			return 10*Math.log(x) / Math.LN10;
		}
		public static function log10a( x ) {
			// Base 10 log with large neg number for zero
			if (x == 0){
				return -99999;
			} else {
				return Math.log(x) / Math.LN10;
			}
		}
		public static function Vrms2dBm( Vrms, Z ){
			return (20*log10(Vrms) - 10*log10(Z) + 30);
		}
		public static function Vratio2dB( Vratio ){
			return (20*log10(Vratio) );
		}
		public static function dB2Vratio( dB ){
			return ( Math.pow(10, dB/20) );
		}
		
		public static function sumdBPowers( a:Array ){
			// Adds up all the members of the array in power, assuming that are in dB units.
			/// Returns a value in the same dB units.
			var Psum = 0;
			for (var i=0; i<a.length; i++){
				Psum +=  Math.pow(10,  (a[i] / 10) );
			}
			return (  10 * Math.log(Psum) / Math.LN10 );
		}
		public static function sum2CWsignals( p1dBx:Number, ph1deg:Number, p2dBx:Number, ph2deg:Number):Number{
			// Sums two CW signals both in dBx; returns power in dBx
			var v1 = dB2Vratio(p1dBx);
			var v1x = v1*Math.cos(radians(ph1deg));
			var v1y = v1*Math.sin(radians(ph1deg));
			var v2 = dB2Vratio(p2dBx);
			var v2x = v2*Math.cos(radians(ph2deg));
			var v2y = v2*Math.sin(radians(ph2deg));
			var vSumx = v1x + v2x;
			var vSumy = v1y + v2y;
			var vSum = Math.sqrt( vSumx*vSumx + vSumy*vSumy );
			return (  Vratio2dB( vSum ) );
			
		}

		public static function radians(deg) {
			return deg * Math.PI / 180;
		}
		public static function degrees(rad) {
			return rad * 180 / Math.PI;
		}
		public static function mod360(ang) {
			// Shifts angle in degrees to the range 0-360, even if negative.
			var b;
			b = ang%360;// This gets it in the range -360 to +360.
			if (b<0) {
				b += 360;
			}
			return b;
		}
		public static function mod2Pi(ang) {
			// Shifts angle in degrees to the range 0-2Pi, even if negative.
			var b;
			b = ang%(2*Math.PI);// This gets it in the range -2Pi to +2Pi.
			if (b<0) {
				b += 2*Math.PI;
			}
			return b;
		}
		public static function pm180(ang) {
			// Shifts angle in degrees to the range -180- +180, even if negative.
			var a = mod360(ang);
			if (a>180) {
				return a - 360;
			} else {
				return a;
			}
		}
		public static function modPos(j, k) {
			// Returns j modulo k, but j always >= 0.
			var b;
			b = j%k;// This gets it in the range -k to +k.
			if (b<0) {
				b += k;
			}
			return b;
		}
		public static function mod2pi(ang) {
			// Shifts angle in radians to the range 0-2*pi, even if negative.
			var b;
			b = ang%(2*Math.PI);// This gets it in the range -2pi to +2pi.
			if (b<0) {
				b += 2*Math.PI;
			}
			return b;
		}
		public static function diffAng(a1, a2){
			var aa1 = mod360(a1);
			var aa2 = mod360(a2);
			if (aa1 < aa2){
				aa1 += 360;
			}
			var d= pm180(aa1 - aa2);
			return d;
		}
		 public static function angleIsBetween(ang, min, max){
			// True if angle is between min and max
			var ret:Boolean;
			var a = mod360(ang);
			var b = mod360(min);
			var c = mod360(max);
			
			if (c<b){
				c += 360;
			}
			if ( a < b ){
				a += 360;
			}
			if ( a >= b && a<= c){
				ret = true;
			} else {
				ret = false;
			}
			return ret;
		 }
		public static function angIsGreater( a, b ){
			// Returns a > b, based on which side of the circle they are both on.
			var greater:Boolean;
			var a1:Number = a%360;
			var b1:Number = b%360;
			var c = Util3.pm180(a1 - b1);
			greater = (c>0);
			return greater;
		}
		public static function polDiffAng(a1, a2){
			/*
			var temp1 = a1%180;
			if (temp1 < 0 ){ temp1 += 180; };
			var temp2 = a2%180;
			if (temp2 < 0 ){ temp2 += 180; };
			var diff = temp1 - temp2;
			//trace("In polDiffAng, a1 = "+a1+", temp1 = "+temp1+", a2 = "+a2+", temp2 = "+temp2+", diff = "+diff);
			//return diff;
			*/
			// Fixed 8/29/2012 RB
			return polPM90(a1 - a2);
		}
		public static function polPM90(a){
			var temp1 = a%180;
			var retval = temp1;
			if (temp1 < -90 ){ retval = temp1 + 180; };
			if (temp1 > 90 ){ retval = temp1 - 180; };
			return retval;
		}
		public static function polPresetCaseNumber(polUplinkSense, ES_lat, targetAz){
			// Selects which diagram is the correct case in SP-REF-001, Rev 5
			var caseNo;
			if (polUplinkSense=="V"){
				if (  (ES_lat>= 0 && targetAz < 180) || (ES_lat< 0 && targetAz >= 270)  ){
					caseNo = 1;
				} else {
					caseNo = 2;
				}
			} else {
				if (  (ES_lat>= 0 && targetAz < 180) || (ES_lat< 0 && targetAz >= 270)  ){
					caseNo = 3;
				} else {
					caseNo = 4;
				}
			}
			return caseNo;
		}
		public static function polSettingResultMessage( ){
			//targetPolScale, actualPolScale, tolerance, feedSystemType, transmitVH
			// Scale here refers to the generic (Prodelin 1132) RFT cradle antenna feed pol scale
			// 0 deg = vertical transmit.
			// positive on scale = CW in reverse view, CCW in forward view
			// negative on scale = CCW in reverse view, CW in forward view
			/*
			
			scale param		Anubis			Andrew125
			0				0				0 on V mark, +/-90 on H mark		Vertical xmit
			+5				+5				-5 on V mark, +85 on H mark	
			-5				-5				+5 on V mark, -85 on H mark	
			90				90				+/-90 on V mark, 0 on H mark		Horiz xmit
			+95				+95				+85 on V mark, -5 on H mark	
			+85				+85				-85 on V mark, +5 on H mark	
			
			*/
			var nArgs = arguments.length;
			var targetPolScale = arguments[0];
			var actualPolScale = arguments[1];
			var tolerance = arguments[2];
			var feedSystemType = "ProdelinCradle"; // Default if not provided
			var reverseView = true;
			var viewDir:Number;  // +1 means looking into the reflector; -1 means looking towards satellite
			var transmitVH = "V";
			if (nArgs > 3){
				feedSystemType = arguments[3];
			}
			if (nArgs > 4){
				transmitVH = arguments[4];
			}
			if (reverseView){
				viewDir = 1;
			} else {
				viewDir = -1;
			}
			
			
			// Generates a text message assessing the accuracy of a polarization adjustment.
			var polError = Math.abs(polDiffAng(targetPolScale, actualPolScale)); //calcPolError(targetPolScale, ant_mc.antennaPolScale);
			// negative on scale = CCW; positive on scale = CW
			var resStr;
			switch (feedSystemType) {
				case "ProdelinCradle":

					resStr = "Pol preset: your setting is "+ Math.abs(Math.round(actualPolScale)) +" deg ";
					resStr += dir2text(viewDir*actualPolScale) +" ";
					
					resStr += "from vertical; ";
					// negative on scale = CCW; positive on scale = CW
					resStr += "should be "+ Math.abs(Math.round(targetPolScale)) +" deg ";
					resStr += dir2text(viewDir*targetPolScale) +" ";
					
					resStr += "(+/- "+Math.round(tolerance)+" deg). ";
					
					break;
				case "Andrew125":
					/* Should be rotated CW from horiz transmit so 17 deg is aligned with H mark."
					Your setting: rotated CCW from horiz transmit with 39 deg aligned with H mark."
					*/
					var rotCWFwdFromVH;
					var act:int;
					var targ:int;
					if (transmitVH == "V"){
						act = -Math.round(actualPolScale); //actual forward view rotation CW from V
						targ = -Math.round(targetPolScale);
					} else {
						act = -Math.round(actualPolScale+90); //actual forward view rotation CW from H
						targ = -Math.round(targetPolScale+90);
					}
					resStr = "Pol preset: should be rotated "+dir2text(targ)+" from "+transmitVH+" transmit so "+Math.abs(targ)+" is aligned with "+transmitVH+" mark. "
					resStr += "Your setting: rotated "+dir2text(act)+" from "+transmitVH+" transmit so "+Math.abs(act)+" is aligned with "+transmitVH+" mark. "
					break;
				case "RTRCradle":
					resStr = "Pol preset accurate? ";
					resStr += "Your setting is "+ sprintf3("%6.1f", actualPolScale) +" deg and ";
					resStr += "should be "+ sprintf3("%6.1f", targetPolScale) +" deg. ";
					resStr += "(+/- "+Math.round(tolerance)+" deg). ";
					
					break;
				default:
					resStr = "ERROR in polSettingResultMessage: invalid feedSystemType = "+feedSystemType;
					break;
			}
			if (polError <= tolerance){
				resStr += "PASS.";
			} else {
				resStr += "FAIL.";
			}
			return resStr;
		}
		public static function dir2text(dir){
			if (dir >= 0){
				return "CW";
			} else {
				return "CCW"
			}
		}
		public static function polSettingResultMessageHughes( targetPolScale, actualPolScale, tolerance){
			// Generates a text message assessing the accuracy of a polarization adjustment.
			var polError = Math.abs(polDiffAng(targetPolScale, actualPolScale)); //calcPolError(targetPolScale, ant_mc.antennaPolScale);
			var resStr = "Pol preset: your setting is "+ Math.round(actualPolScale) +" deg; ";
			resStr += "should be "+ Math.round(targetPolScale) +" deg ";
			resStr += "(+/- "+Math.round(tolerance)+" deg). ";
			
			if (polError <= tolerance){
				resStr += "PASS.";
			} else {
				resStr += "FAIL.";
			}
			return resStr;
		}
		public static function pointingAnglesTextFull(ES_long, ES_lat, sat_long, polDownlinkSense, azNom, elNom, polNom ){
			// Generates a detailed text message defining the satellite location, earth station location, and pointing angles.
			var txt = "Your location is "+ formatLatLong(ES_long, "E", 0)+
					", "+ Util3.formatLatLong(ES_lat, "N", 0) + "."+
					"\nThe satellite is at "+ Util3.formatLatLong(sat_long, "E", 0)+"."+
					"\nThe VSAT will use "+polDownlinkSense+" downlink polarization. " +
					"\nPointing angles from your look angle calculator:"+
					"\nTrue azimuth = "+azNom+", Elevation = "+elNom+", Pol = "+Math.round( Math.abs(polNom) );
			return txt;
		}
		
		public static function pointingAnglesTextFullHughes(ES_long, ES_lat, sat_long, polDownlinkSense, azNomMag, elNom, polNom ){
			// Generates a detailed text message defining the satellite location, earth station location, and pointing angles.
			var txt = "Your location is "+ formatLatLong(ES_long, "E", 0)+
					", "+ Util3.formatLatLong(ES_lat, "N", 0) + "."+
					"\nThe satellite is at "+ Util3.formatLatLong(sat_long, "E", 0)+"."+
					"\nThe VSAT will use "+polDownlinkSense+" downlink polarization. " +
					"\nValues from the IDU antenna pointing web page:"+
					"\nMagnetic azimuth = "+azNomMag+", Elevation = "+elNom+", Pol = "+Math.round( polNom );
			return txt;
		}
		public static function pointingAnglesTextShort(ES_long, ES_lat, sat_long, polDownlinkSense, azNom, elNom, polNom ){
			// Generates a short text message defining the satellite location, earth station location, and pointing angles.
			var txt = "VSAT at "+ formatLatLong(ES_long, "E", 0)+
					", "+ Util3.formatLatLong(ES_lat, "N", 0) + "; "+
					"sat pos "+ Util3.formatLatLong(sat_long, "E", 0)+"; "+
					"downlink pol: "+polDownlinkSense+"; "+
					"True az = "+azNom+", El = "+elNom+", Pol = "+Math.round( Math.abs(polNom) ) + ".";
			return txt;
		}
		public static function pointingAnglesTextShortRTR(ES_long, ES_lat, sat_long, polUplinkSense, az, el, pol ){
			// Generates a short text message defining the satellite location, earth station location, and pointing angles.
			var txt = "VSAT at "+ formatLatLong(ES_long, "E", 0)+
					", "+ Util3.formatLatLong(ES_lat, "N", 0) + ";\n"+
					"Sat pos "+ Util3.formatLatLong(sat_long, "E", 0)+"; "+
					"Uplink pol: "+polUplinkSense+";\n"+
					"iSite LAC: Az = "+Util3.sprintf3("%6.1f",az)+", El = "+Util3.sprintf3("%6.1f",el)+", Pol = "+Util3.sprintf3("%6.1f",pol)  + ".";
			return txt;
		}
		public static function pointingAnglesTextShortRTR2(ES_long, ES_lat, sat_long, polDownlinkSense, az, el, pol ){
			// Generates a short text message defining the satellite location, earth station location, and pointing angles.
			var txt = "VSAT at "+ formatLatLong(ES_long, "E", 0)+
					", "+ Util3.formatLatLong(ES_lat, "N", 0) + ";\n"+
					"Sat pos "+ Util3.formatLatLong(sat_long, "E", 0)+"; "+
					"Downlink pol: "+polDownlinkSense+";\n"+
					"iSite LAC: Az = "+Util3.sprintf3("%6.1f",az)+", El = "+Util3.sprintf3("%6.1f",el)+", Pol = "+Util3.sprintf3("%6.1f",pol)  + ".";
			return txt;
		}
		public static function pointingAnglesTextShortHughes(ES_long, ES_lat, sat_long, polDownlinkSense, azNomMag, elNom, polNom ){
			// Generates a short text message defining the satellite location, earth station location, and pointing angles.
			var txt = "VSAT at "+ formatLatLong(ES_long, "E", 0)+
					", "+ Util3.formatLatLong(ES_lat, "N", 0) + "; "+
					"sat pos "+ Util3.formatLatLong(sat_long, "E", 0)+"; "+
					"downlink pol: "+polDownlinkSense+"; "+
					"Mag az = "+azNomMag+", El = "+elNom+", Pol = "+Math.round( polNom ) + ".";
			return txt;
		}

		public static function pointingErrorText( errorAngle, tolerancePass, toleranceExcellent, units, az, el){
			// Generates a text message assessing the accuracy of a dish fine pointing adjustment.
			//var txt = "Your pointing settings: az = "+Math.round(az)+", el = "+Math.round(el);
			var txt = "\nPointing error: ";
			txt += "Specification: "+Util3.sprintf3("%6.2f", Math.abs(tolerancePass) ) + " "+units+" max; ";
			txt += "your result: "+Util3.sprintf3("%6.2f", Math.abs(errorAngle) ) + " "+units+": ";
			
			if ( Math.abs(errorAngle) >  Math.abs(tolerancePass)){
				txt += "FAIL.";
			} else if (Math.abs(errorAngle) >  Math.abs(toleranceExcellent) ){
				txt += "PASS.";
			} else {
				txt += "EXCELLENT!";
			}
			return txt;
		}
		
		public static function findAndPeakErrorText( CNActual, CNSpecification, pointingLossActual, pointingLossSpecification, az, el){
			// Generates a text message assessing coarse dish pointing accuracy.
			var txt = ""; //Your pointing settings: Az = "+Math.round(az)+", El = "+Math.round(el)+".\n";
			
			if ( CNActual < CNSpecification){
				txt += "Correct satellite not found on meter.  FAIL.";
			} else {
				if ( Math.abs(pointingLossActual) > Math.abs( pointingLossSpecification ) ){
					txt += "You adjusted az and el to get "+ Util3.sprintf3("%5.1f",Math.abs(pointingLossActual))+" dB from true peak.  "+
						"You should be able to get within "+ Util3.sprintf3("%5.1f",Math.abs( pointingLossSpecification ))+" dB.  FAIL."
				} else {
					txt += "You adjusted az and el to get "+ Util3.sprintf3("%5.1f",Math.abs(pointingLossActual))+" dB from true peak.  "+
						"You should be able to get within "+ Util3.sprintf3("%5.1f",Math.abs( pointingLossSpecification ))+" dB.  PASS."
				}
			}
			return txt;
		}
		public static function findAndPeakErrorTextHughes( SQFActual, SQFSpecification, SQFThreshold){
			// Generates a text message assessing coarse dish pointing accuracy.
			var txt = ""; //Your pointing settings: Az = "+Math.round(az)+", El = "+Math.round(el)+".\n";
			//trace("In findAndPeakErrorTextHughes: SQFActual = "+SQFActual+", SQFSpecification = "+SQFSpecification+", SQFThreshold = "+SQFThreshold);
			if ( SQFActual < SQFThreshold){
				txt += "Correct satellite not found (SQF less than 30).  FAIL.";
			} else {
				if ( SQFActual < SQFSpecification ){
					txt += "You adjusted az and el to get an SQF reading of "+ Math.round(SQFActual)+".  "+
						"In this example you should be able to get an SQF of at least "+ Math.round(SQFSpecification)+".  FAIL."
				} else {
					txt += "You adjusted az and el to get an SQF reading of "+ Math.round(SQFActual)+".  "+
						"In this example you should be able to get an SQF of at least "+ Math.round(SQFSpecification)+".  PASS."
				}
			}
			return txt;
		}
		public static function findAndPeakErrorTextSkyEdge( rxLock, LCDValue, LCDValueSpecification){
			// Generates a text message assessing coarse dish pointing accuracy.
			var txt = ""; //Your pointing settings: Az = "+Math.round(az)+", El = "+Math.round(el)+".\n";
			//trace("In findAndPeakErrorTextHughes: SQFActual = "+SQFActual+", SQFSpecification = "+SQFSpecification+", SQFThreshold = "+SQFThreshold);
			if ( !rxLock){
				txt += "Correct satellite not found (greed LED is off).  FAIL.";
			} else {
				if ( LCDValue < LCDValueSpecification ){
					txt += "You adjusted az and el to get a reading of "+ Math.round(LCDValue)+".  "+
						"In this example you should be able to get a reading of at least "+ Math.round(LCDValueSpecification)+".  FAIL."
				} else {
					txt += "You adjusted az and el to ge ta reading of "+ Math.round(LCDValue)+".  "+
						"In this example you should be able to get a reading of at least "+ Math.round(LCDValueSpecification)+".  PASS."
				}
			}
			return txt;
		}
		public static function findAndPeakErrorTextRTR( Vactual, pointingLossdBActual, pointingLossdBSpecification){
			// Generates a text message assessing coarse dish pointing accuracy.
			// Losses must be positive!!
			var txt = ""; //Your pointing settings: Az = "+Math.round(az)+", El = "+Math.round(el)+".\n";
			var Vpeak = Vactual + pointingLossdBActual/2;
			var Vspec = Vpeak - pointingLossdBSpecification/2;
			txt += "Correct satellite found? ";
			if ( Vactual < 12){
				txt += "No.  FAIL.";
			} else {
				txt += "Yes.  PASS.";
			}
			txt += "\n";
			txt += "Pointed carefully? ";
			if ( Vactual < 12){
				txt += "No.  Satellite not found. FAIL.";
			} else {
				if ( Math.abs(pointingLossdBActual) > Math.abs( pointingLossdBSpecification ) ){
					txt += "No. Your DVM reading was only "+Util3.sprintf3("%5.1f",Vactual)+
					"V. You should be able to peak az and el for at least "+  Util3.sprintf3("%5.1f",Vspec) +"V.  FAIL."
				} else {
					txt += "Yes. You peaked the signal within "+Util3.sprintf3("%5.1f",(Vpeak-Vspec))+"V of maximum.  PASS."
				}
			}
			trace("In findAndPeakErrorTextRTR: Vactual = "+Vactual+", pointingLossdBActual = "+pointingLossdBActual+
				  ", pointingLossdBSpecification = "+pointingLossdBSpecification+ ", Vpeak = "+Vpeak+
				  ", Vspec = "+Vspec+", txt = "+txt);
			
			return txt;
		}
		

		public static function sDigitalClock(secs){
			//Returns a string with the time in hh:mm:ss format.  Input in seconds
			var hrs = secs /( 60 * 60 );
			var time = hrs - 24* Math.floor( hrs/24);
			var hours =  Math.floor(time);
			var h:String =  formatIntegerWithZeros( hours, 2);
			var minutes = Math.floor( 60*(time - hours));
			var m:String = formatIntegerWithZeros( minutes, 2);
			var seconds = Math.floor( 60*60*(time - hours - minutes/60));
			var s:String = formatIntegerWithZeros(seconds, 2);
			//trace(time+" = "+ hours+" : "+  minutes+" : "+ seconds);
			return h+":"+m+":"+s;
		}
		public static function sDigitalClockHMS1(secs){
			//Returns a string with the time in hh:mm:ss.s format.  Input in seconds
			var hrs = secs /( 60 * 60 );
			var time = hrs - 24* Math.floor( hrs/24);
			var hours =  Math.floor(time);
			var h:String =  formatIntegerWithZeros( hours, 2);
			var minutes = Math.floor( 60*(time - hours));
			var m:String = formatIntegerWithZeros( minutes, 2);
			var seconds = Math.floor( 60*60*(time - hours - minutes/60));
			var s:String = formatIntegerWithZeros(seconds, 2);
			var d:String = int(Math.floor(10 * (secs % 1))).toString();
			//trace(time+" = "+ hours+" : "+  minutes+" : "+ seconds);
			return h+":"+m+":"+s+"."+d;
		}		
		public static function sDigitalClockHM(secs){
			//Returns a string with the time in hh:mm format.  Input in seconds
			var hrs = secs /( 60 * 60 );
			var time = hrs - 24* Math.floor( hrs/24);
			var hours =  Math.floor(time);
			var h:String =  formatIntegerWithZeros( hours, 2);
			var minutes = Math.floor( 60*(time - hours));
			var m:String = formatIntegerWithZeros( minutes, 2);
			//trace(time+" = "+ hours+" : "+  minutes+" : "+ seconds);
			return h+":"+m;

		}
		
		public static function formatIntegerWithZeros(num, digits) {
			//format a number as an integer with leading zeros and a specified number total digits
			//  12, 4 -> 0012
			//  12, 3 ->  012
			//  12, 2 ->   12
			//  12, 1 ->   12
		
        	//if no decimal places needed, we're done
        	if (digits <= 0) {
       	         return Math.round(num); 
       		} 
			var n = Math.floor(num);
        	//round the number to specified decimal places
        	//e.g. 12.3456 to 3 digits (12.346) -> mult. by 1000, round, div. by 1000
			var s = String(n);		
			if (n < Math.pow(10, digits-1) ){
				s = String(n);
				for (var p=1; p<=digits-1; p++){
					if ( n < Math.pow(10, p)){
						s = "0"+s;
					}
				}
			}
			return s;
		}
		public static function parseCSVLine( line:String ){
		/*
		Parses a string in Excel CSV format to an array of strings
		RB 6/25/07
		Input:
   		line      string in CSV format
		Returns an array of strings.
		CSV format rules:
  			1. All fields are separated by commas.
  			2. A field may have any number of internal spaces which are preserved.
  			3. A field may be surrounded by doublequotes, in which case the literal contents 
    		are returned, except that a two doublequotes inside a field surrounded 
			by doublequotes is interpreted as one doublequote.
			4. No space is allowed between the ending quote of the previous field and the comma separator

		Example:
 			aa,"b,b","""Hello""","""""","aa""bb",Next cell is empty,,12,A space,Two  spaces,"Two commas ,,","xx,""","yy,""y"
		Returns (underscore indicates a space):
 			aa
 			b,b
 			"Hello"
 			""
 			Next_cell_is_empty
 			<null>
 			12
 			A_space
 			Two__spaces
 			Two_commas_,,
			xx,"
			yy,"y"
		*/

			var N = line.length; // Last character
			var fields:Array = new Array();
			var f = 0; // Field counter
			var ch;
			var ch1;
			var state;
	
			// Initialize.
			var p = 0;
			fields[f] = "";
			ch = line.charAt(p);
			if ( ch == "," ){
				state = "inSeparator";
				p++;
			}else if ( ch == '"' ){
				state = "inQuotedField";
				p++;
			}else {
				// Assume we are starting the first field.
				fields[f] = ch;
				p++;
				state = "inSimpleField";
			}
	
			do { 
				ch = line.charAt(p);
				if ( state == "inSimpleField"){
					if ( ch == ","){
						p++;
						state = "inSeparator";
					}else{ 
						// We are still within the field.
						fields[f] = fields[f] + ch;
						p++;
					}
				} else if ( state == "inSeparator" ){
					if ( ch == '"'){
						// Entering a quoted field
						p++;
						f++; // Start a new field
						fields[f] = "";
						state = "inQuotedField";
					} else if ( ch == ",") {
						// Another comma means an empty field; we are still in the separator though.
						f++; // Start a new field
						fields[f] = "";
						p++
					} else {
						// Assume we are starting the next field.
						f++; // Start a new field
						fields[f] = ch;
						p++;
						state = "inSimpleField";
					}
				} else if ( state == "inQuotedField" ){
					if ( p >= line.length-1) {
						// This is the last character.
						fields[f] = fields[f] + ch;
						p++;
					} else {
						// We are not at the end yet.
						ch1 = line.charAt(p+1);
						if ( ch == '"' && ch1 == '"') {
							// Double dquote.
							fields[f] = fields[f] + '"';
							p += 2; // Skip over the second one.
						} else if ( ch == '"' && ch1 == ',') {
							// This is the end of the field.
							p += 2; // Skip over the comma
							state = "inSeparator";
						} else {
							// We are still within the field.
							fields[f] = fields[f] + ch;
							p++;
						}
					}
				}
			} while ( p < N);
		
			return fields
		}
	
	
		public static function rotateAxesX( aPoint:Array, rotAngleRad:Number ){
			/* Rotates axes (frame of reference).
			Converts a point in 3-space to a new frame of reference, where the frame is rotated around the x axis by rotAngleRad

			% Inputs:  aPoint   array containing x, y, z value of point in the starting frame.
			%          rotAngleRad: rotation angle in radians
			% Output: array containing x, y, z value of point in the ending frame of reference.

			% Rotation sense:
			%
			%     z
			%     |    y
			%     |   /
			%     |  /
			%     | /
			%     |/________ x
			%
			% A positive axis rotation is defined as counterclockwise when looking at
			% the origin along the axis of rotation.

			Original Matlab code:
			ax = rot_vector(1);
			ay = rot_vector(2);
			az = rot_vector(3);
			Rx = [1 0 0 ; 0 cos(ax) sin(ax); 0 -sin(ax) cos(ax) ];
			Ry = [cos(ay) 0 -sin(ay); 0 1 0 ; sin(ay) 0 cos(ay) ];
			Rz = [cos(az) sin(az) 0; -sin(az) cos(az) 0; 0 0 1];

			p = Rx * pin';
			p = Ry * p;
			p = Rz * p;
			pout = p';
			*/
			
			/* Rotate around x by ax radians:
			[ qX ]     [ 1     0       0    ] [ pX ]
			[ qY ]  =  [ 0  cos(ax) sin(ax) ] [ pY ]
			[ qZ ]     [ 0 -sin(ax) cos(ax) ] [ pZ ]
			*/
			
			var q:Array = new Array(3);
			q[0] =  aPoint[0];
			q[1] = aPoint[1] * Math.cos(rotAngleRad) + aPoint[2] * Math.sin(rotAngleRad);
			q[2] = -aPoint[1] * Math.sin(rotAngleRad) + aPoint[2] * Math.cos(rotAngleRad);
			return q;
		}
	
		public static function rotateAxesY( aPoint:Array, rotAngleRad:Number ){
			/* See comments for rotateAxesX()
			Rotate frame of refrence around y by ay radians:
			[ qX ]     [ cos(ay)     0  -sin(ay) ] [ pX ]
			[ qY ]  =  [    0        1      0    ] [ pY ]
			[ qZ ]     [ sin(ay)     0   cos(ay) ] [ pZ ]
			*/
			var q:Array = new Array(3);
			q[0] = aPoint[0] * Math.cos(rotAngleRad) + -aPoint[2] * Math.sin(rotAngleRad);
			q[1] = aPoint[1];
			q[2] = aPoint[0] * Math.sin(rotAngleRad) + aPoint[2] * Math.cos(rotAngleRad);
			
			return q;
		}
		
		public static function rotateAxesZ( aPoint:Array, rotAngleRad:Number ){
			/* See comments for rotateAxesX()
			Rotate frame of refrence around z by az radians:
			
			[ qX ]     [ cos(az)  sin(az)  0  ] [ pX ]
			[ qY ]  =  [-sin(az)  cos(az)  0  ] [ pY ]
			[ qZ ]     [    0         0    1  ] [ pZ ]
			*/
			var q:Array = new Array(3);
			q[0] = aPoint[0] * Math.cos(rotAngleRad) + aPoint[1] * Math.sin(rotAngleRad);
			q[1] = -aPoint[0] * Math.sin(rotAngleRad) + aPoint[1] * Math.cos(rotAngleRad);
			q[2] = aPoint[2];
			
			return q;
		}
		
		public static function dotProduct( a:Array, b:Array ){
			// Computes the dot product of two vectors a and b.
			// Returns a number value.
			
			var d:Number;
			d = a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
			return d;
		}

		public static function crossProduct( a:Array, b:Array ){
			// Computes the cross product of two vectors a and b.
			// Returns an array containing the x, y, z components.
			var c:Array = new Array(3);
			c[0] = a[1]*b[2] - a[2]*b[1];
			c[1] = a[2]*b[0] - a[0]*b[2];
			c[2] = a[0]*b[1] - a[1]*b[0];
			return c;
		}
		public static function cart2azel(xyz:Vector3D):Vector3D{
			// Converts cartesian coordinates to spherical az/el
			// Assumes Z is north, X is west, Y is up to zenith
			// Returns vector containing az in deg (+/- 180), el in deg, and radius in same units as x-y-z
			var r:Number = Math.sqrt(xyz.x*xyz.x + xyz.y*xyz.y + xyz.z*xyz.z);
			var elDeg:Number = Util3.degrees(Math.asin(xyz.y/r));
			var azDeg:Number = Util3.degrees(Math.atan2(-xyz.x,xyz.z));
			return new Vector3D(azDeg, elDeg, r);
		}
		public static function azel2cart(aer:Vector3D):Vector3D{
			// Converts spherical az/el to cartesian coordinates
			// Assumes Z is north, X is west, Y is up to zenith
			// Input: az, el in degrees, radius in any units.
			var azDeg:Number = aer.x;
			var elDeg:Number = aer.y;
			var r:Number = aer.z;
			var yy:Number = r*Math.sin(Util3.radians(elDeg));
			var r2 = r*Math.cos(Util3.radians(elDeg));
			var xx = r2*Math.sin( Util3.radians(-azDeg));
			var zz = r2*Math.cos( Util3.radians(-azDeg));
			return new Vector3D(xx, yy, zz);
		}
		
		public static function sph2cart( rtp:Array ):Array	{
			// Spherical to cartesian coordinate conversion.
			// Follows Matlab convention for angles.
			// Input: array containing r, theta, phi
			// Returns: array containing x, y, z
			var xyz:Array = new Array(3)
			var r = rtp[0];
			var theta = rtp[1];
			var phi = rtp[2];
			xyz[0] = r * Math.cos(phi) * Math.cos(theta); // x
			xyz[1]= r * Math.cos(phi) * Math.sin(theta); // y
			xyz[2]= r * Math.sin(phi); //z
			return xyz;
		}
		public static function sph2cartV( rtp:Vector3D ):Vector3D	{
			// Spherical to cartesian coordinate conversion using vectors to hold values
			// Follows Matlab convention for angles.
			// Input: array containing r, theta, phi
			// Returns: array containing x, y, z
			var xyz:Vector3D = new Vector3D();
			var r = rtp.x;
			var theta = rtp.y;
			var phi = rtp.z;
			xyz.x = r * Math.cos(phi) * Math.cos(theta); // x
			xyz.y= r * Math.cos(phi) * Math.sin(theta); // y
			xyz.z= r * Math.sin(phi); //z
			return xyz;
		}

		public static function cart2sph( xyz:Array ):Array	{
			// Cartesian to spherical coordinate conversion.
			// Follows Matlab convention for angles.
			// Input:  array containing x, y, z
			// Returns: array containing r, theta, phi
			var rtp:Array = new Array(3)
			var x = xyz[0];
			var y = xyz[1];
			var z = xyz[2];
			
			rtp[1] = Math.atan2(y, x); // theta
			rtp[2] = Math.atan2(z, Math.sqrt(x*x + y*y)  ); // phi
			rtp[0] = Math.sqrt( x*x + y*y + z*z ); // r
			return rtp;
		}
   
		public static function rampWave( t:Number, ramptime:Number, vBottom:Number, vTop:Number, repeating:Boolean ):Number {
			var tNorm;  // Normalize time to 0-1
			var v;
			if ( (t >= ramptime) && (!repeating) ){
				v = vTop;
				//trace("In Util3.rampWave, t = "+t+", ramptime = "+ramptime+", t >= ramptime, v = "+v);
			} else {
				tNorm = (t%ramptime)/ramptime;
				
				if ( tNorm < 0 ){
					v = vBottom;
				} else if (tNorm < 1){
					v = vBottom + (vTop-vBottom)*tNorm;
				} else {
					v = vTop;
				}
				//trace("In Util3.rampWave, tNorm = "+tNorm+", v = "+v);
			}
			return v;
			
		}
		public static function rampDwell( t:Number, ramptime:Number, dwelltime:Number, vBottom:Number, vTop:Number, repeating:Boolean ):Number {
			var tNorm;  // Normalize time to 0-1
			var v;
			var T = ramptime + dwelltime;
			tNorm = (t%T)/T;
			
			if ( (t >= T) && (!repeating) ){
				// End of cycle and not repeating
				v = vTop;
			} else {
				
				if ( tNorm < 0 ){
					v = vBottom;
				} else if (tNorm < ramptime/T){
					v = vBottom + (vTop-vBottom)*tNorm/(ramptime/T);
				} else {
					v = vTop;
				}
			}
			//trace("t = "+t+", tNorm = "+tNorm+", v = "+v);
			return v;
			
		}
		public static function rampWaveN( t:Number, ramptimeList:Array, pointList:Array, repeating:Boolean ):Number {
			var tNorm;  // Normalize time to 0-1
			var v, t1;
			var nSegments = ramptimeList.length - 1;
			var i;
			var iSeg = -1;
			var endTime = ramptimeList[ramptimeList.length-1];
			var ramptime;
			//trace("nSegments = "+nSegments+", endTime = "+endTime);
			t1  = (t%endTime); // Time since start of this cycle
			
			for (i = 0; i <nSegments; i++){
				// Find which segment we are in
				if ( t1 >= ramptimeList[i] && t1<= ramptimeList[i+1]){
					iSeg = i;
					break;
				}
			}
			if (t <= 0){
				return pointList[0];
			}
			if ( t >= endTime  && (!repeating) ) {
				return  pointList[nSegments];
			}
			
			ramptime = ramptimeList[iSeg+1] - ramptimeList[iSeg];
			var tInRamp = t1 - ramptimeList[iSeg];
			
			tNorm = (tInRamp % ramptime)/ramptime;
			var vBottom = pointList[iSeg];
			var vTop = pointList[iSeg+1];
			
			if ( tNorm < 0 ){
				v = vBottom;
			} else if (tNorm < 1){
				v = vBottom + (vTop-vBottom)*tNorm;
			} else {
				v = vTop;
			}
			//trace("t = "+t+", t1 = "+t1+", iSeg = "+iSeg+", tNorm = "+tNorm+", v = "+v);
			return v;
			
		}
		public static function sineWave( t:Number, period:Number, vAmpl:Number, vAvg:Number, repeating:Boolean  ):Number {
			var phase;
			var v;
			if ( (t >= period) && (!repeating) ){
				v = vAvg;
			} else {
				phase = 2*Math.PI*(t%period)/period;
				v = vAvg + vAmpl*Math.sin( phase );
			}
			return v;
		
		}
		public static function triangleWave(  t:Number, period:Number, vAmpl:Number, vAvg:Number, repeating:Boolean  ):Number {
			var phase;
			var v;
			if ( (t >= period) && (!repeating) ){
				v = vAvg;
			} else {
				phase = 360*(t%period)/period;
				if ( phase <90 ){
					v = vAvg + vAmpl*(phase/90);
				} else if (phase < 180){
					v = vAvg + vAmpl*(180-phase)/90;
				} else if (phase < 270){
					v = vAvg - vAmpl*(phase-180)/90;
				} else {
					v = vAvg - vAmpl*(360-phase)/90;
				}
			}
			return v;
		}
		public static function triangleWave2(  t:Number, period:Number, vBottom:Number, vTop:Number, repeating:Boolean  ):Number {
			//return triangleWave(  t, period, (vTop - vBottom)/2, (vTop + vBottom)/2, repeating  );
			var phase;
			var v;
			var vpp = vTop - vBottom;
			if ( (t >= period) && (!repeating) ){
				v = vBottom;
			} else {
				phase = 360*(t%period)/period;
				if ( phase <180 ){
					v = vBottom + vpp*(phase/180);
				} else {
					v = vBottom + vpp*(360-phase)/180; // ph = 181, 
				}
			}
			return v;
		}
		public static function triangleWave2Dwell( t:Number, period:Number, dwelltime:Number, vBottom:Number, vTop:Number, repeating:Boolean ):Number {
			var tNorm:Number;  // Normalize time to 0-1
			var v:Number;
			if (repeating){
				tNorm = (t%period)/period;
			} else {
				tNorm = t / period;
			}
			
			var tN2:Number = 1 - dwelltime/period;
			var tN1:Number = tN2/2;
			
			if ( tNorm >= 0 && tNorm< tN1 ){
				v =  vBottom + ( tNorm/tN1 )*(vTop - vBottom);
			} else if ( tNorm >= tN1 && tNorm < tN2 ){
				v =  vBottom + ( 1 - (tNorm - tN1)/(tN2-tN1) )*(vTop - vBottom);
			} else {
				v = vBottom;
			}
			//trace("t = "+t+", tNorm = "+tNorm+", tN1 = "+tN1+", tN2 = "+tN2+", vBottom = "+vBottom+", vTop = "+vTop+", v = "+v);
			return v;
			
		}
		public static function squareWave(  t:Number, period:Number, vAmpl:Number, vAvg:Number, repeating:Boolean  ):Number {
			var phase;
			var v;
			if ( (t >= period) && (!repeating) ){
				v = vAvg;
			} else {
				phase = 360*(t%period)/period;
				if ( phase < 180){
					v = vAvg - vAmpl;
				} else {
					v = vAvg + vAmpl;
				}
			}
			return v;
		}
		
		public static function antennaPattern2(angle_deg, widthAcrossArc_m, freq_MHz, gOnAxisdB, sidelobeLeveldB, k3:Number=70, k20:Number=150, kNull:Number=165, c:Number=-0.5){
			
			
			var sl:Number = -Math.abs(sidelobeLeveldB);
			var lambda:Number = 300/freq_MHz;
			var dL:Number = widthAcrossArc_m/lambda;
			var HBWnull:Number = 0.5* kNull / dL;
			var a = Math.abs(pm180(angle_deg));
			var xx = a/HBWnull;
			var h = 1/(1-xx) - 1;
			var xx3 = k3/kNull;
			var xx20 = k20/kNull;
			//var c = -0.5;
			var h3 = 1/(1-xx3) - 1;
			var h20 = 1/(1-xx20) - 1;
			var yy3 = -3;
			var yy20 = -20;
			var bb = Math.log( (yy3-c*h3) / (yy20 - c*h20) ) / Math.log(xx3/xx20);
			var aa = (yy3 - c*h3)/ Math.pow(xx3, bb);
			var theta = xx * Math.PI/2;
			var gAbs:Number;
			var gRel:Number;
			var zone:int;
			var HBW3:Number = 0.5* k3 / dL;
			var HBW20:Number = 0.5* k20 / dL;
			//trace("HBW3 = "+HBW3+", HBW20 = "+HBW20+", HBWnull = "+HBWnull);
				 
			var g580;
			if (xx == 0) {
				gAbs = gOnAxisdB;
				zone = 0;
			} else if (xx < 1) {
				// Main lobe
				gRel = c*h + aa*Math.pow(xx, bb);
   				gAbs = gRel + gOnAxisdB;
				zone = 1;
			} else if ( (theta >= Math.PI / 2) && (theta < Math.PI) ){
				// First sidelobe
				//   up to a = 2*a3*ana3
    			gRel = 20 * log10(Math.abs(Math.sin(2 * theta))) + sl;
    			gAbs = gRel + gOnAxisdB;
				zone = 2;
			} else if (theta >= Math.PI) {
					// Remaining sidelobes
				if (a <= 20) {
					g580 = 29 - 25 * log10(a);
				} else if (a > 20 && a <= 26.5) {
					g580 = -3.5;
				} else if (a > 26.5 && a <= 48) {
					g580 = 32 - 25 * log10(a);
				} else {
					g580 = -10;
				}
            	gAbs = 20 * log10( Math.abs(Math.sin(2 * theta))) + g580 - 2;
				gRel = gAbs - gOnAxisdB;
				zone = 3;
			}
				//trace("In antennaPattern, zone = "+zone+", a = "+a+", x/Pi = "+(x/Math.PI)+", gAbs = "+gAbs);
			//trace("Calculated gAbs = "+gAbs);
			if (gRel > 0){
				//trace("Problem???");
			}
			return gAbs;			
		}
	public static function pointing_errorBeamBalance2( L, E, widthAcrossArc_m, freq_MHz, k3, k20, kNull, c){
		// L = pointing loss to ref level; E = meter error 
		// L must be >0
		// E must be >0
		var a1 = Util3.antennaPattern2inverse( -(L+E), widthAcrossArc_m, freq_MHz, 0, k3, k20, kNull, -0.5); //Right side
		var a2 = -Util3.antennaPattern2inverse( -(L-E), widthAcrossArc_m, freq_MHz, 0, k3, k20, kNull, -0.5); // Left side

		var errAng = (a1+a2)/2;
		return errAng;
	}
		
		public static function antennaPattern2inverse(mainBeamGain, widthAcrossArc_m, freq_MHz, gOnAxisdB, k3:Number=70, k20:Number=150, kNull:Number=165, c:Number=-0.5){
			var angle_deg = 0;
			var sidelobeLeveldB = -20;
			var lambda:Number = 300/freq_MHz;
			var dL:Number = widthAcrossArc_m/lambda;
			var HBWnull:Number = 0.5* kNull / dL;
			var HBW3 = 0.5* k3 / dL;
			var a1= HBW3*Math.sqrt( (gOnAxisdB - mainBeamGain)/3 );
			var a2= Math.max(a1*1.2, HBWnull);
			var done = false;
			var retVal;
			var aNew:Number;
			var err:Number;
			var g1:Number, g2:Number, gNew:Number;
			var tol:Number = 0.001;
			var i:int = 0;
			do {
				g1 = antennaPattern2(a1, widthAcrossArc_m, freq_MHz, gOnAxisdB, sidelobeLeveldB, k3, k20, kNull, c);
				err = Math.abs(g1 -  mainBeamGain);
				if (err <= tol){
					done = true;
					retVal = a1;
					//trace("Iter "+i+": Target = "+mainBeamGain+", a1 = "+a1+", g1 = "+g1+", err = "+err);
				} else {
					g2 = antennaPattern2(a2, widthAcrossArc_m, freq_MHz, gOnAxisdB, sidelobeLeveldB, k3, k20, kNull, c);
					//trace("Iter "+i+": Target = "+mainBeamGain+", a1 = "+a1+", g1 = "+g1+", a2 = "+a2+", g2 = "+g2+", err = "+err);
					aNew = a1 + (a2-a1)*(mainBeamGain-g1)/(g2-g1);
					gNew = antennaPattern2(aNew, widthAcrossArc_m, freq_MHz, gOnAxisdB, sidelobeLeveldB, k3, k20, kNull, c);
					err =  Math.abs(gNew - mainBeamGain);
					if (err <= tol){
						done = true;
						retVal = aNew;
					} else {
						a2 = a1;
						a1 = aNew;
					}
				}
				i++;
				if (i > 100){
					trace("Error in Util3.antennaPattern2inverse: FAILED TO CONVERGE AFTER 100 ITERATIONS:");
					trace("     Iter "+i+": Target = "+mainBeamGain+", a1 = "+a1+", g1 = "+g1+", a2 = "+a2+", g2 = "+g2+", err = "+err);
					done = true;
				}
			} while (!done);
			return retVal;
		}

		public static function antennaPattern(angle_deg, dia_m, freq_MHz, eff, sidelobeLeveldB, type){
			/*
			Synthesizes a typical parabolic antenna gain pattern.
			angleDeg:  Angle off axis in degrees
			dia: Antenna diameter in meters
			efficiency: Antenna aperture efficiency (0 - 1)
			sidelobeLevel: Relative level of first sidelobe in dB, e.g. -18
			type:  "parabolic"  Uses parabolic main beam shape only.
		       	"sinXoverX"  Uses a simple sinX/X approximation
			   	"synth"      Synthesizes pattern using Brooker approximation
			*/
			//var fGHz = freq_MHz / 1000;
			var gOnAxisdB = antGaindB( dia_m, freq_MHz, eff ); //20 * log10(Math.PI * dia_m * Math.sqrt(eff) * fGHz / 0.3);
			var a3 = antBeamwidth( dia_m, freq_MHz, eff );// 3 dB half bandwidth
			var sl:Number = -Math.abs(sidelobeLeveldB);
			return antennaPatternFromHBW( angle_deg, a3, gOnAxisdB, sl, type );
		}
		
		public static function antennaPatternFromHBW( angle_deg, HalfBW3dB, gOnAxisdB, sidelobeLeveldB, type ){
			/*
			Synthesizes a typical parabolic antenna gain pattern.
			angleDeg:  Angle off axis in degrees
			sidelobeLevel: Relative level of first sidelobe in dB, e.g. -18
			type:  "parabolic"  Uses parabolic main beam shape only.
		       	"sinXoverX"  Uses a simple sinX/X approximation
			   	"synth"      Synthesizes pattern using Brooker approximation
			*/
			//var fGHz = freq_MHz / 1000;
			var a = Math.abs(pm180(angle_deg));
			var gAbs = 0;
			var gRel;
			var a3 = HalfBW3dB;
		
			if (type == "synth"){
				//var a3 = (4.53 / (dia_m * fGHz)) * Math.sqrt(3 / eff); // 3 dB half bandwidth

				var ana3 = 2.5; // Ratio of first null angle to 3 dB half beamwidth
				var x = Math.abs((Math.PI / 2) * (1 / ana3) * a / a3);
				var zone = 0;

				var g580;
				if (x == 0) {
    				gAbs = gOnAxisdB;
					zone = 0;
				} else if (x < Math.PI / 2) {
					// Main lobe
					//  up to a = a3*ana3
    				var k1 = 3 / log10(Math.cos((Math.PI / 2) * (1 / ana3)));
					var p = 1;
    				gRel = -k1 * log10( Math.pow(Math.abs(Math.cos(x)), p)  );
    				gAbs = gRel + gOnAxisdB;
					zone = 1;
				} else if ( (x >= Math.PI / 2) && (x < Math.PI) ){
					// First sidelobe
					//   up to a = 2*a3*ana3
    				gRel = 20 * log10(Math.abs(Math.sin(2 * x))) + sidelobeLeveldB;
    				gAbs = gRel + gOnAxisdB;
					zone = 2;
				} else if (x >= Math.PI) {
					// Remaining sidelobes
    				if (a <= 20) {
        				g580 = 29 - 25 * log10(a);
					} else if (a > 20 && a <= 26.5) {
        				g580 = -3.5;
					} else if (a > 26.5 && a <= 48) {
        				g580 = 32 - 25 * log10(a);
					} else {
        				g580 = -10;
					}
            		gAbs = 20 * log10( Math.abs(Math.sin(2 * x))) + g580 - 2;
					zone = 3;
				}
				//trace("In antennaPattern, zone = "+zone+", a = "+a+", x/Pi = "+(x/Math.PI)+", gAbs = "+gAbs);
			} else if (type == "sinXoverX"){
				// Sin(x)/x function
			
				var aS = 1.808 * a * Math.PI / (3*a3);
				var y;
				if (aS == 0){
					y = 1;
				}else{
					y = Math.abs( Math.sin(aS) / aS ); // Returns a value from 0 to 1.
				}
				var gReldB = W2dBW( y );
				gAbs = gReldB + gOnAxisdB;
	
			} else if (type == "parabolic"){
				gAbs = -beamwidth2loss( a, a3 ) + gOnAxisdB;
			}
			//trace("Calculated gAbs = "+gAbs);
			return gAbs;

		}
		public static function patternSpec(angle_deg, type, returnVal ){
			/*
			*/
			var a;
			var g580;
			var g;
			if (type == "ITU580" && returnVal == "gain"){
				a = Math.abs(angle_deg);
				if (a <= 20) {
					g580 = 29 - 25 * log10(a);
				} else if (a <= 26.5) {
					g580 = -3.5;
				} else if (a <= 48) {
					g580 = 32 - 25 * log10(a);
				} else {
					g580 = -10;
				}
				return g580;
			} else if (type == "ITU580" && returnVal == "startAngle"){
				return 1;
			} else if (type == "FCC" && returnVal == "gain"){
				a = Math.abs(angle_deg);
				if (a <= 7) {
					g = 29 - 25 * log10(a);
				} else if (a <= 9.2) {
					g = 8;
				} else if (a <= 48) {
					g = 32 - 25 * log10(a);
				} else {
					g = -10;
				}
				return g;
			} else if (type == "FCC" && returnVal == "startAngle"){
				return 1.25;
			}
			
			
		}

		public static function calc_xpr( pol_error_deg, point_error_deg, off_axis_xpr,  notch_full_bw_30_dB, notch_center_xpr ){
			// Calculates x-pol ratio from mispointing and antenna xpol pattern model
			trace("WARNING: function Util3.calc_xpr is OBSOLETE. Use CrossPolCalculator object instead.");
			var mispoint_xpr = xpol_lp( point_error_deg, off_axis_xpr,  notch_full_bw_30_dB, notch_center_xpr ); // XPR if pol was properly aligned
	
			// Polarization is elliptical, with eccentricity due to mispoint_xpr, and overal rotation due to pol_error_deg
			var b_a:Number = dB2Vratio( mispoint_xpr );  // A small number
			var a:Number = 1;
			var b:Number =  b_a * a;
			var xtmax:Number = 0;
			var ytmax:Number = 0;
			// Find the max an min of the ellipse rotated by the pol error:
			var tRad, phiRad, xt, yt;
			for (var t=0; t<=180; t+=2.5){
				// From http://en.wikipedia.org/wiki/Ellipse#General_parametric_form
				tRad = radians(t);
				phiRad = radians(pol_error_deg);
				xt = a*Math.cos(tRad)*Math.cos(phiRad) - b*Math.sin(tRad)*Math.sin(phiRad);
				yt = a*Math.cos(tRad)*Math.sin(phiRad) - b*Math.sin(tRad)*Math.cos(phiRad);
				xtmax = Math.max( xtmax, Math.abs(xt) );
				ytmax = Math.max( ytmax, Math.abs(yt) );
				//trace("a = "+a+", b = "+b+", t = "+t+", pol_error_deg = "+pol_error_deg+", xt = "+xt+", yt = "+yt);
			}
			// Take the voltage ratio to get XPR:
			///var xpr = 20*log10( Math.abs(Math.tan( Math.abs(ytmax/xtmax) )) ); /// Wrong?
			var xpr = 20*log10( Math.abs(ytmax/xtmax) );
			//trace("In calc_xpr: al_xpr = "+al_xpr+", al_rot = "+al_rot+", net_rot = "+net_rot+", xpr = "+xpr);
			trace("mispoint_xpr = "+mispoint_xpr+", pol_error_deg = "+pol_error_deg+", point_error_deg = "+point_error_deg+ ", xtmax = "+xtmax+", ytmax = "+ytmax+", xprdB = "+xpr);
			
			return xpr;
		}
		
		public static function xpol_lp(angle_deg, off_axis_xpr, notch_full_bw_30_dB, notch_center_xpr ){
			trace("WARNING: function Util3.xpol_lp is OBSOLETE. Use CrossPolCalculator object instead.");
			/* xpol_lp: Simple model of LP antenna close-in x-pol rejection ratio
			Implements a hyperbolic model of the x-pol notch.
			Inputs:
			  angle_deg = off-axis angle (deg)
			  off_axis_xpr  =  XPR (dB) at say +/- 4 deg.  Typ -12.
			  notch_full_bw_30_dB = width of notch (deg) at the 30 dB points. Typ 0.6 deg
			  notch_center_xpr = xpr at center of notch (negative) e.g. -30
			  
			  e.g. x = Util3.xpol_lp(a, -12, 0.6, -30);
	
			Hyperbola x = k1 + k2/|a|
			*/
			var xpr;
			var k1 =  off_axis_xpr;
			var k2 = (-30 - k1) * (notch_full_bw_30_dB/2);
			if ( angle_deg == 0 ){
				xpr = notch_center_xpr;
			}else{
				xpr = k1 + k2*Math.abs( 1/angle_deg );
				xpr = Math.max(notch_center_xpr, xpr);
			}
			//trace(angle_deg+"  "+ off_axis_xpr+"  "+ notch_full_bw_30_dB+"  "+notch_center_xpr);
			//trace("In xpol_lp: xpr = "+xpr);
			return xpr;
		}
		public static function xpol_lp2(angle_deg, off_axis_xpr, notch_full_bw_30_dB, notch_center_xpr ){
			trace("WARNING: function Util3.xpol_lp2 is OBSOLETE. Use CrossPolCalculator object instead.");
			var a = Math.abs(pm180(angle_deg));
			if (a > 90){ a = 180-a; };
			var xpolHyper = xpol_lp(a, off_axis_xpr, notch_full_bw_30_dB, notch_center_xpr );
			var xpolSin = 20* log10( Math.abs(Math.sin(radians(a)) ) );
			var res = Math.max(xpolHyper, xpolSin);
			//trace("angle_deg = "+angle_deg+", a = "+a+" xpolHyper = "+xpolHyper +", xpolSin = "+xpolSin+", res = "+res);
			return res;
		}
		public static function loss2beamwidth( L, hb3 ){
			//Converts antenna off-axis loss to half beamwidth at that loss.  Requires 3-dB half beamwidth.
			// Loss (dB) L = 3 * (hb/hb3)^2
			// hb =  hb3 * sqrt(L/3)
			if( L < 0 ){
				trace("Error in Util3.loss2beamwidth: parameter L less than zero.");
			}
			return hb3 * Math.sqrt( L/3 );
		}
	
		public static function beamwidth2loss( hb, hb3 ){
			//Converts antenna half beamwidth angle to off-axis loss.  Requires 3-dB half beamwidth.
			// Loss (dB) L = 3 * (hb/hb3)^2
			return 3 * (hb*hb)/(hb3*hb3);
		}

		public static function antGaindB( dia_m, freq_MHz, eff ){
			var a = 2 * Math.PI * (dia_m/2) * (freq_MHz/300 );
			var g = eff * a * a;
			var gdB = W2dBW( g );
			return gdB;
		}
		public static function antEllipticalGaindB( majorDia_m, minorDia_m, freq_MHz, eff, offsetAngle:Number=0 ){
			var area = ellipseArea(majorDia_m, minorDia_m);
			var lambda = 300/freq_MHz;
			var g = 4 * Math.PI * eff * area / (lambda*lambda) ; // Ref Data For Radio Engineers, p 33-26
			var gdB = W2dBW( g );
			return gdB;
		}
		public static function antEllipticalEffectiveDia( majorDia_m, minorDia_m ){
			// Dia of a circle that has the same area as a given ellipse
			var area = ellipseArea(majorDia_m, minorDia_m);
			//A = PI r^2
			var r = Math.sqrt( area / Math.PI );
			return 2*r;
		}
		public static function antBeamwidth( dia_m, freq_MHz, eff ){
			// Returns half beamwidth at 3dB point.
			var g = dBW2W( antGaindB( dia_m, freq_MHz, eff ) );
			return (Math.sqrt( 27000/ g ))/2;
		}
		public static function antBeamwidth20( dia_m, freq_MHz, eff ){
			// Returns half beamwidth at 20dB point for a typical antenna.
			var g = dBW2W( antGaindB( dia_m, freq_MHz, eff ) );
			return (Math.sqrt( 145000/ g ))/2;
		}
		public static function antEllipticalBeamwidth( majorDia_m, minorDia_m, freq_MHz, eff, tiltDeg  ){
			// Returns half beamwidth at 3dB point.
			var g = dBW2W( antEllipticalGaindB( majorDia_m, minorDia_m, freq_MHz, eff) );
			var thetaH; // full beamwidth in height (minor) axis
			var thetaW; // full beamwidth in width (major) axis
			// thetaW * thetaH = eff * 41253 / g; // Freeman p1275
			// thetaW / thetaH = minorDia_m / majorDia_m (Beamwidth inversely proportional to width;
			thetaH = Math.sqrt(  eff * 41253 * majorDia_m / (g * minorDia_m ) );
			thetaW = (eff * 41253 / g) / thetaH;
			var tiltedHBW = ellipseR(tiltDeg, thetaW, thetaH);  // Beamwidth across the elliptical spot
			//trace("tilt = "+tiltDeg+", thetaW = "+thetaW+", thetaH = "+thetaH+", tilted HBW = "+tiltedHBW);
			return tiltedHBW;
		}

		public static function trimSpaces( str:String ):String{
			// Trims leading and trailing spaces from a string.
			var s = str;
			//trace("Starting with s = |"+s+"|");
			while ( s.length >0 && s.charAt(0) == " "){
				s = s.substr(1,s.length); 
				//trace("Trimmed leading space; now s = |"+s+"|");
			}
			while ( s.length >0 && s.charAt( s.length-1) == " "){
				s = s.substr(0,s.length-1); 
				//trace("Trimmed trailing space; now s = |"+s+"|");
			}
	
			return s;
		}
		
		public static function trimChars( str:String, char:String ):String{
			// Trims leading and trailing characters from a string.
			var s:String = str;
			var ch:String = char.charAt(0);
			//trace("Starting with s = |"+s+"|");
			while ( s.length >0 && s.charAt(0) == ch){
				s = s.substr(1,s.length); 
				//trace("Trimmed leading space; now s = |"+s+"|");
			}
			while ( s.length >0 && s.charAt( s.length-1) == ch){
				s = s.substr(0,s.length-1); 
				//trace("Trimmed trailing space; now s = |"+s+"|");
			}
	
			return s;
		}
		public static function textFieldActualHeight(tf:TextField):Number{
			// Finds the actual height of a text field at its current width, which may have multiple lines and autowrap.
			// From https://stackoverflow.com/questions/16929311/how-best-way-to-resize-textfield-to-fit-all-text
			// Caution:
			// FIRST set tf format; THEN width; THEN text; THEN call this function; THEN set tf.height = result of this function.
			//trace("------------------------");
			//trace(tf.text);
			var gutter:Number  = 2;
			var totalLines:int = tf.bottomScrollV - tf.scrollV + tf.maxScrollV;
			var actualHeight:Number = 0;
			var prevLeading:Number = 0;
			for (var i:int = 0; i < totalLines; i += 1){
				var metrics = tf.getLineMetrics(i);
				actualHeight += metrics.ascent + metrics.descent + prevLeading;
				prevLeading = metrics.leading;
				//trace(" i = "+i+", metrics.ascent = "+metrics.ascent+", metrics.descent = "+metrics.descent);
			}
			actualHeight += 2 * gutter + 5; // Need extra for some reason
			//trace("totalLines = "+totalLines+", actualHeight = "+actualHeight+", numLines = "+tf.numLines +", width = "+tf.width);
			return actualHeight;
		}
		public static function removeNonPrintable( str:String ):String{
			// Removes any non-printable characters from a string.
			var s = str;
			var ls = str.length;
			var n = 0;
			var sOut:String = "";
			
			for (var i=0; i<str.length; i++){
				if ( (s.charCodeAt(i) >= 32 ) &&  (s.charCodeAt(i) >= 32 ) ){
					// Printable character
					n++;
					sOut += s.charAt(i);
				}
			}
			return sOut;
		}
		public static function isNotANumber(str:String):Boolean {
			// Like isNaN, but also works if the string is null or all spaces.
			var s = trimSpaces(str);
			if ( (s.length <= 0) || isNaN(s) ){
				return true;
			} else {
				return false;
			}
		}
		public static function isTrue(val):Boolean{
			
			var retval:Boolean = false;
			
			if (val is Boolean){
				retval = val;
			} else if (val is int){
				retval = !(val == 0);
			} else if (val is Number){
				retval = !(val == 0);
			} else if (val is String){
				var vu:String = val.toUpperCase();
				//trace("vu = "+vu);
				retval = ( vu == "TRUE" || vu == "T" || vu == "YES" || vu == "Y");
			} else {
				trace("ERROR in Util3.isTrue: could not interpret val = "+val);
				retval = false;
			}
			return retval;
		}
		public static function stringRepresentsBoolean(val): Boolean { 
			var retval:Boolean = false;
			if(val is Boolean) {
				retval = true;
			} else if (val is String) {
				var vu:String = val.toUpperCase();
				if ( vu == "TRUE" || vu == "T" || vu == "YES" || vu == "Y" || vu == "FALSE" || vu == "F" || vu == "NO" || vu == "N" ) {
					retval = true;
				}
			} else if(val is int){
				if(val == 1 || val == 0 ) {
					return true;
				}
			} else {
				trace("ERROR in Util3.isTrue: could not interpret val = "+val);
				retval = false;
			}
			return retval;
		}
		
	public static function pointing_slantrange(ES_long, ES_lat, sat_long){
		var r = earthRadiuskm; // Radius of the earth (km)
		var h = geoHeightkm; // Geostationary height (km)

		var lat = radians(ES_lat); //Latitude of Earth Station site (North or South).
		var LHA = radians(ES_long - sat_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).

		var cosbeta = Math.cos(lat) * Math.cos(LHA);

		return Math.sqrt( r*r + (r+h)*(r+h) - 2*r*(r+h)* cosbeta ); // in km

	}
	
	public static function pointing_az(ES_long, ES_lat, sat_long){
		// Returns azimuth degrees from due North in the range 0 to 360.  Eastwards is negative, westwards is positive.
		// Ref: Van Valkenburg, Reference Data for Radio Engineers, 9th Ed, p. 27-11.
		var lat = radians(ES_lat); // Latitude of Earth Station site. Positive = North
		var LHAdeg = pm180(ES_long - sat_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).
		
		var LHA = radians(LHAdeg);

		// Azimuth angle to satellite. East or West from South or North.
		var Tan_Phi = Math.tan(LHA) / Math.sin(lat);
		var azDeg1 = degrees(Math.atan(Tan_Phi));
		//var LHAdeg = degrees(LHA);
		var azDeg;
		if (lat >= 0){
			// Northern hemisphere
			if (LHAdeg > 90){
				azDeg = azDeg1 + 360;
			} else if (LHAdeg >= -90) {
				azDeg = azDeg1 + 180;
			} else {
				azDeg = azDeg1;
			}
		} else {
			// Southern hemisphere
			if (LHAdeg > 90){
				azDeg = azDeg1 - 180;
			} else if (LHAdeg >= -90) {
				azDeg = azDeg1;
			} else {
				azDeg = azDeg1 + 180;
			}
			
		}
		//trace("    satLong = "+sat_long+", LHA = "+degrees(LHA)+", azDeg1 = "+azDeg1+ ", azDeg = "+azDeg);
		return azDeg;

	}
	public static function pointingO3b_az(ES_long, ES_lat, sat_long){
		// Azimuth is independent of satellite altitude.
		return  pointing_az(ES_long, ES_lat, sat_long);
	}
	
	public static function pointing_el(ES_long, ES_lat, sat_long){
		// Ref: Van Valkenburg, Reference Data for Radio Engineers, 9th Ed, p. 27-11.

		var r = earthRadiuskm; // Radius of the earth (km)
		var h = geoHeightkm; // Geostationary height (km)
		var lat = radians(ES_lat); // Latitude of Earth Station site (North or South).
		var LHA = radians(ES_long - sat_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).

		var cosbeta = Math.cos(lat) * Math.cos(LHA);
		var beta = Math.acos(cosbeta);
		var sinbeta = Math.sin(beta);
		var rphsq = (r+h)*(r+h);
		var d = Math.sqrt( r*r + rphsq - 2*r*(r+h)* cosbeta ); // in km
		var theta = Math.acos((r + h) * sinbeta / d);
		if (rphsq >= (r*r + d*d) ){
			theta = Math.abs(theta);
		} else {
			theta = -Math.abs(theta);
		}
		//trace("cosbeta = "+cosbeta +", sinbeta = "+sinbeta +", beta(deg) = "+degrees(beta)+", d = "+d +", theta = "+theta);
		return degrees(theta);
	}
	public static function pointingO3b_el(ES_long, ES_lat, sat_long){
		// Based on pointing_el but with satellite height at O3b height
		var r = earthRadiuskm; // Radius of the earth (km)
		var h = O3bHeightkm; // O3b height (km)
		var lat = radians(ES_lat); // Latitude of Earth Station site (North or South).
		var LHA = radians(ES_long - sat_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).

		var cosbeta = Math.cos(lat) * Math.cos(LHA);
		var beta = Math.acos(cosbeta);
		var sinbeta = Math.sin(beta);
		var rphsq = (r+h)*(r+h);
		var d = Math.sqrt( r*r + rphsq - 2*r*(r+h)* cosbeta ); // in km
		var theta = Math.acos((r + h) * sinbeta / d);
		if (rphsq >= (r*r + d*d) ){
			theta = Math.abs(theta);
		} else {
			theta = -Math.abs(theta);
		}
		//trace("cosbeta = "+cosbeta +", sinbeta = "+sinbeta +", beta(deg) = "+degrees(beta)+", d = "+d +", theta = "+theta+" = "+degrees(theta)+" el deg");
		return degrees(theta);
		
	}
	public static function pointingSatLong(elDeg, ES_long, ES_lat, orbitHeightAboveSurface_km){
		// For equatorial orbit, returns the satellite longitude for a given elevation angle and site latitude.
		// See RB Note1 FLA and AS notes, p. O3b Elevation
		var h = orbitHeightAboveSurface_km;
		var R = earthRadiuskm; // Radius of the earth (km)
		var theta = radians(elDeg); // Latitude of Earth Station site (North or South).
		var costheta = Math.cos(theta);
		var phi = radians(ES_lat);
		
		var Rphsq = (R+h)*(R+h);
		var a = Rphsq;
		var b = -2*R*(R+h)*costheta*costheta;
		var c = R*R*costheta*costheta + Rphsq*( costheta*costheta - 1);
		
		var cosbeta1 = quadraticRoot1(a, b, c);
		var cosbeta2 = quadraticRoot2(a, b, c);
		var beta1 = Math.acos(cosbeta1);
		var beta2 = Math.acos(cosbeta2);
		var beta1deg = degrees(beta1);
		var beta2deg = degrees(beta2);
		
		var cosLambda1 = cosbeta1 / Math.cos(phi) ;
		var LHA1deg = degrees(Math.acos(cosLambda1));
		var cosLambda2 = cosbeta2 / Math.cos(phi) ;  // Not sure why this root is not useful
		var LHA2deg = degrees(Math.acos(cosLambda2));
		
		var satLongEdeg = mod360(ES_long + LHA1deg);
		var satLongWdeg = mod360(ES_long - LHA1deg);
		return new Point(satLongWdeg, satLongEdeg); // W will be less than E
	}
	public static function quadraticRoot1(a:Number, b:Number, c:Number):Number{
		return (-b + Math.sqrt( b*b - 4*a*c) )/(2*a);
	}
	public static function quadraticRoot2(a:Number, b:Number, c:Number):Number{
		return (-b - Math.sqrt( b*b - 4*a*c) )/(2*a);
	}
	public static function pointing_pol(ES_long, ES_lat, sat_long){
		
		var lat = radians(ES_lat); // Latitude of Earth Station site (North or South).
		var LHA = radians(ES_long - sat_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).

		// Polarization angle from local vertical.
		var tan_Gamma = Math.sin(LHA) / Math.tan(lat);
		return degrees( Math.atan(tan_Gamma));
	}

	public static function pointing_feedRotation(ES_long, ES_lat, sat_long, definedSense, actualSense ){
		// Returns feed rotation in degrees, where positive is CW when looking into the dish.
		var pol = Util3.pointing_pol(ES_long, ES_lat, sat_long);
		var rot;
		if (definedSense == actualSense ){
			rot = -pol;
		} else {
			rot = -pol + 90;
		}
		rot = pm180(rot);
		if (rot < -90 ){
			rot += 180;
		}
		if (rot > 90 ){
			rot -= 180;
		}
		return rot;
	}

	public static function pointing_discr_angle(ES_long, ES_lat, sat1_long, sat2_long){

		var lat = radians(ES_lat); // Latitude of Earth Station site (North or South).
		var LHA1 = radians(ES_long - sat1_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).
		var LHA2 = radians(ES_long - sat2_long); // Local Hour Angle - longitude difference between satellite and Earth Station (East or West).
		var r = earthRadiuskm; // Radius of the earth (km)
		var h = geoHeightkm; // Geostationary height (km)

		var cosbeta1 = Math.cos(lat) * Math.cos(LHA1);
		var cosbeta2 = Math.cos(lat) * Math.cos(LHA2);

		var SR1 = Math.sqrt(r*r + (r+h)*(r+h) - 2*r*(r + h)*cosbeta1); // in km
		var SR2 = Math.sqrt(r*r + (r+h)*(r+h) - 2*r*(r + h)*cosbeta2); // in km

		var Sat1_2_distance = Math.sqrt(2 * ((r + h) ^ 2) - 2 * ((r + h) ^ 2) * Math.cos(radians(sat1_long - sat2_long)));// B18

		return degrees(Math.acos(((SR1*SR1) + (SR2*SR2) - (Sat1_2_distance*Sat1_2_distance)) / (2 * SR1 * SR2)))
	}
	

	public static function pointing_loss(freq_GHz, dia_m, eff, angle_deg){
		//Approximate off-axis loss for a typical parabolic antenna.
		// Returns a positive number
		return 0.0487 * Math.pow((freq_GHz * dia_m), 2) * eff * angle_deg * angle_deg;
	}
	public static function pointing_errorBeamBalance( hbw3, L, E){
		// hbw = 3dB half beamwidth; L = pointing loss to ref level; E = meter error 
		// From RB paper
		var errAng = (hbw3 / (2*Math.sqrt(3) ) )* ( Math.sqrt(L+E) - Math.sqrt(L-E) );
		return errAng;
	}
	public static function pointing_angle(freq_GHz, dia_m, eff, loss){
		//Approximate off-boresight angle for a given off-axis loss for a typical parabolic antenna.

		return Math.sqrt(1 / 0.0487) * Math.sqrt(loss) / (dia_m * freq_GHz * Math.sqrt(eff));
	}
	public static function pointing_lossToTarget(az, el, targetAz, targetEl, hb3){
		// Pointing loss to a target satellite az-el from current antena direction az/el 
		var da =  pointing_diff_angle(az, el, targetAz, targetEl );
		return beamwidth2loss( da, hb3 );
	}

	public static function pointing_angle_rt(Tx_freq_GHz, Rx_freq_GHz, dia_m, eff, loss){
		//Approximate off-boresight angle for a given off-axis round-trip (transmit+receive) loss for a typical parabolic antenna.

		return Math.sqrt(loss / ((Tx_freq_GHz*Tx_freq_GHz + Rx_freq_GHz*Rx_freq_GHz) * 0.0487 * dia_m*dia_m * eff));
	}

	public static function pointing_diff_angle( az1, el1, az2, el2){
		// Returns the angle between two pointing directions, all in degrees.
		// cos c = cos a . cos b, where a and b are the sides of spherical right triangle; c is the hypotenuse
		var daz = radians(az2-az1);
		var del = radians(el2-el1);
		return degrees(  Math.acos( Math.cos(daz) * Math.cos(del) ) );
	}
	
	public static function pointing_apparent_az_beamwidth( bw_deg, el_deg){; 
		// Azimuth width of a beam with beamwidth bw as seen at elevation el
		// THIS IS INCORRECT!!!
		trace("Error - do not use function Util3.pointing_apparent_az_beamwidth.  Use pointing__beamwidth2deltaAz instead.");
		return NaN;
		//return bw_deg / (1 - Math.cos( radians(el_deg) ));
	}
	public static function pointing_beamwidth2deltaAz( bw_deg, el_deg){; 
		/* 	Azimuth width of a beam with beamwidth bw as seen at elevation el
				cos(daz) = (1/(cos^2(el))*( cos(bw) - sin^2(el) )
			where daz is the mount azimuth rotation required to move a beam of width bw across its beamwidth
			Returns an error if 90 - elevation is less than the beamwith because the beamwidth cannot be traversed by rotating azimuth.
		*/
		var el = radians(el_deg)
		var bw = radians(bw_deg)
		var cos_daz = (1 / (Math.cos(el)*Math.cos(el)) ) * (Math.cos(bw) - (Math.sin(el)*Math.sin(el) ))
		var daz = Math.acos(cos_daz)
		var daz_deg = degrees(daz)
		return daz_deg;
		/* Old code - corrected 5/26/2010
		// Azimuth width of a beam with beamwidth bw as seen at elevation el
		// sin(az'/2) = sin(az/2) / cos(el)
		// where az' is the mount azimuth rotation required to move a beam of width az across its beamwidth
		var sind2 = Math.sin(radians(bw_deg/2)) / Math.cos(radians(el_deg));
		var azd = degrees( Math.asin( 2 * sind2 ) );
		return azd;
		*/
	}
	public static function deltaAz2pointing_beamwidth( dAz_deg, el_deg){
		/* Inverse of pointing_beamwidth2deltaAz'
			cos(daz) = (1/(cos^2(el))*( cos(bw) - sin^2(el) )
			cos(daz) * cos^2(el) =  cos(bw) - sin^2(el) 
			cos(daz) * cos^2(el) + sin^2(el)=  cos(bw)  
			cos(bw) = cos(daz) * cos^2(el) + sin^2(el)
		*/
		var el = radians(el_deg)
		var daz = radians(dAz_deg);
		var cosbw = Math.cos(daz) * (Math.cos(el)*Math.cos(el)) + (Math.sin(el)*Math.sin(el) );
		var bw = Math.acos(cosbw);
		var bw_deg = degrees(bw);
		return bw_deg;
	}
	 
	public static function scanTilt2AzEl(A0deg, E0deg, Sdeg, Tdeg){
		/*
		A0 & E0 are the azimuth & elevation of the antenna axis beam.
		Sdeg is scan offset.  Sdeg positive moves the beam to the right along the arc (with Tdeg = 90).
		Tdeg is tilt following the DIRECTV convention, i.e. 
			Tdeg = 90 deg:  dish major axis is horizontal, locus of beams is horizontal.
			Tdeg < 90 deg: locus of beams is rotated clockwise in the sky.

		Returns an array.  Element 0 is azimuth of the scanned beam.  Element 1 is the elevation.
		See TestPointing_scannedBeamEl.fla for spherical geometry diagrams
		*/
		
		var azEl:Array = new Array();
		/*
		Get Q1 from: 
		sin (Q1) = sin(T) sin(S)
		Get E1 from:
		cos(S) = cos(E0-E1) cos(Q1)
		cos(E0-E1)  = cos(S) / cos(Q1)
		E1 = E0 - acos[  cos(S) / cos(Q1) ]
		Get A1 from:
		sin(Q1/2) = sin[ (A1-A0)/2] sin(E1')
		(A1-A0)/2 = asin[ sin(Q1/2)  / sin(E1') ]
		A1 = A0 + 2*asin[ sin(Q1/2) / sin(E1') ]
		*/
		
		var A0 = radians(A0deg);
		var E0 = radians(E0deg);
		var S = radians(Sdeg);
		var Tpdeg = mod360( Tdeg);
		var Tp = radians(Tpdeg);
		
		var Q1;
		var E1;
		var Edelta;
		if (Tpdeg == 90){
			Q1= S;
			Edelta = 0;
		} else if ( Tpdeg == 270){
			Q1= -S;
			Edelta = 0;
		} else {
			Q1 = Math.asin( Math.sin(Tp) * Math.sin(S) ); // Tp = 90 deg; Q1 = S
			Edelta = Math.acos(  Math.cos(S) / Math.cos(Q1) );
		}
		
		if ( S > 0 ){
			if ( Tpdeg <= 90 || Tpdeg >= 270){
				E1 = E0 - Edelta ;
			} else {
				E1 = E0 + Edelta ;
			}
		} else {
			if ( Tpdeg <= 90 || Tpdeg >= 270){
				E1 = E0 + Edelta ;
			} else {
				E1 = E0 - Edelta ;
			}
			
		}
		var	A1 = A0 + 2*Math.asin( Math.sin(Q1/2) / Math.sin( (Math.PI/2)-E1) );
		//trace("A0 = "+sprintf3("%7.1f", degrees(A0))+", E0 = "+sprintf3("%7.1f", degrees(E0))+", S = "+sprintf3("%7.1f", degrees(S))+", Tp = "+sprintf3("%7.1f", Tpdeg)+", Q1 = "+sprintf3("%7.1f", degrees(Q1))+", A1 = "+sprintf3("%7.1f", degrees(A1))+", E1 = "+sprintf3("%7.1f", degrees(E1)) );
		azEl[0] = degrees(A1);
		azEl[1] = degrees(E1);
		if (isNaN(A1) || isNaN(E1)){
			trace("ERROR in Util3.scanTilt2AzEl: A0deg = "+A0deg+", E0deg = "+E0deg+", Sdeg = "+Sdeg+", Tdeg = "+Tdeg+", A1 = "+A1+", E1 = "+E1+", Edelta = "+Edelta );
		}
		return azEl;
	}
	public static function pointing_scannedBeamAzEl(mainBeamAz, mainBeamEl, scanBeamDistanceDeg, tiltDeg, scanBeamRadiusDeg, scanBeamAngleDeg){
		/* See TestPointing_scannedBeamEl.fla for spherical geometry diagrams
		
		Returns the az-el of point p, where M is the main beam, S is the scanned beam. 
		
		                  S
		                 /  \
		                /    p
		              M
		
		   S is defined relative to M by scanBeamDistanceDeg, tiltDeg
		   p is defined relative to s by scanBeamRadiusDeg, scanBeamAngleDeg
		*/
		var A1E1:Array = new Array();
		var A2E2:Array = new Array();
		
		// Get az-el of center of a scanned beam:
		A1E1 = scanTilt2AzEl(mainBeamAz, mainBeamEl, scanBeamDistanceDeg, tiltDeg);
		if (isNaN(A1E1[0]) || isNaN(A1E1[1])){
			trace("Error in  pointing_scannedBeamAzEl: NaN found in A1E1.  mainBeamAz = "+mainBeamAz+", mainBeamEl = "+mainBeamEl+", scanBeamDistanceDeg = "+scanBeamDistanceDeg+", tiltDeg = "+tiltDeg);
		}
		// Get az-el at a given point away from the result: 
		A2E2 = scanTilt2AzEl( A1E1[0], A1E1[1], scanBeamRadiusDeg, scanBeamAngleDeg );
		if (isNaN(A2E2[0]) || isNaN(A2E2[1])){
			trace("Error in  pointing_scannedBeamAzEl: NaN found in A2E2.  mainBeamAz = "+mainBeamAz+", mainBeamEl = "+mainBeamEl+", scanBeamDistanceDeg = "+scanBeamDistanceDeg+", tiltDeg = "+tiltDeg+", A1E1[0] = "+ A1E1[0]+", A1E1[1] ="+ A1E1[1]);
		}
		return A2E2;
	}
	public static function kepler2():Number{
		traceToConsole("In Util3.kepler2...");
		return 99.9;
	}
		public static function radians88(deg) {
			return deg * Math.PI / 180;
		}
	
	public static function keplerOrbit(
			satApogeeHeightkm:Number, satPerigeeHeightkm:Number, satInclDeg:Number, satRaanDeg:Number, 
			satAOPDeg:Number, satPhaseOffsetDeg:Number, tSinceEpochSec:Number):Vector3D{
		
		//traceToConsole("In Util3.keplerOrbit...");
		//return new Vector3D(2000,1000,0); ////
		/*
		Assume we are using the equatorial plane as the reference plane.
		See OrbitalMechanics1.fla
		
		satApogeekm   distance above earth's surface
		satPerigeekm   distance above earth's surface
		satInclDeg  Orbit inclination. 0 = orbit is in equatorial plane
		satRaanDeg	Right ascension of the ascending node
		satAOPDeg	Argument of Peripasis
		satPhaseOffsetDeg	Phase offset. This offsets the Mean Anomaly.
		tSinceEpochSec  Time since periapsis (assuming phase offset is zero)
		
		Orbit equations are from:
		http://en.wikipedia.org/wiki/Orbit
		http://en.wikipedia.org/wiki/Orbital_period
		http://en.wikipedia.org/wiki/Standard_gravitational_parameter
		
		*/
		
		var mu = 3.986E14; // GM (gravitational constant for the earth times the mass of the earth) meters/seconds
		var TA:Number;
		var MA:Number;
		var n:Number;
		var r:Number;
		var a:Number;
		var e:Number;
		
		var isCircular:Boolean = equalToNplaces(satApogeeHeightkm, satPerigeeHeightkm, 7); // Returns true if a and b a equal to N decimal places.
		//traceToConsole("In Util3.keplerOrbit, isCircular = "+isCircular);
		if (isCircular){
			a = 1000*(satApogeeHeightkm + earthRadiuskm);
			r = a;
			n = Math.sqrt( mu / (a*a*a) ); // Mean angular motion = dMA/dt
			TA = n * tSinceEpochSec + radians(satPhaseOffsetDeg);
			e = 0;
		} else {
			// Semi-major axis of orbit
			var AD = 1000 * (satApogeeHeightkm + earthRadiuskm); // Apogee distance from center of earth
			var PD = 1000 * (satPerigeeHeightkm + earthRadiuskm); // Perigee distance from center of earth
			a = (AD+PD)/2; // Semi-major axis
			e = (AD-PD)/(AD+PD) ; // Eccentricity
			n = Math.sqrt( mu / (a*a*a) ); // Mean angular motion = dMA/dt
			// Mean anomaly:
			MA = n * tSinceEpochSec + radians(satPhaseOffsetDeg); // Mean anomaly in radians
			MA = mod2Pi(MA);
			// Eccentric anomaly:
			var EA:Number = MA + (2*e - (1/4)*e*e*e)*Math.sin(MA)
				+ (5/4)*e*e*Math.sin(2*MA)
				+ (13/12)*e*e*e*Math.sin(3*MA); // Initial terms of series
			// True anomaly:
			
			TA = 2 * Math.atan( Math.sqrt( (1+e)*Math.tan(EA/2)*Math.tan(EA/2) ) / (1-e)  );
			if (MA > Math.PI){
				TA = -TA;
			}
			TA = mod2Pi(TA);
			
			r = a*( 1 - e*Math.cos(EA) ); // Distance from center of earth to satellite
			

			// Integration constant for Kepler's 2nd law
			var k = Math.sqrt(a * mu ); // Not sure if we need this
			var dThetadT = k / (r * r); // Angular velocity???
		}
	
		//traceToConsole("In Util3 point A");
		// Period:
		var T = 2*Math.PI* Math.sqrt(  a*a*a / mu);	// http://en.wikipedia.org/wiki/Orbital_period
					
		// Now convert to cartesian coordinates.
		// x axis is from the center of the earth towards zero celestial longitude (reference direction, i.e. first point of Aries).
		// y axis is from the center of the earth towards 90 deg east celestial longitude.
		// z axis is from the center of the earth towards the zenith.
		// We start with the orbit in the x-y plane.  Perigee is on the +x axis with y=0, x = 0.
		// Major axis of the orbit is along the x axis.  Apogee is on the -x axis.
		// x0, y0 is the location on the original flat x-y plane:
		var x0 = r * Math.cos( TA );
		var y0 = r * Math.sin( TA );
		var z0 = 0;
		var initPos:Vector3D = new Vector3D(x0,y0,z0);
		
		//traceToConsole("In Util3 point B");
		
		// Now tilt the orbit around the y axis.  
		// This represents the inclination parameter.
		var x1 = x0 * Math.cos( radians(satInclDeg) );
		var y1 = y0;
		var z1 = x0 * Math.sin( radians(satInclDeg) );
		//traceToConsole("In Util3 point C");
		
		var rotMat:Matrix3D = new Matrix3D();
		rotMat.identity();
		//traceToConsole("In Util3 point D, rotMat = "+rotMat);
		//1. Rotate around Z by Argument Of Periapsis. (Stay in X-Y plane)
		rotMat.appendRotation(satAOPDeg, new Vector3D(0,0,1) );
		
		//2. Rotate around the Y' axis by inclination. Ascending node will still be in the X-Y plane.
		var yPrimAxis:Vector3D = new Vector3D( -Math.sin(radians(satAOPDeg)), Math.cos(radians(satAOPDeg)), 0 );
		rotMat.appendRotation(satInclDeg, yPrimAxis );
		
		//3. Rotate around Z by RAAN
		rotMat.appendRotation(satRaanDeg, new Vector3D(0,0,1) );
		
		//4. Rotate around X by 90 deg to convert to Away3D 
		rotMat.appendRotation(90, new Vector3D(1,0,0) );
		//traceToConsole("In Util3 point E");
		
		
		var finalPos:Vector3D = rotMat.transformVector(initPos);
		
		finalPos.scaleBy(1e-3); // Convert back to km
		//traceToConsole("In Util3 point F");
		
		//trace("tSinceEpochSec = "+tSinceEpochSec+", satApogeekm = "+satApogeekm+", r = "+r+", MA = "+degrees(MA)+", EA = "+degrees(EA)+", TA = "+degrees(TA)+", finalPos = "+finalPos);
		/*
		// Now rotate the orbit around the z axis.  
		// This represents the raan parameter (right ascension of ascending node).
		var a1 = Math.atan2(y1, x1);
		var a2 = a1 + Util3.radians( satRaanDeg );
		var r2 = Math.sqrt( x1*x1 + y1*y1 );
		var x2 = r2 * Math.cos( a2 );
		var y2 = r2 * Math.sin( a2 );
		var z2 = z1;
		return new Vector3D(x2, z2, y2); // Flip so that 0 inclination is in X-Z plane
		*/
		finalPos.w = degrees(TA);
		//traceToConsole("In Util3 point G finalPos = "+finalPos);
		return finalPos;
	}
	public static function sign(x){
		if (x>=0){
			return +1;
		}else{
			return -1;
		}
	}
	public static function signChar(x){
		if (x>=0){
			return "+";
		}else{
			return "-";
		}
	}
	public static function formatSignedInt(x){
		var s:String = (int(Math.abs(x))).toString();
		
		if (x>0){
			return "+"+s;
		}else if (x<0){
			return "-"+s;
		} else if (x==0){
			return "0";
		}
		
	}
	public static function randomESlongitude10(ESlat, satLong){
		// Returns random latitude for elevation at least 10 degrees.
		// See testUtil3PointingAngles.fla for table.
		var latAbs = Math.abs(ESlat);
		var LHAmax;
		if (latAbs <= 20 ){
			LHAmax = 70;
		} else if (latAbs <= 50 ){
			LHAmax = 60;
		} else if (latAbs <= 60 ){
			LHAmax = 50;
		} else if (latAbs <= 65 ){
			LHAmax = 40;
		} else if (latAbs <= 70 ){
			LHAmax = 20;
		} else {
			LHAmax = NaN;
			trace("Error in randomESlongitude10: Latitude is too high for 10 deg elevation.");
			return NaN;
		}
		var ESlong = satLong -LHAmax + Math.random()*2*LHAmax;
		ESlong = pm180(ESlong);
		return ESlong;
	}
	public static function randomESlongitude20(ESlat, satLong){
		// Returns random latitude for elevation at least 20 degrees.
		// See testUtil3PointingAngles.fla for table.
		var latAbs = Math.abs(ESlat);
		var LHAmax;
		if      (latAbs <= 20 ){ LHAmax = 60;} 
		else if (latAbs <= 42 ){ LHAmax = 50; } 
		else if (latAbs <= 53 ){ LHAmax = 40; } 
		else if (latAbs <= 60 ){ LHAmax = 20;} 
		else {
			LHAmax = NaN;
			//trace("Error in randomESlongitude20: Latitude = "+latAbs+" is too high for 20 deg elevation.");
			return NaN;
		}
		var ESlong = satLong -LHAmax + Math.random()*2*LHAmax;
		ESlong = pm180(ESlong);
		//trace("In randomESlongitude20: satLong "+satLong+", latAbs = "+latAbs+", LHAmax = "+LHAmax+", ESlong = "+ESlong);
		return ESlong;
	}
	public static function DIRECTVdB2IRD(dB){
		/// Curve fit measured dB down from peak to IRD value.
		var curve = 0.0314*dB*dB*dB - 0.0034*dB*dB + 1.0699*dB + 97.959;
		var IRD = Math.max(0, Math.min(curve, 100) );
		return IRD;
	}
	public static function DIRECTV_CN2IRD(CNdB){
		// Based on measured data on DIRECTV 101 (DSS) with SuperBuddy, 12 May 2009
		if (CNdB > 17){
			return 100;
		}
		if (CNdB < 5){
			return 0; // No lock
		}
		var curve =  -0.4916*CNdB*CNdB + 16.257*CNdB - 34.086;
		var IRD = Math.max(0, Math.min(curve, 100) );
		//trace("CNdB = "+CNdB+", curve = "+curve);
		return IRD;
	}
		
	
	public static function SpaceTrackPointingLossToAGC( signaldBm, inputAttendB, offSatPct ){
		/* Converts signal level to AGC value in Schlumberger SpaceTrack tracking receiver
		CNmax = C/N when signaldB = 0 and input att = 0;
		
		AGC = 100:  signal = -25;
		AGC =  0: signal = -85;
		Linear formulas:
		AGC = 100 + (sig+25)*100/60
		Sig = (60/100)*(AGC-100) - 25
		*/
		var PsigW = dBW2W( signaldBm - inputAttendB);
		var offSatdB = (60/100)*(offSatPct-100) - 25; //(offSatPct-100)/scalePctPerdB;
		var PnoiseWSigma = dBW2W( offSatdB );
		var a = randGaussian(); // Amplitude
		var PnoiseW = PnoiseWSigma * (1 +a*a * 0.1);
		var CNdB = W2dBW( PsigW+PnoiseW );
		var AGC = minmax(  (100 + (CNdB+25)*100/60 ), 0, 100);  
		//trace("signaldB = "+signaldBm +", PsigW = "+PsigW+", offSatdB = "+offSatdB +", PnoiseW = "+PnoiseW+", PnoiseWSigma = "+PnoiseWSigma+", CNdB = "+CNdB+", AGC = "+AGC);
		return AGC;		
	}
	public static function iDirectCNtoPWMVolts(CNR, sigLevel, sigLevelBaseline){
		/* Converts CNR and signal level in dB to the PWM voltage dislplayed and output by the iDirect iNFINITY IDU
		Voltage display behavior per Venu Eyyunni (iDirect engineering):
		In lock: 
			V = CNR/2 + 11.    CNR = 2*(V-11).  E.g. V=12, CNR=2.  V-15, CNR = 8.
			11 < V < 22.  
			Typical lock threshold at CNR = 7 for QPSK.  CNR is defined in the signal bandwidth.
			Bar is green.
			Scale is 2 dB per volt.
		Out of lock: 
			V = ( P(rf) - P(cold sky) )/ 2  + 0.3
			2 < V < 8.3
			P is defined as wideband RF power at the IF input to demod.  
			P(cold sky) is the value capture when user clicks OK in the initial dialog.
			Bar is yellow 
			V >= 2.0V
			Scale is 2 dB per volt.
		No signal at all:
			0.3 < V < 2V
			Bar is red
			Return 0.3V
		*/
		var volts;
		var CNRlock = 7;
		var dS = sigLevel- sigLevelBaseline;
		if (CNR >= CNRlock ){
			// Locked.
			volts = 11 + (CNR / 2 );
			volts = Math.min(volts, 22);
		} else {
			volts = 0.3 +  dS/2;
			volts = Math.max(volts, 0.3); // Show min level of 0.3V
			volts = Math.min(volts, 8.3); // Show max level of 8.3V
			if (volts < 2 ){
				volts = 0.3;
			}

		}
		return volts
	}
	
	public static function CNR2iDirectVoltage( CNR, CNRlock, tunedToCorrectCarrier, totalWidebandPowerdBm, coldSkyWidebandPowerdBm ){
		var dS = totalWidebandPowerdBm - coldSkyWidebandPowerdBm;
		var volts:Number;
		if (CNR >= CNRlock && tunedToCorrectCarrier){
			// Locked.
			volts = 11 + (CNR / 2 );
			volts = minmax(volts, 11, 22);
		} else {
			volts = 0.3 +  dS/2;
			volts = minmax(volts, 0.3, 8.3); 
			if (volts < 2 ){
				volts = 0.3;
			}
		}
		return volts;
	}
	
	public static function EsNo2HNSQF( e, _EsNoThreshold, _tunedToLockableCarrier, _tunedToCorrectCarrier, _totalWidebandPowerdBm, zeroSQFPowerdBm ){
		/*
		Curve fits for SQF display when locked to a DVB-S2 signal.
		From document: 
			DVB-S2 ACM SQF Scaling Proposal
			HNS-34654
			Version A.02
			February 28, 2006
		SQF = 31; x < 1.0
		SQF = -0.0044x3 + 0.1799x2 + 1.7624x + 29.179; 1.0 <= x < 7.0
		SQF = 0.0002x5 - 0.0068x4 - 0.0498x3 + 2.6498x2 - 15.154x + 54.645;  7.0<= x <= 12.3
		SQF = 0.0171x3 - 0.8868x2 + 16.367x - 8.9147;  12.3 < x <= 19
		SQF = 99 ; x > 19
		
		Inputs:
			e 	Es/No
			_EsNoThreshold		Typically 1
			_tunedToLockableCarrier  boolean
			_tunedToCorrectCarrier	boolean
			_totalWidebandPowerdBm	-50 dBm gives 29 SWF; 1 SQF unit per dB
			zeroSQFPowerdBm -80 gives similar result as previous version without this parameter.
		E.g.
		
			Util3.EsNo2HNSQF(EsNo, 1, true, true, -60)
		*/
		var _SQF;
		if ( e < 1 ){
			_SQF = 31;
		} else if ( e >=1 && e < 7.0){
			_SQF = -0.0044*e*e*e + 0.1799*e*e + 1.7624*e + 29.179;
		} else if ( e >= 7.0 && e <= 12.3 ){
			_SQF = 0.0002*e*e*e*e*e - 0.0068*e*e*e*e - 0.0498*e*e*e + 2.6498*e*e - 15.154*e + 54.645;
		} else if ( e > 12.3 && e <= 19 ){
			_SQF = 0.0171*e*e*e - 0.8868*e*e + 16.367*e - 8.9147; 
		} else {
			_SQF = 99;
		}
		
		if ( e > _EsNoThreshold && _tunedToLockableCarrier ){
			if ( ! _tunedToCorrectCarrier ){
				_SQF = 30; // Locked on wrong carrier
			}
		} else {
			
			//_SQF = 29 + _totalWidebandPowerdBm - (-50);  // S+N = -50: SQF = 30.  1 dB per dB.
			_SQF = _totalWidebandPowerdBm - zeroSQFPowerdBm; 
			// Limit to the range 0-29
			_SQF = Math.min(_SQF, 29);
			_SQF = Math.max(_SQF, 0);
		}
		
		return _SQF;
	}
	
	public static function minmax(val, min, max){
		return Math.max(min, Math.min(val, max));
	}
	public static function skinDepthInchesCu(fGHz){
		// From Van Valkenburg, Ref Data fro Radio Engineers, p. 6-7
		var f = fGHz * 1E6;
		return (2.60 / Math.sqrt(f) );
	}
	public static function min(val):Number{
		// Minimum value of array
		if (val is Array){
			if (val.length <=0){
				return NaN;
			} else if (val.length == 1){
				return val[0];
			} else {
				var v = val[0];
				for (var i=1; i<val.length; i++){
					v = Math.min(v, val[i]);
				}
				return v;
			}
		} return Math.min(val);
	}
	public static function max(val):Number{
		// Minimum value of array
		if (val is Array){
			if (val.length <=0){
				return NaN;
			} else if (val.length == 1){
				return val[0];
			} else {
				var v = val[0];
				for (var i=1; i<val.length; i++){
					v = Math.max(v, val[i]);
				}
				return v;
			}
		} return Math.min(val);
	}
	public static function listAllChildren(obj){
		var N = obj.children.length;
		trace("Obj name "+obj.name+" has "+N+" children:");
		for (var i=N-1; i>=0; i--){
				//trace("Removing child no. "+i+", child obj = "+obj.children[i]+", name = "+obj.children[i].name);
			trace(obj.children[i].name);
		}
		
	}
	public static function clearMovieClip(mc){
		// Example: Util3.clearMovieClip(myMovieClip);
		try {
			//trace ('before : '+mc.numChildren);
			while(mc.numChildren)
			{
				mc.removeChildAt(0);
			}
			//trace ('   after : '+mc.numChildren);
		} catch (error:Error){
			
		}
	}
	public static function disableMouseOnAllChildren(obj){
		// Disables mouse on all children of this object.  Useful to prevent mouse from responding to any text fields in a symbol.
		// NOTE: mouseChildren = false seems to work better!
		var N = obj.numChildren;
		for (var i=0; i<N; i++){
			trace(obj.getChildAt(i).name);
			try {
				obj.getChildAt(i).mouseEnabled = false;
				trace("  Disabled mouse in "+obj.getChildAt(i).name);
			} catch (error:Error) {
				// In case this child does not support the mouseEnabled property.
				trace("  Failed to disable mouse in "+obj.getChildAt(i).name);
			}
		}
		
	}
	public static function clearArray(a){
		// Removes all elements from an array.
		var N = a.length;
		if (N>0){
			for (var i=0; i<N; i++){
				a.pop();
			}
		}
	}
	public static function fillArray( A:Array, f ){
		// Fills array A with the value f
		var B:Array = new Array();
		if (A.length > 0) {
			for (var i=0; i<A.length; i++){
				B[i] = f;
			}
		} else {
			B = [];
		}
		return B;
	}
	public static function newFilledArray( len:int, f ):Array{
		// Makes a new array of length len, filled with the value f
		var B:Array = [];
		if (len > 0) {
			for (var i:int=0; i<len; i++){
				B[i] = f;
			}
		} 
		trace("In newFilledArray, len = "+len + ", f = "+f+", B = "+B);
		return B;
	}
	
	public static function ratioAbs(a, b){
		// Abs value of the ratio, always >= 0.  e.g. ratioAbs(1, 1.2) = 0.2
		// 123, 0 --> 1e99
		// 0, 0 --> 0
		// 0, 123 --> 1e99
		
		if (b == 0 && a == 0){
			return 0;
		} else if (b == 0 && a!= 0){
			return 1e99;
		} else if (a == 0 && b!= 0){
			return 1e99;
		} else {
			var r = Math.abs(a) / Math.abs(b);
			if (r < 1 ){
				r = 1/r;
			}
			//trace("a = "+a+", b = "+b+", r = "+r);
			return r-1;
		}
	}
	public static function rss(a, b){
		// sqrt of (a^2 + b^2)
		return (Math.sqrt( a*a + b*b ) );
	}
	public static function distanceBetween(a, b):Number{
		// sqrt of (a^2 + b^2)
		// Should work if a and b are Point or MovieClip
		return (Math.sqrt( (b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y) ) );
	}

	public static function filterGaussian(w:Number):Array{
	// Gaussian weighting filter net gain - power transfer function
	// width w should be an odd number
	// 
		var result:Array = new Array();
		var fc:Number, i:Number, f:Number, h:Number, w2:Number, b:Number, cum:Number;
		if( w<= 1){
			result[0] = 1;
		}else{
			cum = 0;
			fc = Math.ceil(w/2);
			w2 = Math.floor(w/2);
			b = w2;
			//trace("w = "+ w + ", fc = " + fc+ ", w2 = " +  w2+ ", b = " +  b );
			for (i=0; i<w; i++){
				f = i - fc + 1;
				h = Math.pow( Math.exp( -(f*f)/(b*b )), 2 );
				//trace("   "+i+ ", f = " +  f+ ", h = " +  h);
				result[i] = h;
				cum += h;
			}
			// Do not normalize!  Should be 1 at center.
			/*
			//Now force integrated power to equal w:
			for (i=0; i<w; i++){
				result[i] *= w/cum;
			}
			*/
		}
		//trace(result);
		return result;
	}
	public static function filterGaussian2(w:Number, b:int):Array{
	// Gaussian weighting filter net gain - power transfer function
	// Total width w should be an odd number
	// Bandwidth is b
	// Center is at w/2
		var result:Array = new Array();
		var fc:Number, i:Number, f:Number, h:Number, w2:Number, cum:Number;
		if( w<= 1){
			result[0] = 1;
		}else{
			cum = 0;
			fc = Math.ceil(w/2);
			w2 = Math.floor(w/2);
			//trace("w = "+ w + ", fc = " + fc+ ", w2 = " +  w2+ ", b = " +  b );
			for (i=0; i<w; i++){
				f = i - fc + 1;
				h = Math.pow( Math.exp( -(f*f)/(b*b )), 2 );
				//trace("   "+i+ ", f = " +  f+ ", h = " +  h);
				result[i] = h;
				cum += h;
			}
			// Do not normalize!  Should be 1 at center.
		}
		//trace(result);
		return result;
	}
	public static function filterGaussian3(len:int, b:Number, fc:Number, gain:Number):Array{
	// Gaussian weighting filter net gain - power transfer function
	// Total width w should be an odd number
	// Bandwidth is b
	// Center is at w/2
		var result:Array = new Array();
		var i:Number, df:Number, h:Number;
		//, w2:Number, cum:Number;
		//fc = Math.ceil(w/2);
		//w2 = Math.floor(w/2);
		//trace("w = "+ w + ", fc = " + fc+ ", w2 = " +  w2+ ", b = " +  b );
		for (i=0; i<len; i++){
			df = i - fc;
			h = Math.pow( Math.exp( -(df*df)/(b*b )), 2 );
			//trace("   "+i+ ", df = " +  df+ ", h = " +  h);
			result[i] = gain*h;
		}
			// Do not normalize!  Should be 1 at center.
		//trace(result);
		return result;
	}
	public static function modFilter(f, symbrate, alph, filtType){
		//Raised cosine or raised root cosine filter for PSK modulation
		/* Filter will have this response:
		   = 1 for freq <= filterLowerEdge
		   = 0 for freq >= filterUpperEdge
		   = "RC" raised cos or "RRC" root raised cos for filterLowerEdge < freq < filterUpperEdge
		   Midpoint freq = symbol rate / 2
		   alpha is typically 0.2 to 0.35
		*/
		var filterMidPoint = symbrate/2;
		var filterLowerEdge = filterMidPoint* (1 - alph);
		var filterUpperEdge = filterMidPoint* (1 + alph);
		var a:Number;
		var frq:Number;
		if (filtType == "none"){
			a = 1;
			return a;
		}
		frq = Math.abs(f);
		if ( frq <= filterLowerEdge ){
			a = 1;
		}else if ( frq >= filterUpperEdge ){
			a = 0;
		}else{
			var r = (frq-filterMidPoint) / (filterUpperEdge-filterLowerEdge) ; // -1/2 to 0 to +1/2
			var theta = (r+0.5) *  Math.PI;  // 0 to pi/2 to pi
			
			if (filtType == "RC"){
				a = (1 + Math.cos(theta))/2;
				//filterCalFactordB = -11.45; // dB
			}else if (filtType == "RRC"){
				a = Math.sqrt( (1 + Math.cos(theta))/2 );
				//filterCalFactordB = -11.45; // dB
			}else{
				trace("ERROR in modFilter: invalid filter type "+filtType);
				return;
			}
		}
		return a;	
	}

	public static function rainLossSimple( rainRate ){
		// Rough approximation for loss vs. rain rate.
		// Taken from Pol20.fla
		var r:Number = 1.3 * Math.max(0, Math.min( rainRate, 100) ); // Bound it to 0-100;
		var L:Number = (0.0367 * Math.pow(r, 1.154) );
		//trace("Fwd: rainRate = "+rainRate+", r = "+r+", L = "+L);
		//trace( rainRateSimple( L ) );
		return L;
	}
	public static function rainRateSimple( Loss_dB ){
		// Rough approximation for loss vs. rain rate.
		// Taken from Pol20.fla
		var r:Number = Math.pow( (Loss_dB/.0367), 1/1.154);
		var rainRate:Number = r / 1.3;
		//trace("... Loss_dB = "+Loss_dB+", r = "+r+", rainRate = "+rainRate);
		return rainRate;
	}
	public static function isEven(n){
		if (n % 2 == 0 ){
			return true;
		} else {
			return false;
		}
	}
	public static function freeSpaceLoss(freq_MHz, distance_km){
		var lambda = 3e8/ ( freq_MHz * 1e6 ); // meters
		var d = distance_km * 1000; // meters
		var loss = 20 * log10( 4 * Math.PI * d / lambda ); // dB
		return loss;
	}
	
	public static function dec2bin(d, maxbits:int){
		
		var B:Array = new Array(maxbits);
		for (var i=0; i<maxbits; i++){
			B[i] = 0;
		}
		var I:int = 0;
        var Q:int = d;
        do{
            B[I] = Q % 2 ;
            Q = Q / 2 ; 
            I = I + 1 ;
		} while (Q != 0);
		return B;
	}
	public static function bit(d, n){
		return ( (d>>n) & 1 );
	}

	public static function sunAzEl(param, Lon_deg, Lat_deg, yearNo, monthNo, dayNo, UTC_hrs){
		// param = "az" or "el"
		var J_days = YMDT2Jdays(yearNo, monthNo, dayNo, UTC_hrs);
		return sunAzElDecimalDays(param, Lon_deg, Lat_deg, J_days);
	}
	public static function sunAzElDaysUTC(param, Lon_deg, Lat_deg, days, UTC_hrs){
		var J_days = days + UTC_hrs/24;
		return sunAzElDecimalDays(param, Lon_deg, Lat_deg, J_days);
	}
	public static function YMDT2Jdays(yearNo, monthNo, dayNo, UTC_hrs){
		var d0_days = 367*yearNo - Math.floor( (7/4)*(yearNo+ Math.floor((monthNo+9)/12)) ) + Math.floor(275*monthNo/9) + dayNo -730531.5; 
		var J_days = d0_days + UTC_hrs/24;  // No of days before J2000 at this UTC 
		return J_days;
	}
	//public static function sunAzEl2(param, Lon_deg, Lat_deg, yearNo, monthNo, dayNo, UTC_hrs){
	public static function sunAzElDecimalDays(param, Lon_deg, Lat_deg, J_days){
		
		/* From http://www.stargazing.net/kepler/sun.html		
		'*********************************************************
		QBASIC program by Keith Burnett (kburnett@geocity.com)
		This program will calculate the position of the Sun using a low precision method found on page C24 of the
	    1996 Astronomical Almanac.
		The method is good to 0.01 degrees in the sky over the period 1950 to 2050.*/		

		//d_days =  367 * yearNo - 7 * (yearNo + (monthNo+9) \ 12) \ 4 + 275 * monthNo \ 9 + dayNo - 730531.5 + UTC_hrs/ 24;
		// Get the no of days before J2000 at midnight UTC for this date: 
		//var d0_days = 367*yearNo - Math.floor( (7/4)*(yearNo+ Math.floor((monthNo+9)/12)) ) + Math.floor(275*monthNo/9) + dayNo -730531.5; 
		//var d_days = d0_days + + UTC_hrs/24;  // No of days before J2000 at this UTC 
		var d_days = J_days;
		var d0_days = Math.floor(d_days);
		var UTC_hrs = 24 * (d_days - d0_days);
		//trace("d0_days = "+d0_days+" UTC_hrs = "+UTC_hrs);
		var L_deg = modulo1( 280.461 + .9856474 * d_days, 360); //mean longitude of the Sun.  Need to convert to 0-2pi
		var g_deg = modulo1( 357.528 + .9856003 * d_days, 360 ); //  mean anomaly of the Sun
		var lambda_deg = modulo1(L_deg + 1.915*Math.sin(radians(g_deg)) + .02 * Math.sin(radians(2*g_deg)), 360); //Ecliptic longitude of the Sun. Ecliptic latitude is assumed to be zero by definition
		var epsilon_deg = 23.439  - .0000004 * d_days; // Obliquity of the ecliptic
		var alpha_rad = Math.atan2( Math.cos(radians(epsilon_deg)) * Math.sin(radians(lambda_deg)),  Math.cos(radians(lambda_deg)) );// Right ascension:
		var delta_rad = Math.asin(  Math.sin(radians(epsilon_deg)) * Math.sin(radians(lambda_deg)) );// Declination:
		var alpha_deg = degrees( alpha_rad );
		var delta_deg = degrees( delta_rad );
		
		// Now we need to convert to local az-el coordinates.
		
		var T0 = d0_days / 36525; //number of Julian centuries To from J2000.0 
		var S0 = 6.6974 + 2400.0513*T0; // The sidereal time So (in hours) for the meridian of Greenwich, at midnight (00h) UT 
		var SG = S0 + (366.2422 / 365.2422)* UTC_hrs; //The sidereal time SG of the Greenwich meridian, at our time
		var Lon_hrs = Lon_deg / 15; 
		var S = SG + Lon_hrs; //    local sidereal time S (hours) for the geographical longitude (in hours)
		// The definition of the sidereal time S = Object's Hour Angle  + Right Ascension
		var H = S - alpha_deg/15; // Sun's hour angle (hours)
		var H_rad = radians( H * 15 ); //
		var Lon_rad = radians(Lon_deg);
		var Lat_rad = radians(Lat_deg);
		var Y = Math.sin(H_rad)*Math.cos(delta_rad);
		var X = Math.cos(Lat_rad)*Math.sin(delta_rad) - Math.sin(Lat_rad)*Math.cos(delta_rad)*Math.cos(H_rad);
		var az_deg = degrees( Math.atan2( -Y, X ) );
		var el_rad = Math.asin(Math.sin(Lat_rad)*Math.sin(delta_rad) + Math.cos(Lat_rad)*Math.cos(delta_rad)*Math.cos(H_rad));
		var el_deg = degrees( el_rad );
		

		
		/*
		Test case:
		yearNo = 1997;
		monthNo = 8;
		dayNo = 7;
		UTC_hrs = 11.0;

		Results:
		L = 136.00716 deg
		g = 213.11547 deg
		*/
		/*
		trace("Lambda = "+lambda_deg); // = 134.97925
		trace("epsilon = "+epsilon_deg); // = 23.439351
		trace("alpha = "+alpha_deg); // = 137.44352 deg
		trace("delta = "+delta_deg); // = 16.342193
		trace("az = "+az_deg);
		trace("el = "+el_deg);
		*/
		var res;
		if ( param == "az" ){
			res = az_deg;
		}else if(param == "el"){
			res = el_deg;
		}else if(param == "RA"){
			res = alpha_deg;
		}else if(param == "dec"){
			res = delta_deg;
		}
		return res;
	}
	public static function modulo1( a, b){
		return a - b* Math.floor( a/b);
	}
	public static function ellipseR(thetaDeg, majorDia, minorDia){
		// Radius from center to ellipse.
		var ct = Math.cos(radians(thetaDeg));
		var st = Math.sin(radians(thetaDeg));
		var a = majorDia/2;
		var b = minorDia/2;
		var r = a*b / Math.sqrt( b*b*ct*ct + a*a*st*st );
		return r;
	}
	public static function ellipseArea(majorDia, minorDia){
		// Area of ellipse
		return (Math.PI * (majorDia/2)*(minorDia/2) );
	}
	public static function scrollPercent(MCToScroll, ScrollPercent){
		// Move on Y position in percents.
		//trace((MCToScroll.height/100) * ScrollPercent);
		return ((MCToScroll.height/100) * ScrollPercent);
	}

	public static function obstructionHeight(dist, elevation, antDia, antMidHeight, diaMarginRatio, angMargin){
		// Clearance height
		var r = (diaMarginRatio + 0.5)* antDia;
		var e = elevation - angMargin;
		var h = dist * Math.tan(radians(e));
		var ht = h - r*Math.cos(radians(e)) + antMidHeight;
		if (dist < 2 * antDia ){
			ht = 0;
		}
		//trace("dist = "+dist+", el = "+elevation+", r = "+r+", e = "+e+", h = "+h+", ht = "+ht);
		return ht;
	}
	public static function obstructionDistance(ht, elevation, antDia, antMidHeight, diaMarginRatio, angMargin){
		// Clearance distance
		var r = (diaMarginRatio + 0.5)* antDia;
		var e = elevation - angMargin;
		var h = ht + r*Math.cos(radians(e)) - antMidHeight;
		
		var distCalc = h / Math.tan(radians(e));
		var dist = Math.max(distCalc, 2 * antDia);
		//trace("dist = "+dist+", el = "+elevation+", r = "+r+", e = "+e+", h = "+h+", height = "+ht);
		return dist;
	}
	public static function coaxTemperatureLossFactorFrom20C(T){
		// From Andrew Heliax catalog.  Assumes copper conductors. 
		// Multiply the result by the actual loss in dB.
		return (Math.sqrt(1 + 0.00393*(T-20))) / 1.00977777;
	}

	public static function SeaTelSettings2Pointing( azSetting, clSetting, elSetting, cantAngle ):Vector3D{
		// See RB Notebook #1, p. 140-143; also SeaTel\Spherical trig calculations.xlsx
		var ELdeg = elSetting;
		var CLdeg = clSetting;
		var AZdeg = azSetting;
		var Cdeg = cantAngle;
		
		var EL = radians(ELdeg);
		var CL = radians(CLdeg);
		var AZ = radians(AZdeg);
		var C = radians(Cdeg);
		
		var a;
		var b;
		var h;
		var tol = 1E-6;
		var dAbs;
		var h_AZ_abs;

		//trace("h_AZ_abs = "+Util3.degrees(h_AZ_abs)+", h_AZ = "+Util3.degrees(h_AZ)+", h = "+Util3.degrees(h) );
		var Cp = Math.PI/2 - C;
		var cos_ap;
		var ap;
		var h_Az, hanum, haden, cos_ha;
		var bp, bpnum, bpden, cos_bp;
		
		cos_ap = Math.cos(EL)*Math.cos(Cp) + Math.sin(EL)*Math.sin(Cp)*Math.cos(CL);
		ap = Math.acos(cos_ap);
		a = Math.PI/2 - ap;
		if (EL == 0){
			b = CL;
			h_Az = 0;
		} else {
			bpnum = Math.cos(Cp) - Math.cos(EL)*Math.cos(ap);
			bpden = Math.sin(EL)*Math.sin(ap);
			cos_bp = bpnum / bpden;
			if (Math.abs(cos_bp)>1){
				if (Math.abs(cos_bp)>1.000000001){
					trace("WARNING: In SeaTelSettings2Pointing, cos(bp) = "+cos_bp+", a = "+a);
				}
				cos_bp = sign(cos_bp);
			}
			bp = Math.acos( cos_bp ) * Util3.sign(EL);
			b = (Math.PI - bp)*Util3.sign(CL);
			
			hanum = Math.cos(EL) - Math.cos(ap)*Math.cos(Cp);
			haden = Math.sin(ap)*Math.sin(Cp);
			cos_ha = hanum / haden;
			if (Math.abs(cos_ha)>1){
				if (Math.abs(cos_ha)>1.000000001){
					trace("WARNING: In SeaTelSettings2Pointing, cos(h-Az) = "+cos_ha); // 1.0000000000000004 max observed
				}
				cos_ha = sign(cos_ha);
			}
			h_Az = Math.acos( cos_ha ) * Util3.sign(EL)* Util3.sign(CL);
		}
		h = h_Az + AZ;
		
		
		var headingDeg = Util3.degrees(h);
		var attitudeDeg = Util3.degrees(a);
		var bankDeg = -Util3.degrees(b); // Changed to negative 8/11/2011 RB
		 
		if (isNaN(headingDeg) || isNaN(attitudeDeg) || isNaN(bankDeg) ){
			trace("ERROR in Util3.SeaTelSettings2Pointing: headingDeg = "+headingDeg+", attitudeDeg = "+attitudeDeg+", bankDeg = "+bankDeg);
		}
		if ( attitudeDeg > 90 ){
			//trace("WARNING: in Util3.SeaTelSettings2Pointing: headingDeg = "+headingDeg+", attitudeDeg = "+attitudeDeg+", bankDeg = "+bankDeg);
		}
		var hab:Vector3D = new Vector3D(headingDeg, attitudeDeg, bankDeg);
		//trace("In 2HAB:\n   AZ = "+AZdeg+", EL = "+ELdeg+", CL = "+CLdeg+", cant = "+Cdeg+"\n"+
		//	  "   --> h = "+headingDeg+", a = "+attitudeDeg+", b = "+bankDeg+", dAbs = "+Util3.degrees(dAbs) );
		return hab;
	}
	
	public static function SeaTelPointing2Settings( hab:Vector3D, cantAngle ):Vector3D{
		// See RB Notebook #1, p. 140-143; also SeaTel\Spherical trig calculations.xlsx
		var hDeg = hab.x;
		var aDeg = hab.y;
		var bDeg = -hab.z; // Changed to negative 8/11/2011 RB to reverse sense for CW pol vs quaternion rotation angle.
		
		var C = Util3.radians(cantAngle);
		var h = Util3.radians(hDeg);  // Desired heading (pointing az)
		var a = Util3.radians(aDeg);  // Desired attitude (pointing el - cant)
		var b = Util3.radians(bDeg); // Desired bank (pointing pol)
		
		var CL:Number, CLdeg:Number;
		var EL:Number, ELdeg:Number;
		var AZ:Number, AZdeg:Number;
		var h_AZ:Number;
		
		var ap = Math.PI/2 - a;
		var Cp = Math.PI/2 - C;
		var bp = Math.PI - b;
		var sinCL = Math.asin(  Math.sin(ap) * Math.sin(bp) / Math.sin(Cp) );
		CL = Math.asin(sinCL );
		
		var w = Math.asin(  Math.sin(bp) * Math.sin(ap) );
		var h2 = Math.asin(  Math.cos(bp) / Math.cos(w) );
		var EL2 = Math.asin( Math.sin(h2) * Math.sin(ap) );
		if (a < 0 ){
			EL2 = -Math.PI - EL2;
		}
		var EL1 = Math.acos(  Math.cos(Cp) / Math.cos(w) );
		var h1 = Math.asin( Math.sin(EL1) / Math.sin(Cp) );
		var h_AZ_1 = h1+h2;
		h_AZ = h_AZ_1 * Util3.sign(CL);
		AZ = h - h_AZ;
		EL = EL1 + EL2;
		
		//trace("h = "+hDeg+", w = "+Util3.degrees(w)+", h2 = "+Util3.degrees(h2)+", h1 = "+Util3.degrees(h1)+", EL1 = "+Util3.degrees(EL1)+", EL2 = "+Util3.degrees(EL2)+", h_AZ = "+Util3.degrees(h_AZ) );
		//trace("CL = "+Util3.degrees(CL)+", EL = "+Util3.degrees(EL)+", AZ = "+Util3.degrees(AZ) );
		
		CLdeg = Util3.degrees(CL);
		ELdeg = Util3.degrees(EL);
		AZdeg = Util3.degrees(AZ);
		//trace("In 2Settings:\n"+
		//	  "   --> h = "+hDeg+", a = "+aDeg+", b = "+bDeg+", dAbs = "+Util3.degrees(dAbs)+"\n"+
		//	  "       AZ = "+AZdeg+", EL = "+ELdeg+", CL = "+CLdeg+", cant = "+cantAngle  );
		if (isNaN(AZdeg) || isNaN(ELdeg) || isNaN(CLdeg) ){
			trace("ERROR in Util3.SeaTelPointing2Settings: AZdeg = "+AZdeg+", ELdeg = "+ELdeg+", CLdeg = "+CLdeg);
		}
		
		var AzElCl:Vector3D = new Vector3D(AZdeg, ELdeg, CLdeg);
		return AzElCl;
	}
	public static function SpaceTrackSettings2Pointing( CASetting, ELSetting, FASetting, PZSetting ):Vector3D{
		// See RB Notebook #2, p. 194;
		var CAdeg = CASetting;
		var ELdeg = ELSetting;
		var FAdeg = FASetting;
		var PZdeg = PZSetting;
		
		var CA = radians(CAdeg);
		var EL = radians(ELdeg);
		var FA = radians(FAdeg);
		var PZ = radians(PZdeg);
		var PZc = radians(90-PZdeg);
		var pi2 = Math.PI/2;
		
		var pp, p, e, a;
		if (FA == 0){
			pp = 0;
			p = PZ + pp;
			e = EL;
			a = CA;
		}else if (ELdeg == 90 ){
			e = pi2 - Math.abs(FA);
			if (FA>=0){
				a = CA + pi2;
				p = PZ + pi2;
			} else {
				a = CA - pi2;
				p = PZ + pi2;
			}
		} else {
			var sin_e = Math.sin( EL) * Math.cos(FA);
			e = Math.asin(sin_e);
			var sin_aCA = Math.sin(FA) / Math.cos(e); // sin(a-CA);
			a = Math.asin(sin_aCA) + CA;
			pp = Math.acos(Math.sin(pi2-EL)/Math.sin(pi2-e));
			p = PZ + pp;
		}
		
		var aDeg = degrees(a);
		var eDeg = degrees(e);
		var pDeg = degrees(p);
		return (new Vector3D(aDeg, eDeg, pDeg)); // HAB sequence
	}
	public static function SpaceTrackPointing2Settings( hab:Vector3D, CAsetting ):Vector3D{
		// See RB Notebook #2, p. 194;
		var aDeg = hab.x;
		var eDeg = hab.y;
		var pDeg = hab.z;
		var CAdeg = CAsetting;
		
		var a = radians(aDeg)
		var e = radians(eDeg);
		var p = radians(pDeg);
		var CA = radians (CAdeg);

		var FA, EL, PZ, pp;
		if (aDeg == CAdeg){
			FA = 0;
			EL = e;
			PZ = p;
		} else {
			FA = Math.asin( Math.sin(a-CA) * Math.cos(e) );
			EL = Math.asin( Math.sin(e) / Math.cos(FA) );
			pp = Math.acos( Math.cos(EL) / Math.cos(e) );
			PZ = p - pp;
		}
		
		var ELdeg = degrees(EL );
		var FAdeg = degrees(FA);
		var PZdeg = degrees(PZ);
		
		return (new Vector3D(CAdeg, ELdeg, FAdeg, PZdeg)); //
	}
	
	
	public static function RL2seriesXL( RLdB, Z0 ){
		// Converts RL (+) in dB to an equivalent series inductive reactance
		var gammaMag = dB2Vratio( -RLdB );
		var gammaPsq = 1/(gammaMag*gammaMag);
		
		var X = 2*Z0 / Math.sqrt( gammaPsq -1 );
		return X;
	}
	public static function shuffledArray(len){
		// Returns an array containing integers 0...len in random order (nonrepeating)
		var temp:Array = new Array();
		var i:int, r:int;
		for (i=0; i<len; i++){
			temp.push(i);
		}
		var shuffled:Array = new Array();
		while (temp.length >0 ){
			r = Math.floor( Math.random()*temp.length );
			shuffled.push( temp[r] ); // Copy this element to the shuffled list
			temp.splice(r,1); // Delete it from the ordered list
		}
		return shuffled;
	}
	public static function ka_cloud_loss(t, tOffset, maxLoss, timeScale){
		var T1 = 13;
		var T2 = 17;
		var T3 = 23;
		var a1 = maxLoss * 0.15;
		var a2 = maxLoss * 0.1;
		var a3 = maxLoss * 0.25;
		var ph1 = 360*(t-tOffset)/(T1*timeScale);
		var ph2 = 45 + 360*(t-tOffset)/(T2*timeScale);
		var ph3 = 82 + 360*(t-tOffset)/(T3*timeScale);
		
		var a = (maxLoss/2) + a1*Math.sin( radians(ph1) ) + a2*Math.sin( radians(ph2) ) + a3*Math.sin( radians(ph3) );
		//trace("a = "+a);
		return a;
	}
	public static function blockedZone(RELAZ, EL, AZ1, AZ2, EL12, AZ3, AZ4, EL34, AZ5, AZ6, EL56){
		// Returns zone number (1-3) if RELAZ and el are within that zone.  If not blocked, returns 0.
		
		var relAz = mod360(RELAZ);
		var retcode = 0;
		var aStart, aEnd, elLim;
		for (var izone = 1; izone<=3; izone++){
			switch (izone){
				case 1:
					aStart = AZ1;
					aEnd = AZ2;
					elLim = EL12;
					break;
				case 2:
					aStart = AZ3;
					aEnd = AZ4;
					elLim = EL34;
					break;
				case 3:
					aStart = AZ5;
					aEnd = AZ6;
					elLim = EL56;
					break;
			}
			aStart = mod360(aStart);
			aEnd =  mod360(aEnd);
			if (aEnd < aStart){
				aEnd += 360;
			}
			
			if ( ((relAz >= aStart && relAz < aEnd) ||  (relAz+360 >= aStart && relAz+360 < aEnd) )&& EL <= elLim ){
				retcode = izone;
			}
		}
		
		//trace("relAz = "+relAz+", AZ1 = "+AZ1+", az2 = "+az2+", az3 = "+az3+", az4 = "+az4+", az5 = "+az5+", az6 = "+az6+", retcode = "+retcode);
		return retcode;
	}
	public static function extractSWFfromPath(orig:String){
		/* Test strings:
		file:///C|/Users/SatProf/Documents/Satprof/SVNContent/Content/Site3_review-X.swf/[[asdfsdf]]/3/9
		file:///C|/FlashProjects/Protector/out/protected%5Ftestparams.swf/[[DYNAMIC]]/1/[[DYNAMIC]]/2/[[DYNAMIC]]/3/[[DYNAMIC]]/4/[[DYNAMIC]]/5
		file:///E|/My%20Documents/SatProf/SVNContent/Content/HCCTracking5.swf/[[DYNAMIC]]/3
		file:///E|/My%20Documents/SatProf/SVNContent/Content/HCCTracking5.swf/
		file:///E|/My%20Documents/SatProf/SVNContent/Content/HCCTracking5.swf
		
		file:///E|/My%20Documents/SatProf/SVNContent/Content/GVFCerts%5Ffixed.swf
		*/
		//trace("  Test: _SWFfullPath = "+_SWFfullPath);
		//debugTxt("_SWFfullPath = "+_SWFfullPath); ////
	
		var dbracketpos = orig.indexOf("[[");
		//trace("dbracketpos = "+dbracketpos);
		if (dbracketpos>= 0){
			orig = orig.substring(0,dbracketpos);
		}
		//trace("orig = "+orig);
		if (orig.substr(orig.length-1,1) == "/"){
			orig = orig.substr(0, orig.length-1);
		}
		//trace("orig = "+orig);
		var slashpos = Math.max( orig.lastIndexOf("/"), orig.lastIndexOf('\\') );
		var dotpos =  orig.lastIndexOf(".");
		var fstart, fend;
		if (slashpos < 0){
			fstart = 0;
		} else {
			fstart = slashpos+1;
		}
		if (dotpos < 0){
			fend = orig.length;
		} else {
			fend = dotpos;
		}
		if (dotpos <= slashpos){
			// Dot must be within a folder, and no extenstion was given.
			fend = orig.length;
		}
		
		var f = orig.substring(fstart, fend);
		f =  f.split("%5F").join("_").split("%2D").join("-"); // Substitute
		f = decodeURI(f); // Replace escape seqs with characters
		
		//trace("orig = "+orig+", slashpos = "+slashpos+", dotpos = "+dotpos+", f = "+f);
		//trace("In extractSWFfromPath, orig = "+orig+", returning "+f);
		return f;
		/*
		
		var _SWFlastIndex = _SWFfullPath.length-4//_SWFfullPath.lastIndexOf(".swf");
		trace("  _SWFlastIndex = "+_SWFlastIndex);
		var _SWFfileName = _SWFfullPath.slice(0,_SWFlastIndex);  // Chop off everything after last .swf
		trace("  _SWFfileName = "+_SWFfileName);
		
		_SWFlastIndex = Math.max( _SWFfileName.lastIndexOf("/"), _SWFfileName.lastIndexOf('\\') );
		trace("  _SWFlastIndex = "+_SWFlastIndex);
		_SWFfileName = _SWFfileName.slice(_SWFlastIndex+1,_SWFfullPath.length);  // Chop off everything before last /
		trace("  _SWFfileName = "+_SWFfileName);
		_SWFfileName =  _SWFfileName.split("%5F").join("_").split("%2D").join("-"); // Substitute
		trace("  _SWFfileName = "+_SWFfileName);
		_SWFfileName = decodeURI(_SWFfileName); // Replace escape seqs with characters
		trace("  _SWFfileName = "+_SWFfileName);
		//_SWFfileName = _SWFfileName.slice(0, _SWFfileName.length-4); // Chop off the .swf
		trace("  _SWFfileName = "+_SWFfileName);
		return _SWFfileName;
		*/
		
	}
	public static function clipper(parameter, Input_power_dB, Small_signal_gain_dB, Limit_level_dB){
		/* Calculates large signal gain of an ideal clipper.
		Clips the voltage or current at a defined level such that output power approaches Limit_level_dB

		Inputs:
			Parameter
				"gain" returns large signal gain
				"Pout" returns output power
			Input_power_dBW = input power in dB (same units as limit level)
			Small_signal_gain_dB = small signal gain of the clipper
			Limit_level_dB = the output power in limiting
		Returns:
			Large signal gain at given input power. (Same units as input power and limit level)
		*/
		var Theta_c;
		var pi = Math.PI;
		
		var A = Math.sqrt(2 * Math.pow(10,(Input_power_dB / 10))); // Input amplitude
		var G = Math.pow(10, (Small_signal_gain_dB / 20)); //Voltage gain
		var k = Math.pow(10, (Limit_level_dB / 20)); // Output voltage clipping level in a 1 ohm system

		if ( (A * G) > k) {
    		Theta_c = Math.asin( k / (A * G));
		}else{
    		Theta_c = pi / 2;
		}

		var p = A*A * G*G * ((Theta_c / pi) - (Math.sin(2*Theta_c)) / (2*pi)) + k*k*(1 - 2*Theta_c/pi);

		var P_dB = 10 * log10(p);

		if (parameter == "Pout"){ 
    		return P_dB;
		} else if (parameter == "gain") {
    		return (P_dB - Input_power_dB);
		} else {
    		trace( "Error - invalid parameter type in function Clipper: " + parameter );
		}
	}
	public static function equalToNplaces(a, b, N:int){
		// Returns true if a and b a equal to N decimal places.
		var m:int = Math.pow(10,N);
		var an:Number = Number(a);
		var bn:Number = Number(b);
		return ( Math.round(an*m) == Math.round(bn*m) );
	}
	public static function equalArrays(a:Array, b:Array):Boolean{
		if (a.length != b.length){
			return false;
		}
		if (a.length == 0 && b.length == 0){
			return true;
		}
		for (var i=0; i<a.length; i++){
			if (a[i] != b[i]){
				return false;
			}
		}
		return true;
		
	}
	public static function copyOfArray(a:Array):Array{
		var b:Array = new Array(a.length);
		for (var i=0; i<a.length; i++){
			b[i] = a[i];
		}
		return b;
	}
	public static function roundToNplaces(a:Number, N:int){
		var m:int = Math.pow(10,N);
		return  Number(Math.round(a*m))/(Number(m));
	}
	public static function snapTo(a:Number, s:Number){
		var retval:Number;
		var ss:Number = Math.abs(s);
		if (ss == 0){
			retval = a;
		} else {
			retval = Number(Math.round(a/ss)) * (Number(ss));
		}
		return retval;
	}
	public static function snapPointTo(p:Point, s:Number){
		var xx = snapTo(p.x, s);
		var yy = snapTo(p.y, s);
		var pSnap:Point = new Point(xx, yy);
		//trace("p = "+p+", s = "+s+", pSnap = "+pSnap);
		return pSnap;
	}
	
	public static function polPresetCaseNo(rxPol:String, az:Number, northernHemisphere:Boolean){
		//  Returns case no (1-4) per the diagram in SP-REF-001
		var caseNo:int;
		if (rxPol == "H"){
			if ( northernHemisphere && (az <= 180) || !northernHemisphere && (az <= 360) ){
				caseNo = 1;
			} else {
				caseNo = 2;
			}
		} else {
			if ( northernHemisphere && (az <= 180) || !northernHemisphere && (az <= 360) ){
				caseNo = 3;
			} else {
				caseNo = 4;
			}
		}
		return caseNo;
	}
	public static function skyColor(timeOfDayHrs){
		var t:Number = timeOfDayHrs % 24;
		var k:Number = 0;
		var tTwilightStart = 5.25;
		var tDuskStart = 18;
		var tDuration = 0.75;
		
		if (t < tTwilightStart ){
			k = 0; // Night
		} else if (t >= tTwilightStart && t < tTwilightStart+tDuration){
			k = (t - tTwilightStart) / tDuration;
		} else if ( t >= tTwilightStart+tDuration && t < tDuskStart){
			k = 1;
		} else if (t >= tDuskStart && t < tDuskStart+tDuration){
			k = 1 - (t - tDuskStart) / tDuration;
		} else {
			k = 0;
		}
		// Midnight: k = 0: g=0, b = 150;
		// Midday: k = 1: g=204, b = 255
		var r:int = 0;
		var g:int = 150 * k;
		var b:int = 150 + (230-150) * k;
		return r*256*256 +g*256 + b;
	}
	public static function antennaNoiseTempInRain(rainFadedB:Number, Tant:Number, Tsky:Number, TgroundPhys:Number, TatmPhys:Number, TrainPhys:Number){
		// For this analysis, see RB notebook 3 p. 170
		// rainFadedB  Rain loss of rain in dB, above clear sky atmospheric loss (positive)
		// Tant     noise temp of the antenna with no rain
		// Tsky     Noise temperature of the sky with no rain (T2 in notebook)
		// TgroundPhys  Physical temperature of the ground (T1 in notebook)
		// TatmPhys     Physical temperature of the atmosphere
		// TrainPhys    Physical temperature of the rain
		
		var Grain:Number = dBW2W( -rainFadedB); // transmission coefficient (0-1)
		var Gatm:Number = 1 - Tsky/TatmPhys; /// transmission through the atmosphere, no rain
		var TskyRain:Number = Tsky*Grain + TrainPhys*(1 - Grain);  // T2' in notebook
		
		var TantRain:Number = ( TgroundPhys*(Tant - Tsky) + TskyRain*(TgroundPhys - Tant) ) / (TgroundPhys - Tsky);
		return TantRain;
	}
	public static function cloneArray(a:Array){
		var r:Array = new Array();
		for (var i=0; i<a.length; i++){
			r[i] = a[i];
		}
		return r;
	}
	public static function lineSphereIntersection( sphereCenter:Vector3D, sphereRadius:Number, lineOriginPoint:Vector3D, lineDirection:Vector3D):Vector3D{
		// From https://en.wikipedia.org/wiki/Line%E2%80%93sphere_intersection
		// Returns vector of closest intersection.
		// w = 1 if intersection is found, -1 if line does not touch sphere.
		var vO:Vector3D = lineOriginPoint;
		var vI:Vector3D = lineDirection.clone();
		var vC:Vector3D = sphereCenter;
		var r:Number = sphereRadius;
		//trace("Initial: vC = "+vC+", r = "+r+", vO = "+vO+", vI = "+vI);
		vI.normalize();
		//trace("vI normalized = "+vI);
		var d = -1; // Distance to nearest surface
		
		var vOC = vO.subtract(vC);
		var doc:Number = vI.dotProduct(vOC);
		var q:Number = doc*doc - vOC.lengthSquared + r*r;
		
		if (q >= 0){
			var d1 = -doc + Math.sqrt(q);
			var d2 =  -doc - Math.sqrt(q);
			if ( Math.abs(d2) >= Math.abs(d1)){
				d = d1;
			} else {
				d = d2;
			}
		} else {
			// Line does not touch sphere
			return new Vector3D(0,0,0, -1);
		}
		vI.scaleBy(d);
		var vX:Vector3D = vO.add( vI );
		var retVector:Vector3D = vX;
		//trace("Result: vOC = "+vOC+", doc = "+doc+", q = "+q+", d1 = "+d1+", d2 = "+d2+", d = "+d+", vI final = "+vI+", vX = "+vX);
		retVector.w = 1;
		return retVector;
	}
	public static function vectorFromAnglesAndOffsets( thetaNom:Number, phiNom:Number, offsetDist:Number, offsetRot:Number){
		// Returns a vector formed by starting with (1,0,0), then rotating CW by theta around Y, then phi upwards,
		// then offseting by offsetDist degrees, at an angle of offsetRot, which is zero in the X-Z plane, then CCW when loking back to the origin.
		// See RB notebook 4, p. 20
		var theta0:Number = thetaNom;
		var phi0:Number = phiNom;
		var alpha:Number = offsetRot;
		var beta:Number = offsetDist;
		
		var sin_dPhi:Number;
		var dPhi_R:Number
		var cos_dTheta:Number;
		var dTheta_R:Number;
		var theta1_r:Number;
		var phi1_R:Number;
		var vX:Number, vY:Number, vZ:Number;
	
		sin_dPhi = Math.sin( Util3.radians(alpha)) * Math.sin( Util3.radians(beta));
		dPhi_R = Math.asin(sin_dPhi);
		cos_dTheta = Math.cos(Util3.radians(beta)) / Math.cos(dPhi_R);
		dTheta_R = Math.acos(cos_dTheta);
		if (alpha > 90 && alpha < 270){
			dTheta_R = -dTheta_R;
		}
		
		theta1_r = Util3.radians(theta0) + dTheta_R;
		phi1_R = Util3.radians(phi0) + dPhi_R;
		
		vY = Math.sin(phi1_R);
		vZ = Math.cos(phi1_R) * Math.sin(theta1_r);
		vX = -Math.cos(phi1_R) * Math.cos(theta1_r);
		//trace("beta = "+beta+", alpha = "+alpha+", theta1Deg = "+Util3.degrees(theta1_r)+", phi1Deg = "+Util3.degrees(phi1_R));
		return ( new Vector3D(vX,vY,vZ) );
	
	}
	public static function PhoneElPol(gravity:Vector3D, satelliteDirection:Vector3D, upAxis:Vector3D, elOffset:Number):Vector3D{
		/*
		gravity is the gravity vector in the frame of reference of the phone
		satelliteDirection is the vector towards the satellite in the frame of the phone
		upAxis is towards the top of the phone in the frame of the phone
		
		cos(el) is the dot product of the gravity vector and the satdir
		
		Returns the el and pol (twist) of a phone based on the accelerometer
		*/
		var G:Vector3D = gravity;
		G.normalize();
		
		var S:Vector3D = satelliteDirection;
		S.normalize();
		
		var U:Vector3D = upAxis;
		U.normalize();
		
		var theta = Math.acos( G.dotProduct(S) );
		var elDeg = 90 - Util3.degrees(theta) + elOffset;
		
		var C:Vector3D = G.crossProduct(S); // C will be normal to the plane defined by the gravity and sat dir vectors
		C.normalize();
		var pol = Math.acos( C.dotProduct(U) );
		var polDeg = Util3.degrees(pol) - 90;
		
		//var pol2 = Math.asin( (C.crossProduct(U)).length );  // Can use to resolve ambiguity if go past +/- 90?
		
		//trace("C = "+C+", U = "+U);
		var retVal:Vector3D = new Vector3D( elDeg, polDeg, 0);
		return retVal;
	}
	public static function AzEl2CamXY(azDeg:Number, elDeg:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
		/* Camera is looking at the sky, centered on az/el camCenterAzDeg/camCenterElDeg
		Camera is tilted by camTiltDeg
		Camera displays a cartesian map of x and y degrees subtended off its axis. x & y = 0 at the center of the screen.
		This function returns the x/y on screen of a point corresponding to az and el.
		
		See RB OneNote sheet App notes / Camera coordinate transformation
		*/ 

		var thetaDeg:Number = 0;
		var xDeg:Number;
		var yDeg:Number;
		var e0Deg:Number;
		var e1Deg:Number;
		var e1:Number;
		var cosr:Number;
		var r:Number;
		var rDeg:Number;
		var e2:Number;
		var e2Deg:Number;
		var aDeg:Number;
		var a:Number;
		var caseNo:int;
		var cose1:Number;
		var sine1:Number;
		var cosa:Number;
		var sina:Number;
		var cose2:Number;
		var sine2:Number;
		var centerIsAtZenith:Boolean = false;
		var sinr:Number;
		var B:Number;
		var cscr:Number;
		var csce1:Number;
		var cosB:Number;
		var Bdeg:Number;
		var Bdegp:Number;
		var Bp:Number;
		var theta:Number;
		var siny:Number;
		var yym:Number;
		var cosx:Number;
		var xxm:Number;
		var xx:Number;
		var yy:Number;
		var rInit:Number;
		var thetaInit:Number;
		var thetaNew:Number;
		var xDegRot:Number;
		var yDegRot:Number;
		
		e0Deg = camCenterElDeg;
		e1Deg = 90 - e0Deg;
		e1 = Util3.radians(e1Deg);
		e2Deg = 90 - elDeg;
		aDeg = azDeg - camCenterAzDeg; // +ve if to right of center 
		aDeg = Util3.pm180(aDeg);
		
		if (azDeg == camCenterAzDeg && elDeg == camCenterElDeg){
			xDeg = 0;
			yDeg = 0;
			//trace("Dead center:  x = "+xDeg+", y = "+yDeg);
		} else {
			cose1 = Math.cos(e1);
			sine1 = Math.sin(e1);
			a = Util3.radians(aDeg);
			cosa = Math.cos(a);
			sina = Math.sin(a);
			e2 = Util3.radians(e2Deg);
			cose2 = Math.cos(e2);
			sine2 = Math.sin(e2);
			cosr = cose1*cose2 + sine1*sine2*cosa;
			r = Math.acos(cosr);
			
			if (Math.abs(r) <= 1e-14){
				xDeg = 0;
				yDeg = 0;
				//trace("r=0:  x = "+xDeg+", y = "+yDeg);
				caseNo = 0;
			} else {
				rDeg = Util3.degrees(r);
				sinr = Math.sin(r);
				if (Math.abs(e1) <= 1e-14){
					centerIsAtZenith = true;
					thetaDeg = 90 - aDeg;
					r = e2;
					if (a <= 0){
						caseNo = 101;
					} else {
						caseNo = 103;
					}
				} else {
					centerIsAtZenith = false;
					cscr = 1/sinr;
					csce1 = 1/sine1;
					cosB = cscr * csce1*( cose2 - cosr*cose1);
					if ( Math.abs(a) <= 1e-14 && e2 <= e1){
						B = 0;
					} else if (Math.abs(a) <= 1e-14 && e2 > e1){
						B = Math.PI;  
					} else {
						B = Math.acos(cosB);
					}
					Bdeg = Util3.degrees(B);
					Bdegp = Util3.pm180(Math.abs(Bdeg)); // Should be +ve anyway, 0-180
					if (aDeg >= 0 && Bdegp <= 90){
						caseNo = 1;
					} else if (aDeg >= 0 && Bdegp > 90){
						caseNo = 2;   
					} else if (aDeg < 0 && Bdegp <= 90){
						caseNo = 3;   
					} else if (aDeg < 0 && Bdegp > 90){
						caseNo = 4;   
					}
				
					Bp = Util3.radians(Bdegp);
					thetaDeg = 90 - Bdeg;
				}
				
				theta = Util3.radians(thetaDeg);
				siny = Math.sin(theta)*Math.sin(r);
				yym = Math.asin(siny); // Should be +ve
				cosx = Math.cos(r) / Math.cos(yym);
				xxm = Math.acos(cosx);// Should be +ve
				
				yy = yym;
				switch (caseNo){
					case 101:
					case 1:
						xx = xxm;
						break;
					case 2:
						xx = xxm;
						break;
					case 3:
					case 103:
						xx = -xxm;
						break;
					case 4:
						xx = -xxm;
						break;
				}
				yDeg = Util3.degrees(yy);
				xDeg = Util3.degrees(xx);
				//trace("Case "+caseNo+", x = "+xDeg+", y = "+yDeg+", theta = "+thetaDeg+", camTiltDeg = "+camTiltDeg+", B = "+Bdeg+", Bp = "+Bdegp+", e1 = "+e1Deg+", r = "+rDeg+", a = "+aDeg+", e2 = "+e2Deg); 
			}
		}
		// Now tilt the screen CCW around its center by camTiltDeg
		rInit = Math.sqrt(xDeg*xDeg + yDeg*yDeg);
		thetaInit = Math.atan2( yDeg, xDeg); // -pi to +pi
		thetaNew = thetaInit + Util3.radians(camTiltDeg);
		xDegRot = rInit * Math.cos(thetaNew);
		yDegRot = rInit * Math.sin(thetaNew);
		
		// Do a consistency check for debugging:
		
		/*
		var aeCheck:Point = CamXY2AzEl(xDegRot, yDegRot, camCenterAzDeg, camCenterElDeg, camTiltDeg);
		if ( Math.abs(azDeg-aeCheck.x) < 1e-10 &&  Math.abs(elDeg-aeCheck.y) < 1e-10){
			//trace("OK!");
		} else {
			trace("MISMATCH: azDeg: arg into this fn was "+azDeg+"/ returned from check fn is "+aeCheck.x+"; elDeg: arg into this fn was "+elDeg+"/ returned from check fn is "+aeCheck.y);
			trace("   camCenterAzDeg "+camCenterAzDeg+"   camCenterElDeg "+camCenterElDeg+", x before rot = "+xDeg+", y before rot= "+yDeg+", theta = "+thetaDeg+", camTiltDeg = "+camTiltDeg); 
			// Call again so we can debug:
			//aeCheck = CamXY2AzEl(xDegRot, yDegRot, camCenterAzDeg, camCenterElDeg, camTiltDeg);
		}
		*/
		
		
		return new Point(xDegRot, yDegRot);
	}
	public static function CamXY2AzEl(xDegRot:Number, yDegRot:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
		/* Camera is looking at the sky, centered on az/el camCenterAzDeg/camCenterElDeg
		Camera is tilted by camTiltDeg
		Camera's display cartesian map of x and y degrees subtended off its axis. x & y = 0 at the center of the screen.
		This function returns the az and el of a point corresponding to a point x,y on the screen
		
		See RB OneNote sheet App notes / Camera coordinate transformation
		*/ 
		var thetaDeg:Number;
		var azDeg:Number;
		var elDeg:Number;
		var e0Deg:Number;
		var e1Deg:Number;
		var e1:Number;
		var cose1:Number;
		var sine1:Number;
		var r:Number;
		var rDeg:Number;
		var cosr:Number;
		var sinr:Number;
		var e2:Number;
		var e2Deg:Number;
		var cose2:Number;
		var sine2:Number;
		var xDeg:Number;
		var yDeg:Number;
		var xx:Number;
		var yy:Number;
		var rInit:Number;
		var thetaNew:Number;
		var thetaInit:Number;
		var sinTheta:Number;
		var theta:Number;
		var Bdeg:Number;
		var B:Number;
		var cosB:Number;
		var sinB:Number;
		var a:Number;
		var aDeg:Number;
		var sina:Number;
			
		
		// First untilt the screen CW around its center by camTiltDeg:
		rInit = Math.sqrt(xDegRot*xDegRot + yDegRot*yDegRot);
		if (Math.abs(xDegRot) <= 1e-14 ){
			if (yDegRot >= 0){
				thetaInit = Math.PI/2;
			} else {
				thetaInit = -Math.PI/2;
			}
		} else {
			thetaInit = Math.atan2( yDegRot, xDegRot); // -pi to +pi
		}
		thetaNew = thetaInit - Util3.radians(camTiltDeg);
		xDeg = rInit * Math.cos(thetaNew);
		yDeg = rInit * Math.sin(thetaNew);
		
		e0Deg = camCenterElDeg;
		e1Deg = 90 - e0Deg;
		e1 = Util3.radians(e1Deg);
		thetaDeg = 0;
		
		if (Math.abs(xDeg) <= 1e-14 && Math.abs(yDeg) <= 1e-14){
			azDeg = camCenterAzDeg;
			elDeg = camCenterElDeg;
			//trace("Dead center:  az = "+azDeg+", el = "+elDeg);
	
		} else {
			xx = Util3.radians(xDeg);
			yy = Util3.radians(yDeg);
			cosr = Math.cos(xx) * Math.cos(yy);
			r = Math.acos(cosr);
			rDeg = Util3.degrees(r);
			sinTheta = Math.sin(yy) / Math.sin(r);
			theta = Math.asin(sinTheta);
			thetaDeg = Util3.degrees(theta);
			if ( Math.abs(xDeg) <= 1e-14){
				if (yDeg > 0){
					thetaDeg = 90;
				} else {
					thetaDeg = -90;
				}
			}
			if (xDeg < 0){
				thetaDeg = 180 - thetaDeg;
			}
			thetaDeg = Util3.pm180(thetaDeg); // Now theta goes from -180 to +180. CCW.
			theta = Util3.radians(thetaDeg);
			// Know we know r.
			Bdeg = 90 - thetaDeg;
			Bdeg = Util3.pm180(Bdeg); 
			B = Util3.radians(Bdeg);
			
			cose1 = Math.cos(e1);
			sine1 = Math.sin(e1);
			sinr = Math.sin(r);
			cosB = Math.cos(B);
			sinB = Math.sin(B);
			cose2 = cose1*cosr + sine1*sinr*cosB;
			e2 = Math.acos(cose2);
			e2Deg = Util3.degrees(e2);
			sine2 = Math.sin(e2);
			sina = sinr * sinB / sine2;
			a = Math.asin(sina);
			aDeg = Util3.degrees(a);
			
			trace("x = "+xDeg+", y = "+yDeg+", theta = "+thetaDeg+", camTiltDeg = "+camTiltDeg+", B = "+Bdeg+", e1 = "+e1Deg+", r = "+rDeg+", a = "+aDeg+", e2 = "+e2Deg); 
			elDeg = 90 - e2Deg;
			azDeg = aDeg + camCenterAzDeg;
			
		}
		return new Point(azDeg, elDeg);
	}
	public static function transformReferenceSystem( vA:Vector3D, xA:Vector3D, yA:Vector3D, zA:Vector3D, xB:Vector3D, yB:Vector3D, zB:Vector3D):Vector3D{
		/* 
		xA, yA, zA are the x,y,z unit vectors of the frame A
		xB, yB, zB are the x,y,z unit vectors of the frame B
		vA is a vector in frame A
		vB is the same vector now in frame B
		Function returns vB
		See http://ocw.mit.edu/courses/aeronautics-and-astronautics/16-07-dynamics-fall-2009/lecture-notes/MIT16_07F09_Lec03.pdf. eq6
		*/
		var T11:Number = xB.dotProduct(xA);
		var T12:Number = xB.dotProduct(yA);
		var T13:Number = xB.dotProduct(zA);
	
		var T21:Number = yB.dotProduct(xA);
		var T22:Number = yB.dotProduct(yA);
		var T23:Number = yB.dotProduct(zA);
	
		var T31:Number = zB.dotProduct(xA);
		var T32:Number = zB.dotProduct(yA);
		var T33:Number = zB.dotProduct(zA);
		
		var vBx:Number = T11*vA.x + T12*vA.y + T13*vA.z;
		var vBy:Number = T21*vA.x + T22*vA.y + T23*vA.z;
		var vBz:Number = T31*vA.x + T32*vA.y + T33*vA.z;
		
		var vB:Vector3D = new Vector3D(vBx, vBy, vBz);
		return vB;
	}
	public static function AzEl2CamXY3(azDegReq:Number, elDegReq:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
		/* 
		Use Quaternions.
		Start with the point in the main frame P0
		Rotate around Y axis by -az
		Rotate around X axis by -el
		Rotate around Z axis by -tilt
		*/
		var azDeg1:Number = Util3.pm180(azDegReq);
		var elDeg1:Number = Util3.pm180(elDegReq);
		var azDeg:Number = azDeg1;
		var elDeg:Number = elDeg1;
		
		var P0:Vector3D = azel2cart( new Vector3D(azDeg, elDeg, 1));
		
		var Q1:QuatV = new QuatV();
		Q1.setFromAxisAngleDeg(0, 1, 0, camCenterAzDeg);
		var P1:Vector3D = QuatV.rotatePoint( Q1, P0 );
		
		var Q2:QuatV = new QuatV();
		Q2.setFromAxisAngleDeg(1, 0, 0, camCenterElDeg);
		var P2:Vector3D = QuatV.rotatePoint( Q2, P1 );

		/*
		var Q3:QuatV = new QuatV();
		Q3.setFromAxisAngleDeg(0, 0, 1, -camTiltDeg);
		var P3:Vector3D = QuatV.rotatePoint( Q3, P2 );
		*/
		// Now P3 should be on the z axis on the surface.
		var aer:Vector3D = cart2azel(P2);
		
		// Now tilt the screen CCW around its center by camTiltDeg
		var rInit = Math.sqrt(aer.x*aer.x + aer.y*aer.y);
		var thetaInit = Math.atan2( aer.y, aer.x); // -pi to +pi
		var thetaNew = thetaInit + Util3.radians(camTiltDeg);
		var xDegRot = rInit * Math.cos(thetaNew);
		var yDegRot = rInit * Math.sin(thetaNew);

		var camXdeg:Number = xDegRot; //aer.x;
		var camYdeg:Number =yDegRot; // aer.y;
		//trace("azDegReq = "+azDegReq+", elDegReq = "+elDegReq+", azDeg = "+azDeg+", elDeg = "+elDeg+", camCenterAzDeg = "+camCenterAzDeg+"   camCenterElDeg = "+camCenterElDeg+", camTiltDeg = "+camTiltDeg+", r = "+aer.z+", camXdeg = "+camXdeg+", camYdeg = "+camYdeg); 

		// Do a consistency check for debugging:
		
		
		/*
		var aeCheck:Point;
		aeCheck = CamXY2AzEl3(camXdeg, camYdeg, camCenterAzDeg, camCenterElDeg, camTiltDeg);
		if ( Math.abs(azDeg-aeCheck.x) < 1e-10 &&  Math.abs(elDeg-aeCheck.y) < 1e-10){
			trace("OK!");
		} else {
			trace("MISMATCH: azDeg: arg into this fn was "+azDeg+"/ returned from check fn is "+aeCheck.x+"; elDeg: arg into this fn was "+elDeg+"/ returned from check fn is "+aeCheck.y);
			trace("   camCenterAzDeg "+camCenterAzDeg+"   camCenterElDeg "+camCenterElDeg+", x  = "+camXdeg+", y  "+camYdeg+", camTiltDeg = "+camTiltDeg); 
			// Call again so we can debug:
			var aeCheck2:Point = CamXY2AzEl3(camXdeg, camYdeg, camCenterAzDeg, camCenterElDeg, camTiltDeg);
		}
		*/
		

		return new Point(camXdeg, camYdeg);
	}
	public static function CamXY2AzEl3(xDeg:Number, yDeg:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
		/* Start with camera pointing towards Z
		point is P0
		Rotate P0 around Z axis by tilt to get P1
		Rotate P1 around X axis by elevation to get P2
		Rotate P2 arounc Y axis by az to get P3
		Returns az & el in degrees as a Point
		*/

		var P0:Vector3D = azel2cart(new Vector3D(xDeg, yDeg, 1));

		var Q1:QuatV = new QuatV();
		Q1.setFromAxisAngleDeg(0, 0, 1, camTiltDeg);
		var P1:Vector3D = QuatV.rotatePoint( Q1, P0 );
		
		var Q2:QuatV = new QuatV();
		Q2.setFromAxisAngleDeg(1, 0, 0, -camCenterElDeg);
		var P2:Vector3D = QuatV.rotatePoint( Q2, P1 );
		
		var Q3:QuatV = new QuatV();
		Q3.setFromAxisAngleDeg(0, 1, 0, -camCenterAzDeg);
		var P3:Vector3D = QuatV.rotatePoint( Q3, P0 );
		
		// Now P3 should be on pointing to the real target in the main frame.
		var aer:Vector3D = cart2azel(P3)
		
		//trace("x = "+xDeg+", y = "+yDeg+", azDeg = "+aer.x+", elDeg = "+aer.y+", camCenterAzDeg = "+camCenterAzDeg+"   camCenterElDeg = "+camCenterElDeg+", camTiltDeg = "+camTiltDeg+", r = "+aer.z); 

		return new Point(aer.x, aer.y);

	}
	
	public static function AzEl2CamXY2(azDeg:Number, elDeg:Number, camCenterAzDeg:Number, camCenterElDeg:Number, camTiltDeg:Number):Point{
		/*
		Frame A1 is the observer on the earth.  X is west, Y is up. Z is north,  
		Frame B1 = frame of observer rotated in az to cam direction
		
		Frame A2 = frame B1
		Frame B2 = frame of observer rotated in el up to cam direction
		
		Frame A3 = frame B3
		Frame B3 = frame of camer rotated around its Z axis. -Z is towards target, Y is top of the screen, X is right of the screen
		
		v0 = target in frame A1
		v1 = transformReferenceSystem( v0, frame A1, frame B1)
		v2 = transformReferenceSystem( v1, frame A2, frame B2)
		v3 = transformReferenceSystem( v2, frame A3, frame B3)
		*/
		var az = Util3.radians(azDeg);
		var el = Util3.radians(elDeg);
		var y0 = Math.sin(el);
		var x0 = -Math.cos(el)*Math.sin(az);
		var z0 = Math.cos(el)*Math.cos(az);
		var v0:Vector3D = new Vector3D(x0,y0, z0);
		
		var camAz = Util3.radians(camCenterAzDeg);
		var camEl = Util3.radians(camCenterElDeg);
		var camTilt = Util3.radians(camTiltDeg);
		var A1x:Vector3D = new Vector3D(1,0,0);
		var A1y:Vector3D = new Vector3D(0,1,0);
		var A1z:Vector3D = new Vector3D(0,0,1);
		
		var B1x:Vector3D = new Vector3D( Math.cos(camAz), 0, -Math.sin(camAz) );
		var B1y:Vector3D = new Vector3D( 0, 1, 0 );
		var B1z:Vector3D = new Vector3D( -Math.sin(camAz), 0, Math.cos(camAz) );
		var v1:Vector3D = transformReferenceSystem( v0, A1x, A1y, A1z, B1x, B1y, B1z);
		
		var B2x:Vector3D = new Vector3D( 1, 0, 0 );
		var B2y:Vector3D = new Vector3D( 0, Math.cos(camEl), -Math.sin(camEl) );
		var B2z:Vector3D = new Vector3D( 0, Math.sin(camEl), Math.cos(camEl) );
		var v2:Vector3D = transformReferenceSystem( v1, B1x, B1y, B1z, B2x, B2y, B2z);
		
		var B3x:Vector3D = new Vector3D( Math.cos(camTilt), Math.sin(camTilt), 0 );
		var B3y:Vector3D = new Vector3D( -Math.sin(camTilt),  Math.cos(camTilt), 0 );
		var B3z:Vector3D = new Vector3D( 0, 0, 1 );
		var v3:Vector3D = transformReferenceSystem( v2, B2x, B2y, B2z, B3x, B3y, B3z );
	
		v3.normalize();
		var camXdeg:Number = Util3.degrees(-Math.asin(v3.x));
		var camYdeg:Number = Util3.degrees(Math.asin(v3.y));
		
		//trace("azDeg = "+azDeg+", elDeg = "+elDeg+", camCenterAzDeg = "+camCenterAzDeg+"   camCenterElDeg = "+camCenterElDeg+", camTiltDeg = "+camTiltDeg+", camXdeg = "+camXdeg+", camYdeg = "+camYdeg); 

		return new Point(camXdeg, camYdeg);
		
	}
	public static function resampleArray(origArray:Array, newLength:int):Array{
		var N = origArray.length;
		var tempArray:Array = new Array(N);
		var newArray:Array = new Array(newLength);
		
		// Apply filter as rolling average
		var R = N / newLength;
		var nAvg = Math.ceil(R);

		var isComplex = (origArray[0] is Complex);
		/*
		trace("--------------------------------------------");
		if (isComplex){
			trace("origArray = "+ Complex.toString(origArray));
		} else {
			trace("origArray = "+origArray);
		}
		trace("newLength= "+newLength+", R = "+R+", nAvg = "+nAvg);
		*/
		var i:int, iLast:int, iThis:int, nAvgActual;
		var sum:Number = 0;
		var sumC:Complex = Complex.make(0,0);
		for (i=0; i< N; i++){
			if (isComplex){
				sumC = Complex.make(0,0);
			} else {
				sum = 0;
			}
			iLast = Math.min( i+nAvg-1, N-1);
			nAvgActual = iLast - i +1;
			//trace("i = "+i+", iLast = "+iLast+", nAvgActual = "+nAvgActual);
			for (iThis=i; iThis<=iLast; iThis++){
				if (isComplex){
					sumC.re += origArray[iThis].re;
					sumC.im += origArray[iThis].im;
					//trace("  iThis = "+iThis+", sumC = "+Complex.toString(sumC));
				} else {
					sum += origArray[iThis];
					//trace("  iThis = "+iThis+", sum = "+sum);
				}
			}
			if (isComplex){
				tempArray[i] = new Complex( sumC.re/nAvgActual, sumC.im/nAvgActual );
				//trace("  Avg val = "+Complex.toString(tempArray[i]));
			}else {
				tempArray[i] = sum/nAvgActual;
				//trace("   Avg val = "+tempArray[i]);
			}
		}
		/*
		if (isComplex){
			trace("tempArray = "+ Complex.toString(tempArray));
		} else {
			trace("newArray = "+tempArray);
		}
		*/
		// Take new samples by linearly interpolating tempArray
		var i1:int, i2:int, iInterp:Number, k:int, val:Number, valC:Complex;
		for (k=0; k<newLength; k++){
			iInterp = (k/newLength) * N;
			i1 = Math.floor(iInterp);
			i2 = i1+1;
			if (isComplex){
				valC = new Complex();
				if (i2 < N ){
					valC.re = tempArray[i1].re + (iInterp-i1)*(tempArray[i2].re - tempArray[i1].re);
					valC.im = tempArray[i1].im + (iInterp-i1)*(tempArray[i2].im - tempArray[i1].im);
				} else {
					valC = tempArray[N-1];
				}
				newArray[k] = valC;
			} else {
				if (i2 < N ){
					val = tempArray[i1] + (iInterp-i1)*(tempArray[i2] - tempArray[i1]);
				} else {
					val = tempArray[N-1];
				}
				newArray[k] = val;
			}
		}
		/*
		if (isComplex){
			trace("newArray = "+ Complex.toString(newArray));
		} else {
			trace("newArray = "+newArray);
		}
		*/
		return newArray;
		
	}
	public static function insertionSort(indices:Array, values:Array, ascending:Boolean){
		// Sorts array values in place; changes array indices to match.
		
		var N = values.length
		var i:int;
		var j:int;
		var value:Number;
		var index:int;
		
		for(i = 1; i < N; i++){
			value = values[i];
			index = indices[i];
			j = i-1;
			if (ascending){
				while(j >= 0 && values[j] > value){
					values[j+1] = values[j];
					indices[j+1] = indices[j];
					j--;
				}
			} else {
				while(j >= 0 && values[j] < value){
					values[j+1] = values[j];
					indices[j+1] = indices[j];
					j--;
				}
			}
			values[j+1] = value;
			indices[j+1] = index;
		}
	}	
	public static function traceToConsole(str:String){
		trace(str);
		try {
			ExternalInterface.call("absorbScorm.trace", str ); // Only works if running in a browser
		} catch (e:Error){
			
		}
	}	
	public static function isInsideTriangle(A:Point,B:Point,C:Point,P:Point){
		//Give 3 corners of a triangle and a point; returns true if the point is inside the triangle.
		// From https://www.emanueleferonato.com/2012/06/18/algorithm-to-determine-if-a-point-is-inside-a-triangle-with-mathematics-no-hit-test-involved/
		var planeAB:Number = (A.x-P.x)*(B.y-P.y)-(B.x-P.x)*(A.y-P.y);
		var planeBC:Number = (B.x-P.x)*(C.y-P.y)-(C.x - P.x)*(B.y-P.y);
		var planeCA:Number = (C.x-P.x)*(A.y-P.y)-(A.x - P.x)*(C.y-P.y);
		return sign(planeAB)==sign(planeBC) && sign(planeBC)==sign(planeCA);
	}	

	}// End of class
}// End of package