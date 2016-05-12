task building
send: aSelector 
	self assert: aSelector isSymbol description: ' A valid selector must be specified here' .
	selector := aSelector.