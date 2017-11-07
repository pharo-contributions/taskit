accessing
processFinishing: aProcessFinishingAnnouncement
	process = aProcessFinishingAnnouncement process
		ifTrue: [ processFinishing := aProcessFinishingAnnouncement process ]