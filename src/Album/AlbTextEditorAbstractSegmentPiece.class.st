Class {
	#name : #AlbTextEditorAbstractSegmentPiece,
	#superclass : #Object,
	#traits : 'TAlbTextEditorTextualPiece',
	#classTraits : 'TAlbTextEditorTextualPiece classTrait',
	#instVars : [
		'segment',
		'currentCursor'
	],
	#category : #'Album-Model-Segment'
}

{ #category : #updating }
AlbTextEditorAbstractSegmentPiece >> addCursor: aPieceElement of: aLineSegment in: anEditorElement [
	| globalCursor |
	"if text editor cursor is currently within this segment piece then convert it to a local one"

	globalCursor := anEditorElement cursor.
	(globalCursor insideSubText: self of: aLineSegment) ifFalse: [^self ].
	currentCursor := self globalCursorToLocal: globalCursor.
	"tell to add the new cursor"
	self onCursorAdded: currentCursor to: aPieceElement in: anEditorElement
]

{ #category : #'instance creation' }
AlbTextEditorAbstractSegmentPiece >> createElement: anEditorElement [
	<return: #BlElement>

	^ self subclassResponsibility
]

{ #category : #'api - cursor' }
AlbTextEditorAbstractSegmentPiece >> currentCursor [
	"local cursor within this segment piece"
	<return: #AlbTextEditorSingleCursor>
	
	^ currentCursor
]

{ #category : #'api - cursor' }
AlbTextEditorAbstractSegmentPiece >> currentCursor: aCursor [
	"local cursor within this segment piece"
	
	currentCursor := aCursor
]

{ #category : #'api - cursor' }
AlbTextEditorAbstractSegmentPiece >> globalCursorToLocal: aSingleCursor [
	"Convert a global cursor as specified in the editor to a local one"
	<return: #AlbTextEditorSingleCursor>
	| aLocalCursor |
	
	aLocalCursor := aSingleCursor copy.
	aLocalCursor position: (self globalTextIndexToLocal: aSingleCursor position).
	
	^ aLocalCursor
]

{ #category : #'api - cursor' }
AlbTextEditorAbstractSegmentPiece >> globalTextIndexToLocal: aTextIndex [
	"Convert global text index given in the text coordinates of the whole editor to a local index within this segment piece.
	This convertion is necessary due to the fact that text elements that represent every segment piece work with text in their own local system"
	<return: #Number>

	^ self isEmpty
		ifTrue: [ 0 ]
		ifFalse: [ aTextIndex - self textStart ]
]

{ #category : #testing }
AlbTextEditorAbstractSegmentPiece >> isText [
	^ false
]

{ #category : #'cursor - hooks' }
AlbTextEditorAbstractSegmentPiece >> onCursorAdded: aCursor to: aPieceElement in: anEditorElement [
	"Is sent when a cursor is added to a given piece element within provided editor element"

	aPieceElement dispatchEvent:
		(AlbTextEditorShowCursorRequest new
			editorElement: anEditorElement;
			hasFocus: anEditorElement isFocused;
			cursorPosition: aCursor position)
]

{ #category : #'cursor - hooks' }
AlbTextEditorAbstractSegmentPiece >> onCursorRemoved: aCursor from: aPieceElement in: anEditorElement [
	"Is sent when a cursor is removed from a given piece element within provided editor element"
	
	aPieceElement dispatchEvent:
		(AlbTextEditorHideCursorRequest new
			editorElement: anEditorElement;
			cursorPosition: aCursor position)
]

{ #category : #updating }
AlbTextEditorAbstractSegmentPiece >> removeCursor: aPieceElement of: aLineSegment in: anEditorElement [

	currentCursor ifNil: [ ^ self ].
	self onCursorRemoved: currentCursor from: aPieceElement in: anEditorElement.
	"update the current cursor"
	currentCursor := nil
]

{ #category : #'api - cursor' }
AlbTextEditorAbstractSegmentPiece >> screenToCursor: aTransformation of: anEditorElement in: aPieceElement [

	aPieceElement dispatchEvent:
		(AlbTextEditorScreenToCursorRequest new
			transformation: aTransformation;
			editorElement: anEditorElement)
]

{ #category : #accessing }
AlbTextEditorAbstractSegmentPiece >> segment [
	^ segment
]

{ #category : #accessing }
AlbTextEditorAbstractSegmentPiece >> segment: anObject [
	segment := anObject
]

{ #category : #updating }
AlbTextEditorAbstractSegmentPiece >> setCursor: aPieceElement of: aLineSegment in: anEditorElement [
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
AlbTextEditorAbstractSegmentPiece >> updateCursor: aPieceElement of: aLineSegment in: anEditorElement [
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
AlbTextEditorAbstractSegmentPiece >> updateFocus: hasFocus of: aTextPieceElement in: anEditorElement [
	| aRequest |

	aRequest := hasFocus
		ifTrue: [ AlbTextEditorFocusRequest new ]
		ifFalse: [ AlbTextEditorBlurRequest new ].

	aTextPieceElement dispatchEvent: (aRequest editorElement: anEditorElement)
]

{ #category : #updating }
AlbTextEditorAbstractSegmentPiece >> updateSelection: aTextElement of: aLineSegment in: anEditorElement [
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
AlbTextEditorAbstractSegmentPiece >> updateText: aTextElement of: aLineSegment in: anEditorElement [

	aTextElement dispatchEvent: (AlbTextEditorTextChangedRequest new
		editorElement: anEditorElement;
		segmentPiece: self;
		text: self text;
		textStart: self textStart;
		textEnd: self textEnd)
]

{ #category : #'api - geometry' }
AlbTextEditorAbstractSegmentPiece >> wordMargin [
	<return: #BlInsets>
	"| aHalfOfLineSpacing |"
	
	self flag: 'Changed so that the height computed for a ToTextField (or one line ToAlbum) is the same as the height computed for a ToLabel'.
	^ BlInsets empty
	
	"aHalfOfLineSpacing := (self segment lineSpacing / 2.0) floor.
	^ BlInsets
		top: aHalfOfLineSpacing
		bottom: (self segment lineSpacing - aHalfOfLineSpacing)"
]

{ #category : #'api - geometry' }
AlbTextEditorAbstractSegmentPiece >> wordPadding [
	<return: #BlInsets>
		
	^ self segment wordPadding
]
