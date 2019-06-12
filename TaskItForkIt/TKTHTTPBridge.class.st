Class {
	#name : #TKTHTTPBridge,
	#superclass : #TKTBridge,
	#category : #TaskItForkIt
}

{ #category : #accessing }
TKTHTTPBridge >> dependencies [
	^ {self httpTunnel}
]

{ #category : #accessing }
TKTHTTPBridge >> httpTunnel [
	^ [ Metacello new
		baseline: 'HttpTunnel';
		repository: 'github://sbragagnolo/taskit' ]
]
