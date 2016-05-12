notices
noteSuccess: aValue
	self halt.
	self uninstallTaskCallbalks.
	hasBeenDeployed := true.
	isSuccess := true.
	value := aValue.
	self invoke: successCallbacks