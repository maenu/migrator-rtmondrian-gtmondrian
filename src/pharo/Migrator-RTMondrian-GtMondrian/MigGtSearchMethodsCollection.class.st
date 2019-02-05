Class {
	#name : #MigGtSearchMethodsCollection,
	#superclass : #GtCoderMethodsCollection,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #converting }
MigGtSearchMethodsCollection >> asCoder [
	^ MigGtSearchFilteredMethodsCoder new
		forMethods: self;
		yourself
]
