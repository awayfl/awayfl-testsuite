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
import { filePlay } from 'react-icons-kit/icomoon/filePlay'
const mapStateToProps = (state /*, ownProps*/) => {
	return {
		port:state.config.port,
		awayjsPath:state.config.awayjsPath,
		awayjsWatchPath:state.config.awayjsWatchPath
	};
}

const mapDispatchToProps = (dispatch) => ({
	toggleTests: (path) => dispatch({
		type: allActions.toggleValueAtPath,
		path: path
	}),
	openSettings: (dispatchFunction) => dispatch(dispatchFunction)
});

interface ISWFTestProps {
	name: string;
	path: string;
	indent: number;
	obj:any;
	port:string;
	awayjsPath:string;
	awayjsWatchPath: string;
	toggleTests?: Function;
	openSettings?: Function;
	
}
class SWFItemIntern extends React.Component<ISWFTestProps, {}> {

	public onClickFolder(path) {
		path.push("closed");
		this.props.toggleTests(path);
		console.log("onClickFolder")
	}
	public onClickFPRecord() {
		let path=`http://localhost:${this.props.port}/FlashRecorder/?swf=${this.props.obj.swfPath.replace(/\\/g, "/")}&port=${this.props.port}&testURL=${this.props.obj.awayflPlayer}`;
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", path, true);
		xmlhttp.send();
	}
	public onClickOpenNewTab(awayPath) {
		let path=`http://localhost:${awayPath}${this.props.obj.awayflPlayer}.html?swf=${this.props.obj.swfPath.replace(/\\/g, "/")}&port=${this.props.port}&testURL=${this.props.obj.awayflPlayer}`;
		window.open(path);
	}
	public openSettings(path) {
		this.props.openSettings(function (dispatch) {
			dispatch({
				type: allActions.openTest,
				value: path
			});
		})
	}
	
	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);
		return (
			<div id="SWFItem" style={{
				display: "grid",
				gridTemplateColumns: "500px auto",
				gridTemplateRows: "auto",
				height: 25,
				backgroundColor: "#eee",
				color: "#000",
			}}>

				<div key={0} style={{
					display: "grid",
					gridTemplateColumns: this.props.indent+"px 10px 20px 5px auto",
					gridTemplateRows: "auto",
					alignContent: "center",
					alignItems: "center",
					justifyItems: "center",
					backgroundColor: "#eee",
					height: 25
				}}>
					<div key={0} id="TestSpacer"></div>
					<div key={1} id="TestSpacer"></div>
					<div key={2} id="TestHeader" style={{ width: "100%", color: "#000" }}
						onClick={() => this.onClickFolder(this.props.path)}>
						<Icon size={"100%"} icon={filePlay} />
					</div>
					<div key={3} id="TestSpacer"></div>
					<div key={4} id="TestHeader" style={{ width: "100%", paddingTop: 5 }}>
						{this.props.name + " ("+Object.keys(this.props.obj.tests).length+")"}
					</div>
				</div>
				<div key={1} style={{
					backgroundColor: "#eee",
					display: "grid",
					gridTemplateColumns: "100px 10px 100px 10px 100px 10px 100px auto 20px",
					gridTemplateRows: "auto",
					alignContent: "center",
					alignItems: "center",
					justifyItems: "center",

				}}>
					<div key={0} id="TestHeader" style={{ width: "100%", color: "#000" }}
						
						onClick={() => this.onClickFPRecord()}>
						<button style={{ width: "100%", color: "#000" }}>record FP</button>
					</div>
					<div key={0.5} id="Spacer" style={{ width: "100%", color: "#00c" }}></div>
					<div key={1} id="TestHeader" style={{ width: "100%", color: "#000" }}
						onClick={() => this.onClickOpenNewTab(this.props.awayjsPath)}>
						<button style={{ width: "100%", color: "#000" }}>record Away</button>
					</div>
					<div key={1.1} id="Spacer" style={{ width: "100%", color: "#00c" }}></div>
					<div key={1.2} id="TestHeader" style={{ width: "100%", color: "#000" }}
						onClick={() => this.onClickOpenNewTab(this.props.awayjsWatchPath)}>
						<button style={{ width: "100%", color: "#000" }}>Away Watch</button>
					</div>
					<div key={1.5} id="Spacer" style={{ width: "100%", color: "#00c" }}></div>
					<div key={2} id="TestHeader" style={{ width: "100%", color: "#000" }}>
						{/*onClick={() => this.openSettings(this.props.path )}>
						<button style={{ width: "100%", color: "#000" }}>settings</button>*/}
					</div>

					<div key={3} id="TestSpacer"></div>

					{/*<div key={4} id="CategoryActive" onClick={() => this.props.clickActive(["disabledNodes", this.props.path])} style={{}}>
						{<Icon icon={switchIcon} />}
					</div>*/}
				</div>
			</div>


		);

	}
}
export const SWFItem = connect(mapStateToProps, mapDispatchToProps)(SWFItemIntern);
