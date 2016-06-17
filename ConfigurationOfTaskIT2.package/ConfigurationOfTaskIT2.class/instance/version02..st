versions
version02: spec
	<version: '0.2' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.2'.
		spec author: 'SantiagoBragagnolo'.
		spec timestamp: '8/6/2015 16:57'.
		spec 
			package: #TaskIT2 with: 'TaskIT2-SantiagoBragagnolo.20';
			package: #TaskIT2Tests with: 'TaskIT2Tests-SantiagoBragagnolo.11'. ].

	spec for: #'pharo5.x' do: [
		spec package: #TaskIT2Browser with: 'TaskIT2Browser-SantiagoBragagnolo.9'. ].
