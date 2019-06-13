Class {
	#name : #TKTDeployed,
	#superclass : #Object,
	#instVars : [
		'location',
		'archetype'
	],
	#category : #TaskItForkIt
}

{ #category : #accessing }
TKTDeployed class >> pharoScript [
	^ '
#!/usr/bin/env bash
# some magic to find out the real location of this script dealing with symlinks
DIR=`readlink "$0"` || DIR="$0";
DIR=`dirname "$DIR"`;
cd "$DIR"
DIR=`pwd`
cd - > /dev/null
# disable parameter expansion to forward all arguments unprocessed to the VM
set -f
# run the VM and pass along all arguments as is
"$DIR"/"pharo-vm/Pharo.app/Contents/MacOS/Pharo" --headless "$@"'
]

{ #category : #accessing }
TKTDeployed class >> pharoUiScript [
	^ '#!/usr/bin/env bash
# some magic to find out the real location of this script dealing with symlinks
DIR=`readlink "$0"` || DIR="$0";
DIR=`dirname "$DIR"`;
cd "$DIR"
DIR=`pwd`
cd - > /dev/null
# disable parameter expansion to forward all arguments unprocessed to the VM
set -f
# run the VM and pass along all arguments as is
"$DIR"/"pharo-vm/Pharo.app/Contents/MacOS/Pharo" "$@"'
]

{ #category : #accessing }
TKTDeployed >> changesFile [
	^ location / 'Pharo.changes'
]

{ #category : #accessing }
TKTDeployed >> command [
	^ self pharoScript command
		option: self imageFile fullName;
		yourself.
		
		"self vmBinary command
		option:'--headless';
		option: self imageFile fullName;
		yourself"
]

{ #category : #accessing }
TKTDeployed >> commandUi [
	^ self pharoUiScript command
		option: self imageFile fullName;
		yourself
]

{ #category : #accessing }
TKTDeployed >> createScript: ref with: content [
	ref ensureCreateFile.
	(ZnNewLineWriterStream on: ref writeStream)
		forPlatformLineEnding;
		yourself;
		nextPutAll: content;
		close.
	(TKTSystem chmod
		option: '+x';
		argument: ref fullName;
		future) synchronizeTimeout: 5 seconds
]

{ #category : #accessing }
TKTDeployed >> eval [
	^ self command option: 'eval'
]

{ #category : #'evalas yet unclassified' }
TKTDeployed >> evalSerialized: aString [
	| output return input |
	output := UUID new asString asFileReference.
	input := '
	| ston | 
	ston := STONWriter on: (''{1}'' asFileReference ensureDelete; writeStream).
	[ ston nextPut: [{2}] value  ] on:Error do: [ :e |  ston nextPut: e ].
	ston close. 
  '
		format:
			{output fullName.
			aString}.
	(self eval argument: input) future synchronizeTimeout: 15 minutes.
	return := (STONReader on: output readStream) next.
	output ensureDelete.
	^ return 
]

{ #category : #accessing }
TKTDeployed >> imageFile [
	^ location / #'Pharo.image'
]

{ #category : #accessing }
TKTDeployed >> initializeWithLocation: aLocation andArchetype: anArquetype [
	location := aLocation.
	archetype := anArquetype.

]

{ #category : #accessing }
TKTDeployed >> install: url configurationOrBaselineName: confOrBaseline [
	^ self command
		option: 'metacello';
		option: 'install';
		option: url asString;
		option: confOrBaseline asString;
		future
]

{ #category : #accessing }
TKTDeployed >> install: url configurationOrBaselineName: confOrBaseline groups: aCollectionOfGroup [
	^ self command
		option: 'metacello';
		option: 'install';
		option: url asString;
		option: confOrBaseline asString;
		option: ('--groups={1}' format: {(',' join: aCollectionOfGroup)});
		future
]

{ #category : #accessing }
TKTDeployed >> pharoScript [
	(location / 'pharo') exists
		ifFalse:
			[ self createScript: location / 'pharo' with: self class pharoScript ].
	^ location / 'pharo'
]

{ #category : #accessing }
TKTDeployed >> pharoUiScript [
	(location / 'pharo-ui') exists
		ifFalse: [ self
				createScript: location / 'pharo-ui'
				with: self class pharoUiScript ].
	^ location / 'pharo-ui'
]

{ #category : #accessing }
TKTDeployed >> sourcesFile [

	^ location entries
		detect: [ :f | 
			(f basename beginsWith: (archetype version readStream upTo:$-))
				and: [ f basename endsWith: '.sources' ] ]
]

{ #category : #accessing }
TKTDeployed >> vm [
	^ location / 'pharo-vm'
]

{ #category : #accessing }
TKTDeployed >> vmBinary [
	| ref |
	ref := OSPlatform current isMacOS
		ifTrue: [ self vmFolder / 'Pharo.app' / #Contents / #MacOS / #Pharo ]
		ifFalse: [ self vmFolder / #pharo ].
	self assert: ref isFile.
	^ ref
]

{ #category : #'accessingas yet unclassified' }
TKTDeployed >> vmFolder [
	^ location / #'pharo-vm' 
]
