"
Integrates the process browser into the system.
"
Class {
	#name : #TKTWorldMenu,
	#superclass : #Object,
	#category : 'TaskItBrowser-Widget'
}

{ #category : #'world menu' }
TKTWorldMenu class >> menuCommandOn: aBuilder [ 
	<worldMenu> 

	(aBuilder item: self title)
		parent: #Tools;
		icon: ThemeIcons current processBrowserIcon;
		order: 0.5.
]

{ #category : #'world menu' }
TKTWorldMenu class >> monitorCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: 'Process dashboard')
		parent: self title;
		icon: ThemeIcons current processBrowserIcon;
		action: [ TKTFastTableProcess new open ];
		order: 3
]

{ #category : #accessing }
TKTWorldMenu class >> title [

	^ #TaskIT
]

{ #category : #'see class side' }
TKTWorldMenu >> seeClassSide [
]
