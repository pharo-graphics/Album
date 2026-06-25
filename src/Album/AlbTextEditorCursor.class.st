"
I represent a cursor in the Album text editor.
"
Class {
	#name : #AlbTextEditorCursor,
	#superclass : #Object,
	#instVars : [
		'position',
		'isVisible',
		'desiredCoordinate'
	],
	#category : #'Album-Model-Cursor'
}

{ #category : #'instance creation' }
AlbTextEditorCursor class >> position: aTextIndex [

	^ self new position: aTextIndex
]

{ #category : #comparing }
AlbTextEditorCursor >> = anotherObject [
	self == anotherObject
		ifTrue: [ ^ true ].
	(anotherObject isKindOf: self class)
		ifFalse: [ ^ false ].

	^ anotherObject position = self position
]

{ #category : #accessing }
AlbTextEditorCursor >> allCursors [
	^ Array streamContents: [ :aStream | self do: [ :aCursor | aStream nextPut: aCursor ] ]
]

{ #category : #enumerating }
AlbTextEditorCursor >> allSatisfy: aBlock [
	"Evaluate aBlock with all cursor.
	If aBlock returns false for any element return false, otherwise return true"
	<return: #Boolean>

	self do: [ :aCursor | (aBlock value: aCursor )
		ifFalse: [ ^ false] ].
	^ true
]

{ #category : #enumerating }
AlbTextEditorCursor >> anySatisfy: aBlock [
	"Evaluate aBlock with all cursors.
	If aBlock returns true for any element return true, otherwise return false"
	<return: #Boolean>
	
	self do: [ :aCharacter | (aBlock value: aCharacter)
			ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #accessing }
AlbTextEditorCursor >> desiredCoordinate [
	<return: #Number>

	^ desiredCoordinate
]

{ #category : #accessing }
AlbTextEditorCursor >> desiredCoordinate: aNumber [
	desiredCoordinate := aNumber
]

{ #category : #testing }
AlbTextEditorCursor >> hasDesiredCoordinate [

	^ desiredCoordinate isNotNil
]

{ #category : #comparing }
AlbTextEditorCursor >> hash [

	^ self class hash bitXor: self position hash
]

{ #category : #initialization }
AlbTextEditorCursor >> initialize [

	super initialize.
	
	"Default cursor position should be 0,
	which means that it will be before the first text item (character) if it exists"
	position := 0.
	isVisible := false
]

{ #category : #testing }
AlbTextEditorCursor >> insideSegment: aSegment [
	"Return true if I am inside of a given segment"

	^ self position between: aSegment textStart and: aSegment textEnd
]

{ #category : #testing }
AlbTextEditorCursor >> insideSubText: aTextEditorSegmentPiece of: aSegment [
	"Return true if I am inside a given subtext, false otherwise"
	
	^ (self position
		between: aTextEditorSegmentPiece textStart
		and: aTextEditorSegmentPiece textEnd - (aSegment isLastTextPiece: aTextEditorSegmentPiece) not asBit)
			and: [ self position between: aSegment textStart and: aSegment textEnd ]
]

{ #category : #accessing }
AlbTextEditorCursor >> isVisible [
	"Return true if this cursor should be visible, false otherwise"

	^ isVisible
]

{ #category : #accessing }
AlbTextEditorCursor >> isVisible: aBoolean [

	isVisible := aBoolean
]

{ #category : #accessing }
AlbTextEditorCursor >> position [
	"Return position of the cursor within the text"

	^ position
]

{ #category : #accessing }
AlbTextEditorCursor >> position: anIndex [

	self
		assert: [ anIndex >= 0 ]
		description: [ 'Cursor position must not be negative' ].

	position := anIndex
]

{ #category : #printing }
AlbTextEditorCursor >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: position;
		nextPut: $)
]

{ #category : #accessing }
AlbTextEditorCursor >> resetDesiredCoordinate [

	desiredCoordinate := nil
]
