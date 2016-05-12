value waiting
valueTimeoutOcurred: aBoolean ifTimeOut: aBlock
	aBoolean
		ifTrue: [ ^ aBlock value ].
	^ self basicGetValue