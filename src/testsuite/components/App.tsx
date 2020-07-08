import * as React from 'react';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import { Root } from './Root';
import { IState, IAction, IPathAction } from '../interfaces';
import { reducer, ReducerManager } from '../reducer';
import { allActions } from '../actions';
import { initialState } from '../defaultState';
import thunk from 'redux-thunk';
import * as WebSocketWS from 'isomorphic-ws';


function configureStore() {
    const store = createStore(reducer as any, initialState, applyMiddleware(thunk));
    return store;
}
const store = configureStore();
export class App extends React.Component<{}, {}> {
    public static store: any = store;
    public render(): React.ReactElement<Provider> {
        return (<Provider store={store}>
            <Root />
        </Provider>);
    }
}


function getInitialDataFromServer():any {
    return function (dispatch) {
        fetch("http://localhost:1111/all")
            .then(response => response.json())
            .then(data => dispatch({
                type: allActions.InitialDataFromServer,
                value: data
            }))
            .catch(error => console.log("error in getInitialDataFromServer:", error));
    }
}
store.dispatch(getInitialDataFromServer());

let ws = new WebSocketWS("ws://localhost:1112");

    
ws.onopen = function open() {
	console.log('connected');
	//webSocketConnected();
	//ws.send(Date.now(), null, null);
};
ws.onerror = function error(err) {
	console.log('error connecting to websocket', err);
	//setTimeout(connectToWebSocket, 1000);
	//ws.send(Date.now(), null, null);
};

ws.onclose = function close() {
	//webSocketDisconnected();
	console.log('disconnected');
	//setTimeout(connectToWebSocket.bind(null, username, webSocketConnected, webSocketDisconnected, updateGameStation, ip_adress, socket_port), 1000);
};

ws.onmessage = function incoming(data) {
	console.log('data', data);
};
/*

var xmlhttp = new XMLHttpRequest();
var url = "http://localhost:1111/all";

xmlhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
        var allData = JSON.parse(this.responseText);
        store.dispatch({
            type: allActions.InitialDataFromServer,
            value: allData
        })
    }
};
xmlhttp.open("GET", url, true);
xmlhttp.send();
*/
