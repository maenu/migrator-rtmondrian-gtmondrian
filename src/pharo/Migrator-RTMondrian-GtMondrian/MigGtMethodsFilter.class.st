Class {
	#name : #MigGtMethodsFilter,
	#superclass : #GtCoderMethodsFilter,
	#instVars : [
		'methods',
		'search'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #'instance creation' }
MigGtMethodsFilter class >> fromGtMondrian [
	^ self new
		methods:
			(((#'GToolkit-Mondrian' asPackage classTags
				detect: [ :e | e name = #Examples ]) classes
				flatCollect: #gtExamples) collect: #method);
		yourself
]

{ #category : #'instance creation' }
MigGtMethodsFilter class >> fromRTMondrian [
	^ self new
		methods:
			((RTMondrianExample selectors
				select: [ :e | (e beginsWith: 'example') and: [ (e endsWith: 'Icon') not ] ])
				collect: [ :e | RTMondrianExample >> e ]);
		yourself
]

{ #category : #converting }
MigGtMethodsFilter >> asCollection [
	^ MigGtSearchMethodsCollection new
		filter: self;
		search: search;
		yourself
]

{ #category : #accessing }
MigGtMethodsFilter >> highlighter [
	^ MigGtSearchHighlighter new
		search: search;
		yourself
]

{ #category : #testing }
MigGtMethodsFilter >> includeMethod: aCompiledMethod [
	^ (self methods
		anySatisfy: [ :e | 
			e methodClass = aCompiledMethod methodClass
				and: [ e selector = aCompiledMethod selector ] ])
		and: [ search isNil
				or: [ (search migMatchesIn: aCompiledMethod ast) anySatisfy: #isNotEmpty ] ]
]

{ #category : #accessing }
MigGtMethodsFilter >> methods [
	^ methods
]

{ #category : #accessing }
MigGtMethodsFilter >> methods: anObject [
	methods := anObject
]

{ #category : #accessing }
MigGtMethodsFilter >> search [
	^ search
]

{ #category : #accessing }
MigGtMethodsFilter >> search: anObject [
	search := anObject
]
