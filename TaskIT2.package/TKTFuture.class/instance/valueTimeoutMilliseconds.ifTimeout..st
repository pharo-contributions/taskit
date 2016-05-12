value waiting
valueTimeoutMilliseconds: aTimeout ifTimeout: aBlock
	^ self valueTimeoutOcurred: (self waitForValue: aTimeout) ifTimeOut: aBlock