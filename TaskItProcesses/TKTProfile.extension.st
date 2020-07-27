Extension { #name : #TKTProfile }

{ #category : #'*TaskItProcesses' }
TKTProfile class >> development [
	<profile: #development>
	
	^ TKTDevelopmentProfile new
]

{ #category : #'*TaskItProcesses' }
TKTProfile class >> lightweight [
	<profile: #lightweight>
	
	^ TKTLightweigthProfile new
]
