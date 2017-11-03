*TaskIt
asWeakReference
	^ (WeakArray new: 1)
		at: 1 put: self;
		yourself