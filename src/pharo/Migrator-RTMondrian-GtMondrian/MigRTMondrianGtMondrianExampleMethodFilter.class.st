Class {
	#name : #MigRTMondrianGtMondrianExampleMethodFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'methods'
	],
	#category : #'Migrator-RTMondrian-GtMondrian-Migrator-RTMondrian-GtMondrian'
}

{ #category : #'instance creation' }
MigRTMondrianGtMondrianExampleMethodFilter class >> fromGtMondrian [
	^ self new
		methods:
			(((#'GToolkit-Mondrian' asPackage classTags
				detect: [ :e | e name = #Examples ]) classes
				flatCollect: #gtExamples) collect: #method);
		yourself
]

{ #category : #'instance creation' }
MigRTMondrianGtMondrianExampleMethodFilter class >> fromRTMondrian [
	^ self new
		methods:
			((RTMondrianExample selectors
				select: [ :e | (e beginsWith: 'example') and: [ (e endsWith: 'Icon') not ] ])
				collect: [ :e | RTMondrianExample >> e ]);
		yourself
]

{ #category : #testing }
MigRTMondrianGtMondrianExampleMethodFilter >> includeMethod: aCompiledMethod [
	^ self methods
		anySatisfy: [ :e | 
			e methodClass = aCompiledMethod methodClass
				and: [ e selector = aCompiledMethod selector ] ]
]

{ #category : #accessing }
MigRTMondrianGtMondrianExampleMethodFilter >> methods [
	^ methods
]

{ #category : #accessing }
MigRTMondrianGtMondrianExampleMethodFilter >> methods: anObject [
	methods := anObject
]
