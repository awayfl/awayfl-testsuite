
export interface StringTMap<T> { [key: string]: T; };
export interface NumberTMap<T> { [key: number]: T; };
// todo: types
export interface IState{
	tree:any;
	name:string;
	invalidTests:any;
	openTest:any;
	defaultSettings:any;
	config:any;
}
export interface IFilter{
	disabled:string[];
	selected:string[];
	multiselect:string[];
	
	disabledTreeNodes:string[];
	closedTreeNodes:string[];
	selectedTreeNodes:string[];
	multiselectTreeNodes:string[];
}
export interface IFolder{
    folders:StringTMap<ITest>;
    tests:StringTMap<ITest>;
}
export interface ITest{
    fpVersion:string,
    asVersion:string,
    exVersion:string,
    recorded:string,//date
    recordedUI:string,//date
    tested:string,//date
    numFramesRecorded:number,
    numFramesTested:number,
    numTracesRecorded:number,
    numTracesTested:number,
    numScreenshotsRecorded:number,
    numScreenshotsTested:number,
    numUIEventsRecorded:number,
    message:string,
}

export interface IAction {
    type:string
    value:any
}

export interface IPathAction {
    type:string,
    path:string[],
}
