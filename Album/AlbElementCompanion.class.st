Class {
	#name : #AlbElementCompanion,
	#superclass : #Object,
	#category : #'Album-Core'
}

{ #category : #converting }
AlbElementCompanion class >> asLook [
	^ self new asLook
]

{ #category : #converting }
AlbElementCompanion >> asLook [
	^ self
]

{ #category : #'api - hooks' }
AlbElementCompanion >> onInstalledIn: anElement [

]

{ #category : #'api - hooks' }
AlbElementCompanion >> onUninstalledIn: anElement [
	"Is sent when I am removed from an element (or from the other actor which was part of the element)"
	self removeEventHandlersFromWidget: anElement.

]

{ #category : #'private - event management' }
AlbElementCompanion >> removeEventHandlersFromWidget: anElement [
	anElement removeEventHandlersSuchThat: [ :eachEventHandler | 
		self flag: 'how to remove my eventHandler ? '.
		true
		"eachEventHandler eventTarget == anElement" ]
]
