Class {
	#name : #MigGtRTMondrianExample,
	#superclass : #Object,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #'as yet unclassified' }
MigGtRTMondrianExample >> exampleSystemComplexity [

	| b |
	b := RTMondrian new.
	b shape rectangle 
				withBorder;
				width: [ :cls | cls numberOfVariables * 5];
				height: #numberOfMethods;
				linearFillColor: #numberOfLinesOfCode within: RTObject withAllSubclasses.
	b nodes: RTObject withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	b build.
	^ b view
]
