Extension { #name : #BlockClosure }

{ #category : #'*TaskItForkIt' }
BlockClosure >> stonOn: stonWriter [
	TKTBlockClosureWriter ston: self on: stonWriter
]
