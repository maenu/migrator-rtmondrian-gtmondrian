Class {
	#name : #MigGtSearchMethodsCollection,
	#superclass : #GtCoderMethodsCollection,
	#instVars : [
		'search'
	],
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #converting }
MigGtSearchMethodsCollection >> asCoder [
	^ MigGtSearchFilteredMethodsCoder new
		forMethods: self;
		implementorsFilterString: search;
		yourself
]

{ #category : #accessing }
MigGtSearchMethodsCollection >> search [
	^ search
]

{ #category : #accessing }
MigGtSearchMethodsCollection >> search: anObject [
	search := anObject
]
