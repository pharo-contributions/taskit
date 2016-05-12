annotations
processAnnotation
	^ processAnnotation ifNil: [ processAnnotation := WeakValueDictionary new ]