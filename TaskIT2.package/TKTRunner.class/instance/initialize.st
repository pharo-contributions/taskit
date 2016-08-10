initialization
initialize
	super initialize.
	exceptionHandler := TKTDebuggerExceptionHandler new.
	TKTProcess uniqueAnnouncer weak when: TKTProcessFinishing send: #verifyRunnerStatus to: self