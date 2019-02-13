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
					e
						migMethodSource: (self searchWith: aCoder replaceWith: anotherCoder in: e) formattedCode ] ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> initializeLook [
	| methodsList index search replace migrations match apply save reset restart |
	super initializeLook.
	methodsList := self widget childNamed: #methodsList.
	index := self widget childIndexOf: methodsList.
	search := self searchCoder.
	replace := self replaceCoder.
	migrations := self
		migrationsAccordionWithSearch: search
		replace: replace.
	match := self matchButtonWithSearch: search.
	apply := self applyButtonWithSearch: search replace: replace.
	save := self saveButton.
	reset := self resetButton.
	restart := self restartButton.
	self widget
		addChild:
			(BlElement new
				layout: BlLinearLayout horizontal;
				addChildren:
					{match.
					apply.
					save.
					reset.
					restart};
				constraintsDo: [ :c | 
					c vertical fitContent.
					c horizontal matchParent ];
				yourself)
			at: index;
		addChild: replace asElement at: index;
		addChild: search asElement at: index;
		addChild: migrations asElement at: index
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> matchButtonWithSearch: aCoder [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Match';
		action: [ self matchWithSearch: aCoder ];
		yourself
]

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> matchWithSearch: aCoder [
	| block |
	block := aCoder evaluateAndHighlightAllSource.
	(block isKindOf: BlockClosure)
		ifTrue: [ methodsCoder methodCoders
				do: [ :e | 
					e migGtSearchBodyStyler
						ifNotNil: [ :f | 
							f block: block.
							e styleText ] ] ]
]

{ #category : #'as yet unclassified' }
MigGtRuleMethodsCoderLook >> migrationsAccordionWithSearch: aCoder replace: anotherCoder [
	| list accordion |
	list := BrSimpleList new.
	list
		display: (methodsCoder instVarNamed: #originalFilter) migrations;
		stencil: [ :e :i | 
			BrLabel new
				look: BrGlamorousLabelLook new;
				text: e key key;
				padding: (BlInsets all: 5);
				when: BlClickEvent
					do: [ :f | 
					f consumed: true.
					list selectOne: i.
					aCoder source: e key value.
					anotherCoder source: e value.
					self matchWithSearch: aCoder ];
				hMatchParent;
				yourself ];
		yourself.
	accordion := BrAccordion new.
	^ accordion
		look: BrGlamorousAccordionLook new;
		margin: (BlInsets all: 5);
		content: [ list asScrollableElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical exact: 200 ];
				yourself ];
		header: [ BrButton new
				look: BrGlamorousAccordionHeaderLook new;
				label: 'Migrations';
				action: [ accordion toggle ] ];
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
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
MigGtRuleMethodsCoderLook >> restartButton [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: 'Restart';
		action: [ MigGtRTMondrianExample reset ];
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

{ #category : #initialization }
MigGtRuleMethodsCoderLook >> searchWith: aCoder replaceWith: anotherCoder in: e [
	| ast |
	ast := e rbAST.
	(MigRBReplaceNodeVisitor new
		search: aCoder evaluateAndHighlightAllSource;
		replace: anotherCoder evaluateAndHighlightAllSource;
		yourself) visitNode: ast.
	^ ast
]
