versions
version03: spec
	<version: '0.3' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.3'.
		spec author: 'SantiagoBragagnolo'.
		spec timestamp: '12/11/2015 11:43'.
		spec 
			package: #TaskIT2 with: 'TaskIT2-SantiagoBragagnolo.21';
			package: #TaskIT2Tests with: 'TaskIT2Tests-SantiagoBragagnolo.12'. ].

	spec for: #'pharo5.x' do: [
		spec package: #TaskIT2Browser with: 'TaskIT2Browser-SantiagoBragagnolo.11'. ].
