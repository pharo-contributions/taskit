versions
version05: spec
	<version: '0.5' imports: #('0.2-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.5'.
		spec author: 'SantiagoBragagnolo'.
		spec timestamp: '3/1/2016 16:09'.
		spec 
			package: #TaskIT2 with: 'TaskIT2-SantiagoBragagnolo.23';
			package: #TaskIT2Tests with: 'TaskIT2Tests-SantiagoBragagnolo.14'. ].

	spec for: #'pharo5.x' do: [
		spec package: #TaskIT2Browser with: 'TaskIT2Browser-SantiagoBragagnolo.11'. ].
