value waiting
valueTimeoutMilliseconds: aTimeout
	^ self valueTimeoutOcurred: (self waitForValue: aTimeout)