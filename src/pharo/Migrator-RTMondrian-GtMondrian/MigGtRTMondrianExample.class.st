Class {
	#name : #MigGtRTMondrianExample,
	#superclass : #Object,
	#category : #'Migrator-RTMondrian-GtMondrian'
}

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
	<gtExample>
	| b toBeRed |
	toBeRed := #(21 2 3 24 44 63 82 81 83 84 26 46 66 7 8 29 49 69 88 87 51 32 13 33 53 73 93 18 17 16 36 56 57 58 78 98 97 96).
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 15 asPoint;
				background:
					(([ :value | toBeRed includes: value ] value: e)
						ifTrue: [ Color red ]
						ifFalse: [ Color veryLightGray alpha: 0.4 ]);
				yourself ];
		with: (1 to: 100).
	b edges
		connectToAll: [ :v | 
			v \\ 20 ~~ 0
				ifTrue: [ Array with: v + 1 with: v + 20 ]
				ifFalse: [ Array with: v + 20 ] ].
	b layout grid columnCount: 20.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleArrowedLines [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 30 asPoint;
				yourself ];
		with: RTShape withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				arrowedLine;
				withShorterDistanceAttachPoint;
				yourself ];
		connectFrom: #superclass.
	b layout forceWithCharge: -500.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleBezier [
	<gtExample>
	<noTest>
	| classes b |
	(TRPlatform current
		dialogConfirm: 'This example takes a long time to load, execute?')
		ifFalse: [ ^ self ].
	classes := RTObject withAllSubclasses , RTTest withAllSubclasses.
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				yourself ];
		with: classes.
	b edges connectFrom: #superclass.
	b edges
		shape: [ :e | 
			BlElement new
				bezierLineFollowing: #superclass;
				color: (Color blue alpha: 0.2);
				yourself ];
		notUseInLayout;
		connectToAll: #dependentClasses.
	b normalizer
		normalizeSize: #numberOfMethods using: #sqrt;
		normalizeColor: #numberOfMethods
			using: (Array with: Color green with: Color red)
			using: #sqrt.
	b layout cluster.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleBezierLines [
	<gtExample>
	| b lb |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				color: (Color red alpha: 0.4);
				yourself ];
		with: Collection withAllSubclasses.
	b edges connectFrom: #superclass.
	b edges
		shape: [ :e | 
			BlElement new
				bezierLineFollowing: #superclass;
				color: (Color blue alpha: 0.1);
				yourself ];
		notUseInLayout;
		connectToAll: #dependentClasses.
	b normalizer normalizeSize: #numberOfMethods min: 5 max: 50.
	b layout force.
	lb := RTLegendBuilder new.
	lb view: b view.
	lb
		addText:
			'Circle = classes, size = number of methods; gray links = inheritance;'.
	lb
		addText:
			'blue links = dependencies; layout = force based layout on the inheritance links'.
	lb build.
	^ b view @ RTZoomableView
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleBezierLinesAndLayout [
	<gtExample>
	| classes b |
	classes := RTShape withAllSubclasses , TRShape withAllSubclasses.
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				yourself ];
		with: classes.
	b edges connectFrom: #superclass.
	b edges
		shape: [ :e | 
			BlElement new
				bezierLineFollowing: #superclass;
				color: (Color blue alpha: 0.2);
				yourself ];
		notUseInLayout;
		connectToAll: #dependentClasses.
	b normalizer
		normalizeSize: #numberOfMethods using: #sqrt;
		normalizeColor: #numberOfMethods
			using: (Array with: Color green with: Color red)
			using: #sqrt.
	b layout cluster.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClassDependencies [
	<gtExample>
	<noTest>
	| b |
	(TRPlatform current
		dialogConfirm: 'This example takes a long time to load, execute?')
		ifFalse: [ ^ self ].
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 8 asPoint;
				yourself ];
		with: RTObject withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				line;
				color: (Color gray alpha: 0.2);
				yourself ];
		connectToAll: #dependentClasses.
	b normalizer
		normalizeSize: #numberOfMethods using: #sqrt;
		normalizeColor: [ :c | c withAllSuperclasses indexOf: RTObject ]
			using: (Array with: Color red with: Color gray);
		alphaColor: 0.4.
	b layout forceWithCharge: -400.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClasses [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				withBorder;
				width: #numberOfVariables;
				height: #numberOfMethods;
				background: Color white;
				yourself ];
		with: RTObject withAllSubclasses.
	b layout grid.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClusterLayout [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				yourself ];
		with: RTObject withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				line;
				color: (Color blue alpha: 0.4);
				yourself ];
		connectFrom: #superclass.
	b normalizer
		objects: RTObject withAllSubclasses;
		normalizeSize: #numberOfMethods
			min: 5
			max: 30
			using: [ :value | (value + 1) ln ];
		normalizeColor: #numberOfMethods
			using: (Array with: Color gray with: Color blue with: Color red)
			using: [ :value | (value + 1) ln ].
	b layout cluster.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleClusterLayout02 [
	<gtExample>
	<noTest>
	| b |
	(TRPlatform current
		dialogConfirm: 'This example takes a long time to load, execute?')
		ifFalse: [ ^ self ].
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 8 asPoint;
				background:
					(([ :c | c inheritsFrom: RTShape ] value: e)
						ifTrue: [ Color blue ]
						ifFalse: [ ([ :c | c name endsWith: 'Builder' ] value: e)
								ifTrue: [ Color red ]
								ifFalse: [ Color veryLightGray ] ]);
				yourself ];
		with: RTObject withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				line;
				color: (Color gray alpha: 0.1);
				yourself ];
		notUseInLayout;
		connectToAll: #dependentClasses.
	b layout
		for: [ :c | c inheritsFrom: RTLayout ] use: RTForceBasedLayout new;
		for: [ :c | c inheritsFrom: RTShape ] use: RTForceBasedLayout new;
		for: [ :c | c inheritsFrom: RTInteraction ]
			use: RTForceBasedLayout new;
		for: [ :c | c inheritsFrom: RTBuilder ] use: RTForceBasedLayout new;
		for: [ :c | '*Example*' match: c name ] use: RTForceBasedLayout new;
		circleWithRadius: 250.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorInGraph [
	<gtExample>
	<noTest>
	| b |
	(TRPlatform current
		dialogConfirm: 'This example takes a long time to load, execute?')
		ifFalse: [ ^ self ].
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				yourself ];
		with: RTObject withAllSubclasses , TRObject withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				line;
				color: (Color gray alpha: 0.2);
				yourself ];
		connectToAll: #dependentClasses.
	b layout forceWithCharge: -80.
	b normalizer
		normalizeSize: [ :c | c dependentClasses size ]
			min: 5
			max: 25
			using: #log;
		normalizeColor: [ :c | c dependentClasses size ]
			using: (Array with: Color green with: Color red)
			using: #log;
		alphaColor: 0.4.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorPalette [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 20 asPoint;
				yourself ];
		with: RTObject withAllSubclasses.
	b normalizer
		normalizeColor: #numberOfLinesOfCode
		using: (RTColorPalette sequential colors: 9 scheme: 'PuBu')
		using: #ln.
	b layout grid.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorPalette02 [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 20 asPoint;
				yourself ];
		with: RTObject withAllSubclasses.
	b normalizer
		normalizeColor: #numberOfLinesOfCode
		using: (RTColorPalette diverging colors: 11 scheme: 'PRGn')
		using: #ln.
	b layout grid.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColorPalette03 [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 20 asPoint;
				yourself ];
		with: RTObject withAllSubclasses.
	b normalizer
		normalizeColor: #numberOfLinesOfCode
		using: (RTColorPalette sequential colors: 9 scheme: 'YlOrRd')
		using: #ln.
	b layout grid.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleColoredNodes [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				width: [ :cls | cls numberOfVariables * 5 ];
				height: #numberOfMethods;
				if: [ :cls | '*Layout*' match: cls name ] color: Color red;
				if: [ :cls | '*Builder*' match: cls name ] color: Color green;
				yourself ];
		with: RTObject withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleConditionalLayout [
	<gtExample>
	| b |
	b := GtMondrian new.
	b edges
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				background: Color white;
				borderColor: Color lightGray;
				withTextAbove: #name;
				yourself ];
		connectFrom: #superclass.
	b
		nodes: Collection withAllSubclasses
		forEach: [ :cls | 
			b nodes with: cls rtmethods.
			b edges connectToAll: #dependentMethods.
			b layout
				ifElement: #isConnected then: RTTreeLayout new;
				else: RTGridLayout new ].
	b layout tree.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleForce [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 30 asPoint;
				yourself ];
		with: RTShape withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				arrowedLine;
				color: Color black;
				withShorterDistanceAttachPoint;
				yourself ];
		connectFrom: #superclass.
	b layout force
		charge: -500;
		nbIterations: 50.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleForceAndNested [
	<gtExample>
	<noTest>
	| b |
	(TRPlatform current
		dialogConfirm: 'This example takes a long time to load, execute?')
		ifFalse: [ ^ self ].
	b := GtMondrian new.
	b
		nodes: RTShape withAllSubclasses
		forEach: [ :cls | 
			b nodes
				shape: [ :e | 
					BlElement new
						geometry: BlRectangle new;
						color: Color blue;
						yourself ];
				with: cls rtmethods.
			b edges
				shape: [ :e | 
					BlElement new
						line;
						color: Color black;
						yourself ];
				connectToAll: #dependentMethods.
			b layout force ].
	b edges connectFrom: #superclass.
	b layout tree.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleHappy2016 [
	<gtExample>
	| values b ff |
	values := #(61 91 31 2 3 4 5 36 66 96 125 154 183 212 241 241 271 272 273 274 275 276 249 219 189 159 129 99 69 69 39 10 11 12 13 44 74 104 134 164 164 194 194 224 254 283 282 281 280 166 137 108 79 50 21 22 52 82 112 142 172 202 232 262 292 120 90 59 58 57 56 55 84 114 144 174 204 234 264 295 296 297 298 299 270 240 210 209 208 207 206 205).
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlEllipse new;
				size: 20 asPoint;
				background:
					(([ :value | values includes: value ] value: e)
						ifTrue: [ Color red ]
						ifFalse: [ Color white alpha: 0 ]);
				yourself ];
		with: (1 to: 300).
	b edges
		connectToAll: [ :value | 
			value \\ 30 = 0
				ifTrue: [ Array with: value + 30 ]
				ifFalse: [ Array with: value + 1 with: value + 30 ] ].
	b layout grid lineItemsCount: 30.
	ff := RTForceBasedLayout new.
	ff initialLayout: (RTGridLayout new lineItemsCount: 30).
	RTForceLayoutStepping new
		view: b;
		layout: ff;
		inView: b.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleHighlightableEdges [
	<gtExample>
	| b edges |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 10 asPoint;
				color: Color red;
				yourself ];
		with: (1 to: 20).
	edges := b edges connectFrom: [ :v | v // 2 ].
	edges @ RTHighlightable.
	edges
		@
			(RTPopup
				text: [ :association | 
					'An edge from ' , association key asString , ' to '
						, association value asString ]).
	b layout cluster.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleInnerAndPopup [
	<gtExample>
	| b |
	b := GtMondrian new.
	b shape
		rectangle;
		withTextAbove;
		yourself.
	b
		nodes: RTShape withAllSubclasses
		forEach: [ :cls | 
			b nodes
				shape: [ :e | 
					BlElement new
						geometry: BlRectangle new;
						color: Color red;
						size: #numberOfLinesOfCode;
						yourself ];
				with: cls rtmethods.
			b layout grid ].
	b layout flow.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleLayoutPartition [
	<gtExample>
	| b classes |
	classes := (TRPlatform current packageNamed: 'Roassal2')
		definedClasses.
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 5 asPoint;
				yourself ];
		with: classes.
	b edges connectFrom: #superclass.
	b layout
		for: [ :c | 
			(classes intersection: (Array with: c superclass) , c subclasses)
				notEmpty ]
			use: RTTreeLayout new;
		for: [ :c | 
			(classes intersection: (Array with: c superclass) , c subclasses)
				isEmpty ]
			use: RTGridLayout new;
		horizontalLine.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleLegendInPopup [
	<gtExample>
	| b |
	b := GtMondrian new.
	b interaction noInteractions.
	b interaction popup
		group: [ :group :el | 
			| background elements cls legend1 legend2 |
			elements := RTGroup new.
			background := (RTBox new color: (Color green alpha: 0.8)) element.
			el model
				timesRepeat: [ cls := RTEllipse.
					50 atRandom > 25
						ifTrue: [ cls := RTBox ].
					elements
						add:
							(cls new
								size: 10 asPoint;
								color: (Color purple alpha: 0.5)) element ].
			RTGridLayout on: elements.


			"Legend Good"
			legend1 := RTGroup new.
			legend1
				add:
					(RTBox new
						size: 10 asPoint;
						color: (Color purple alpha: 0.5)) element.
			legend1 add: (RTLabel elementOn: '= Good').
			RTHorizontalLineLayout on: legend1.

			"Legend Bad"
			legend2 := RTGroup new.
			legend2
				add:
					(RTEllipse new
						size: 10 asPoint;
						color: (Color purple alpha: 0.5)) element.
			legend2 add: (RTLabel elementOn: '= Bad').
			RTHorizontalLineLayout on: legend2.
			RTVerticalLineLayout new
				gapSize: 0;
				on: (Array with: legend1 with: legend2 with: elements).
			RTNest new
				centerOn: background
				elements: (Array with: legend1 with: legend2 with: elements).
			group add: background.
			group addAll: legend1.
			group addAll: legend2.
			group addAll: elements ].
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				size: #yourself;
				yourself ];
		with: (1 to: 50).
	b layout grid.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNestingAndPopup [
	<gtExample>
	| b |
	b := GtMondrian new.
	b interaction noInteractions.
	b interaction popup
		group: [ :group :el | 
			| background elements |
			elements := OrderedCollection new.
			background := (RTBox new color: (Color green alpha: 0.5)) element.
			el model
				timesRepeat: [ elements
						add:
							(RTBox new
								size: 10 asPoint;
								color: (Color purple alpha: 0.5)) element ].
			RTGridLayout on: elements.
			RTNest new centerOn: background elements: elements.
			group add: background.
			group addAll: elements ].
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				size: #yourself;
				yourself ];
		with: (1 to: 50).
	b layout grid.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNestingAndTitle [
	<gtExample>
	| b |
	b := GtMondrian new.
	b shape
		rectangle;
		withTextAbove;
		yourself.
	b
		nodes: RTShape withAllSubclasses
		forEach: [ :cls | 
			b nodes
				shape: [ :e | 
					BlElement new
						geometry: BlRectangle new;
						color: Color white;
						size: #numberOfLinesOfCode;
						yourself ];
				with: cls rtmethods.
			b layout grid ].
	b flowLayout.
	^ b build
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNormalization [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes with: RTObject withAllSubclasses.
	b normalizer
		objects: RTObject withAllSubclasses;
		normalizeSize: #numberOfMethods
			min: 5
			max: 30
			using: [ :value | (value + 1) ln ];
		normalizeColor: #numberOfMethods
			using: (Array with: Color gray with: Color blue with: Color red)
			using: [ :value | (value + 1) ln ].
	b layout flow.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleNumbersAndBeziers [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes with: (1 to: 300).
	b edges connectFrom: [ :value | value // 2 ].
	b edges
		shape: [ :e | 
			BlElement new
				bezierLineFollowing: [ :value | value // 2 ];
				color: Color blue trans;
				yourself ];
		notUseInLayout;
		connectTo: [ :value | (value / 10) asInteger + (value \\ 10) ].
	b layout cluster.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> examplePartitioningAndNormalization [
	<gtExample>
	| b classes |
	classes := RTLayout withAllSubclasses , RTBuilder withAllSubclasses
		, RTShape withAllSubclasses.
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 5 asPoint;
				yourself ];
		with: classes.
	b edges connectFrom: #superclass.
	b normalizer
		objects: classes;
		normalizeSize: #numberOfMethods min: 5 max: 30;
		normalizeColor: #numberOfLinesOfCode
			using: (Array with: Color green with: Color red)
			using: #sqrt.
	b layout
		for: [ :c | c includesBehavior: RTLayout ]
			use: RTForceBasedLayout new;
		for: [ :c | c includesBehavior: RTBuilder ]
			use: RTForceBasedLayout new;
		for: [ :c | c includesBehavior: RTShape ]
			use: RTForceBasedLayout new;
		flow.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleRadialTree [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 10 asPoint;
				yourself ];
		with: (1 to: 100).
	b edges connectFrom: [ :v | v // 2 ].
	b layout radialTree.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleRandomGraph [
	<gtExample>
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
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				color: (Color black alpha: 0.5);
				yourself ];
		with: nodes.
	b edges
		shape: [ :e | 
			BlElement new
				line;
				color: (Color gray alpha: 0.3);
				yourself ];
		source: edges connectFrom: #key to: #value.
	b layout force.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSidesAndRadius [
	"Thanks to Peter Uhnak for the script"

	<gtExample>
	| sidesCount radius points b els edges |
	sidesCount := 70.
	radius := 2000.
	points := (1 to: sidesCount)
		collect: [ :i | 
			i
				->
					((radius * (Float twoPi * i / sidesCount) cos)
						@ (radius * (Float twoPi * i / sidesCount) sin)) ].
	b := GtMondrian new.
	b shape
		ellipse;
		color: Color transparent;
		size: 0 asPoint;
		yourself.
	els := b nodes with: points.
	b edges shape line color: Color black.
	edges := b edges connectToAll: [ :src | points copyUpTo: src ].
	els do: [ :el | el translateTo: el model value ].
	b view @ RTZoomableView @ RTDraggableView.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSimpleNesting [
	<gtExample>
	| b |
	b := GtMondrian new.
	b
		nodes: (1 to: 20)
		forEach: [ :each | 
			b nodes with: (1 to: each).
			b layout grid ].
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSimpleTree [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				size: 10 asPoint;
				yourself ];
		with: (1 to: 100).
	b edges connectFrom: [ :v | v // 2 ] to: #yourself.
	b layout tree.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSimpleTreeLayout [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				size: 10 asPoint;
				borderColor: Color black;
				yourself ];
		with: (1 to: 100).
	b edges connectFrom: [ :v | v // 2 ].
	b layout tree.
	^ b view
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleStyledLabels [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				styledLabel;
				height: 80;
				bold;
				yourself ];
		with: {'Hello'}.
	b nodes
		shape: [ :e | 
			BlElement new
				styledLabel;
				height: 80;
				italic;
				yourself ];
		with: {'World'}.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSystemComplexity [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				withBorder;
				width: [ :cls | cls numberOfVariables * 5 ];
				height: #numberOfMethods;
				linearFillColor: #numberOfLinesOfCode
					within: RTObject withAllSubclasses;
				yourself ];
		with: RTObject withAllSubclasses.
	b edges connectFrom: #superclass.
	b layout tree.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleSystemComplexity02 [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlRectangle new;
				width: #numberOfVariables;
				height: #numberOfMethods;
				yourself ];
		with: RTObject withAllSubclasses.
	b edges connectToAll: #subclasses.
	b normalizer
		normalizeColor: #numberOfLinesOfCode
		using: (Array with: Color green with: Color red)
		using: #ln.
	b layout tree.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> exampleTreeAndBeziers [
	<gtExample>
	| b |
	b := GtMondrian new.
	b nodes
		shape: [ :e | 
			BlElement new
				geometry: BlCircle new;
				size: 8 asPoint;
				background:
					(([ :c | '*Line*' match: c name ] value: e)
						ifTrue: [ Color red ]
						ifFalse: [ Color veryLightGray ]);
				yourself ];
		with: TRShape withAllSubclasses , RTShape withAllSubclasses.
	b edges
		shape: [ :e | 
			BlElement new
				line;
				yourself ];
		connectFrom: #superclass.
	b edges
		shape: [ :e | 
			BlElement new
				bezierLineFollowing: #superclass;
				color: (Color blue alpha: 0.2);
				yourself ];
		objects: TRShape withAllSubclasses , RTShape withAllSubclasses;
		notUseInLayout;
		connectToAll: #dependentClasses.
	b layout tree.
	^ b
]

{ #category : #accessing }
MigGtRTMondrianExample >> examplenestedTree [
	<gtExample>
	| b |
	b := GtMondrian new.
	b
		nodes: (1 to: 100 by: 10)
		forEach: [ :each | 
			b nodes with: (1 to: each).
			b edges connectFrom: [ :v | v // 2 ].
			b layout cluster ].
	b layout grid.
	^ b view
]
