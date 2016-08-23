private
launch

	worker name: self name.
	worker start.
	worker schedule: [ self setUp ].
	self scheduleRecursiveTask.