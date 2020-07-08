import * as React from 'react';
import { connect } from "react-redux";
import { IState, StringTMap, ITest } from '../interfaces';
import Icon from 'react-icons-kit';
import { switchIcon } from 'react-icons-kit/icomoon/switchIcon'
import { allActions } from '../actions';
import { warning } from 'react-icons-kit/icomoon/warning'
import { checkboxUnchecked } from 'react-icons-kit/icomoon/checkboxUnchecked'
import { checkboxChecked } from 'react-icons-kit/icomoon/checkboxChecked'
import {folder} from 'react-icons-kit/icomoon/folder'
import {folderOpen} from 'react-icons-kit/icomoon/folderOpen'
const mapStateToProps = (state /*, ownProps*/) => {
	return {};
}

const mapDispatchToProps = (dispatch) => ({
	clickActive: (path) => dispatch({
		type: allActions.toggleValueAtPath,
		path: path
	})
});

interface ISWFTestProps {
	swfTest?: any;
	disabledNodes?: StringTMap<boolean>;
	name: string;
	path: string;
	obj:any;
	clickActive?: Function;
	indent:number;
}
class SWFFolderIntern extends React.Component<ISWFTestProps, {}> {

	public onClickFolder(path) {
		path.push("closed");
		this.props.clickActive(path);
		console.log("onClickFolder")
	}
	public render(): React.ReactElement<{}> {

		console.log("this.props", this.props.name);
		console.log("this.props", this.props.path);
		return (
			<div id="TestDirectory" style={{
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
					height: 25,
					backgroundColor: "#eee",
					color: "#000",
				}}>
					
					<div key={0} id="TestSpacer"></div>
					<div key={1} id="TestSpacer"></div>
					<div key={2} id="TestHeader" style={{ width: "100%", color: "#000" }}
						onClick={() => this.onClickFolder(this.props.path)}>
						<Icon size={"100%"} icon={(this.props.obj as any).closed?folder:folderOpen} />
					</div>
					<div key={3} id="TestSpacer"></div>
					<div key={4} id="TestHeader" style={{ width: "100%", paddingTop: 5 }}>
						{this.props.name}
					</div>
				</div>
				<div key={1} style={{
					backgroundColor: "#eee",

				}}></div>
			</div>


		);

	}
}
export const SWFFolder = connect(mapStateToProps, mapDispatchToProps)(SWFFolderIntern);
