initialization
initialize

	super initialize.
	process := TKTWorkerProcess new taskQueue: queue; yourself.
	WeakRegistry default add: self.