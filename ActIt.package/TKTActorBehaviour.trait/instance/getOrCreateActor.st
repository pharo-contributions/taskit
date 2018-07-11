accessing
getOrCreateActor
	^ aself
		ifNil: [ aself := TKTActor new
				initializeWith: self;
				yourself ]