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
	^ Color lightGray
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> adjacentRectangles: aCollection [

	aCollection ifEmpty: [ 
		selectionGeometry := nil.
		vertices := #().
		^ self ].
	selectionGeometry := OBlAjacentRectanglesGeometry new adjacentRectangles: aCollection.
	vertices := selectionGeometry vertices
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

{ #category : #'private - remanent selection' }
AlbEditorMainSelectionView >> newRemanentVertice: aListOfPoints [

	^ AlbEditorSelectionView new
		  vertices: aListOfPoints;
		  borderWidth: 1;
		  borderColor: (Color gray alpha: 0.5);
		  selectionColor: (Color gray alpha: 0.2);
		  yourself
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
	remanents add: (OBlAjacentRectanglesGeometry new adjacentRectangles: rects)
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

{ #category : #'selection accessing' }
AlbEditorMainSelectionView >> selectionRectanglesIn: anInfiniteElement [
	"return all selections rectangles from coordinate system of text elements to my local coordinates"

	^ Array streamContents: [ :stream | 
		  (anInfiniteElement textElementsSelect: [ :te | te hasSelection ]) 
			  do: [ :te | 
				  te selectionRectangles do: [ :r | 
					  stream nextPut: ((anInfiniteElement
							    localBoundsToMine: (BlBounds fromRectangle: r)
							    fromChild: te) translateBy: 0 @ te position y negated) ] ] ]
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> selectionScrolled: aPoint in: anInfiniteElement [

	super selectionScrolled: aPoint in: anInfiniteElement.
	self updateMainSelectionVerticesIn: anInfiniteElement.
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
AlbEditorMainSelectionView >> textEditedIn: anInfiniteElement [

	self updateRemanentsIn: anInfiniteElement
]

{ #category : #'infinite element changes' }
AlbEditorMainSelectionView >> updateMainSelectionVerticesIn: anInfiniteElement [

	self adjacentRectangles: (self selectionRectanglesIn: anInfiniteElement).
			
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
