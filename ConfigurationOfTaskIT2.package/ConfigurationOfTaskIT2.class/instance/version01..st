versions
version01: spec
	<version: '0.1' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.1'.
		spec author: 'SantiagoBragagnolo'.
		spec timestamp: '7/28/2015 17:01'.
		spec 
			package: #TaskIT2 with: 'TaskIT2-SantiagoBragagnolo.18';
			package: #TaskIT2Tests with: 'TaskIT2Tests-SantiagoBragagnolo.10'. ].

	spec for: #'pharo5.x' do: [
		spec package: #TaskIT2Browser with: 'TaskIT2Browser-SantiagoBragagnolo.9'. ].
