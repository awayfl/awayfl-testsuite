import * as React from 'react';
import { connect } from "react-redux";
import { IState, StringTMap, ITest } from '../interfaces';
import Icon from 'react-icons-kit';
import { switchIcon } from 'react-icons-kit/icomoon/switchIcon'
import { allActions } from '../actions';
import { warning } from 'react-icons-kit/icomoon/warning'
import { checkboxUnchecked } from 'react-icons-kit/icomoon/checkboxUnchecked'
import { checkboxChecked } from 'react-icons-kit/icomoon/checkboxChecked'
import { cross } from 'react-icons-kit/icomoon/cross'
import { checkmark } from 'react-icons-kit/icomoon/checkmark'
import { radioUnchecked } from 'react-icons-kit/icomoon/radioUnchecked'
import {info} from 'react-icons-kit/icomoon/info'
import {bin} from 'react-icons-kit/icomoon/bin'
import {eye} from 'react-icons-kit/icomoon/eye'
import {play2} from 'react-icons-kit/icomoon/play2'
const mapStateToProps = (state /*, ownProps*/) => {
	return {
		port: state.config.port,
		awayjsPath: state.config.awayjsPath,
		awayjsWatchPath: state.config.awayjsWatchPath
	};
}

const mapDispatchToProps = (dispatch) => ({
	dispatch: (dispatchFunction) => dispatch(dispatchFunction)
});

interface ISWFTestProps {
	port: string;
	awayjsPath: string;
	awayjsWatchPath: string;
	name: string;
	path: string;
	indent: number;
	obj: any;
	dispatch?: Function;
}
class SWFTestIntern extends React.Component<ISWFTestProps, {}> {

	public onClickOpenNewTab(awayjsPath) {
		let path = `http://localhost:${awayjsPath}${this.props.obj.awayflPlayer}.html?swf=${this.props.obj.swfPath.replace(/\\/g, "/")}&port=${this.props.port}&test=${this.props.obj.test}&testURL=${this.props.obj.awayflPlayer}`;
		window.open(path);
	}
	public onDeleteTest(path) {
		this.props.dispatch(function (dispatch) {
			dispatch({
				type: allActions.deleteTest,
				path: path
			});
		});

		fetch(`http://localhost:${this.props.port}/deleteTest?test=${path.join("__")}`)
			.then(data => {})
			.catch(error => console.log("error in calling to server:", error));
	}

	public openTest(path) {
		this.props.dispatch(function (dispatch) {
			dispatch({
				type: allActions.openTest,
				value: path
			});
		});
	}
	public getResultIcon() {
		if (!this.props.obj.testData)
			return <Icon size={"100%"} icon={radioUnchecked} />
		if (this.props.obj.testData.result == "success")
			return <Icon style={{ color: "#090" }} size={"100%"} icon={checkmark} />
		return <Icon style={{ color: "#f00" }} size={"100%"} icon={cross} />

	}
	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);
		return (
			<div id="SWFTest" style={{
				display: "grid",
				gridTemplateColumns: "500px auto",
				gridTemplateRows: "auto",
				height: 25,
				backgroundColor: "#ddd",
				color: "#000",
			}}>

				<div key={0} style={{
					display: "grid",
					gridTemplateColumns: this.props.indent + "px 10px 20px 5px auto",
					gridTemplateRows: "auto",
					alignContent: "center",
					alignItems: "center",
					justifyItems: "center",
					height: 25
				}}>
					<div key={0} id="TestSpacer"></div>
					<div key={1} id="TestSpacer"></div>
					<div key={2} id="TestHeader" style={{ width: "10px", color: "#000" }}>
						{this.getResultIcon()}
					</div>
					<div key={3} id="TestSpacer"></div>
					<div key={4} id="TestHeader" style={{ width: "100%", paddingTop: 5 }}>
						{this.props.name}
					</div>
				</div>
				<div key={1} style={{
					backgroundColor: "#ddd",
					display: "grid",
					gridTemplateColumns: "20px 10px 20px 10px 20px 10px 20px 20px auto 20px",
					gridTemplateRows: "auto",
					alignContent: "center",
					alignItems: "center",
					justifyItems: "center",

				}}>
					<div key={0} title="inspect test" id="TestHeader" style={{ cursor:"pointer", width: "100%", height:"20px", color: "#000" }}
						onClick={() => this.openTest(this.props.path)}>
							
						<Icon size={"20px"} icon={info} />
						{/*<button style={{ width: "100%", color: "#000" }}>inspect</button>*/}
					</div>
					<div key={0.5} id="Spacer" style={{ width: "100%", color: "#000" }}></div>
					<div key={1} title="run test"  id="TestHeader" style={{ cursor:"pointer", width: "100%", color: "#000" }}
						onClick={() => this.onClickOpenNewTab(this.props.awayjsPath)}>
						<Icon size={"20px"} icon={play2} />
						{/*<button style={{ width: "100%", color: "#000" }}>run</button>*/}
					</div>
					<div key={1.5} id="TestHeader" style={{ width: "100%", color: "#00c" }}>
						{/*<Icon icon=this.props.swfTest.message ? checkboxUnchecked : checkboxChecked />*/}
					</div>
					<div key={2} title="run test in dev-server" id="TestHeader" style={{ cursor:"pointer", width: "100%", color: "#000" }}
						onClick={() => this.onClickOpenNewTab(this.props.awayjsWatchPath)}>
						<Icon size={"20px"} icon={eye} />
						{/*<button style={{ width: "100%", color: "#000" }}>run watch</button>*/}
					</div>
					<div key={2.5} id="TestHeader" style={{ width: "100%", color: "#00c" }}>
						{/*<Icon icon=this.props.swfTest.message ? checkboxUnchecked : checkboxChecked />*/}
					</div>
					<div key={3} title="delete test" id="TestHeader" style={{  cursor:"pointer",width: "100%", color: "#000" }}
						onClick={() => this.onDeleteTest(this.props.path)}>
						<Icon size={"20px"} icon={bin} />
						{/*{<button style={{ width: "100%", color: "#000" }}>delete</button>}*/}
					</div>
					<div key={3.5} id="TestHeader" style={{ width: "100%", color: "#00c" }}>
						{/*<Icon icon=this.props.swfTest.message ? checkboxUnchecked : checkboxChecked />*/}
					</div>
					<div key={4} id="TestHeader" style={{ width: "100%", color: "#00c" }}>
						{this.props.obj.testData? this.props.obj.testData.result!="success"?this.props.obj.testData.message:"":"not tested"}
					</div>


					{/*<div key={4} id="CategoryActive" onClick={() => this.props.clickActive(["disabledNodes", this.props.path])} style={{}}>
						<Icon icon={switchIcon} /></div>*/}
				</div>
			</div>


		);

	}
}
export const SWFTest = connect(mapStateToProps, mapDispatchToProps)(SWFTestIntern);
