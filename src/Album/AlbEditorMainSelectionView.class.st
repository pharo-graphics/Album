Class {
	#name : #AlbEditorMainSelectionView,
	#superclass : #AlbEditorSelectionView,
	#instVars : [
		'selection',
		'remanentUpdater',
		'remanentString',
		'remanents',
		'monitor',
		'currentOppositeTextElement'
	],
	#category : #'Album-UI'
}

{ #category : #accessing }
AlbEditorMainSelectionView class >> oppositeDelimiterBackgroundColor [
	^ Color brown alpha: 0.35
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> extentChangedIn: anInfiniteElement [

	self updateOppositeFrom: anInfiniteElement.
	self updateMainSelectionVerticesIn: anInfiniteElement.
	self updateRemanentsIn: anInfiniteElement
]

{ #category : #'private - opposite highlighting' }
AlbEditorMainSelectionView >> highlightOpposite: aPieceElement from: startIdx to: endIdx [

	aPieceElement
		highlightCategory: #opposite
		with: (BlTextParagraphHighlight paint: self class oppositeDelimiterBackgroundColor from: startIdx to: endIdx).
	currentOppositeTextElement := aPieceElement
]

{ #category : #initialization }
AlbEditorMainSelectionView >> initialize [
	super initialize.
	
	monitor := Monitor new.
	remanents := OrderedCollection new
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

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> newRemanentVertice: aListOfPoints [

	^ AlbEditorSelectionView new
		  vertices: aListOfPoints;
		  borderWidth: 1;
		  borderColor: (Color gray alpha: 0.5);
		  selectionColor: (Color gray alpha: 0.2);
		  yourself
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

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> remanentInterval: anInterval in: anEditorElement [

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
	remanents add: (self newRemanentVertice: (self verticesFromRectangles: rects))
]

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> remanentsUpdatedIn: anEditorElement [

	remanentUpdater := nil.
	anEditorElement invalidate
]

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> resetRemanents [

	remanents reset
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> selectionChangedIn: anInfiniteElement [

	self updateOppositeFrom: anInfiniteElement.
	(selection = anInfiniteElement selection and: [vertices notNil]) ifTrue: [ ^ self ].
	selection := anInfiniteElement selection copy.

	self updateMainSelectionVerticesIn: anInfiniteElement.
]

{ #category : #'private - limit computing' }
AlbEditorMainSelectionView >> selectionLimitRectangleOf: anItemElement in: anInfiniteElement [

	" Select lines with cursor or with an element at left which has a selection that start at 0 "

	(anItemElement children
		 select: [ :e | 
			 (e isKindOf: BlTextElement) and: [ e hasCursor or: [ 
				 e bounds inParent left isZero and: [ e selection isNotEmpty and: [ e selection from isZero ] ] ] ] ]
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
			  rects := te selectionRectangles.
			  rects := rects collect: [ :r | 
				           (anInfiniteElement localBoundsToMine: (BlBounds fromRectangle: r) fromChild: te) translateBy:
					           0 @ (te position y) negated ].
			  stream nextPutAll: rects.
			  "stream nextPutAll: (self selectionLimitRectanglesIn: anInfiniteElement)" ] ]
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [
	super selectionScrolled: aPoint in: anInfiniteElement.
	self updateRemanentsIn: anInfiniteElement
]

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> setRemanentsIn: anEditorElement [

	remanentString := anEditorElement selectedText asString.
	self terminateRemanentsUpdater.
	self resetRemanents.
	remanentString ifEmpty: [ ^ anEditorElement invalidate ].
	self updateRemanentsIn: anEditorElement 

]

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> terminateRemanentsUpdater [

	remanentUpdater ifNotNil: #terminate.
	remanentUpdater := nil
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> updateMainSelectionVerticesIn: anInfiniteElement [

	| rects |
	vertices := nil.
	rects := self selectionRectanglesIn: anInfiniteElement.
	rects ifNotEmpty: [ self vertices: (self verticesFromRectangles: rects)]
]

{ #category : #'private - opposite highlighting' }
AlbEditorMainSelectionView >> updateOppositeFrom: anEditor [

	| globalCursorPos subtext localCursorPos |
	currentOppositeTextElement ifNotNil: [ 
		currentOppositeTextElement resetHighlightsOfCategory: #opposite.
		currentOppositeTextElement := nil ].
	globalCursorPos := anEditor cursor position.
	globalCursorPos isZero ifTrue: [ ^ self ].
	subtext := anEditor subTextOnScreen.
	((subtext start to: subtext end) includes: globalCursorPos) ifFalse: [ ^ self ].
	localCursorPos := globalCursorPos - subtext textOffset.
	anEditor editor limitedSurroundMap
		intervalBetweenDelimitersIn: subtext
		at: localCursorPos
		ifPresent: [ :interval | "before  close delimiter"
			interval first = localCursorPos ifFalse: [ 
				anEditor
					atTextIndex: interval first + subtext start - 1
					do: [ :oppositeTextElement :localIdx | 
						localIdx isZero ifFalse: [ 
							^ self highlightOpposite: oppositeTextElement from: localIdx - 1 to: localIdx ] ] ].
			"after open delimiter"
			interval last = localCursorPos ifFalse: [ 
				anEditor atTextIndex: interval last + subtext start do: [ :oppositeTextElement :localIdx | 
					localIdx isZero ifFalse: [ 
						^ self highlightOpposite: oppositeTextElement from: localIdx - 1 to: localIdx ] ] ] ]
		ifAbsent: [  ]
]

{ #category : #'private - selection echo' }
AlbEditorMainSelectionView >> updateRemanentsIn: anEditorElement [

	| collector subTextOnScreen founds |
	monitor critical: [
		self terminateRemanentsUpdater.
		self resetRemanents.
		remanentString ifNil: [ ^ self ].
		remanentString ifEmpty: [ ^ self ].
		subTextOnScreen := anEditorElement subTextOnScreen.
		collector := BlIntervalCollector new text: subTextOnScreen asString.
		remanentUpdater := [ 
		                   founds := collector searchAll: remanentString.
		                   founds do: [ :interval | self remanentInterval: interval + subTextOnScreen textOffset in: anEditorElement ].
		                   self remanentsUpdatedIn: anEditorElement ]
			                   forkAt: Processor systemBackgroundPriority
			                   named: 'Selection echo updater task' ]
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
