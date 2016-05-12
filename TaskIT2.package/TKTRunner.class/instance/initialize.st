initialization
initialize
	super initialize.
	TKTProcess uniqueAnnouncer weak when: TKTProcessFinishing send: #verifyRunnerStatus to: self