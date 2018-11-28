"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestTaskItDebugger,
	#superclass : #PackageManifest,
	#category : 'TaskItDebugger'
}

{ #category : #'code-critics' }
ManifestTaskItDebugger class >> ruleRBCollectionMessagesToExternalObjectRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'TKTDebugger class' #unegister #true)) #'2016-12-30T15:45:29.100548+01:00') #(#(#RGMethodDefinition #(#'TKTDebugger class' #unregister #true)) #'2016-12-30T15:45:59.447341+01:00') )
]

{ #category : #'code-critics' }
ManifestTaskItDebugger class >> ruleRBContainsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'TKTDebugger class' #unegister #true)) #'2016-12-30T15:45:14.616899+01:00') #(#(#RGMethodDefinition #(#'TKTDebugger class' #unregister #true)) #'2016-12-30T15:46:01.137112+01:00') )
]

{ #category : #'code-critics' }
ManifestTaskItDebugger class >> ruleRBSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'TKTDebugger class' #unegister #true)) #'2016-12-30T15:45:33.656899+01:00') #(#(#RGMethodDefinition #(#'TKTDebugger class' #unregister #true)) #'2016-12-30T15:46:02.56319+01:00') )
]
