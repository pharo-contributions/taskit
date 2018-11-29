"
TKTProcessDataSource is a datasource class for a fast table.
It creates ProcessModels for each tktprocess existant in the system during the initialization, and it registers to the TKTProcess announcer for learned about process state changes and new processes. 

It allows 

	With the TKTProcess:
			inspect it
			pause/resume it
			cancel it
			
	Since a process is spawned only wiht a MessageSend,
	With the MessageSend related to the TKTProcess:
		Inspect the receiver
		Inspect the method to call
		Inspect the rest of implementors of the selector.
		Inspect the arguments
		
	Since this is TaskIT, usually a process is related with a Task Execution and/or a Job
	
		Inspect the TaskExecution object (with the execution callbacks).
		Inspect the Job to know what is this process for.
"
Class {
	#name : #TKTProcessDataSource,
	#superclass : #FTSimpleDataSource,
	#category : 'TaskItBrowser-Widget'
}

{ #category : #'accessing - columns' }
TKTProcessDataSource >> argumentsColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) arguments asStringMorph;
		yourself
]

{ #category : #'menu - columns' }
TKTProcessDataSource >> argumentsMenuColumn: column row: rowIndex [
	| arguments menu |
	arguments := (self elementAt: rowIndex) arguments.
	arguments
		ifNotEmpty: [ 
			menu := UIManager default newMenuIn: self table for: self.
			menu add: 'Inspect arguments' target: arguments selector: #inspect.
			^ menu ].
	^ nil
]

{ #category : #accessing }
TKTProcessDataSource >> cellColumn: column row: rowIndex [
	column id = '#'
		ifTrue: [ ^ FTCellMorph new addMorph: rowIndex asMorph ].
	column id = 'Name'
		ifTrue: [ ^ self nameColumn: column row: rowIndex ].
	column id = 'Sending'
		ifTrue: [ ^ self selectorColumn: column row: rowIndex ].
	column id = 'To'
		ifTrue: [ ^ self receiverColumn: column row: rowIndex ].
	column id = 'With'
		ifTrue: [ ^ self argumentsColumn: column row: rowIndex ].
	column id = 'State'
		ifTrue: [ ^ self stateColumn: column row: rowIndex ].
	"column id = 'Related Task execution'
		ifTrue: [ ^ self taskColumn: column row: rowIndex ]."
	"column id = 'Related Job'
		ifTrue: [ ^ self jobColumn: column row: rowIndex ]."
	self error: 'Invalid column'
]

{ #category : #private }
TKTProcessDataSource >> colorFor: index [
	"index odd ifTrue: [ ^ Smalltalk ui theme lightBackgroundColor ]."
	^ Smalltalk ui theme backgroundColor
	
]

{ #category : #initialization }
TKTProcessDataSource >> createBaseElements [
	^ (TKTProcess allInstances collect: [ :process | TKTProcessModel on: process ]) asOrderedCollection	",
			((Process allInstances reject: #isTerminated) collect: [ :process | TKTSystemProcessModel on: process ])
				asOrderedCollection"
]

{ #category : #private }
TKTProcessDataSource >> iconFor: rowIndex [
	^ (self elementAt: rowIndex) actionOn: self
]

{ #category : #initialization }
TKTProcessDataSource >> initialize [
	super initialize.
	self elements: self createBaseElements.
	TKTProcess uniqueAnnouncer weak when: TKTProcessStarted send: #noteProcessStarted: to: self.
	TKTProcess uniqueAnnouncer weak when: TKTProcessFinishing send: #noteProcessFinished: to: self.
	TKTProcess uniqueAnnouncer weak when: TKTProcessCancelledByThirdThread send: #noteProcessCancelled: to: self.
	TKTProcess uniqueAnnouncer weak when: TKTProcessResumed  send: #noteProcessResumed: to: self.
	TKTProcess uniqueAnnouncer weak when: TKTProcessSuspended send: #noteProcessSuspended: to: self
]

{ #category : #'accessing - columns' }
TKTProcessDataSource >> jobColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) job asStringMorph;
		yourself
]

{ #category : #'menu - columns' }
TKTProcessDataSource >> jobMenuColumn: column row: rowIndex [
	| job menu |
	job := (self elementAt: rowIndex) job.
	job = 'NonJobRelated'
		ifFalse: [ 
			menu := UIManager default newMenuIn: self table for: self.
			menu add: 'Inspect job' target: job selector: #inspect.
			^ menu ].
	^ nil
]

{ #category : #accessing }
TKTProcessDataSource >> menuColumn: column row: rowIndex [
	rowIndex = 0 ifTrue: [ 
		"I could answer a menu without selection, but in this case I will just answer nil, 
		 which means 'no menu'"
		^ nil ].

	"protocols do not have associated menu"
	column id = 'Name' ifTrue: [ ^ self nameMenuColumn: column row: rowIndex ].
	column id = 'Sending' ifTrue: [ ^ self selectorMenuColumn: column row: rowIndex ].	
	column id = 'To' ifTrue: [ ^ self receiverMenuColumn: column row: rowIndex ].	
	column id = 'With' ifTrue: [ ^ self argumentsMenuColumn: column row: rowIndex ].	
	"column id = 'Related Task execution' ifTrue: [ ^ self taskMenuColumn: column row: rowIndex ].	"
	"column id = 'Related Job' ifTrue: [ ^ self jobMenuColumn: column row: rowIndex ].	"
	^ nil	
]

{ #category : #'accessing - columns' }
TKTProcessDataSource >> nameColumn: column row: rowIndex [
	^ FTCellMorph new  
		color: (self colorFor: rowIndex);
		cellInset: 5;
		addMorphBack: (self iconFor: rowIndex) asMorph;
		addMorphBack: (self elementAt: rowIndex) name asStringMorph;
		yourself
]

{ #category : #'menu - columns' }
TKTProcessDataSource >> nameMenuColumn: column row: rowIndex [
	| process menu |
	process := (self elementAt: rowIndex) model.
	process ifNil: [ ^ nil ].
	menu := UIManager default newMenuIn: self table for: self.
	menu add: 'Inspect process' target: process selector: #inspect.
	process isSuspended
		ifTrue: [ menu add: 'Resume process' target: process selector: #resume ]
		ifFalse: [ menu add: 'Suspend process' target: process selector: #suspend ].
	process ifRunning: [ menu add: 'Cancel process' target: process selector: #cancel ].

	^ menu
]

{ #category : #'event-handling' }
TKTProcessDataSource >> noteProcessCancelled: aProcessAnnouncement [
	self elements
		detect: [ :p | p model = aProcessAnnouncement process ]
		ifFound: [ :p | p hasBeenCancelled ].
	self tableRefresh
]

{ #category : #'event-handling' }
TKTProcessDataSource >> noteProcessFinished: aProcessAnnouncement [
	self elements
		detect: [ :p | p model = aProcessAnnouncement process ]
		ifFound: [ :p | p hasFinished ].
	self tableRefresh
]

{ #category : #'event-handling' }
TKTProcessDataSource >> noteProcessResumed: aProcessAnnouncement [
	self elements
		detect: [ :p | p model = aProcessAnnouncement process ]
		ifFound: [ :p | p hasBeenResumed ].
	self tableRefresh
]

{ #category : #'event-handling' }
TKTProcessDataSource >> noteProcessStarted: aProcessAnnouncement [
	self elements add: (TKTProcessModel on: aProcessAnnouncement process).
	self tableRefresh
]

{ #category : #'event-handling' }
TKTProcessDataSource >> noteProcessSuspended: aProcessAnnouncement [
	self elements
		detect: [ :p | p model = aProcessAnnouncement process ]
		ifFound: [ :p | p hasBeenSuspended ].
	self tableRefresh
]

{ #category : #'accessing - columns' }
TKTProcessDataSource >> receiverColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) receiver asStringMorph;
		yourself
]

{ #category : #'menu - columns' }
TKTProcessDataSource >> receiverMenuColumn: column row: rowIndex [
	| receiver menu |
	receiver := (self elementAt: rowIndex) receiver.
	menu := UIManager default newMenuIn: self table for: self.
	menu add: 'Inspect receiver' target: receiver selector: #inspect.
	^ menu
]

{ #category : #'as yet unclassified' }
TKTProcessDataSource >> removeAll [
	^ elements removeAll
]

{ #category : #search }
TKTProcessDataSource >> searchText: aString [
	aString isEmptyOrNil
		ifTrue: [ ^ #() ].
	self elements
		withIndexDo: [ :each :index | 
			(each name beginsWith: aString)
				ifTrue: [ ^ {index} ] ].
	^ #()
]

{ #category : #'accessing - columns' }
TKTProcessDataSource >> selectorColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) selector asStringMorph;
		yourself
]

{ #category : #'menu - columns' }
TKTProcessDataSource >> selectorMenuColumn: column row: rowIndex [
	| selector receiver menu |
	selector := (self elementAt: rowIndex) selector asSymbol.
	receiver := (self elementAt: rowIndex) receiver.
	menu := UIManager default newMenuIn: self table for: self.
	menu add: 'Method' target: [ SystemNavigation default browseHierarchy: receiver class selector: selector ] selector: #value.
	menu add: 'Implementors' target: [ SystemNavigation default browseAllImplementorsOf: selector ] selector: #value.
	^ menu
]

{ #category : #'accessing - columns' }
TKTProcessDataSource >> stateColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) state asStringMorph;
		yourself.
		
	
		
	
	

]

{ #category : #'accessing - columns' }
TKTProcessDataSource >> taskColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) task asStringMorph;
		yourself.
		
		



		
	
	

]

{ #category : #'menu - columns' }
TKTProcessDataSource >> taskMenuColumn: column row: rowIndex [
	| taskExecution menu |
	taskExecution := (self elementAt: rowIndex) task.
	taskExecution = 'NonTaskRelated'
		ifFalse: [ 
			menu := UIManager default newMenuIn: self table for: self.
			menu add: 'Inspect task execution' target: taskExecution selector: #inspect.
			^ menu ].
	^ nil
]

{ #category : #'menu - columns' }
TKTProcessDataSource >> toString: aTKTProcessModel [
	^ aTKTProcessModel indexString
]
