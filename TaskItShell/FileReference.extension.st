Extension { #name : #FileReference }

{ #category : #'*TaskItShell' }
FileReference >> asOSTask [
	^ [ :spec | spec command: self ] asOSTask
]

{ #category : #'*TaskItShell' }
FileReference >> asOSTask: arguments [
	^ [ :spec | 
	spec
		command: self fullName;
		arguments: arguments ] asOSTask
]

{ #category : #'*TaskItShell' }
FileReference >> future [
	^ self asOSTask future
]

{ #category : #'*TaskItShell' }
FileReference >> future: aRunner [
	^ self asOSTask future: aRunner
]

{ #category : #'*TaskItShell' }
FileReference >> futureWithArguments: arguments [
	^ (self asOSTask: arguments) future
]

{ #category : #'*TaskItShell' }
FileReference >> futureWithArguments: arguments andRunner: aRunner [
	^ (self asOSTask: arguments) future: aRunner
]

{ #category : #'*TaskItShell' }
FileReference >> schedule [ 
	^ self asOSTask schedule
]

{ #category : #'*TaskItShell' }
FileReference >> scheduleWithArguments: arguments [
	^ (self asOSTask: arguments) schedule
]
