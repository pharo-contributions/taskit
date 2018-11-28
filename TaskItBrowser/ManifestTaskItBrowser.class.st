"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestTaskItBrowser,
	#superclass : #PackageManifest,
	#category : 'TaskItBrowser'
}

{ #category : #'code-critics' }
ManifestTaskItBrowser class >> ruleAbstractClassRuleV1FalsePositive [
^ #(#(#(#RGMethodDefinition #(#TKTProcessDataSource #receiverMenuColumn:row: #false)) #'2015-07-27T11:44:24.118702+02:00') #(#(#RGMethodDefinition #(#TKTProcessDataSource #jobMenuColumn:row: #false)) #'2015-07-27T11:44:24.11865+02:00') #(#(#RGMethodDefinition #(#TKTProcessDataSource #nameMenuColumn:row: #false)) #'2015-07-27T11:44:24.11867+02:00') #(#(#RGMethodDefinition #(#TKTProcessDataSource #argumentsMenuColumn:row: #false)) #'2015-07-27T11:44:24.118682+02:00') #(#(#RGMethodDefinition #(#TKTProcessDataSource #selectorMenuColumn:row: #false)) #'2015-07-27T11:44:24.118692+02:00') #(#(#RGMethodDefinition #(#TKTProcessDataSource #taskMenuColumn:row: #false)) #'2015-07-27T11:44:24.118712+02:00') )
]

{ #category : #'code-critics' }
ManifestTaskItBrowser class >> ruleClassNotReferencedRuleV1FalsePositive [
^ #(#(#(#RGClassDefinition #(#TKTWorldMenu)) #'2015-07-27T11:44:24.088255+02:00') )
]

{ #category : #'code-critics' }
ManifestTaskItBrowser class >> ruleInconsistentMethodClassificationRuleV1FalsePositive [
^ #(#(#(#RGMethodDefinition #(#TKTProcessDataSource #searchText: #false)) #'2015-07-27T14:17:14.892739+02:00') )
]

{ #category : #'code-critics' }
ManifestTaskItBrowser class >> ruleRBSentNotImplementedRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#TKTFastTableProcess #systemProcessesTable #false)) #'2016-06-02T11:44:02.570996+02:00') )
]

{ #category : #'code-critics' }
ManifestTaskItBrowser class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [
^ #(#(#(#RGMethodDefinition #(#TKTProcessModel #process: #false)) #'2015-07-27T11:44:24.08094+02:00') #(#(#RGMethodDefinition #(#TKTProcessModel #process: #false)) #'2015-07-27T14:17:15.158592+02:00') )
]
