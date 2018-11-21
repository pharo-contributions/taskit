"
This is almost a dummy class that just contains the logic for creating a fast table configured with the proper data source 
"
Class {
	#name : #TKTFastTableProcess,
	#superclass : #Object,
	#instVars : [
		'table',
		'manager',
		'window',
		'systable',
		'systemDataSource',
		'processDataSource'
	],
	#category : 'TaskItBrowser-Widget'
}

{ #category : #'as yet unclassified' }
TKTFastTableProcess class >> exampleProcessTable [
	"Show a table with all Object methods, with a header"
	<example>
	| table |

	table := FTTableMorph new
		extent: 650@500;
		addColumn: ((FTColumn id: '#') width: 40);
		addColumn: ((FTColumn id: 'Name') width: 350);
		addColumn: (FTColumn id: 'Sending');
		addColumn: (FTColumn id: 'To');
		addColumn: (FTColumn id: 'With');
		addColumn: (FTColumn id: 'State');
		addColumn: (FTColumn id: 'Related Task execution');
		addColumn: (FTColumn id: 'Related Job');
		intercellSpacing: 1;
		dataSource: (TKTProcessDataSource new);
		selectRowIndex: 1;
		showFirstRowSelection;
		onAnnouncement: FTSelectionChanged 
			do: [ :ann | ('rows selected: ', (ann newSelectedRowIndexes asString)) crLog ];
		onAnnouncement: FTStrongSelectionChanged 
			do: [ :ann | ('double-click on row: ', (ann selectedRowIndex asString)) crLog ];
		beMultipleSelection;
		yourself.
		
	^ table openInWindow
]

{ #category : #'as yet unclassified' }
TKTFastTableProcess class >> processTable [
	"Show a table with all Object methods, with a header"
	<example>
	| table |

	table := FTTableMorph new
		extent: 650@500;
		addColumn: ((FTColumn id: '#') width: 40);
		addColumn: ((FTColumn id: 'Name') width: 350);
		addColumn: (FTColumn id: 'Sending');
		addColumn: (FTColumn id: 'To');
		addColumn: (FTColumn id: 'With');
		addColumn: (FTColumn id: 'State');
		addColumn: (FTColumn id: 'Related Task execution');
		addColumn: (FTColumn id: 'Related Job');
		intercellSpacing: 1;
		dataSource: (TKTProcessDataSource new);
		selectRowIndex: 1;
		showFirstRowSelection;
		onAnnouncement: FTSelectionChanged 
			do: [ :ann | ('rows selected: ', (ann newSelectedRowIndexes asString)) crLog ];
		onAnnouncement: FTStrongSelectionChanged 
			do: [ :ann | ('double-click on row: ', (ann selectedRowIndex asString)) crLog ];
		beMultipleSelection;
		yourself.
		
	^ table openInWindow
]

{ #category : #'instance creation' }
TKTFastTableProcess >> cleanUpSources [
	systemDataSource removeAll.
	processDataSource removeAll.
]

{ #category : #accessing }
TKTFastTableProcess >> delete [
	window ifNotNil: [ window delete ]
]

{ #category : #'instance creation' }
TKTFastTableProcess >> manager [
	^ manager
		ifNil: [ 
			manager := TabManagerMorph new
				when: #tabManagerDeleted send: #delete to: self;
				yourself ]
]

{ #category : #'instance creation' }
TKTFastTableProcess >> open [
	window := self manager openInWindowLabeled: 'TaskIT v0.2 Process dashboard'.
	window on: WindowClosed send: #cleanUpSources to: self.
	window bounds: (Rectangle origin: 100@100 corner: Display extent /2). 
	self manager addTab: self taskItProcessesTable.
	self manager addTab: self systemProcessesTable
]

{ #category : #accessing }
TKTFastTableProcess >> systemProcessesTable [
	^ systable
		ifNil: [ systemDataSource := TKTSystemProcessDataSource new.
			systable := TabMorph
				label: 'System Processes'
				icon: Smalltalk ui icons smallHelp
				retrievingBlock: [ FTTableMorph new
						extent: 650 @ 500;
						addColumn: ((FTColumn id: '#') width: 20);
						addColumn: ((FTColumn id: 'Priority') width: 50);
						addColumn: ((FTColumn id: 'Name') width: 600);
						addColumn: ((FTColumn id: 'State') width: 40);
						intercellSpacing: 1;
						dataSource: systemDataSource;
						selectRowIndex: 1;
						showFirstRowSelection;
						beMultipleSelection;
						enableFilter;
						yourself ] ]
]

{ #category : #accessing }
TKTFastTableProcess >> taskItProcessesTable [
	^ table
		ifNil: [ processDataSource := TKTProcessDataSource new.
			table := TabMorph
				label: 'TaskIT Processes'
				icon: Smalltalk ui icons smallHelpIcon
				retrievingBlock: [ FTTableMorph new
						extent: 650 @ 500;
						addColumn: ((FTColumn id: '#') width: 40);
						addColumn: ((FTColumn id: 'Name') width: 250);
						addColumn: ((FTColumn id: 'Sending') width: 150);
						addColumn: ((FTColumn id: 'To') width: 200);
						addColumn: ((FTColumn id: 'With') width: 50);
						addColumn: ((FTColumn id: 'State') width: 70);
						"						addColumn: ((FTColumn id: 'Related Task execution') width: 250);"
							"						addColumn: ((FTColumn id: 'Related Job') width: 100);"
							intercellSpacing: 1;
						dataSource: processDataSource;
						selectRowIndex: 1;
						showFirstRowSelection;
						beMultipleSelection;
						beResizable;
						enableFilter;
						yourself ] ]
]
