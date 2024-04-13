"
I am a line segment holder and is responsible for binding `AlbTextEditorLineSegment` with corresponding visual element
"
Class {
	#name : #AlbTextEditorLineSegmentHolder,
	#superclass : #AlbEditorSegmentHolder,
	#instVars : [
		'segment',
		'pieceElements'
	],
	#classInstVars : [
		'defaultSegmentLayoutBlock'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #cleanup }
AlbTextEditorLineSegmentHolder class >> cleanUp [
	super cleanUp.
	
	defaultSegmentLayoutBlock := nil
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder class >> defaultSegmentLayout [
	^ (defaultSegmentLayoutBlock ifNil: [ AlbLineFlowLayout new ]) value
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder class >> defaultSegmentLayout: aBlock [
	defaultSegmentLayoutBlock := aBlock
]

{ #category : #'private - segment' }
AlbTextEditorLineSegmentHolder >> buildSegment: anEditorSegment [

	| newPieceElements thePieces hasSelection hasCursor |
	segment := anEditorSegment.

	hasSelection := self hasSelection.
	hasCursor := self hasCursor.

	segment updateSegmentProperties.

	pieceElements := self newPiecesMap.
	newPieceElements := OrderedCollection new.

	thePieces := segment pieces.

	thePieces withIndexDo: [ :aPiece :eachIndex |
		| thePieceElements |
		thePieceElements := OrderedCollection with:
			                    (aPiece createElement: self infiniteElement).

		newPieceElements addAll: thePieceElements.
		pieceElements atPiece: aPiece putElements: thePieceElements ].

	(hasCursor or: [ hasSelection ]) ifTrue: [
		pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement |
			(hasCursor and: [
				 hasSelection not and: [ self infiniteElement isFocused ] ])
				ifTrue: [
					aPiece
						setCursor: aPieceElement
						of: anEditorSegment
						in: self infiniteElement ].

			aPiece
				updateFocus: self infiniteElement isFocused
				of: aPieceElement
				in: self infiniteElement.

			hasSelection ifTrue: [
				aPiece
					updateSelection: aPieceElement
					of: anEditorSegment
					in: self infiniteElement ] ] ].

	itemElement removeChildren.
	itemElement addChildren: newPieceElements.

	itemElement
		constraintsDo: [ :c |
			c horizontal resizer:
					infiniteElement constraints horizontal resizer ];
		padding: anEditorSegment paragraphMargin
]

{ #category : #'private - accessing' }
AlbTextEditorLineSegmentHolder >> cachedPieces [
	<return: #Collection of: #AlbTextEditorAbstractSegmentPiece>
	
	^ pieceElements allPieces
]

{ #category : #initialization }
AlbTextEditorLineSegmentHolder >> createSegmentElement [
	<return: #BlElement>

	^ AlbTextEditorSegmentElement new
		beInSeparateCompositionLayer;
		layout: self class defaultSegmentLayout;
		focusability: BlFocusability after;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself
]

{ #category : #cursor }
AlbTextEditorLineSegmentHolder >> explicitScreenToCursor: aTransformation [

	| aBoundsInEditor aPositionInSegment aClosestPieceElement aClosestPiece aTransformedScreenPosition |
	aTransformedScreenPosition := aTransformation screenPosition.
	aBoundsInEditor := (itemElement bounds inParent: self infiniteElement) bounds.

	"if location is above the first segment then the index is 0"
	((segment isFirstIn: self editor) and: [ aTransformedScreenPosition y < aBoundsInEditor top ]) ifTrue: [ 
		^ aTransformation transformed: 0 ].

	"if location is below the last segment then the index is text size"
	((segment isLastIn: self editor) and: [ aTransformedScreenPosition y > aBoundsInEditor bottom ]) ifTrue: [ 
		^ aTransformation transformed: self editor privateText size ].

	"not in this segment, ignoring"
	(aTransformedScreenPosition y between: aBoundsInEditor top and: aBoundsInEditor bottom) ifFalse: [ ^ self ].

	aPositionInSegment := (itemElement
		                       globalBoundsToMine: (BlBounds origin: aTransformation screenPosition extent: 0.0 @ 0.0)
		                       fromParent: self infiniteElement) center.
	segment hasPieces ifFalse: [ ^ self ].

	"trying to find a segment that actually contains a given position"
	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | 
		(aPieceElement bounds inParent bounds containsPoint: aPositionInSegment) ifTrue: [ 
			^ aPiece screenToCursor: aTransformation of: self infiniteElement in: aPieceElement ] ].

	"clicked outside of a segment piece, should find the closest element"

	aClosestPieceElement := itemElement layout findClosestChildOf: itemElement to: aPositionInSegment.
	aClosestPiece := pieceElements pieceForElement: aClosestPieceElement ifAbsent: [ ^ self ].

	aClosestPiece screenToCursor: aTransformation of: self infiniteElement in: aClosestPieceElement
]

{ #category : #'private - testing' }
AlbTextEditorLineSegmentHolder >> hasCursor [

	| aTextEditor |
	aTextEditor := self infiniteElement editor.
	^ aTextEditor cursor insideSegment: segment
]

{ #category : #'private - testing' }
AlbTextEditorLineSegmentHolder >> hasSelection [
	| aTextEditor textInterval |

	aTextEditor := self infiniteElement editor.
	textInterval := BlSelection from: (segment textStart + 1 min: segment textEnd) to: segment textEnd.
	
	(aTextEditor selection + aTextEditor selectionRecorder selection) do: [ :aSelection |
		(aSelection overlaps: textInterval)
			ifTrue: [ ^ true ] ].

	^ false
]

{ #category : #'private - segment' }
AlbTextEditorLineSegmentHolder >> newPiecesMap [
	^ AlbTextEditorLineSegmentPieceMap new
]

{ #category : #updating }
AlbTextEditorLineSegmentHolder >> onCursorAdded [

	"Is sent when text editor's cursor changes.
	Segment holder should update text elements accordingly"

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | 
		aPiece
			addCursor: aPieceElement
			of: segment
			in: self infiniteElement]
]

{ #category : #updating }
AlbTextEditorLineSegmentHolder >> onCursorRemoved [

	"Is sent when text editor's cursor changes.
	Segment holder should update text elements accordingly"

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | 
		aPiece
			removeCursor: aPieceElement
			of: segment
			in: self infiniteElement]
]

{ #category : #updating }
AlbTextEditorLineSegmentHolder >> onFocusChanged: aBoolean [
	"Is sent when text editor's focus state changes.
	Segment holder should update text elements accordingly"

	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement |
		aPiece updateFocus: aBoolean of: aPieceElement in: self infiniteElement ]
]

{ #category : #updating }
AlbTextEditorLineSegmentHolder >> onSelectionChanged [
	"Is sent when text editor's selection changes.
	Segment holder should update text elements accordingly"
		
	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement |
		aPiece updateSelection: aPieceElement of: segment in: self infiniteElement ]
]

{ #category : #updating }
AlbTextEditorLineSegmentHolder >> onTextChanged [

	"Is sent when text changed in the editor (for example style attributes).
	Segment holder should update text elements accordingly"

	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | 
		aPiece
			updateText: aPieceElement
			of: segment
			in: self infiniteElement ]
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder >> pieceForElement: aBlElement ifAbsent: anAbsentBlock [
	^ pieceElements pieceForElement: aBlElement ifAbsent: anAbsentBlock
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder >> pieceForElement: aBlElement ifPresent: aBlock ifAbsent: anAbsentBlock [
	^ pieceElements pieceForElement: aBlElement ifPresent: aBlock ifAbsent: anAbsentBlock
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder >> piecesAndTheirElementsDo: aBlock [
	pieceElements piecesAndTheirElementsDo: aBlock
]

{ #category : #cursor }
AlbTextEditorLineSegmentHolder >> relativeScreenToCursor: aTransformation [	
	"trying to find a segment that actually contains a given position"

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement |
		(aTransformation cursor insideSubText: aPiece of: segment)
			ifTrue: [
				^ aPiece screenToCursor: aTransformation of: self infiniteElement in: aPieceElement ] ]
]

{ #category : #cursor }
AlbTextEditorLineSegmentHolder >> screenToCursor: aTransformation [
	aTransformation evaluateOn: self
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder >> segment [
	^ segment 
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder >> segment: anEditorSegment [
	segment == anEditorSegment
		ifTrue: [
			^ self updateSegment: anEditorSegment].
	self buildSegment: anEditorSegment
]

{ #category : #accessing }
AlbTextEditorLineSegmentHolder >> textInterval [ 
	^ (segment textStart + 1 min: segment textEnd) to: segment textEnd
]

{ #category : #'private - segment' }
AlbTextEditorLineSegmentHolder >> updateSegment: anEditorSegment [

	| newPieceElements newPieceMap thePieces |

	self
		assert: [ segment == anEditorSegment ]
		description: [ 'Can only update the same segment!' ].

	segment := anEditorSegment.
	segment updateSegmentProperties.

	newPieceMap := self newPiecesMap.
	newPieceElements := OrderedCollection new.



	thePieces := segment pieces.

	thePieces do: [ :eachSegmentPiece | 
		| thePieceElements |
		thePieceElements := pieceElements
			                    at: eachSegmentPiece
			                    pieceAndElementsDo: [ 
				                    :eachPiece 
				                    :theSegmentElements | "We should transfer the knowledge of the cursor to the new segment piece,
						otherwise the cursor may not be removed from the corresponding elements
						https://github.com/feenkcom/gtoolkit/issues/892"
				                    eachSegmentPiece currentCursor:
					                    eachPiece currentCursor.
				                    theSegmentElements do: [ :eachSegmentElement | 
					                    eachPiece
						                    updateText: eachSegmentElement
						                    of: segment
						                    in: self infiniteElement ].
				                    theSegmentElements ]
			                    ifAbsent: [ 
				                    (eachSegmentPiece createElement:
					                     self infiniteElement) asOrderedCollection ].

		newPieceElements addAll: thePieceElements.
		newPieceMap atPiece: eachSegmentPiece putElements: thePieceElements ].

	pieceElements := newPieceMap.

	"first remove the cursor, else it can be added before being removed".
	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | 
		aPiece
			removeCursor: aPieceElement
			of: anEditorSegment
			in: self infiniteElement].
		
	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | 
		aPiece
			addCursor: aPieceElement
			of: anEditorSegment
			in: self infiniteElement.
		aPiece
			updateSelection: aPieceElement
			of: anEditorSegment
			in: self infiniteElement.
		aPiece
			updateFocus: self infiniteElement isFocused
			of: aPieceElement
			in: self infiniteElement].

	itemElement removeChildren.
	self flag: 'Until I understand why they can have parent'.
	newPieceElements do: [ :e | e removeFromParent ].
	itemElement addChildren: newPieceElements.

	itemElement
		constraintsDo: [ :c | 
			c horizontal resizer:
					infiniteElement constraints horizontal resizer ];
		padding: anEditorSegment paragraphMargin
]
