"
I am a special marker attribute that is intended to be used together with ${method:BlText>>#findAttribute:indicesDo:}$ to dynamically find text interval indices
"
Class {
	#name : #AlbTextInvisibleMarkerAttribute,
	#superclass : #BlTextAttribute,
	#category : #'Album-Editor-Attributes'
}

{ #category : #comparing }
AlbTextInvisibleMarkerAttribute >> type [
	^ self
]
