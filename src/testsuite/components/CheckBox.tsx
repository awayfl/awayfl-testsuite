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
	value:boolean;
	editable:boolean;
	swfTest?: any;
	disabledNodes?: StringTMap<boolean>;
	name: string;
	path: string;
	indent: number;
	obj:any;
	clickActive?: Function;
	openTest?: Function;
}
class CheckBoxIntern extends React.Component<ISWFTestProps, {}> {

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
	public render(): React.ReactElement<{}> {

		//console.log("this.props", this.props);
		return (
			<div id="CheckBox" style={{
				display: "grid",
				gridTemplateColumns: "500px auto",
				gridTemplateRows: "auto",
				height: 25,
				backgroundColor: "#eee",
				color: "#000",
			}}>
				{this.props.value?"true":"false"}
			</div>


		);

	}
}
export const CheckBox = connect(mapStateToProps, mapDispatchToProps)(CheckBoxIntern);
