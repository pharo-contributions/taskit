Class {
	#name : #TKTServerDelegate,
	#superclass : #Object,
	#instVars : [
		'prefixMap'
	],
	#category : #'TaskItForkIt-Worker-Server'
}

{ #category : #initialization }
TKTServerDelegate >> encodeIntoResponse: anObject [
	| serial object |
	object := anObject = self
		ifTrue: [ true ]
		ifFalse: [ anObject ].
	serial := TKTSerializationStrategy default writeZnEntityFor: object.
	^ ZnResponse ok: (ZnEntity text: serial)
]

{ #category : #initialization }
TKTServerDelegate >> generateHelp [
	"Generate an HTML page with links to all pages I support"
	
	^ ZnHtmlOutputStream streamContents: [ :html |
		html page: (self class name, ' Help') do: [  	
			html tag: #h3 with: 'Available Pages'.
			html tag: #ul do: [
				prefixMap keys sorted do: [ :each | 
					html tag: #li do: [ 
						html tag: #a attributes: { #href. each } with: each ] ] ] ] ]
]

{ #category : #initialization }
TKTServerDelegate >> handleRequest: request [
	| prefix prefixHandler |
	prefix := request uri isSlash
		ifTrue: [ prefixMap at: '/' ifAbsent: [ nil ] ]
		ifFalse: [ request uri firstPathSegment ].
	prefixHandler := prefixMap at: prefix ifAbsent: [ nil ].
	[ prefixHandler isNil
		ifFalse: [ ^ self
				encodeIntoResponse: ((MessageSend receiver: self selector: prefixHandler) cull: request) ] ]
		on: Error
		do: [ :e | ^ ZnResponse serverError: e messageText ].
	^ ZnResponse notFound: request uri
]

{ #category : #initialization }
TKTServerDelegate >> map: prefix to: handler [
	"Arrange for the receiver to dispatch requests matching prefix to handler.
	Handler can be a symbol naming a method in the receiver, 
	or a block accepting the request and producing the response.
	The special prefix '/' is resolved first and can refer to another prefix."
	
	self prefixMap 
		at: prefix
		put: handler
		
]

{ #category : #initialization }
TKTServerDelegate >> prefixMap [
	^ prefixMap ifNil: [ prefixMap := Dictionary new ]
]
