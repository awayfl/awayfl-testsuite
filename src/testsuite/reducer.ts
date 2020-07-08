

import produce from "immer"
import { IState, IAction, StringTMap, IPathAction } from "./interfaces"
import { allActions } from "./actions";
import { initialState } from "./defaultState";


export class ReducerManager {
	public static reducers: StringTMap<Function> = {};
}
export function reducer(state: IState = initialState, action: IAction) {
	return produce(state, draftState => {
		// produce ("immer") makes state immutable in the "produce", so we can directly modify the drawState
		if (ReducerManager.reducers[action.type]) {
			ReducerManager.reducers[action.type](draftState, action);
		}
		else {
			console.log("Unregistered action dispatched", action)
		}

	});
}


ReducerManager.reducers[allActions.InitialDataFromServer] = (state: IState, action: IAction) => {
	state=Object.assign(state, action.value);

}

ReducerManager.reducers[allActions.openTest] = (state: IState, action: IAction) => {
	state.openTest = action.value;
}
ReducerManager.reducers[allActions.closeTest] = (state: IState, action: IAction) => {
	state.openTest = null;
}
ReducerManager.reducers[allActions.deleteTest] = (state: IState, action: IPathAction) => {
	var obj = state;
	if (!action.path) {
		console.log("IPathAction provides no path!");
		return;
	}
	for (var i = 0; i < action.path.length - 1; i++) {
		if (!obj[action.path[i]]) {
			console.log("IPathAction provides no valid path!");
			return;
		}
		obj = obj[action.path[i]];
	}
	delete obj[action.path[action.path.length - 1]];


}



async function postData(url = '', data = {}) {
	const response = fetch(url, {
		method: 'POST', // *GET, POST, PUT, DELETE, etc.
		headers: {
			'Content-Type': 'application/json'
			// 'Content-Type': 'application/x-www-form-urlencoded',
		},
		body: JSON.stringify(data) // body data type must match "Content-Type" header
	}).catch(error => console.log("error posting data to server", error))
}

ReducerManager.reducers[allActions.toggleValueAtPath] = (state: IState, action: IPathAction) => {
	var obj = state;
	if (!action.path) {
		console.log("IPathAction provides no path!");
		return;
	}
	for (var i = 0; i < action.path.length - 1; i++) {
		if (!obj[action.path[i]]) {
			console.log("IPathAction provides no valid path!");
			return;
		}
		obj = obj[action.path[i]];
	}

	//  update the data on the server (todo: do this somewhere else and report errors in UI)
	(<any>action).value = !obj[action.path[action.path.length - 1]];
	//postData('http://localhost:1111/saveTestData', action);

	obj[action.path[action.path.length - 1]] = !obj[action.path[action.path.length - 1]];
}