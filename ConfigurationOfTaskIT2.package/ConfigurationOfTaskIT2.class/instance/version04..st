versions
version04: spec
	<version: '0.4' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.4'.
		spec author: 'SantiagoBragagnolo'.
		spec timestamp: '2/24/2016 12:25'.
		spec 
			package: #TaskIT2 with: 'TaskIT2-SantiagoBragagnolo.23';
			package: #TaskIT2Tests with: 'TaskIT2Tests-SantiagoBragagnolo.12'. ].

	spec for: #'pharo5.x' do: [
		spec package: #TaskIT2Browser with: 'TaskIT2Browser-SantiagoBragagnolo.11'. ].
