Extension { #name : #BlockClosure }

{ #category : #'*TaskItShell' }
BlockClosure >> asOSTask [
	^ TKTOSTask buildingCommandWith:  self.
]

{ #category : #'*TaskItShell' }
BlockClosure >> asOSVerboseTask [
	^ TKTOSVerboseTask buildingCommandWith:  self.
]
