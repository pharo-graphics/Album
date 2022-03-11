Class {
	#name : #AlbLookAddChildFirstChange,
	#superclass : #AlbLookAddChildChange,
	#category : #'Album-Brick-Core-Changes'
}

{ #category : #initialization }
AlbLookAddChildFirstChange >> writeOn: aLook value: anObject [
	| container |
	container := self containerOn: aLook.
	^ anObject
		ifNil: [ container removeChild: child ]
		ifNotNil: [ child := anObject.
			container addChildFirst: anObject ]
]
