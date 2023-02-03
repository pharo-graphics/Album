Class {
	#name : #AlbEditorElementEventDistributor,
	#superclass : #BlSharedEventDistributor,
	#category : #'Album-UI'
}

{ #category : #'api - event managing' }
AlbEditorElementEventDistributor >> wantsEvent: anEvent [

	^ anEvent isUIEvent and: [ anEvent isBaseDrag not and: [ anEvent isConsumed not] ]
]
