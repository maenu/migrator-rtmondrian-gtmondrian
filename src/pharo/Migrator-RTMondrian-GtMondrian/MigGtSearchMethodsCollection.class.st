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
		search: search;
		forMethods: self;
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
