class Tester2 extends MovieClip
{		

  function Tester2() {
	  trace("constructor Tester2 / "+this._parent._name+" / "+this._name);

  }
	function onLoad ()
	{
	  trace("load Tester2 / "+this._parent._name+" / "+this._name);
	}
} 