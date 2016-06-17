deploy
deployValue:  aValue
	| realValue |

	realValue := (aValue class = SmallInteger) ifTrue: [ aValue asFloat ] ifFalse: [ aValue ]. 	
	
	self becomeForward: realValue.
