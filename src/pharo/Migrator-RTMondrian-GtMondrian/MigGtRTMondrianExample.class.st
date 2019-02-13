Class {
	#name : #MigGtRTMondrianExample,
	#superclass : #Object,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

{ #category : #accessing }
MigGtRTMondrianExample class >> migrations [
	^ {('RTMondrian -> GtMondrian'
		-> [ :e | 
			e isVariable
				and: [ e typType representsClass
						and: [ e typType asClass = RTMondrian class ] ] ]
		-> [ :e | RBParser parseExpression: 'GtMondrian' ]).
	('shape x * -> shape x; *'
		-> [ :e | 
			(e isMessage or: [ e isCascade ])
				and: [ e parent isSequence
						and: [ e receiver isMessage
								and: [ e receiver receiver isMessage
										and: [ e receiver receiver selector = #shape
												and: [ | t |
													t := e receiver receiver receiver typType.
													t representsClass and: [ t asClass = GtMondrian ] ] ] ] ] ] ]
		-> [ :e | 
			| s |
			s := e receiver sourceCode.
			RBParser
				parseExpression: s , ';' , (e sourceCode copyFrom: s size + 1 to: e sourceCode size) ]).
	('shape * -> shape *; yourself'
		-> [ :e | 
			(e isMessage or: [ e isCascade ])
				and: [ e parent isSequence
						and: [ e receiver isMessage
								and: [ e receiver selector = #shape
										and: [ | t |
											t := e receiver receiver typType.
											t representsClass and: [ t asClass = GtMondrian ] ] ] ] ] ]
		-> [ :e | RBParser parseExpression: e sourceCode , '; yourself' ]).
	('nodes: -> nodes with:'
		-> [ :e | 
			e isMessage
				and: [ e receiver typType representsClass
						and: [ e receiver typType asClass = GtMondrian
								and: [ e selector = #nodes: ] ] ] ]
		-> [ :e | 
			RBParser
				parseExpression:
					'(' , e receiver sourceCode , ') nodes with: ('
						, (e arguments at: 1) sourceCode , ')' ]).
	('node: x -> nodes with: {x}'
		-> [ :e | 
			e isMessage
				and: [ e receiver typType representsClass
						and:
							[ e receiver typType asClass = GtMondrian and: [ e selector = #node: ] ] ] ]
		-> [ :e | 
			RBParser
				parseExpression:
					'(' , e receiver sourceCode , ') nodes with: {'
						, (e arguments at: 1) sourceCode , '}' ]).
	('edgesFrom: -> edges connectFrom:'
		-> [ :e | e isMessage and: [ e selector = #edgesFrom: ] ]
		-> [ :e | 
			RBParser
				parseExpression:
					'(' , e receiver sourceCode , ') edges connectFrom: ('
						, (e arguments at: 1) sourceCode , ')' ]).
	('shape x*. nodes y -> nodes shape: [ :e | BlElement new x* ]; y'
		-> [ :e | 
			e isSequence
				and: [ | i |
					i := e statements
						detectIndex: [ :f | 
							f isCascade
								and: [ f receiver isMessage
										and: [ f receiver selector = #shape
												and: [ | t |
													t := f receiver receiver typType.
													t representsClass and: [ t asClass = GtMondrian ] ] ] ] ]
						ifNone: [ 0 ].
					i > 0
						and: [ (e statements copyFrom: i + 1 to: e statements size)
								anySatisfy: [ :f | 
									f isMessage
										and: [ f receiver isMessage
												and: [ f receiver selector = #nodes
														and: [ | t |
															t := f receiver receiver typType.
															t representsClass and: [ t asClass = GtMondrian ] ] ] ] ] ] ] ]
		-> [ :e | 
			| shape nodes i cascade |
			shape := e statements
				detect: [ :f | 
					f isCascade
						and: [ f receiver isMessage
								and: [ f receiver selector = #shape
										and: [ | t |
											t := f receiver receiver typType.
											t representsClass and: [ t asClass = GtMondrian ] ] ] ] ].
			i := e statements indexOf: shape.
			nodes := (e statements copyFrom: i + 1 to: e statements size)
				detect: [ :f | 
					f isMessage
						and: [ f receiver isMessage
								and: [ f receiver selector = #nodes
										and: [ | t |
											t := f receiver receiver typType.
											t representsClass and: [ t asClass = GtMondrian ] ] ] ] ].
			e statements
				remove: shape;
				remove: nodes.
			shape := RBParser
				parseExpression:
					'nil shape: [ :e | BlElement new '
						,
							(shape sourceCode
								copyFrom: shape receiver sourceCode size + 1
								to: shape sourceCode size) , ' ]'.
			cascade := RBCascadeNode
				messages:
					{shape.
					nodes}.
			shape parent: cascade.
			shape receiver: nodes receiver.
			nodes parent: cascade.
			cascade parent: e.
			e statements add: cascade beforeIndex: i.
			e ]).
	('shape x*. edges y -> edges shape: [ :e | BlElement new x* ]; y'
		-> [ :e | 
			e isSequence
				and: [ | i |
					i := e statements
						detectIndex: [ :f | 
							f isCascade
								and: [ f receiver isMessage
										and: [ f receiver selector = #shape
												and: [ | t |
													t := f receiver receiver typType.
													t representsClass and: [ t asClass = GtMondrian ] ] ] ] ]
						ifNone: [ 0 ].
					i > 0
						and: [ (e statements copyFrom: i + 1 to: e statements size)
								anySatisfy: [ :f | 
									(f isMessage or: [ f isCascade ])
										and: [ f receiver isMessage
												and: [ f receiver selector = #edges
														and: [ | t |
															t := f receiver receiver typType.
															t representsClass and: [ t asClass = GtMondrian ] ] ] ] ] ] ] ]
		-> [ :e | 
			| shape edges i cascade |
			shape := e statements
				detect: [ :f | 
					f isCascade
						and: [ f receiver isMessage
								and: [ f receiver selector = #shape
										and: [ | t |
											t := f receiver receiver typType.
											t representsClass and: [ t asClass = GtMondrian ] ] ] ] ].
			i := e statements indexOf: shape.
			edges := (e statements copyFrom: i + 1 to: e statements size)
				detect: [ :f | 
					(f isMessage or: [ f isCascade ])
						and: [ f receiver isMessage
								and: [ f receiver selector = #edges
										and: [ | t |
											t := f receiver receiver typType.
											t representsClass and: [ t asClass = GtMondrian ] ] ] ] ].
			e statements
				remove: shape;
				remove: edges.
			shape := RBParser
				parseExpression:
					'nil shape: [ :e | BlElement new '
						,
							(shape sourceCode
								copyFrom: shape receiver sourceCode size + 1
								to: shape sourceCode size) , ' ]'.
			cascade := RBCascadeNode
				messages:
					{shape}
						,
							(edges isCascade
								ifTrue: [ edges messages ]
								ifFalse: [ {edges} ]).
			shape parent: cascade.
			shape receiver: edges receiver.
			edges isCascade
				ifTrue: [ edges messages do: [ :f | f parent: cascade ] ]
				ifFalse: [ edges parent: cascade ].
			e statements add: cascade beforeIndex: i.
			e ]).
	('circle -> geometry: BlCircle new'
		-> [ :e | 
			e isMessage
				and: [ e selector = #circle
						and: [ e receiver typType representsClass
								and: [ e receiver typType asClass = BlElement ] ] ] ]
		-> [ :e | 
			e
				selector: #geometry:;
				arguments: {(RBParser parseExpression: 'BlCircle new')};
				yourself ]).
	('ellipse -> geometry: BlEllipse new'
		-> [ :e | 
			e isMessage
				and: [ e selector = #ellipse
						and: [ e receiver typType representsClass
								and: [ e receiver typType asClass = BlElement ] ] ] ]
		-> [ :e | 
			e
				selector: #geometry:;
				arguments: {(RBParser parseExpression: 'BlEllipse new')};
				yourself ]).
	('rectangle -> geometry: BlRectangle new'
		-> [ :e | 
			e isMessage
				and: [ e selector = #rectangle
						and: [ e receiver typType representsClass
								and: [ e receiver typType asClass = BlElement ] ] ] ]
		-> [ :e | 
			e
				selector: #geometry:;
				arguments: {(RBParser parseExpression: 'BlRectangle new')};
				yourself ]).
	('size: x:Number -> size: x asPoint'
		-> [ :e | 
			e isMessage
				and: [ e selector = #size:
						and: [ | arg |
							arg := e arguments first.
							arg typType representsClass
								and: [ arg typType asClass inheritsFrom: Number ] ] ] ]
		-> [ :e | 
			e arguments
				at: 1
				put: (RBParser parseExpression: e arguments first sourceCode , ' asPoint').
			e ]).
	('if:fillColor: -> background:'
		-> [ :e | 
			e isCascade
				and: [ e receiver typType representsClass
						and: [ e receiver typType asClass = BlElement
								and: [ (e messages collect: #selector) includes: #if:fillColor: ] ] ] ]
		-> [ :e | 
			| colors ifFillColors defaultColor color background |
			colors := e messages
				select: [ :f | f selector = #color: or: [ f selector = #fillColor: ] ].
			ifFillColors := (e messages
				select: [ :f | f selector = #if:fillColor: ]) asOrderedCollection.
			e messages
				removeAll: colors;
				removeAll: ifFillColors.
			defaultColor := colors
				ifEmpty: [ RBParser parseExpression: 'Color veryLightGray' ]
				ifNotEmpty: [ colors first arguments first ].
			color := defaultColor.
			[ ifFillColors isEmpty ]
				whileFalse: [ | ifFillColor |
					ifFillColor := ifFillColors removeLast.
					color := RBParser
						parseExpression:
							'((' , ifFillColor arguments first sourceCode
								, ') value: e) ifTrue: ['
								, ifFillColor arguments second sourceCode , '] ifFalse: ['
								, color sourceCode , ']' ].
			background := RBParser
				parseExpression: 'nil background: (' , color sourceCode , ')'.
			background parent: e.
			e messages add: background beforeIndex: e messages size.
			e ]).
	('fillColor: -> background:'
		-> [ :e | 
			e isMessage
				and: [ e selector = #fillColor:
						and: [ e receiver typType representsClass
								and: [ e receiver typType asClass = BlElement ] ] ] ]
		-> [ :e | 
			e
				selector: #background:;
				yourself ]).
	('edges moveBehind -> '
		-> [ :e | 
			e isCascade
				and: [ e receiver isMessage
						and: [ e receiver selector = #edges
								and: [ e receiver receiver typType representsClass
										and: [ e receiver receiver typType asClass = GtMondrian ] ] ] ] ]
		-> [ :e | 
			(e messages select: [ :f | f selector = #moveBehind ])
				do: [ :f | e messages remove: f ].
			e ]).
	('gridWithPerRow: -> grid columnCount:'
		-> [ :e | e isMessage and: [ e selector = #gridWithPerRow: ] ]
		-> [ :e | 
			RBParser
				parseExpression:
					'(' , e receiver sourceCode , ') grid columnCount: ('
						, e arguments first sourceCode , ')' ]).
	('build -> '
		-> [ :e | 
			e isSequence
				and: [ e statements
						anySatisfy: [ :f | f isMessage and: [ f selector = #build ] ] ] ]
		-> [ :e | 
			e statements
				remove:
					(e statements
						detect: [ :f | f isMessage and: [ f selector = #build ] ]).
			e ]).
	('view -> ' -> [ :e | e isMessage and: [ e selector = #view ] ]
		-> [ :e | 
			e receiver
				parent: e receiver parent;
				yourself ]).
	('x:Method -> x <gtExample>'
		-> [ :e | e isMethod and: [ (e hasPragmaNamed: #gtExample) not ] ]
		-> [ :e | 
			e addPragma: (RBPragmaNode selector: #gtExample arguments: #()).
			e ])}
]

{ #category : #initialization }
MigGtRTMondrianExample class >> reset [
	<script>
	((RTMondrianExample selectors
		select: [ :e | (e beginsWith: 'example') and: [ (e endsWith: 'Icon') not ] ])
		collect: [ :e | RTMondrianExample >> e ])
		do: [ :e | self compile: e sourceCode ]
]

{ #category : #accessing }
MigGtRTMondrianExample >> example2015 [

| b toBeRed |
toBeRed := #(21 2 3 24 44 63 82 81 83 84 26 46 66 7 8 29 49 69 88 87 51 32 13 33 53 73 93 18 17 16 36 56 57 58 78 98 97 96 ).

b := RTMondrian new.
b shape circle size: 15;
	color: (Color veryLightGray alpha: 0.4);
	if: [ :value | toBeRed includes: value ] fillColor: Color red.

b nodes: (1 to: 100).
b edges
	moveBehind;
	connectToAll: [ :v | 
		v \\ 20 ~~ 0 
			ifTrue: [ Array with: v + 1 with: v + 20 ]
			ifFalse: [ Array with: v + 20 ]
		 ].
b layout gridWithPerRow: 20.
b  build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleArrowedLines [

	| b |
	b := RTMondrian new.

	b shape circle size: 30.
	b nodes: (RTShape withAllSubclasses).

	b shape arrowedLine withShorterDistanceAttachPoint.
	b edgesFrom: #superclass.
	b layout forceWithCharge: -500.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleBezier [
	<gtExample> 
	<noTest>
| classes b |
(TRPlatform current dialogConfirm: 'This example takes a long time to load, execute?')
	ifFalse: [ ^ self ].
classes := RTObject withAllSubclasses, RTTest withAllSubclasses.

b := RTMondrian new.
b shape circle.
b nodes: classes.
b edges connectFrom: #superclass.

b shape bezierLineFollowing: #superclass;
	color: (Color blue alpha: 0.2).
b edges 
	notUseInLayout;
	connectToAll: #dependentClasses.
b normalizer
	normalizeSize: #numberOfMethods using: #sqrt;
	normalizeColor: #numberOfMethods using: (Array with: Color green with: Color red) using: #sqrt.
b layout cluster.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleBezierLines [

| b lb |
b := RTMondrian new.

b shape circle color: (Color red alpha: 0.4).
b nodes: Collection withAllSubclasses.
b edges connectFrom: #superclass.

b shape bezierLineFollowing: #superclass; color: (Color blue alpha: 0.1).
b edges
	notUseInLayout;
	connectToAll: #dependentClasses.

b normalizer
	normalizeSize: #numberOfMethods min: 5 max: 50.

b layout force.
b build.

lb := RTLegendBuilder new.
lb view: b view.
lb addText: 'Circle = classes, size = number of methods; gray links = inheritance;'.
lb addText: 'blue links = dependencies; layout = force based layout on the inheritance links'.
lb build.

^ b view @ RTZoomableView.
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleBezierLinesAndLayout [


| classes b |
classes := RTShape withAllSubclasses, TRShape withAllSubclasses.

b := RTMondrian new.
b shape circle.
b nodes: classes.
b edges connectFrom: #superclass.

b shape bezierLineFollowing: #superclass;
	 color: (Color blue alpha: 0.2).
b edges notUseInLayout; connectToAll: #dependentClasses.
b normalizer
	normalizeSize: #numberOfMethods using: #sqrt;
	normalizeColor: #numberOfMethods using: (Array with: Color green with: Color red) using: #sqrt.
b layout cluster.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClassDependencies [
<gtExample> 
<noTest>
| b |
(TRPlatform current dialogConfirm: 'This example takes a long time to load, execute?')
	ifFalse: [ ^ self ].
b := RTMondrian new.
b shape circle size: 8.
b nodes: RTObject withAllSubclasses.

b shape line color: (Color gray alpha: 0.2).

b edges
	connectToAll: #dependentClasses.

b normalizer
	normalizeSize: #numberOfMethods using: #sqrt;
	normalizeColor: [ :c | c withAllSuperclasses indexOf: RTObject ] using: (Array with: Color red with: Color gray);
	alphaColor: 0.4.
	
b layout forceWithCharge: -400.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClasses [

	| b |
	b := RTMondrian new.
	b shape rectangle 
				withBorder;
				width: #numberOfVariables;
				height: #numberOfMethods;
				fillColor: Color white.
	b nodes: RTObject withAllSubclasses.
	b layout grid.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClusterLayout [

| b |
b := RTMondrian new.

b shape circle.
b nodes: RTObject withAllSubclasses.

b shape line color: (Color blue alpha: 0.4).
b edges connectFrom: #superclass.

b normalizer
	objects: RTObject withAllSubclasses;
	normalizeSize: #numberOfMethods min: 5 max: 30 using: [:value | (value + 1) ln ];
	normalizeColor: #numberOfMethods using: (Array with: Color gray with: Color blue with: Color red) using: [ :value | (value + 1) ln ].
	
b layout cluster.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClusterLayout02 [
<gtExample> 
<noTest>
| b |
(TRPlatform current dialogConfirm: 'This example takes a long time to load, execute?')
	ifFalse: [ ^ self ].
b := RTMondrian new.
b shape circle
	size: 8;
	if: [ :c | c inheritsFrom: RTShape ] fillColor: Color blue;
	if: [ :c | c name endsWith: 'Builder' ] fillColor: Color red.

b nodes: RTObject withAllSubclasses.

b shape line
	color: (Color gray alpha: 0.1)";
	if: [ :f :t | f inheritsFrom: RTLayout ] fillColor: (Color green alpha: 0.2)".
b edges
	notUseInLayout;
	connectToAll: #dependentClasses.

b layout
	for: [ :c | c inheritsFrom: RTLayout ] use: RTForceBasedLayout new;
	for: [ :c | c inheritsFrom: RTShape ] use: RTForceBasedLayout new;
	for: [ :c | c inheritsFrom: RTInteraction ] use: RTForceBasedLayout new;
	for: [ :c | c inheritsFrom: RTBuilder ] use: RTForceBasedLayout new;
	for: [ :c | '*Example*' match: c name] use: RTForceBasedLayout new;
	circleWithRadius: 250.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorInGraph [
<gtExample> 
<noTest>
| b |
(TRPlatform current dialogConfirm: 'This example takes a long time to load, execute?')
	ifFalse: [ ^ self ].
b := RTMondrian new.

b shape circle.
b nodes: ((RTObject withAllSubclasses, TRObject withAllSubclasses)).

b shape line color: (Color gray alpha: 0.2).
b edges 
	moveBehind;
	connectToAll: #dependentClasses.
b layout forceWithCharge: -80.

b normalizer
	normalizeSize: [ :c | c dependentClasses size ]
		min: 5 max: 25 using: #log;
	normalizeColor: [ :c | c dependentClasses size ] 
		using: (Array with: Color green with: Color  red ) using: #log;
	alphaColor: 0.4.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorPalette [
| b |
b := RTMondrian new.
b shape circle
	size: 20.

b nodes: RTObject withAllSubclasses.

b normalizer
	normalizeColor: #numberOfLinesOfCode using: (RTColorPalette sequential colors: 9 scheme: 'PuBu') using: #ln.
	
b layout grid.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorPalette02 [
| b |
b := RTMondrian new.
b shape circle
	size: 20.

b nodes: RTObject withAllSubclasses.

b normalizer
	normalizeColor: #numberOfLinesOfCode using: (RTColorPalette diverging colors: 11 scheme: 'PRGn') using: #ln.
	
b layout grid.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorPalette03 [
| b |
b := RTMondrian new.
b shape circle
	size: 20.

b nodes: RTObject withAllSubclasses.

b normalizer
	normalizeColor: #numberOfLinesOfCode using: (RTColorPalette sequential colors: 9 scheme: 'YlOrRd') using: #ln.
	
b layout grid.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColoredNodes [

	| b |
	b := RTMondrian new.
	b shape rectangle 
				width: [ :cls | cls numberOfVariables * 5];
				height: #numberOfMethods;
				if: [:cls | '*Layout*' match: cls name ] color: Color red;
				if: [:cls | '*Builder*' match: cls name ] color: Color green.
	b nodes: RTObject withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleConditionalLayout [

| b |
b := RTMondrian new.
b shape rectangle
	fillColor: Color white;
	borderColor: Color lightGray;
	withTextAbove: #name.
b nodes: Collection withAllSubclasses forEach: [ :cls |
	b nodes: cls rtmethods.
	b edges connectToAll: #dependentMethods.
	b layout 
		ifElement: #isConnected then: RTTreeLayout new;
		else: RTGridLayout new.
 ].

b edges connectFrom: #superclass.
b layout tree.
b build.
^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleForce [
	| b |
	b := RTMondrian new.

	b shape circle size: 30.
	b nodes: (RTShape withAllSubclasses).

	b shape arrowedLine color: Color black; withShorterDistanceAttachPoint.
	b edges connectFrom: #superclass.
	b layout force charge: -500; nbIterations: 50.

	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleForceAndNested [
	<gtExample> 
	<noTest>
	| b |
	(TRPlatform current dialogConfirm: 'This example takes a long time to load, execute?')
	ifFalse: [ ^ self ].
	b := RTMondrian new.
	b nodes: RTShape withAllSubclasses forEach: [ :cls |
		b shape rectangle color: Color blue.
		b nodes: cls rtmethods.
		b shape line color: Color black.
		b edges connectToAll: #dependentMethods.
		b layout force.
	].
	b edges connectFrom: #superclass.
	b layout tree.
	b build.
	
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleHappy2016 [

| values b ff |
values := #(61 91 31 2 3 4 5 36 66 96 125 154 183 212 241 241 271 272 273 274 275 276 249 219 189 159 129 99 69 69 39 10 11 12 13 44 74 104 134 164 164 194 194 224 254 283 282 281 280 166 137 108 79 50 21 22 52 82 112 142 172 202 232 262 292 120 90 59 58 57 56 55 84 114 144 174 204 234 264 295 296 297 298 299 270 240 210 209 208 207 206 205 ).

b := RTMondrian new.

b shape ellipse size: 20;
	fillColor: (Color white alpha: 0);
	if: [ :value | values includes: value ]  fillColor: Color red.
b nodes: (1 to: 300).
"b shape line color: Color white."
b edges 
	moveBehind;
	connectToAll: [ :value | 
	(value \\ 30 = 0) 
		ifTrue: [ Array with: (value + 30) ]
		ifFalse: [ Array with: (value + 1) with: (value + 30) ]
	 ].
b layout grid lineItemsCount: 30.
b build.

ff := RTForceBasedLayout new.
ff initialLayout: (RTGridLayout new lineItemsCount: 30).
RTForceLayoutStepping new 
	view: b view; 
	layout: ff;
	inView: b view.
^ b view 
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleHighlightableEdges [

| b edges |
b := RTMondrian new.
b shape circle size: 10; color: Color red.
b nodes: (1 to: 20).

edges := b edges moveBehind; connectFrom: [ :v | v // 2 ].
edges @ RTHighlightable.
edges @ (RTPopup text: [ :association | 'An edge from ', association key asString, ' to ', association value asString ]).
b layout cluster.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleInnerAndPopup [
	| b |
	b := RTMondrian new.
	b shape rectangle withTextAbove.
	b nodes: RTShape withAllSubclasses forEach: [:cls | 
		b shape rectangle color: Color red; size: #numberOfLinesOfCode.
		b nodes: cls rtmethods. b layout grid ].
	b layout flow.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleLayoutPartition [
| b classes |
classes := (TRPlatform current packageNamed: 'Roassal2') definedClasses.

b := RTMondrian new.
b shape circle size: 5.
b nodes: classes.
b edges connectFrom: #superclass.

b layout
		for: [ :c | (classes intersection: (Array with: c superclass), c subclasses) notEmpty ] use: RTTreeLayout new;
		for: [ :c | (classes intersection: (Array with: c superclass), c subclasses) isEmpty ] use: RTGridLayout new;
		horizontalLine.
b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleLegendInPopup [
	| b |

	b := RTMondrian new.
	b interaction noInteractions.

	b interaction popup group: [ :group :el |
	
		| background elements cls legend1 legend2 | 
		elements := RTGroup new.
		background := (RTBox new color: (Color green alpha: 0.8)) element.
		
		el model timesRepeat: [ 
				cls := RTEllipse.
				50 atRandom > 25
					ifTrue: [ cls := RTBox ].
				elements add: (cls new size: 10; color: (Color purple alpha: 0.5)) element
				].
		RTGridLayout on: elements.
		
		
		"Legend Good"
		legend1 := RTGroup new.
		legend1 add: (RTBox new size: 10; color: (Color purple alpha: 0.5)) element.
		legend1 add: (RTLabel elementOn: '= Good').
		RTHorizontalLineLayout on: legend1.
		
		"Legend Bad"
		legend2 := RTGroup new.
		legend2 add: (RTEllipse new size: 10; color: (Color purple alpha: 0.5)) element.
		legend2 add: (RTLabel elementOn: '= Bad').
		RTHorizontalLineLayout on: legend2.
		
		RTVerticalLineLayout new gapSize: 0; on: (Array with: legend1 with: legend2 with: elements). 
		
			RTNest new centerOn: background elements: (Array with: legend1 with: legend2 with: elements).

		group add: background.
		group addAll: legend1.
		group addAll: legend2.
		group addAll: elements ].

	b shape rectangle size: #yourself.
	b nodes: (1 to:50).
	b layout grid.
	
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNestingAndPopup [
	| b |
	b := RTMondrian new.
	b interaction noInteractions.

	b interaction popup group: [ :group :el |
		| background elements | 
		elements := OrderedCollection new.
		background := (RTBox new color: (Color green alpha: 0.5)) element.
		el model timesRepeat: [ 
				elements add: (RTBox new size: 10; color: (Color purple alpha: 0.5)) element.
				].
		RTGridLayout on: elements.
		RTNest new centerOn: background elements: elements.
		group add: background .
		group addAll: elements ].

	b shape rectangle size: #yourself.
	b nodes: (1 to:50).
	b layout grid.
	
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNestingAndTitle [

	| b |
	b := RTMondrian new.
	b shape rectangle withTextAbove.
	b nodes: RTShape withAllSubclasses forEach: [:cls | 
		b shape rectangle color: Color white; size: #numberOfLinesOfCode.
		b nodes: cls rtmethods. b layout grid ].
	b flowLayout.
	^ b build
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNormalization [

		| b |
	b := RTMondrian new.

b nodes: RTObject withAllSubclasses.

b normalizer
	objects: RTObject withAllSubclasses;
	normalizeSize: #numberOfMethods min: 5 max: 30 using: [:value | (value + 1) ln ];
	normalizeColor: #numberOfMethods using: (Array with: Color gray with: Color blue with: Color red ) using: [ :value | (value + 1) ln ].
	
b layout flow.
b build.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNumbersAndBeziers [

| b |
b := RTMondrian new.

b nodes: (1 to: 300).
b edges connectFrom: [ :value | value // 2 ].

b shape 
	bezierLineFollowing: [ :value | value // 2 ];
	color: Color blue trans.
b edges 
	notUseInLayout;
	connectTo: [ :value | (value / 10) asInteger + (value \\ 10) ].

b layout cluster.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> examplePartitioningAndNormalization [
| b classes |
classes := RTLayout withAllSubclasses, RTBuilder withAllSubclasses, RTShape withAllSubclasses.

b := RTMondrian new.
b shape circle size: 5.
b nodes: classes.
b edges connectFrom: #superclass.

b normalizer
	objects: classes;
	normalizeSize: #numberOfMethods min: 5 max: 30;
	normalizeColor: #numberOfLinesOfCode using: (Array with: Color green with: Color red ) using: #sqrt.
	

b layout
		for: [ :c | c includesBehavior: RTLayout ] use: RTForceBasedLayout new;
		for: [ :c | c includesBehavior: RTBuilder ] use: RTForceBasedLayout new;
		for: [ :c | c includesBehavior: RTShape ] use: RTForceBasedLayout new;
		flow.
b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleRadialTree [
	| b |
	b := RTMondrian new.
	b shape circle size: 10.
	b nodes: (1 to: 100).
	b edges connectFrom: [ :v | v // 2 ].
	b layout radialTree.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleRandomGraph [

| nbOfNodes nbOfRandomEdges nodes edges b |

nbOfNodes := 40.
nbOfRandomEdges := 40.

nodes := 1 to: nbOfNodes.
edges := (1 to: nbOfRandomEdges) 
				collect: [ :notUsed | nodes atRandom -> nodes atRandom ].

"
In case you do not wish random data. You can set it manually. 
nodes := #(1 2 3 4 5).
edges := { 1 -> 2 . 1 -> 4 . 4 -> 3 }.
"

b := RTMondrian new.

b shape circle color: (Color black alpha: 0.5).
b nodes: nodes.

b shape line color: (Color gray alpha: 0.3).
b edges
	source: edges connectFrom: #key to: #value.

b layout force.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSidesAndRadius [

"Thanks to Peter Uhnak for the script"
|sidesCount radius points b els edges|
sidesCount := 70.
radius := 2000.

points := (1 to: sidesCount) collect: [ :i |
	i -> (
	(radius * ((Float twoPi * i) / sidesCount) cos)
	@
	(radius * ((Float twoPi * i) / sidesCount) sin)
	)
].

b := RTMondrian new.
(b shape ellipse)
	color: Color transparent;
	size: 0.
els := (b nodes: points).
(b edges shape line)
	color: Color black.
edges := b edges connectToAll: [ :src | points copyUpTo: src ].

b build.
els do: [ :el |
	el translateTo: el model value.
].

b view @ RTZoomableView @ RTDraggableView.

^ b view

]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSimpleNesting [

	| b |
	b := RTMondrian new.
	
	b nodes: (1 to: 20) forEach: [ :each |
		b nodes: (1 to: (each)).
		b layout grid.
	].
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSimpleTree [

	| b |
	b := RTMondrian new.
	b shape rectangle size: 10.
	b nodes: (1 to: 100).
	b edges connectFrom: [ :v | v // 2 ] to: #yourself.
	b layout tree.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSimpleTreeLayout [
	| b |
	b := RTMondrian new.
	b shape rectangle size: 10; borderColor: Color black.
	b nodes: (1 to: 100).
	b edges connectFrom: [ :v | v // 2 ].
	b layout tree.
	b build.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleStyledLabels [

| b |
b := RTMondrian new.
b shape styledLabel 
	height: 80;
	bold.
b node: 'Hello'.
b shape styledLabel 
	height: 80;
	italic.
b node: 'World'.
^ b
]

{ #category : #accessing }
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

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSystemComplexity02 [
| b |
b := RTMondrian new.

b shape rectangle
	width: #numberOfVariables;
	height: #numberOfMethods.

b nodes: RTObject withAllSubclasses.

b edges 
	connectToAll: #subclasses.

b normalizer
	normalizeColor: #numberOfLinesOfCode using: (Array with: Color green with: Color red) using: #ln.
	
b layout tree.
b build.
^ b

]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleTreeAndBeziers [
| b |
b := RTMondrian new.
b shape circle
	size: 8;
	if: [ :c | '*Line*' match: c name ] fillColor: Color red.

b nodes: TRShape withAllSubclasses, RTShape withAllSubclasses.

b shape line.
b edges
	connectFrom: #superclass.

b shape bezierLineFollowing: #superclass; color: (Color blue alpha: 0.2).

b edges
	objects: TRShape withAllSubclasses, RTShape withAllSubclasses;
	notUseInLayout;
	connectToAll: #dependentClasses.
	
b layout tree.
^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> examplenestedTree [

	| b |
	b := RTMondrian new.
	
	b nodes: (1 to: 100 by: 10) forEach: [ :each |
		b nodes: (1 to: each).
		b edges connectFrom: [ :v | v // 2 ].
		b layout cluster.
	].
	b layout grid.
	b build.
	^ b view 
]
