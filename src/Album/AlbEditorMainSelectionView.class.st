Class {
	#name : #AlbEditorMainSelectionView,
	#superclass : #AlbEditorSelectionView,
	#instVars : [
		'selection',
		'echo',
		'selectedString',
		'echoUpdater',
		'echoAllowed'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorMainSelectionView >> borderColor [
	^ self selectionColor  
]

{ #category : #accessing }
AlbEditorMainSelectionView >> borderWidth [
	^ 2
]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> echoInterval: anInterval in: anEditorElement [

	| startIdx endIdx rects |
	startIdx := anInterval first.
	endIdx := anInterval last.
	rects := Array streamContents: [ :stream | 
		         anEditorElement
			         textPiecesAndTheirElementsWithinIndexInterval: (startIdx to: endIdx)
			         do: [ :piece :pieceElement | 
				         | first last origin corner bnds |
				         ((piece textStart to: piece textEnd) includesAll: (startIdx to: endIdx))
					         ifTrue: [ 
						         first := startIdx.
						         last := endIdx ]
					         ifFalse: [ 
						         startIdx > piece textStart
							         ifTrue: [ 
								         first := startIdx.
								         last := piece textEnd ]
							         ifFalse: [ 
								         first := piece textStart.
								         last := endIdx min: piece textEnd ] ].
				         origin := pieceElement screenOriginAt: first - piece textStart - 1.
				         corner := pieceElement screenCornerAt: last - piece textStart.
				         bnds := (origin corner: corner) translateBy: pieceElement positionInEditor.
				         stream nextPut: bnds ] ].
	rects ifEmpty: [ ^ self ].
	echo add: (AlbEditorSelectionEchoView new vertices: (self verticesFromRectangles: rects) )
]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> echoUpdatedIn: anEditorElement [

	echoUpdater := nil.
	anEditorElement invalidate
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> extentChangedIn: anInfiniteElement [

	self forceUpdate.
	self selectionChangedIn: anInfiniteElement
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> forceUpdate [

	selection := nil
]

{ #category : #initialization }
AlbEditorMainSelectionView >> initialize [
	super initialize.
	echo := OrderedCollection new.
	echoAllowed := true
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> maxXRightCoord: yCoord fromRectangles: aListOfRectangles [

	| l |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	^ (l sort: [ :a :b | a right > b right ]) first right
]

{ #category : #'private - limit computing' }
AlbEditorMainSelectionView >> minLimitWidth [
	^ 0
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> minXLeftCoord: yCoord fromRectangles: aListOfRectangles [

	| l |
	l := self rectanglesAtY: yCoord fromRectangles: aListOfRectangles.
	^ (l sort: [ :a :b | a left < b left ]) first left
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> rectanglesAtY: anY fromRectangles: aListOfRectangles [

	| rectsAtYExcBottomLines |
	rectsAtYExcBottomLines := self rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles.
	rectsAtYExcBottomLines ifNotEmpty: [ ^ rectsAtYExcBottomLines ].
	^ self rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> rectsAtYExcBottomLines: anY fromRectangles: aListOfRectangles [

	^ aListOfRectangles select: [ :rect | rect top <= anY and: [ rect bottom > anY ] ]
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> rectsAtYIncBottomLines: anY fromRectangles: aListOfRectangles [

	^ aListOfRectangles select: [ :rect | rect top <= anY and: [ rect bottom = anY ] ]
]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> resetCurrentEcho [

	echo reset
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> selectionChangedIn: anInfiniteElement [

	selection = anInfiniteElement selection ifTrue: [ ^ self ].
	selection := anInfiniteElement selection copy.
	selectedString := anInfiniteElement selectedText asString.

	self updateMainSelectionVerticesIn: anInfiniteElement
]

{ #category : #accessing }
AlbEditorMainSelectionView >> selectionColor [

	^ Color
		  r: 0.9530791788856305
		  g: 0.8084066471163245
		  b: 0.1906158357771261
		  alpha: 1.0
]

{ #category : #'private - limit computing' }
AlbEditorMainSelectionView >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement [

	" Select lines with cursor or with an element at left which has a selection that start at 0 "

	(anItemElement children
		 select: [ :e | 
			 (e isKindOf: BlTextElement) and: [ 
				 e bounds inParent left isZero and: [ e selection isNotEmpty and: [ e selection from isZero ] ] ] ]
		 thenCollect: [ :e | e textFlow assignedLine ]) in: [ :l | 
		l ifEmpty: [ ^ nil ].
		^ 0 @ l first origin y corner: self minLimitWidth @ (l last origin y + l last height) ]
]

{ #category : #'private - limit computing' }
AlbEditorMainSelectionView >> selectionLimitRectanglesIn: anInfiniteElement [

	^ Array streamContents: [ :stream | 
		  anInfiniteElement childrenDo: [ :child | 
			  | rect |
			  rect := self selectionLimitRectangleOf: child in: anInfiniteElement.
			  rect ifNotNil: [ stream nextPut: ((BlBounds fromRectangle: rect) translateBy: child bounds asRectangle origin)] ] ]
]

{ #category : #'selection accessing' }
AlbEditorMainSelectionView >> selectionRectanglesIn: anInfiniteElement [

	"return all selections rectangles from coordinate system of text elements with selection to my local coordinates"

	^ Array streamContents: [ :stream | 
		  anInfiniteElement textElementsDo: [ :te | 
			  | rects |
			  rects := te selectionRectangles collect: [ :r | r insetBy: self borderWidth].
			  stream nextPutAll: (rects collect: [ :r | 
					   (anInfiniteElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy:
						   (self borderWidth negated @ te position y) negated ]) ].
		  stream nextPutAll: (self selectionLimitRectanglesIn: anInfiniteElement) ]
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [
	super selectionScrolled: aPoint in: anInfiniteElement.
	echo ifNil: [ ^ self ].
	self updateEchoIn: anInfiniteElement
]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> terminateUpdater [

	echoUpdater ifNotNil: #terminate.
	echoUpdater := nil
]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> updateEchoIn: anEditorElement [
	
	echoAllowed ifFalse: [ ^ self  ].
	self resetCurrentEcho.
	selection ifNil: [ ^ self  ].
	selection ifEmpty: [ ^ self  ].
	self updateEchoIn: anEditorElement withString: selectedString

]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> updateEchoIn: anEditorElement withString: aString [

	| collector currentSelectionInterval subTextOnScreen founds |
	self terminateUpdater.

	self resetCurrentEcho.
	aString = String space ifTrue: [ ^ self ].
	aString = String cr ifTrue: [ ^ self ].
	aString = String crlf ifTrue: [ ^ self ].
	subTextOnScreen := anEditorElement subTextOnScreen.
	aString size >= (subTextOnScreen size // 2) ifTrue: [ ^ self ].
	collector := BlIntervalCollector new text: subTextOnScreen asString.
	currentSelectionInterval := selection from + 1 to: selection to.

	echoUpdater := [ 						
	               founds := collector searchAll: aString excluding: currentSelectionInterval - subTextOnScreen textOffset.
	               founds do: [ :interval | self echoInterval: interval + subTextOnScreen textOffset in: anEditorElement ].
	               anEditorElement enqueueTask: (BlTaskAction new action: [ self echoUpdatedIn: anEditorElement ]) ]
		               forkAt: Processor systemBackgroundPriority
		               named: 'Selection echo updater task'
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> updateMainSelectionVerticesIn: anInfiniteElement [

	| rects |
	vertices := nil.

	rects := self selectionRectanglesIn: anInfiniteElement.
	rects ifNotEmpty: [ self vertices: (self verticesFromRectangles: rects)].
	self updateEchoIn: anInfiniteElement
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> verticesFromRectangles: aListOfRectangles [

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

{ #category : #accessing }
AlbEditorMainSelectionView >> withSelectionEchoIn: anEditorElement [
	echoAllowed := true.
	self updateEchoIn: anEditorElement
]

{ #category : #accessing }
AlbEditorMainSelectionView >> withoutSelectionEchoIn: anEditorElement [
	echoAllowed := false.
	self resetCurrentEcho.
	anEditorElement invalidate
]

{ #category : #'private - vertices computing' }
AlbEditorMainSelectionView >> yCoordsFromRectangles: aListOfRectangles [

	| allBotoms allTops allCoords |
	allBotoms := aListOfRectangles collect: [ :rect | rect bottom ].
	allTops := aListOfRectangles collect: [ :rect | rect top ].
	allCoords := Set new.
	allCoords addAll: allTops.
	allCoords addAll: allBotoms.
	^ allCoords asArray
]
