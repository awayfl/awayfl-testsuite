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
import { TextField } from './TextField';
import { CheckBox } from './CheckBox';
import { NumberStepper } from './Number';
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
	settings?: any;
	defaultSettings?: any;
	keys: string[];

	disabledNodes?: StringTMap<boolean>;
	name: string;
	path: string;
	indent: number;
	obj: any;
	clickActive?: Function;
	openTest?: Function;
}
class TestSettingsIntern extends React.Component<ISWFTestProps, {}> {

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
	public renderValue(value) {
		if (typeof value === "string") {
			return <TextField value={value}></TextField>
		}
		if (typeof value === "boolean") {
			return <CheckBox value={value}></CheckBox>
		}
		if (typeof value === "number") {
			return <NumberStepper value={value}></NumberStepper>
		}
		return <div>Error unsupported settings type (should be boolean / string / number)</div>

	}
	public getSettingsRow(key) {
		let output = [];
		output.push(<div key={0} style={{ width: "100px", flexShrink: 0, height: "30px", backgroundColor: "#eee" }}>
			{key}
		</div>);
		if (this.props.defaultSettings) {
			if (this.props.settings && this.props.settings.hasOwnProperty(key)) {
				output.push(<div key={1} style={{ width: "100%", height: "30px", backgroundColor: "#eee" }}>
					{this.renderValue(this.props.settings[key] + "*")}
				</div>);
			}
			else {
				output.push(<div key={1} style={{ width: "100%", height: "30px", backgroundColor: "#eee" }}>
					{this.renderValue(this.props.defaultSettings[key])}
				</div>);
			}
		}
		else if (this.props.settings) {
			output.push(<div key={1} style={{ width: "100%", height: "30px", backgroundColor: "#eee" }}>
				{this.renderValue(this.props.settings[key])}
			</div>);

		}
		return output;
	}
	public renderSettings() {
		let output = [];
		let idCnt = 0;
		if (this.props.keys) {
			for (var i = 0; i < this.props.keys.length; i++) {
				output.push(<div style={{ display: "flex", width: "100%" }} key={1}>
					{this.getSettingsRow(this.props.keys[i])}
				</div>);
			}
		}

		return output;
	}

	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);
		return (
			<div id="TestSettings" style={{
				backgroundColor: "#eee",
				color: "#000",
				width: "100%",
				margin: "5px",
			}} >
				{this.renderSettings()}
			</div >


		);

	}
}
export const TestSettings = connect(mapStateToProps, mapDispatchToProps)(TestSettingsIntern);
