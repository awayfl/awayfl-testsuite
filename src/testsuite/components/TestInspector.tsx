import * as React from 'react';
import { connect } from "react-redux";
import { IState, StringTMap, ITest } from '../interfaces';
import Icon from 'react-icons-kit';
import { switchIcon } from 'react-icons-kit/icomoon/switchIcon'
import { allActions } from '../actions';
import { warning } from 'react-icons-kit/icomoon/warning'
import { checkboxUnchecked } from 'react-icons-kit/icomoon/checkboxUnchecked'
import { checkboxChecked } from 'react-icons-kit/icomoon/checkboxChecked'
import { folder } from 'react-icons-kit/icomoon/folder'
import { folderOpen } from 'react-icons-kit/icomoon/folderOpen'
import { TestSettings } from './TestSettings';
import { SWFFrame } from './SWFFrame';
import { SWFInfos } from './SWFInfos';
const mapStateToProps = (state /*, ownProps*/) => {
	return {};
}

const mapDispatchToProps = (dispatch) => ({
	clickActive: (path) => dispatch({
		type: allActions.toggleValueAtPath,
		path: path
	}),
	clickClose: (path) => dispatch({
		type: allActions.closeTest,
	})
});

interface ISWFTestProps {
	swfTest?: any;
	pathToTest:string;
	disabledNodes?: StringTMap<boolean>;
	name: string;
	path: string;
	obj: any;
	clickActive?: Function;
	clickClose?: Function;
	indent: number;
	defaultSettings: any;
}
class TestInspectorIntern extends React.Component<ISWFTestProps, {}> {

	public onClickClose(path) {
		this.props.clickClose(path);
	}

	public renderTest(obj) {
		let output = [];
		if (obj) {
			console.log("obj.testData", obj)
			output.push(<h2 key={0} >test</h2>);
			output.push(<TestSettings key={2}
				settings={obj}
				keys={["player", "date", "duration"]}>
			</TestSettings>);
		}
		else {
			output.push(<h2 key={3}  >test</h2>);
			output.push(<h3 key={4} >test not run yet</h3>);

		}
		return output;


	}
	public renderTestContent(obj) {
		var idCnt = 0;
		if (obj.defaultSettings) {
			// render settings / config for app
			let output = [];
			output.push(<div key={idCnt++} style={{ paddingLeft: "30px", height: "30px", backgroundColor: "#eee" }}>
				<h1>{"AwayFL TestSuite: " + obj.name}</h1>
			</div>)
			output.push(<div key={idCnt++} style={{ width: "100%", paddingLeft: "30px", height: "30px", backgroundColor: "#eee" }}>
				<h2>{"config:"}</h2>
			</div>)
			output.push(<TestSettings key={idCnt++}
				settings={obj.config}
				keys={["path"]}>
			</TestSettings>)
			output.push(<div key={idCnt++} style={{ width: "100%", paddingLeft: "30px", height: "30px", backgroundColor: "#eee" }}>
				<h2>{"defaultSettings:"}</h2>
			</div>)
			output.push(<TestSettings key={idCnt++}
				settings={obj.defaultSettings}
				keys={["path"]}>
			</TestSettings>)
			//console.log("obj", obj);
			return output;
		}
		if (obj.tests) {
			// render settings / config for a TestSWF
			let output = [];
			output.push(<div key={idCnt++} style={{ width: "100%", paddingLeft: "30px", height: "30px", backgroundColor: "#eee" }}>
				<h1>{"AwayFL SWF: " + this.props.obj.name}</h1>
			</div>)

			output.push(<div key={idCnt++} style={{ width: "100%", paddingLeft: "30px", height: "30px", backgroundColor: "#eee" }}>
				<h2>{"Settings: "}</h2>
			</div>)
			output.push(<TestSettings key={idCnt++}
				settings={obj.settings}
				defaultSettings={this.props.defaultSettings}
				keys={["path"]}>
			</TestSettings>)
			return output;
		}
		if (obj.recordetData) {
			// render recordetData for a Test
			let output = [];
			output.push(<div key={idCnt++} style={{ height: "30px", backgroundColor: "#eee" }}>
				<h1>{"AwayFL Test: " + obj.name}</h1>
			</div>)

			output.push(<div key={idCnt++} style={{ height: "30px", backgroundColor: "#eee" }}>
				<h2>{"Settings: "}</h2>
			</div>)
			output.push(<TestSettings key={idCnt++}
				settings={obj.recordetData.settings}
				keys={["onlyTraces"]}>
			</TestSettings>);
			output.push(<div key={idCnt++} style={{
				display: "flex",
				width: "auto", backgroundColor: "#eee"
			}}>
				<div style={{width:"50%"}}>
					<h2>recordet</h2>
					<TestSettings key={idCnt++}
						settings={obj.recordetData}
						keys={["player", "date", "duration"]}>
					</TestSettings>
				</div>
				<div style={{width:"50%"}}>
					{this.renderTest(obj.testData)}
				</div>
			</div>)

			output.push(<SWFInfos key={idCnt++}
				swfInfosRecordet={obj.recordetData?.swfInfos}
				swfInfosTest={obj.testData?.swfInfos}></SWFInfos>);

			output.push(<div key={idCnt++} style={{
				display: "flex", backgroundColor: "#ccc", 
				margin: "5px"
			}}>
				<div style={{width:"100%"}} >
					<h2>frames:{obj.recordetData.frames.length}</h2>
				</div>
				<div style={{ width:"100%", backgroundColor: obj.testData ? obj.testData.frames.length==obj.recordetData.frames.length?"#0f0":"#f00" : "#eee"}}>
					<h2>{obj.testData ? "frames:"+obj.testData.frames.length : ""}</h2>
				</div>
			</div>)
			let maxKeyCount = Math.max(obj.recordetData.frames.length, obj.testData ? obj.testData.frames.length : 0);
			for (let i = 0; i < maxKeyCount; i++) {

				output.push(<SWFFrame key={idCnt++}
					errorColor={obj.testData?"#f00":"#eee"}
					pathToTest={this.props.pathToTest}
					frameRecordet={obj.recordetData.frames[i]}
					frameTest={obj.testData?.frames[i]}
				></SWFFrame>);


			}

			return output;

		}
		return ""
	}
	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);
		return (
			<div id="TestInspector" style={{
				position: "absolute",
				display: "grid",
				gridTemplateColumns: "500px auto",
				gridTemplateRows: "auto",
				left: 0,
				top: 0,
				right: 0,
				bottom: 0,
				color: "#f00",
			}}>
				<div key={0} id="TestInspector" style={{
					position: "absolute",
					display: "grid",
					gridTemplateColumns: "500px auto",
					gridTemplateRows: "auto",
					left: 0,
					top: 0,
					right: 0,
					bottom: 0,
					backgroundColor: "#000",
					opacity: 0.8,
					color: "#000",
				}}
					onClick={() => this.onClickClose(this.props.path)}>

				</div>

				<div key={1} id="TestInspector" style={{
					position: "absolute",
					left: 50,
					top: 50,
					right: 50,
					bottom: 50,
					backgroundColor: "#eee",
					opacity: 1,
					color: "#000",
					overflowX: "hidden",
					overflowY: "auto"
				}}>
					{this.renderTestContent(this.props.obj)}

				</div>
			</div>


		);

	}
}
export const TestInspector = connect(mapStateToProps, mapDispatchToProps)(TestInspectorIntern);
