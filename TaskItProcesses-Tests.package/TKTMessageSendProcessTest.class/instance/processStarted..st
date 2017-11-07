accessing
processStarted: aProcessStartedAnnouncement
	process = aProcessStartedAnnouncement process
		ifTrue: [ processStarted := aProcessStartedAnnouncement process ]