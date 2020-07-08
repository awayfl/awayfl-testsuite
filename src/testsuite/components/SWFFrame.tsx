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
	frameRecordet: any,
	frameTest: any,
	errorColor:string,
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
class SWFFrameIntern extends React.Component<ISWFTestProps, {}> {

	public openTest(path) {
		this.props.openTest(function (dispatch) {
			dispatch({
				type: allActions.openTest,
				value: path
			});
		});
	}
	public renderTestMessages() {
		let output = [];
		let cnt = 0;
		if (!this.props.frameTest) {
			output.push(<div key={cnt++}
				style={{ height: "100%", backgroundColor: "#eee" }}>
			</div>)
			return output;
		}
		for (let i = 0; i < this.props.frameTest.messages.length; i++) {
			let color = "#0f0";
			if (!this.props.frameRecordet || this.props.frameRecordet.messages.length <= i ||
				this.props.frameRecordet.messages[i] != this.props.frameTest.messages[i]) {
				color = "#f00";
			}
			output.push(<div key={cnt++}
				style={{ backgroundColor: color }}>
				{this.props.frameTest.messages[i]}
			</div>);
		}
		return output;
	}
	public renderMessages() {
		let output = [];
		let cnt = 0;
		for (let i = 0; i < this.props.frameRecordet.messages.length; i++) {
			output.push(<div key={cnt++}
				style={{ backgroundColor: "#ccc" }}>
				{this.props.frameRecordet.messages[i]}
			</div>);
		}
		return output;
	}

	public getBGColorForFrameIdx() {
		if (this.props.frameRecordet && this.props.frameTest && this.props.frameRecordet.frameIdx == this.props.frameTest.frameIdx)
			return "#0f0";
		return this.props.errorColor;
	}

	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);

		return (
			<div id="SWFFrame" style={{
				display: "flex",
				backgroundColor: "#ccc",
				margin: "5px",
				color: "#000",
			}}>
				<div style={{width:"100px", flexShrink: 0}} key={0}>{this.props.frameRecordet ? this.props.frameRecordet.frameIdx : ""}</div>
				<div style={{width:"100%"}} key={1}>{this.renderMessages()}</div>
				<div style={{width:"100px", flexShrink: 0, backgroundColor: this.getBGColorForFrameIdx() }} key={2}>{this.props.frameTest ? this.props.frameTest.frameIdx : ""}</div>
				<div style={{width:"100%"}} key={3}>{this.renderTestMessages()}</div>

			</div>


		);

	}
}
export const SWFFrame = connect(mapStateToProps, mapDispatchToProps)(SWFFrameIntern);
