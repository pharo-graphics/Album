Class {
	#name : #AlbMainSelectionElement,
	#superclass : #BlOverlayElement,
	#instVars : [
		'selection',
		'vertices',
		'borderWidth',
		'selectionColor',
		'selectionPolygon',
		'editorHandler',
		'elementHandler',
		'focusHandler',
		'monitor'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbMainSelectionElement >> borderWidth [

	^ borderWidth ifNil: [ borderWidth := 1 ]
]

{ #category : #accessing }
AlbMainSelectionElement >> borderWidth: aNumber [

	borderWidth := aNumber
]

{ #category : #'private - focus' }
AlbMainSelectionElement >> defaultSelectionColor [

	^  (Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0)
]

{ #category : #'infinite element changes' }
AlbMainSelectionElement >> extentChangedIn: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #initialization }
AlbMainSelectionElement >> initialize [ 

	super initialize.
	selectionPolygon := BlPolygonElement new.
	selectionPolygon constraintsDo: [ :c | c ignoreByLayout  ].
	selectionPolygon outskirts: (BlOutskirts centered).
	self selectionColor: self defaultSelectionColor
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> maxXRightCoord: yCoord fromRectangles: aListOfRectangles [
	" optimized with compiled in-line primitives "

	| l mostRight |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	mostRight := l first right.
	2 to: l size do: [ :pos | mostRight := mostRight max: (l at: pos) right ].
	^ mostRight
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> minXLeftCoord: yCoord fromRectangles: aListOfRectangles [
	"optimized with compiled in-line primitives "

	| l mostLeft |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	mostLeft := l first left.
	2 to: l size do: [ :pos | mostLeft := mostLeft min: (l at: pos) left ].
	^ mostLeft
]

{ #category : #'private - focus' }
AlbMainSelectionElement >> onGotFocus [ 

	self selectionColor: self defaultSelectionColor
]

{ #category : #'infinite element changes' }
AlbMainSelectionElement >> onInstalledIn: anEditorElement [

	editorHandler := AlbSelectionViewEditorHandler new
		                 selectionView: self;
		                 editorElement: anEditorElement;
		                 yourself.
	elementHandler := AlbSelectionViewElementHandler new selectionView: self; yourself.
	focusHandler := AlbTextEditorFocusHandler new.
	anEditorElement editor addEventHandler: editorHandler.
	anEditorElement editor addEventHandler: focusHandler.
	anEditorElement addEventHandler: elementHandler
]

{ #category : #'private - focus' }
AlbMainSelectionElement >> onLostFocus [ 

	self selectionColor: (Color veryVeryLightGray )
]

{ #category : #'infinite element changes' }
AlbMainSelectionElement >> onUninstalledIn: anEditorElement [

	anEditorElement editor removeEventHandler: editorHandler.
	anEditorElement editor removeEventHandler: focusHandler.
	anEditorElement removeEventHandler: elementHandler
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> rectanglesAtY: anY fromRectangles: aListOfRectangles [

	| rectsAtYExcBottomLines |
	rectsAtYExcBottomLines := self rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles.
	rectsAtYExcBottomLines ifNotEmpty: [ ^ rectsAtYExcBottomLines ].
	^ self rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles [

	^ Array streamContents: [ :stream | aListOfRectangles do: [ :rect |
			(rect top <= anY and: [ rect bottom > anY ]) ifTrue: [ stream nextPut: rect ] ]]
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles [

	^ Array streamContents: [ :stream | aListOfRectangles do: [ :rect |
			(rect top <= anY and: [ rect bottom = anY ]) ifTrue: [ stream nextPut: rect ] ]]
]

{ #category : #'infinite element changes' }
AlbMainSelectionElement >> selectionChangedIn: anInfiniteElement [

	(selection = anInfiniteElement selection and: [vertices notEmpty]) ifTrue: [ ^ self ].
	selection := anInfiniteElement selection copy.
	self updateMainSelectionVerticesIn: anInfiniteElement.
]

{ #category : #accessing }
AlbMainSelectionElement >> selectionColor [

	^ selectionColor
]

{ #category : #accessing }
AlbMainSelectionElement >> selectionColor: aColor [

	aColor = selectionColor ifTrue: [ ^ self ].
	selectionColor := aColor.
	selectionPolygon background: (BlPaintBackground paint: selectionColor).
	selectionPolygon border:	(BlBorder paint: selectionColor muchDarker width: self borderWidth)
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> selectionRectanglesIn: anInfiniteElement [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  anInfiniteElement textElementsDo: [ :te | 
			  te selectionRectangles do: [ :r | 
					stream nextPut: ((anInfiniteElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy: 0 @ (te position y) negated ) ] ] ]
]

{ #category : #'infinite element changes' }
AlbMainSelectionElement >> selectionScrolled: aPoint in: anInfiniteElement [

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #'infinite element changes' }
AlbMainSelectionElement >> textEditedIn: anInfiniteElement [
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> updateMainSelectionVerticesIn: anInfiniteElement [

		| rects |
		rects := self selectionRectanglesIn: anInfiniteElement.
		self vertices: (self verticesFromRectangles: rects).
			
]

{ #category : #accessing }
AlbMainSelectionElement >> vertices: aListOfPoints [

	vertices := aListOfPoints.
	selectionPolygon vertices: vertices.
	vertices	ifEmpty: [ 
			selectionPolygon parentDo: [ :p | selectionPolygon removeFromParent ] ]
		ifNotEmpty: [ 
			selectionPolygon hasParent ifFalse: [ self addChild: selectionPolygon ] ]
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> verticesFromRectangles: aListOfRectangles [
	" raw implementation https://stackoverflow.com/questions/289779/calculating-a-boundary-around-several-linked-rectangles. "
	
	| ret yCoords previousLeftCoord previousRightCoord |
	ret := OrderedCollection new.
	yCoords := self yCoordsFromRectangles: aListOfRectangles.
	yCoords := yCoords sort: [ :a :b | a < b ].
	previousLeftCoord := 0.
	previousRightCoord := 0.
	yCoords do: [ :yCoord | 
		| minimumXLeftCoord maximumXRightCoord first |
		minimumXLeftCoord := self minXLeftCoord: yCoord fromRectangles: aListOfRectangles.
		maximumXRightCoord := self maxXRightCoord: yCoord fromRectangles: aListOfRectangles.
		first := yCoords first.
		yCoord = yCoords first
			ifTrue: [ ret add: minimumXLeftCoord @ yCoord ]
			ifFalse: [ 
				minimumXLeftCoord ~= previousLeftCoord ifTrue: [ ret add: previousLeftCoord @ yCoord beforeIndex: 1 ].
				ret add: minimumXLeftCoord @ yCoord beforeIndex: 1.
				maximumXRightCoord ~= previousRightCoord ifTrue: [ ret add: previousRightCoord @ yCoord ] ].
		ret add: maximumXRightCoord @ yCoord.
		previousLeftCoord := minimumXLeftCoord.
		previousRightCoord := maximumXRightCoord ].
	^ ret
]

{ #category : #'private - vertices computing' }
AlbMainSelectionElement >> yCoordsFromRectangles: aListOfRectangles [

	^ Array streamContents: [ :stream | 
		  aListOfRectangles do: [ :rect | 
			  stream nextPut: rect bottom.
			  stream nextPut: rect top ] ]
]
