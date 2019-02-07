Class {
	#name : #MigGtPatternMethodsCoderLook,
	#superclass : #GtImplementorsFilterMethodsCoderLook,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #initialization }
MigGtPatternMethodsCoderLook >> initializeLook [
	| methodsList index |
	super initializeLook.
	methodsList := self widget childNamed: #methodsList.
	index := self widget childIndexOf: methodsList.
	self widget
		addChild: self replacePatternElement at: index;
		addChild: self searchPatternElement at: index
]

{ #category : #initialization }
MigGtPatternMethodsCoderLook >> replacePatternElement [
	| element editor button |
	editor := BrTextEditor new.
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
			(self updateReplacePattern: editor text asString)
				ifTrue: [ element
						border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1) ]
				ifFalse: [ element border: (BlBorder paint: Color red width: 1) ] ];
		when: BrTextEditorDeletedEvent
			do: [ :event | 
			(self updateReplacePattern: editor text asString)
				ifTrue: [ element
						border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1) ]
				ifFalse: [ element border: (BlBorder paint: Color red width: 1) ] ].
	button := BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Apply';
		action: [ | rewriter |
			rewriter := RBParseTreeRewriter new
				replace: methodsCoder pattern with: editor text asString;
				yourself.
			methodsCoder coders
				do: [ :e | 
					| ast |
					ast := e rbAST.
					rewriter executeTree: ast.
					e migMethodSource: ast formattedCode ] ];
		yourself.
	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		addChild: element;
		addChild: button;
		yourself
]

{ #category : #initialization }
MigGtPatternMethodsCoderLook >> searchPatternElement [
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
			(self updateSearchPattern: editor text asString)
				ifTrue: [ element
						border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1) ]
				ifFalse: [ element border: (BlBorder paint: Color red width: 1) ] ];
		when: BrTextEditorDeletedEvent
			do: [ :event | 
			(self updateSearchPattern: editor text asString)
				ifTrue: [ element
						border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1) ]
				ifFalse: [ element border: (BlBorder paint: Color red width: 1) ] ].
	^ element
]

{ #category : #'event handling' }
MigGtPatternMethodsCoderLook >> updateReplacePattern: aString [
	[ RBParseTreeSearcher new matches: aString do: [ :e :f | "noop" ] ]
		on: SyntaxErrorNotification
		do: [ ^ false ].
	^ true
]

{ #category : #'event handling' }
MigGtPatternMethodsCoderLook >> updateSearchPattern: aString [
	[ RBParseTreeSearcher new matches: aString do: [ :e :f | "noop" ] ]
		on: SyntaxErrorNotification
		do: [ ^ false ].
	methodsCoder pattern: aString.
	^ true
]
