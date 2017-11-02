global
global
	^ GlobalInstance
		ifNil: [ GlobalInstance := self new
				name: 'Global TaskIT Common-QUEUE Worker Pool';
				poolMaxSize: 4 ]