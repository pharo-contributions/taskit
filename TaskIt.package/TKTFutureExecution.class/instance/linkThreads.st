private
linkThreads
	self executionProcess isTaskItRawProcess ifFalse: [ ^ self ].
	
	self executionProcess masterProcessHolder: self masterProcessHolder