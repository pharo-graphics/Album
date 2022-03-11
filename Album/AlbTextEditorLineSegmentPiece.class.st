Class {
	#name : #AlbTextEditorLineSegmentPiece,
	#superclass : #Object,
	#traits : 'TAlbTextEditorTextualPiece',
	#classTraits : 'TAlbTextEditorTextualPiece classTrait',
	#instVars : [
		'segment',
		'currentCursors'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #'instance creation' }
AlbTextEditorLineSegmentPiece >> createElement: anEditorElement [
	<return: #BlElement>

	^ self subclassResponsibility
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> currentCursors [
	"Return a collection of known unique cursors within this segment piece.
	It is important to remember cursors in order to send fine grained events when cursor's location changes
	or new cursors are added"
	<return: #Set of: #AlbTextEditorSingleCursor>
	
	^ currentCursors
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> currentCursors: aSetOfCursors [	
	currentCursors := aSetOfCursors asSet
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> findAddedCursors: theUpdatedCursors to: theCurrentCursors [
	"Find which cursors are new relative to the set of current cursors"
	<return: #Set of: #AlbTextEditorSingleCursor>
	
	^ theUpdatedCursors difference: theCurrentCursors
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> findRemovedCursors: theUpdatedCursors from: theCurrentCursors [
	"Find which cursors were removed relative from the set of current cursors"
	<return: #Set of: #AlbTextEditorSingleCursor>
	
	^ theCurrentCursors difference: theUpdatedCursors
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> globalCursorToLocal: aSingleCursor [
	"Convert a global cursor as specified in the editor to a local one"
	<return: #AlbTextEditorSingleCursor>
	| aLocalCursor |
	
	aLocalCursor := aSingleCursor copy.
	aLocalCursor position: (self globalTextIndexToLocal: aSingleCursor position).
	
	^ aLocalCursor
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> globalTextIndexToLocal: aTextIndex [
	"Convert global text index given in the text coordinates of the whole editor to a local index within this segment piece.
	This convertion is necessary due to the fact that text elements that represent every segment piece work with text in their own local system"
	<return: #Number>

	^ self isEmpty
		ifTrue: [ 0 ]
		ifFalse: [ aTextIndex - self textStart ]
]

{ #category : #initialization }
AlbTextEditorLineSegmentPiece >> initialize [
	super initialize.
	
	currentCursors := Set new
]

{ #category : #testing }
AlbTextEditorLineSegmentPiece >> isText [
	^ false
]

{ #category : #'cursor - hooks' }
AlbTextEditorLineSegmentPiece >> onCursorAdded: aCursor to: aPieceElement in: anEditorElement [
	"Is sent when a cursor is added to a given piece element within provided editor element"

	aPieceElement dispatchEvent:
		(BrTextEditorShowCursorRequest new
			editorElement: anEditorElement;
			hasFocus: anEditorElement isFocused;
			cursorPosition: aCursor position)
]

{ #category : #'cursor - hooks' }
AlbTextEditorLineSegmentPiece >> onCursorRemoved: aCursor from: aPieceElement in: anEditorElement [
	"Is sent when a cursor is removed from a given piece element within provided editor element"
	
	aPieceElement dispatchEvent:
		(BrTextEditorHideCursorRequest new
			editorElement: anEditorElement;
			cursorPosition: aCursor position)
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> onRecycled: aPieceElement in: anEditorElement [
]

{ #category : #printing }
AlbTextEditorLineSegmentPiece >> printOn: aStream [
	self text printOn: aStream
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> screenToCursor: aTransformation of: anEditorElement in: aPieceElement [

	aPieceElement dispatchEvent:
		(BrTextEditorScreenToCursorRequest new
			transformation: aTransformation;
			editorElement: anEditorElement)
]

{ #category : #accessing }
AlbTextEditorLineSegmentPiece >> segment [
	^ segment
]

{ #category : #accessing }
AlbTextEditorLineSegmentPiece >> segment: anObject [
	segment := anObject
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> setCursor: aPieceElement of: aLineSegment in: anEditorElement [
	| theUpdatedCursors aFocusRequest |
	"select text editor cursors that are currently within this segment piece and convert them to local ones"
	theUpdatedCursors := (anEditorElement editor cursors allCursors
		select: [ :aCursor | aCursor insideSubText: self of: aLineSegment ]
		thenCollect: [ :aCursor | self globalCursorToLocal: aCursor ]) asSet.

	"update current cursors"
	currentCursors := theUpdatedCursors.

	"tell to add new cursors"
	theUpdatedCursors
		do: [ :aCursor | self onCursorAdded: aCursor to: aPieceElement in: anEditorElement ].
	aFocusRequest := anEditorElement isFocused
		ifTrue: [ AlbTextEditorFocusRequest new ]
		ifFalse: [ AlbTextEditorBlurRequest new ].
	aPieceElement
		dispatchEvent: (aFocusRequest editorElement: anEditorElement)
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> updateCursor: aPieceElement of: aLineSegment in: anEditorElement [
	| theUpdatedCursors theAddedCursors theRemovedCursors |
	"select text editor cursors that are currently within this segment piece and convert them to local ones"
	theUpdatedCursors := (anEditorElement editor cursors allCursors
		select: [ :aCursor | aCursor insideSubText: self of: aLineSegment ]
		thenCollect: [ :aCursor | self globalCursorToLocal: aCursor ]) asSet.
	theAddedCursors := self
		findAddedCursors: theUpdatedCursors
		to: self currentCursors.
	theRemovedCursors := self
		findRemovedCursors: theUpdatedCursors
		from: self currentCursors.

	"update current cursors"
	currentCursors := theUpdatedCursors.

	"tell to remove deleted cursors"
	theRemovedCursors
		do: [ :aCursor | self onCursorRemoved: aCursor from: aPieceElement in: anEditorElement ].

	"tell to add new cursors"
	theAddedCursors
		do: [ :aCursor | self onCursorAdded: aCursor to: aPieceElement in: anEditorElement ]
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> updateFocus: hasFocus of: aTextPieceElement in: anEditorElement [
	| aRequest |

	aRequest := hasFocus
		ifTrue: [ AlbTextEditorFocusRequest new ]
		ifFalse: [ AlbTextEditorBlurRequest new ].

	aTextPieceElement dispatchEvent: (aRequest editorElement: anEditorElement)
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> updateSelection: aTextElement of: aLineSegment in: anEditorElement [
	| aTextEditor |

	aTextEditor := anEditorElement editor.

	aTextElement dispatchEvent: (BrTextEditorDeselectRequest new
		editorElement: anEditorElement;
		fromIndex: 0;
		toIndex: self textLength).

	(aTextEditor selection + aTextEditor selectionRecorder selection) do: [ :aSelection |
		| aSelectionInterval textInterval |
		aSelectionInterval := aSelection interval.
		textInterval := BlSelection from: (self textStart + 1 min: self textEnd) to: self textEnd.
		(aSelection overlaps: textInterval)
			ifTrue: [
				| localFrom localTo |
				localFrom := (aSelectionInterval first - self textStart) max: 0.
				localTo := (aSelectionInterval last - self textStart) min: self textLength + 1.

				aTextElement dispatchEvent: (BrTextEditorSelectRequest new
					editorElement: anEditorElement;
					fromIndex: localFrom;
					toIndex: localTo) ] ]
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> updateText: aTextElement of: aLineSegment in: anEditorElement [
	aTextElement dispatchEvent: (BrTextEditorTextChangedRequest new
		editorElement: anEditorElement;
		segmentPiece: self;
		text: self text;
		textStart: self textStart;
		textEnd: self textEnd)
]

{ #category : #'api - geometry' }
AlbTextEditorLineSegmentPiece >> wordMargin [
	<return: #BlInsets>
	| aHalfOfLineSpacing |
	
	aHalfOfLineSpacing := (self segment lineSpacing / 2.0) floor.

	^ BlInsets
		top: aHalfOfLineSpacing
		bottom: (self segment lineSpacing - aHalfOfLineSpacing)
]

{ #category : #'api - geometry' }
AlbTextEditorLineSegmentPiece >> wordPadding [
	<return: #BlInsets>
		
	^ self segment wordPadding
]
