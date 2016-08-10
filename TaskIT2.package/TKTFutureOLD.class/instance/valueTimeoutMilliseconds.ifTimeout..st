value waiting
valueTimeoutMilliseconds: aTimeout ifTimeout: aBlock
	^ self valueTimeoutOcurred: (self waitForCompletion: aTimeout) ifTimeOut: aBlock