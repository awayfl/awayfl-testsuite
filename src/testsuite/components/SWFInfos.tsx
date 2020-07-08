import * as React from 'react';
import { connect } from "react-redux";
import { IState, StringTMap, ITest } from '../interfaces';
import Icon from 'react-icons-kit';
import { switchIcon } from 'react-icons-kit/icomoon/switchIcon'
import { allActions } from '../actions';
import { warning } from 'react-icons-kit/icomoon/warning'
import { checkboxUnchecked } from 'react-icons-kit/icomoon/checkboxUnchecked'
import { checkboxChecked } from 'react-icons-kit/icomoon/checkboxChecked'
import { play2 } from 'react-icons-kit/icomoon/play2'
import { cross } from 'react-icons-kit/icomoon/cross'
import { checkmark } from 'react-icons-kit/icomoon/checkmark'
import { radioUnchecked } from 'react-icons-kit/icomoon/radioUnchecked'
const mapStateToProps = (state /*, ownProps*/) => {
	return {};
}

const mapDispatchToProps = (dispatch) => ({
	clickActive: (path) => dispatch({
		type: allActions.toggleValueAtPath,
		path: path
	}),
	openTest: (dispatchFunction) => dispatch(dispatchFunction)
});

interface ISWFTestProps {
	swfInfosRecordet: any,
	swfInfosTest: any,
	swfTest?: any;
	disabledNodes?: StringTMap<boolean>;
	name: string;
	nameTest: string;
	path: string;
	indent: number;
	obj: any;
	clickActive?: Function;
	openTest?: Function;
}
class SWFInfosIntern extends React.Component<ISWFTestProps, {}> {

	public openTest(path) {
		this.props.openTest(function (dispatch) {
			dispatch({
				type: allActions.openTest,
				value: path
			});
			/*
			fetch("http://localhost:1111/all")
				.then(response => response.json())
				.then(data => dispatch({
					type: allActions.InitialDataFromServer,
					value: data
				}))
				.catch(error => console.log("error in getInitialDataFromServer:", error));*/
		}
		);
	}
	public renderInfos() {
		let output = [];
		let cnt = 0;
		let swfInfoRec = this.props.swfInfosRecordet;
		let swfInfoTest = this.props.swfInfosTest;
		if (swfInfoRec && !swfInfoTest) {

			output.push(<div key={cnt++}
				style={{
					display: "flex",
					backgroundColor: "#eee"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>FrameRate</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.frameRate}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}></div>
				<div style={{width:"100%"}} key={3}></div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex",
					backgroundColor: "#eee"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>SWF-version</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.swfVersion}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}></div>
				<div style={{width:"100%"}} key={3}></div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex",
					backgroundColor: "#eee"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>AS-version</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.asVersion}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}></div>
				<div style={{width:"100%"}} key={3}></div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex", 
					backgroundColor: "#eee"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>width</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.width}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}></div>
				<div style={{width:"100%"}} key={3}></div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex",
					backgroundColor: "#eee"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>height</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.height}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}></div>
				<div style={{width:"100%"}} key={3}></div>
			</div>);
			return output;
		}
		if (swfInfoRec && swfInfoTest) {

			output.push(<div key={cnt++}
				style={{
					display: "flex"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>FrameRate</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.frameRate}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}>FrameRate</div>
				<div style={{width:"100%", backgroundColor: swfInfoTest.frameRate == swfInfoRec.frameRate ? "#0f0" : "#f00"}} key={3}>{swfInfoTest.frameRate}</div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>SWF-version</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.swfVersion}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}>SWF-version</div>
				<div style={{width:"100%", backgroundColor: swfInfoTest.swfVersion == swfInfoRec.swfVersion ? "#0f0" : "#f00"}} key={3}>{swfInfoTest.swfVersion}</div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>AS-version</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.asVersion}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}>AS-version</div>
				<div style={{width:"100%", backgroundColor: swfInfoTest.asVersion == swfInfoRec.asVersion ? "#0f0" : "#f00"}} key={3}>{swfInfoTest.asVersion}</div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex"
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>width</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.width}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}>width</div>
				<div style={{width:"100%", backgroundColor: swfInfoTest.width == swfInfoRec.width ? "#0f0" : "#f00"}} key={3}>{swfInfoTest.width}</div>
			</div>);
			output.push(<div key={cnt++}
				style={{
					display: "flex",
				}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>height</div>
				<div style={{width:"100%"}} key={1}>{swfInfoRec.height}</div>
				<div style={{width:"100px", flexShrink: 0}} key={2}>height</div>
				<div style={{width:"100%", backgroundColor: swfInfoTest.height == swfInfoRec.height ? "#0f0" : "#f00"}} key={3}>{swfInfoTest.height}</div>
			</div>);
			return output;
		}
		<div key={0}>no SWF-Info recordet</div>
	}
	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);

		return (
			<div id="SWFFrame" style={{
				display: "flex",
				backgroundColor: "#ccc",
				width: "auto",
				margin: "5px",
				color: "#000",
			}}>
				<div style={{width:"100%"}} key={1}>{this.renderInfos()}</div>

			</div>


		);

	}
}
export const SWFInfos = connect(mapStateToProps, mapDispatchToProps)(SWFInfosIntern);
