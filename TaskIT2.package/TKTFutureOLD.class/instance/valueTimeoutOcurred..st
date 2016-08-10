value waiting
valueTimeoutOcurred: aBoolean
	^ self
		valueTimeoutOcurred: aBoolean
		ifTimeOut: [ TKTTimeoutError signal: 'timeout ocurred when getting the future value' ]