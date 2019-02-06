Class {
	#name : #MigGtImplementorsFilterMethodsCoderLook,
	#superclass : #GtImplementorsFilterMethodsCoderLook,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #initialization }
MigGtImplementorsFilterMethodsCoderLook >> initializeLook [
	| methodsList index |
	super initializeLook.
	methodsList := self widget childNamed: #methodsList.
	index := self widget childIndexOf: methodsList.
	self widget addChild: self patternElement at: index
]

{ #category : #initialization }
MigGtImplementorsFilterMethodsCoderLook >> patternElement [
	| element editor |
	editor := BrTextEditor new.
	methodsCoder pattern ifNotNil: [ :e | editor text: e asRopedText ].
	element := BrEditorElement new.
	element editor: editor.
	element
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		margin:
			(BlInsets
				top: 10
				left: 10
				bottom: 0
				right: 10).
	element padding: (BlInsets all: 3).
	editor
		when: BrTextEditorInsertedEvent
			do: [ :event | 
			(self updatePattern: editor text asString)
				ifTrue: [ element
						border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1) ]
				ifFalse: [ element border: (BlBorder paint: Color red width: 1) ] ];
		when: BrTextEditorDeletedEvent
			do: [ :event | 
			(self updatePattern: editor text asString)
				ifTrue: [ element
						border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1) ]
				ifFalse: [ element border: (BlBorder paint: Color red width: 1) ] ].
	^ element
]

{ #category : #'event handling' }
MigGtImplementorsFilterMethodsCoderLook >> updatePattern: aString [
	[ RBParseTreeSearcher new matches: aString do: [ :e :f | "noop" ] ]
		on: SyntaxErrorNotification
		do: [ ^ false ].
	methodsCoder pattern: aString.
	^ true
]
