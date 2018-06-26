accessing
actor
	^ aself
		ifNil: [ aself := TKTActor new
				initializeWith: self;
				yourself ]