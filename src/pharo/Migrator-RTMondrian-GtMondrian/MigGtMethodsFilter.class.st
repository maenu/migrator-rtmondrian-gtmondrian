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
MigGtMethodsFilter class >> fromGtRTMondrian [
	^ self new
		methods: MigGtRTMondrianExample methods;
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

{ #category : #'as yet unclassified' }
MigGtMethodsFilter class >> inspectGtRTMondrian [
	<script>
	GtInspector openOn: self fromGtRTMondrian
]

{ #category : #'as yet unclassified' }
MigGtMethodsFilter class >> inspectRTMondrian [
	<script>
	GtInspector openOn: self fromRTMondrian
]

{ #category : #converting }
MigGtMethodsFilter >> asCollection [
	^ MigGtSearchMethodsCollection new
		filter: self;
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
	^ (methods isNil
		or: [ methods
				anySatisfy: [ :e | 
					e methodClass = aCompiledMethod methodClass
						and: [ e selector = aCompiledMethod selector ] ] ])
		and: [ search migWords migMatches: aCompiledMethod ast ]
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
