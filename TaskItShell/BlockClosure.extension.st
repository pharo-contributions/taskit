Extension { #name : #BlockClosure }

{ #category : #'*TaskItShell' }
BlockClosure >> asOSTask [
	^ TKTOSTask buildingCommandWith:  self.
]
