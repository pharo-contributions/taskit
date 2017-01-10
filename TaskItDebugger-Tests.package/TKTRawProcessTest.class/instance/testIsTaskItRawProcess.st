tests
testIsTaskItRawProcess
	| rawProcess |
	rawProcess := self newRawProcess.
	
	self assert: rawProcess isTaskItRawProcess