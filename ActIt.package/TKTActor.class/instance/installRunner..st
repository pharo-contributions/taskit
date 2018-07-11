initialize
installRunner: aRunner
	actorModificationMutex
		critical: [ self ensureRunnerIsSwitchable.
			self beWritableObject.
			runner := aRunner.
			self beReadOnlyObject ]