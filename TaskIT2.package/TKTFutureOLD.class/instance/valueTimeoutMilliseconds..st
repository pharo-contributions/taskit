value waiting
valueTimeoutMilliseconds: aTimeout
	^ self valueTimeoutOcurred: (self waitForCompletion: aTimeout)