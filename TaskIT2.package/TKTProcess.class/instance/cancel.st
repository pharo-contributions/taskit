running
cancel
	self cancelIfNotRunning: [ self error: 'Process is not running' ]