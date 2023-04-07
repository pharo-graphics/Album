Class {
	#name : #AlbTextEditorParagraphSegmentHolder,
	#superclass : #AlbTextEditorSegmentHolder,
	#instVars : [
		'segment',
		'pieceElements'
	],
	#classInstVars : [
		'defaultSegmentLayoutBlock'
	],
	#category : #'Album-Brick-NU-Segment Paragraph'
}

{ #category : #cleanup }
AlbTextEditorParagraphSegmentHolder class >> cleanUp [
	super cleanUp.
	
	defaultSegmentLayoutBlock := nil
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentHolder class >> defaultSegmentLayout [
	^ (defaultSegmentLayoutBlock ifNil: [ AlbLineFlowLayout new ]) value
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentHolder class >> defaultSegmentLayout: aBlock [
	defaultSegmentLayoutBlock := aBlock
]

{ #category : #'private - segment' }
AlbTextEditorParagraphSegmentHolder >> buildSegment: anEditorSegment [
	| newPieceElements thePieces hasSelection hasCursor |

	segment := anEditorSegment.
	itemElement segment: segment.

	hasSelection := self hasSelection.
	hasCursor := self hasCursor.
	itemElement text: segment text.

	segment updateSegmentProperties.

	pieceElements := self newPiecesMap.
	newPieceElements := OrderedCollection new.

	thePieces := segment pieces.
	
	thePieces withIndexDo: [ :aPiece :eachIndex | 
		| thePieceElements |				
		thePieceElements := (aPiece createElement: self infiniteElement) asOrderedCollection.				
		newPieceElements addAll: thePieceElements.
		pieceElements atPiece: aPiece putElements: thePieceElements ].

	itemElement removeChildren.
	itemElement addChildren: newPieceElements.
		
	(hasCursor or: [ hasSelection ])
		ifTrue: [
			hasCursor
				ifTrue: [ self onCursorChanged ].
			hasSelection
				ifTrue: [ self onSelectionChanged ] ].

	itemElement
		constraintsDo: [ :c | c horizontal resizer: infiniteElement constraints horizontal resizer ];
		padding: anEditorSegment paragraphMargin
]

{ #category : #initialization }
AlbTextEditorParagraphSegmentHolder >> createSegmentElement [
	<return: #BlElement>
self flag: 'AlbLayoutResizerAptitude stuff removed until I understand it'.
	^ AlbTextEditorParagraphElement new
		beInSeparateCompositionLayer;
		focusability: BlFocusability block;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		"aptitude: (AlbLayoutResizerAptitude new
			hInherit;
			vAnyToFitContent)"
		yourself
]

{ #category : #cursor }
AlbTextEditorParagraphSegmentHolder >> explicitScreenToCursor: aTransformation [
	| aBoundsInEditor aTransformedScreenPosition |
	
	aTransformedScreenPosition := aTransformation screenPosition.
	aBoundsInEditor := (itemElement bounds inParent: self infiniteElement) bounds.
	
	"if location is above the first segment then the index is 0"
	((segment isFirstIn: self editor) and: [ aTransformedScreenPosition y < aBoundsInEditor top ])
		ifTrue: [ ^ aTransformation transformed: 0 ].

	"if location is below the last segment then the index is text size"
	((segment isLastIn: self editor) and: [ aTransformedScreenPosition y > aBoundsInEditor bottom ])
		ifTrue: [ ^ aTransformation transformed: self editor text size ].	

	"not in this segment, ignoring"
	(aTransformedScreenPosition y between: aBoundsInEditor top and: aBoundsInEditor bottom)
		ifFalse: [  ^ self ].

	segment hasPieces
		ifFalse: [ ^ self ].

	itemElement
		screenToCursor: aTransformation
		of: self infiniteElement
		at: aTransformation screenPosition
]

{ #category : #'private - testing' }
AlbTextEditorParagraphSegmentHolder >> hasCursor [
	| aTextEditor |
	aTextEditor := self infiniteElement editor.
	aTextEditor cursors
		do: [ :aCursor | 
			(aCursor insideSegment: segment)
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #'private - testing' }
AlbTextEditorParagraphSegmentHolder >> hasSelection [
	| aTextEditor textInterval |

	aTextEditor := self infiniteElement editor.
	textInterval := BlSelection from: (segment textStart + 1 min: segment textEnd) to: segment textEnd.
	
	(aTextEditor selection + aTextEditor selectionRecorder selection) do: [ :aSelection |
		(aSelection overlaps: textInterval)
			ifTrue: [ ^ true ] ].

	^ false
]

{ #category : #'private - segment' }
AlbTextEditorParagraphSegmentHolder >> newPiecesMap [
	^ AlbTextEditorLineSegmentPieceMap new
]

{ #category : #updating }
AlbTextEditorParagraphSegmentHolder >> onCursorChanged [
	"Is sent when text editor's cursor changes.
	Segment holder should update text elements accordingly"

	| theCursors |
	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].
	theCursors := (self infiniteElement editor cursors allCursors
				select: [ :aCursor | aCursor insideSegment: segment ]
				thenCollect: [ :aCursor | aCursor position - segment textStart ])
				asSet.
	itemElement setCursors: theCursors.
	(theCursors isNotEmpty and: [ self infiniteElement isFocused ])
		ifTrue: [ itemElement showCursors ]
]

{ #category : #updating }
AlbTextEditorParagraphSegmentHolder >> onFocusChanged: aBoolean [
	"Is sent when text editor's focus state changes.
	Segment holder should update text elements accordingly"

	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement |
		aPiece updateFocus: aBoolean of: aPieceElement in: self infiniteElement ]
]

{ #category : #updating }
AlbTextEditorParagraphSegmentHolder >> onRecycled [

	itemElement removeChildren.
	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement | aPiece onRecycled: aPieceElement in: self infiniteElement ].
	pieceElements := nil.
	segment := nil.
]

{ #category : #updating }
AlbTextEditorParagraphSegmentHolder >> onSelectionChanged [
	"Is sent when text editor's selection changes.
	Segment holder should update text elements accordingly"
		
	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].

	itemElement selection: (self selectionIn: self infiniteElement editor)
]

{ #category : #updating }
AlbTextEditorParagraphSegmentHolder >> onTextChanged [
	"Is sent when text changed in the editor (for example style attributes).
	Segment holder should update text elements accordingly"

	self
		assert: [ segment isNotNil ]
		description: [ 'Segment must be bound!' ].

	pieceElements piecesAndTheirElementsDo: [ :aPiece :aPieceElement |
		aPiece updateText: aPieceElement of: segment in: self infiniteElement ].
	
	itemElement text: segment text
]

{ #category : #cursor }
AlbTextEditorParagraphSegmentHolder >> relativeScreenToCursor: aTransformation [
	"trying to find a segment that actually contains a given position"
		
	itemElement relativeScreenToCursor: aTransformation of: self infiniteElement
]

{ #category : #cursor }
AlbTextEditorParagraphSegmentHolder >> screenToCursor: aTransformation [
	aTransformation evaluateOn: self
]

{ #category : #accessing }
AlbTextEditorParagraphSegmentHolder >> segment: anEditorSegment [
	segment == anEditorSegment
		ifTrue: [
			self infiniteElement ignoreRequestLayoutDuring: [ self updateSegment: anEditorSegment ] ]
		ifFalse: [
			self infiniteElement ignoreRequestLayoutDuring: [ self buildSegment: anEditorSegment ] ]
]

{ #category : #'private - accessing' }
AlbTextEditorParagraphSegmentHolder >> selectionIn: aTextEditor [
	| theLocalSelection |
	
	theLocalSelection := BlCompositeSelection new.
	
	(aTextEditor selection + aTextEditor selectionRecorder selection) do: [ :aSelection |
		| aSelectionInterval textInterval |
		aSelectionInterval := aSelection interval.
		textInterval := BlSelection from: (segment textStart + 1 min: segment textEnd) to: segment textEnd.
		(aSelection overlaps: textInterval)
			ifTrue: [
				| localFrom localTo |
				localFrom := (aSelectionInterval first - segment textStart) max: 0.
				localTo := (aSelectionInterval last - segment textStart) min: segment textLength + 1.
				
				theLocalSelection select: localFrom to: localTo ] ].
		
	^ theLocalSelection
]

{ #category : #'private - segment' }
AlbTextEditorParagraphSegmentHolder >> updateSegment: anEditorSegment [
	| newPieceElements newPieceMap hasCursor hasSelection thePieces |
	self
		assert: [ segment == anEditorSegment ]
		description: [ 'Can only update the same segment!' ].

	hasSelection := self hasSelection.
	hasCursor := self hasCursor.

	segment := anEditorSegment.
	segment updateSegmentProperties.
	
	newPieceMap := self newPiecesMap.
	newPieceElements := OrderedCollection new.

	thePieces := segment pieces.
			
	thePieces do: [ :eachSegmentPiece | 
		| thePieceElements |
				
		thePieceElements := pieceElements
			at: eachSegmentPiece
			pieceAndElementsDo: [ :eachPiece :theSegmentElements |						
				theSegmentElements do: [ :eachSegmentElement |
					eachPiece updateText: eachSegmentElement of: segment in: self infiniteElement ].
				theSegmentElements ]
			ifAbsent: [ (eachSegmentPiece createElement: self infiniteElement) asOrderedCollection ].
			
		newPieceElements addAll: thePieceElements.
		newPieceMap atPiece: eachSegmentPiece putElements: thePieceElements ].

	pieceElements := newPieceMap.

	itemElement removeChildren.
	itemElement addChildren: newPieceElements.
		
	(hasCursor or: [ hasSelection ])
		ifTrue: [
			hasCursor
				ifTrue: [	self onCursorChanged].
			hasSelection
				ifTrue: [self onSelectionChanged ] ].
	
	self onFocusChanged: self infiniteElement isFocused.
	
	itemElement
		constraintsDo: [ :c | c horizontal resizer: infiniteElement constraints horizontal resizer ];
		padding: anEditorSegment paragraphMargin
]
