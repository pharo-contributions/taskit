accessing
processStarted: aProcessStartedAnnouncement
	aProcessStartedAnnouncement process = process
		ifTrue: [ processStarted := aProcessStartedAnnouncement process ]