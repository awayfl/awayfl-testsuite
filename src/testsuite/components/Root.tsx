import * as React from 'react';
import { connect } from "react-redux";
import { IState, StringTMap, IFolder } from '../interfaces';

import { allActions } from '../actions';
import Select from 'react-select'
import { SWFTest } from './SWFTest';
import { SWFFolder } from './SWFFolder';
import { SWFItem } from './SWFItem';
import { TestInspector } from './TestInspector';

const options = [
	{ value: 'chocolate', label: 'Chocolate' },
	{ value: 'strawberry', label: 'Strawberry' },
	{ value: 'vanilla', label: 'Vanilla' }
]
const mapStateToProps = (state: IState /*, ownProps*/) => {
	return {
		tree: state.tree,
		name: state.name,
		openTest: state.openTest,
		defaultSettings: state.defaultSettings,
		config: state.config
	}
}

const mapDispatchToProps = (dispatch) => ({
	clickTag: (path) => dispatch({
		type: allActions.toggleValueAtPath,
		path: path
	}),

	openConfig: (dispatchFunction) => dispatch(dispatchFunction)
});

interface IRootProps {
	tree?: any;
	name?: string;
	openTest?: string;
	defaultSettings: any;
	openConfig?: Function;
	config:any;
}
class RootIntern extends React.Component<IRootProps, {}> {

	public openConfig(path) {
		this.props.openConfig(function (dispatch) {
			dispatch({
				type: allActions.openTest,
				value: path
			});
		}
		);
	}
	public renderTreeNode(treeNode: any, output, indent: number, path: string[]): any {
		if (treeNode.closed) {
			return;
		}
		if (treeNode.dirs) {
			for (var key in treeNode.dirs) {
				let newPath = path.concat();
				let name=key+"";
				newPath.push("dirs");
				newPath.push(key);
				//console.log(name);
				output.push(<SWFFolder
					key={newPath.join("_")}
					name={name}
					obj={treeNode.dirs[key]}
					path={newPath}
					indent={indent}
				></SWFFolder>);
				if (!treeNode.dirs[key].closed)
					this.renderTreeNode(treeNode.dirs[key], output, indent + 25, newPath);
			}
		}
		if (treeNode.swfs) {
			for (var key in treeNode.swfs) {
				let newPath = path.concat();
				let keyLet = key;
				newPath.push("swfs");
				newPath.push(key);
				output.push(<SWFItem
					key={newPath.join("_")}
					name={keyLet}
					indent={indent}
					obj={treeNode.swfs[keyLet]}
					path={newPath}
				></SWFItem>);
				if (!treeNode.swfs[key].closed) {
					if (treeNode.swfs[key].tests) {
						for (var key2 in treeNode.swfs[key].tests) {
							let newPath2 = newPath.concat();
							newPath2.push("tests");
							newPath2.push(key2);
							output.push(<SWFTest
								key={newPath2.join("_")}
								name={key2}
								indent={indent + 25}
								obj={treeNode.swfs[key].tests[key2]}
								path={newPath2}
							></SWFTest>);
						}
					}
				}
			}

		}
		return output;
	}
	public renderSWFs(): any {
		let output = [];
		this.renderTreeNode(this.props.tree, output, 0, ["tree"]);
		return output;
	}
	public findObjAtPath(path) {
		var obj = this.props;
		for (var i = 0; i < path.length; i++) {
			if (!obj[path[i]]) {
				console.log("IPathAction provides no valid path!");
				return;
			}
			obj = obj[path[i]];
		}
		return obj;
	}
	public findPathToTest(path) {
		let pathToTest = "http://localhost:"+this.props.config.port+"/"+this.props.config.testsDirectoryRoot;
		for (let i = 0; i < path.length; i++) {
			if(path[i]!="tree" && path[i]!="dirs" && path[i]!="swfs" && path[i]!="tests"){
				pathToTest+=path[i]+"/";
			}
		}
		return pathToTest;
	}
	public renderTestInspector(): any {
		if (this.props.openTest) {


			return <TestInspector
				key={5}
				name={this.props.openTest}
				obj={this.findObjAtPath(this.props.openTest)}
				path={this.props.openTest}
				pathToTest={this.findPathToTest(this.props.openTest)}
				defaultSettings={this.props.defaultSettings}
				indent={null}>
			</TestInspector>
		}
		return "";
	}

	public render(): React.ReactElement<{}> {

		return (
			<div id="Root" style={{
				display: "grid",
				width: "100%",
				height: "100%",
				gridTemplateColumns: "auto",
				gridTemplateRows: "70px auto",
				backgroundColor: "#eee",
				overflow: "hidden",
			}}>
				<div key={0} id="Header" style={{
					display: "grid",
					width: "100%",
					height: "100%",
					gridTemplateColumns: "600px 150px 120px auto auto",
					backgroundColor: "#ccc",
				}}>
					<div key={0} style={{ paddingLeft: 40, height: "100%", }}><h1>AwayFL TestSuite {this.props.name}</h1></div>
					{/*<div style={{ 
						display: "grid",
						alignItems: "center",width:"140px", height: 70,}}><Select style={{height:"40px"}} options={options} /></div>
					*/}
					<div key={1} style={{
						display: "flex",
						alignItems: "center",
						width: "100%",
						height: 70,
						//backgroundColor: "#0f0"
					}}>{/*}
						onClick={() => this.openConfig([])}>
				<button style={{ width: "100%", color: "#000" }}>config</button>*/}
					</div>

				</div>
				<div key={1} id="Content" style={{
					position: "absolute",
					left: 0,
					top: 70,
					right: 0,
					bottom: 0,
					backgroundColor: "#eee",
					opacity: 1,
					color: "#000",
					overflowX: "auto",
					overflowY: "auto"
				}}>
					<div key={1} id="Content" style={{
						width: "100%",
						backgroundColor: "#ccc",
					}}>
						{this.renderSWFs()}
					</div>
				</div>
				{this.renderTestInspector()}
			</div>


		);

	}
}
export const Root = connect(mapStateToProps, mapDispatchToProps)(RootIntern);
