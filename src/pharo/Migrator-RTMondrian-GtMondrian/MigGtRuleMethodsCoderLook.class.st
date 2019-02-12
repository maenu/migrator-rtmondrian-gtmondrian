Class {
	#name : #MigGtRuleMethodsCoderLook,
	#superclass : #GtImplementorsFilterMethodsCoderLook,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> applyButtonWithSearch: aCoder replace: anotherCoder [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Apply';
		action: [ methodsCoder coders
				do: [ :e | 
					| ast |
					ast := e rbAST.
					(MigRBReplaceNodeVisitor new
						search: aCoder evaluateAndHighlightAllSource;
						replace: anotherCoder evaluateAndHighlightAllSource;
						yourself) visitNode: ast.
					e migMethodSource: ast formattedCode ] ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> initializeLook [
	| methodsList index search match replace apply save reset |
	super initializeLook.
	methodsList := self widget childNamed: #methodsList.
	index := self widget childIndexOf: methodsList.
	search := self searchCoder.
	replace := self replaceCoder.
	match := self matchButtonWithSearch: search.
	apply := self applyButtonWithSearch: search replace: replace.
	save := self saveButton.
	reset := self resetButton.
	self widget
		addChild:
			(BlElement new
				layout: BlLinearLayout horizontal;
				addChildren:
					{match.
					apply.
					save.
					reset};
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal matchParent ];
				yourself)
			at: index;
		addChild: replace asElement at: index;
		addChild: search asElement at: index
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> matchButtonWithSearch: aCoder [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Match';
		action: [ | block |
			block := aCoder evaluateAndHighlightAllSource.
			(block isKindOf: BlockClosure)
				ifTrue: [ methodsCoder methodCoders
						do: [ :e | 
							e migGtSearchBodyStyler
								ifNotNil: [ :f | 
									f block: block.
									e styleText ] ] ] ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> replaceCoder [
	| coder |
	coder := GtPharoSnippetCoder new
		source: '[ :e | e ]';
		yourself.
	^ coder
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> resetButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Reset';
		action: [ methodsCoder methodCoders do: #migReset ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> saveButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Save';
		action: [ methodsCoder methodCoders do: #save ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> searchCoder [
	| coder |
	coder := GtPharoSnippetCoder new
		source: '[ :e | false ]';
		yourself.
	^ coder
]
