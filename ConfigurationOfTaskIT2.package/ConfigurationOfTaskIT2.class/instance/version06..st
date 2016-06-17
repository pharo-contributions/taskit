versions
version06: spec
	<version: '0.6' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.6'.
		spec author: 'SantiagoBragagnolo'.
		spec timestamp: '5/12/2016 17:26'.
		spec 
			package: #TaskIT2 with: 'TaskIT2-SantiagoBragagnolo.27';
			package: #TaskIT2Tests with: 'TaskIT2Tests-SantiagoBragagnolo.17'. ].

	spec for: #'pharo5.x' do: [
		spec package: #TaskIT2Browser with: 'TaskIT2Browser-SantiagoBragagnolo.13'. ].
