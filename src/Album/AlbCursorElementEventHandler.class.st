Class {
	#name : #AlbCursorElementEventHandler,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'previousBoundsInSpace'
	],
	#category : #'Album-UI'
}

{ #category : #'event handling' }
AlbCursorElementEventHandler >> elementAddedToSceneGraphEvent: anEvent [

	self notifyCursorElementMovedFromEvent: anEvent
]

{ #category : #'event handling' }
AlbCursorElementEventHandler >> elementExtentChangedEvent: anEvent [

	self notifyCursorElementMovedFromEvent: anEvent
]

{ #category : #'event handling' }
AlbCursorElementEventHandler >> elementPositionInSpaceChangedEvent: anEvent [

	self notifyCursorElementMovedFromEvent: anEvent
]

{ #category : #'api - accessing' }
AlbCursorElementEventHandler >> eventsToHandle [

	^ {
		  BlElementExtentChangedEvent.
		  BlElementAddedToSceneGraphEvent.
		  BlElementPositionInSpaceChangedEvent }
]

{ #category : #'event handling' }
AlbCursorElementEventHandler >> notifyCursorElementMovedFromEvent: anEvent [
	
	| cursorElement boundsInSpace |
	cursorElement := anEvent currentTarget.
	boundsInSpace := cursorElement bounds inSpace bounds.
	previousBoundsInSpace = boundsInSpace ifTrue: [ ^ self ].
	previousBoundsInSpace := boundsInSpace.
	anEvent currentTarget fireEvent: AlbCursorElementMovedEvent new
]
