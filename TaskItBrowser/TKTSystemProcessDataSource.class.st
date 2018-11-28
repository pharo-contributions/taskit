"
This data source allows to watch system processes into the TaskIT browser. 
Since they are not yet reified as TaskIT tasks / jobs, they do not have extra data nor events.
"
Class {
	#name : #TKTSystemProcessDataSource,
	#superclass : #FTSimpleDataSource,
	#category : 'TaskItBrowser-Widget'
}

{ #category : #accessing }
TKTSystemProcessDataSource >> cellColumn: column row: rowIndex [
	column id = '#'
		ifTrue: [ ^ FTCellMorph new addMorph: rowIndex asMorph ].
	column id = 'Name'
		ifTrue: [ ^ self nameColumn: column row: rowIndex ].
	column id = 'State'
		ifTrue: [ ^ self stateColumn: column row: rowIndex ].
	column id = 'Priority'
		ifTrue: [ ^ self priorityColumn: column row: rowIndex ].
	self error: 'Invalid column'
]

{ #category : #private }
TKTSystemProcessDataSource >> colorFor: index [
	"index odd ifTrue: [ ^ Smalltalk ui theme lightBackgroundColor ]."
	^ Smalltalk ui theme backgroundColor
]

{ #category : #private }
TKTSystemProcessDataSource >> iconFor: rowIndex [
	^ (self elementAt: rowIndex) actionOn: self
]

{ #category : #initialization }
TKTSystemProcessDataSource >> initialize [
	super initialize.
	self elements: TKTSystemProcessModel systemProcesses.
]

{ #category : #accessing }
TKTSystemProcessDataSource >> menuColumn: column row: rowIndex [
	rowIndex = 0
		ifTrue: [ ^ nil ].	"I could answer a menu without selection, but in this case I will just answer nil, 
		 which means 'no menu'"	"protocols do not have associated menu"
	column id = 'Name'
		ifTrue: [ ^ self nameMenuColumn: column row: rowIndex ].
	^ nil
]

{ #category : #'accessing - columns' }
TKTSystemProcessDataSource >> nameColumn: column row: rowIndex [
	^ FTCellMorph new  
		color: (self colorFor: rowIndex);
		cellInset: 20;
		addMorphBack: (self iconFor: rowIndex) asMorph;
		addMorphBack: (self elementAt: rowIndex) name asStringMorph;
		yourself
]

{ #category : #'menu - columns' }
TKTSystemProcessDataSource >> nameMenuColumn: column row: rowIndex [
	| process menu |
	process := (self elementAt: rowIndex) model.
	process ifNil: [ ^ nil ].
	menu := UIManager default newMenuIn: self table for: self.
	menu add: 'Inspect process' target: process selector: #inspect.
	^ menu
]

{ #category : #'accessing - columns' }
TKTSystemProcessDataSource >> priorityColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) priority asStringMorph;
		yourself
]

{ #category : #initialization }
TKTSystemProcessDataSource >> removeAll [
	^ elements removeAll
]

{ #category : #accessing }
TKTSystemProcessDataSource >> searchText: aString [
	aString isEmptyOrNil
		ifTrue: [ ^ #() ].
	self elements
		withIndexDo: [ :each :index | 
			(each name beginsWith: aString)
				ifTrue: [ ^ {index} ] ].
	^ #()
]

{ #category : #'accessing - columns' }
TKTSystemProcessDataSource >> stateColumn: column row: rowIndex [
	^ FTCellMorph new
		color: (self colorFor: rowIndex);
		addMorph: (self elementAt: rowIndex) state asStringMorph;
		yourself.
		
	
		
	
	

]
