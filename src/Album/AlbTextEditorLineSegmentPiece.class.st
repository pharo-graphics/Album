Class {
	#name : #AlbTextEditorLineSegmentPiece,
	#superclass : #Object,
	#traits : 'TAlbTextEditorTextualPiece',
	#classTraits : 'TAlbTextEditorTextualPiece classTrait',
	#instVars : [
		'segment',
		'currentCursor'
	],
	#category : #'Album-Model-Segment-Text-Line'
}

{ #category : #'instance creation' }
AlbTextEditorLineSegmentPiece >> createElement: anEditorElement [
	<return: #BlElement>

	^ self subclassResponsibility
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> currentCursor [
	"local cursor within this segment piece"
	<return: #AlbTextEditorSingleCursor>
	
	^ currentCursor
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> currentCursor: aCursor [
	"local cursor within this segment piece"
	
	currentCursor := aCursor
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> findAddedCursors: theUpdatedCursors to: theCurrentCursors [
	"Find which cursors are new relative to the set of current cursors"
	<return: #Set of: #BrTextEditorSingleCursor>
	
	^ theUpdatedCursors difference: theCurrentCursors
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> findRemovedCursors: theUpdatedCursors from: theCurrentCursors [
	"Find which cursors were removed relative from the set of current cursors"
	<return: #Set of: #BrTextEditorSingleCursor>
	
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

{ #category : #testing }
AlbTextEditorLineSegmentPiece >> isText [
	^ false
]

{ #category : #'cursor - hooks' }
AlbTextEditorLineSegmentPiece >> onCursorAdded: aCursor to: aPieceElement in: anEditorElement [
	"Is sent when a cursor is added to a given piece element within provided editor element"

	aPieceElement dispatchEvent:
		(AlbTextEditorShowCursorRequest new
			editorElement: anEditorElement;
			hasFocus: anEditorElement isFocused;
			cursorPosition: aCursor position)
]

{ #category : #'cursor - hooks' }
AlbTextEditorLineSegmentPiece >> onCursorRemoved: aCursor from: aPieceElement in: anEditorElement [
	"Is sent when a cursor is removed from a given piece element within provided editor element"
	
	aPieceElement dispatchEvent:
		(AlbTextEditorHideCursorRequest new
			editorElement: anEditorElement;
			cursorPosition: aCursor position)
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> onRecycled: aPieceElement in: anEditorElement [
]

{ #category : #'api - cursor' }
AlbTextEditorLineSegmentPiece >> screenToCursor: aTransformation of: anEditorElement in: aPieceElement [

	aPieceElement dispatchEvent:
		(AlbTextEditorScreenToCursorRequest new
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
	| aFocusRequest localCursor globalCursor |
	"get the global cursor "
	globalCursor := anEditorElement cursor.
	"if text editor cursor is currently within this segment piece then convert it to a local one"
	(globalCursor insideSubText: self of: aLineSegment) ifTrue: [ localCursor := self globalCursorToLocal: globalCursor ].
	
	"update current cursors"
	currentCursor := localCursor.

	"tell to add new cursors"
	currentCursor ifNotNil: [ self onCursorAdded: currentCursor to: aPieceElement in: anEditorElement ].

	"set the focus"
	aFocusRequest := anEditorElement isFocused
		ifTrue: [ AlbTextEditorFocusRequest new ]
		ifFalse: [ AlbTextEditorBlurRequest new ].
	aPieceElement
		dispatchEvent: (aFocusRequest editorElement: anEditorElement)
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> updateCursor: aPieceElement of: aLineSegment in: anEditorElement [
	| globalCursor localCursor |
self flag: 'to be checked because of failing tests AlbTextEditorNavigatorTest>>test_cursor_add_at_1_in_multiline'.
	"if text editor cursor is currently within this segment piece then convert it to a local one"

	globalCursor := anEditorElement cursor.

	(globalCursor insideSubText: self of: aLineSegment) ifTrue: [ localCursor := self globalCursorToLocal: globalCursor ].
	
	"tell to remove the deleted cursor"
	currentCursor ifNotNil: [ self onCursorRemoved: currentCursor from: aPieceElement in: anEditorElement ].

	"update the current cursor"
	currentCursor := localCursor.

	"tell to add the new cursor"
	currentCursor ifNotNil: [ self onCursorAdded: currentCursor to: aPieceElement in: anEditorElement ]
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

	aTextElement dispatchEvent: (AlbTextEditorDeselectRequest new
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

				aTextElement dispatchEvent: (AlbTextEditorSelectRequest new
					editorElement: anEditorElement;
					fromIndex: localFrom;
					toIndex: localTo) ] ]
]

{ #category : #updating }
AlbTextEditorLineSegmentPiece >> updateText: aTextElement of: aLineSegment in: anEditorElement [

	aTextElement dispatchEvent: (AlbTextEditorTextChangedRequest new
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
