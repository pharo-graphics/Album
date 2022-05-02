Class {
	#name : #AlbDresser,
	#superclass : #Object,
	#category : #'Album-Brick-Core'
}

{ #category : #converting }
AlbDresser class >> asLook [
	^ self new asLook
]

{ #category : #converting }
AlbDresser >> asLook [
	^ self
]

{ #category : #'api - hooks' }
AlbDresser >> onInstalledIn: anElement [

]

{ #category : #'api - hooks' }
AlbDresser >> onUninstalledIn: anElement [
	"Is sent when I am removed from an element (or from the other actor which was part of the element)"
	self removeEventHandlersFromWidget: anElement.

]

{ #category : #'private - event management' }
AlbDresser >> removeEventHandlersFromWidget: anElement [

	anElement removeEventHandlersSuchThat: [ :eachEventHandler | 
		eachEventHandler eventTarget == anElement ]
]
