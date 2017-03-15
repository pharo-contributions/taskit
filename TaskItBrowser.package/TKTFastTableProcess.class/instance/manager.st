instance creation
manager
	^ manager
		ifNil: [ 
			manager := TabManagerMorph new
				when: #tabManagerDeleted send: #delete to: self;
				yourself ]