initialize
installRunner: aRunner
	aRunner exceptionHandler: self exceptionHandler.
	actorModificationMutex
		critical: [ self ensureRunnerIsSwitchable.
			self beWritableObject.
			runner := aRunner.
			self beReadOnlyObject ]