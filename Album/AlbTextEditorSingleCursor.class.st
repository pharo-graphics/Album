Class {
	#name : #AlbTextEditorSingleCursor,
	#superclass : #AlbTextEditorCursor,
	#instVars : [
		'position',
		'isVisible',
		'desiredCoordinate'
	],
	#category : #'Album-Editor-Model - Cursor'
}

{ #category : #accessing }
AlbTextEditorSingleCursor class >> at: aTextIndex [
	^ self new position: aTextIndex
]

{ #category : #comparing }
AlbTextEditorSingleCursor >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].

	^ anotherObject position = self position
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> desiredCoordinate [
	<return: #Number>

	^ desiredCoordinate
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> desiredCoordinate: aNumber [
	desiredCoordinate := aNumber
]

{ #category : #enumerating }
AlbTextEditorSingleCursor >> do: aBlock [
	aBlock value: self
]

{ #category : #testing }
AlbTextEditorSingleCursor >> hasDesiredCoordinate [
	<return: #Boolean>

	^ desiredCoordinate isNotNil
]

{ #category : #comparing }
AlbTextEditorSingleCursor >> hash [
	^ self class hash bitXor: self position hash
]

{ #category : #initialization }
AlbTextEditorSingleCursor >> initialize [
	super initialize.
	
	"Default cursor position should be 0,
	which means that it will be before the first text item (character) if it exists"
	position := 0.
	isVisible := false
]

{ #category : #testing }
AlbTextEditorSingleCursor >> insideSegment: aSegment [
	"Return true if I am inside of a given segment"
	<return: #Boolean>

	^ self position between: aSegment textStart and: aSegment textEnd
]

{ #category : #testing }
AlbTextEditorSingleCursor >> insideSubText: aBrTextEditorSegmentPiece of: aSegment [
	"Return true if I am inside a given subtext, false otherwise"
	<return: #Boolean>
	
	^ (self position
		between: aBrTextEditorSegmentPiece textStart
		and: aBrTextEditorSegmentPiece textEnd - (aSegment isLastTextPiece: aBrTextEditorSegmentPiece) not asBit)
			and: [ self position between: aSegment textStart and: aSegment textEnd ]
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> isVisible [
	"Return true if this cursor should be visible, false otherwise"
	<return: #Boolean>

	^ isVisible
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> isVisible: aBoolean [
	isVisible := aBoolean
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> position [
	"Return position of the cursor within the text"
	<return: #Number>

	^ position
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> position: anIndex [
	self
		assert: [ anIndex >= 0 ]
		description: [ 'Cursor position must not be negative' ].

	position := anIndex
]

{ #category : #printing }
AlbTextEditorSingleCursor >> printOn: aStream [
	aStream
		nextPutAll: 'Cursor (';
		nextPutAll: self position asString;
		nextPutAll: ')'
]

{ #category : #accessing }
AlbTextEditorSingleCursor >> resetDesiredCoordinate [
	desiredCoordinate := nil
]
