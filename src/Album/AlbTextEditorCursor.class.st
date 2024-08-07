Class {
	#name : #AlbTextEditorCursor,
	#superclass : #Object,
	#category : #'Album-Model-Cursor'
}

{ #category : #'instance creation' }
AlbTextEditorCursor class >> at: aTextIndex [
	<return: #AlbTextEditorSingleCursor>

	^ AlbTextEditorSingleCursor at: aTextIndex
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

{ #category : #enumerating }
AlbTextEditorCursor >> collect: aBlock [ 	
	^ Array streamContents: [ :aStream |
		self do: [ :anElement | aStream nextPut: (aBlock value: anElement) ] ]
]

{ #category : #accessing }
AlbTextEditorCursor >> cursorsCount [
	<return: #Number>
	| aCount |
	
	aCount := 0.
	self do: [ :aCursor | aCount := aCount + 1 ].
	^ aCount
]

{ #category : #enumerating }
AlbTextEditorCursor >> detect: aBlock [ 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Answer the first element for which aBlock evaluates to true."

	^ self detect: aBlock ifNone: [self errorNotFound: aBlock]
]

{ #category : #enumerating }
AlbTextEditorCursor >> detect: aBlock ifFound: foundBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	If some element evaluates aBlock to true, then cull this element into 
	foundBlock. 
	If no element matches the criteria then do nothing.
	Always returns self to avoid misuse and a potential isNil check on the sender."

	self
		detect: aBlock
		ifFound: foundBlock
		ifNone: [ 
			"Do nothing on purpose"
			 ]
]

{ #category : #enumerating }
AlbTextEditorCursor >> detect: aBlock ifFound: foundBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	If some element evaluates aBlock to true, then cull this element into 
	foundBlock and answer the result of this evaluation. 
	If none evaluate to true, then evaluate exceptionBlock."

	self
		do: [ :each | 
			(aBlock value: each)
				ifTrue: [ ^ foundBlock cull: each ] ].
	^ exceptionBlock value	
]

{ #category : #enumerating }
AlbTextEditorCursor >> detect: aBlock ifNone: exceptionBlock [
	"Evaluate aBlock with each of the receiver's elements as the argument.  
	Answer the first element for which aBlock evaluates to true. If none  
	evaluate to true, then evaluate the argument, exceptionBlock."

	^ self detect: aBlock ifFound: [ :element | element ] ifNone: exceptionBlock
]

{ #category : #enumerating }
AlbTextEditorCursor >> do: aBlock [
	"Evaluate a given block with all available cursors"
	
	^ self subclassResponsibility
]

{ #category : #enumerating }
AlbTextEditorCursor >> errorNotFound: anObject [
	"Raise a NotFound exception."

	NotFound signalFor: anObject
]

{ #category : #accessing }
AlbTextEditorCursor >> first [
	"Return the first cursor sorted by position. Throw an error if there are no cursors"
	<return: #AlbTextEditorSingleCursor>

	^ (self allCursors sorted: [ :a :b | a position < b position ]) first
]

{ #category : #testing }
AlbTextEditorCursor >> isEmpty [
	"Return true if there are no cursors"
	<return: #Boolean>

	self do: [ :aCursor | ^ false ].
	^ true
]

{ #category : #testing }
AlbTextEditorCursor >> isNotEmpty [
	"Return true if there is at least one cursor"
	<return: #Boolean>

	^ self isEmpty not
]

{ #category : #testing }
AlbTextEditorCursor >> isSingle [
	"Return true if there is exactly *one* cursor"
	<return: #Boolean>

	^ self cursorsCount = 1
]

{ #category : #accessing }
AlbTextEditorCursor >> positions [
	^ self collect: [ :eachCursor | eachCursor position ]
]

{ #category : #enumerating }
AlbTextEditorCursor >> select: aBlock [ 	
	^ Array streamContents: [ :aStream |
			self do: [ :anElement |
				(aBlock value: anElement)
					ifTrue: [ aStream nextPut: anElement ] ] ]
]
