console.debug("TestSuite - 0.0.2");
import * as React from 'react';
import {App} from './testsuite/components/App';
import * as ReactDOM from 'react-dom';

window.onload = function ()
{
	//console.log(location.port)
	//document.getElementById('splash').style.opacity="0";
	ReactDOM.render(<App />, document.getElementById('app'));

}