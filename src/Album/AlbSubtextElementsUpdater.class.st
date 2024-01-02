Class {
	#name : #AlbSubtextElementsUpdater,
	#superclass : #BlCustomEventHandler,
	#instVars : [
		'updaterProcess',
		'remanentSubtexts'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #'api - accessing' }
AlbSubtextElementsUpdater >> eventsToHandle [

	^ { AlbSubtextElementInvalidateEvent. AlbInfiniteModeChangedEvent }
]

{ #category : #'event handling' }
AlbSubtextElementsUpdater >> infiniteModeChangedEvent: anEvent [

	anEvent currentTarget removeEventHandler: self
]

{ #category : #initialization }
AlbSubtextElementsUpdater >> initialize [

	super initialize.
	remanentSubtexts := #(  )
]

{ #category : #'api - hooks' }
AlbSubtextElementsUpdater >> onUninstalledIn: anElement [

	super onUninstalledIn: anElement.
	remanentSubtexts do: [ :r | r removeFromParent ]
]

{ #category : #'event handling' }
AlbSubtextElementsUpdater >> subtextElementInvalidateEvent: anEvent [

	| target |
	target := anEvent currentTarget.
	remanentSubtexts do: [ :r | r removeFromParent ].
	self terminateUpdater.
	target selectedText ifEmpty: [ ^ self ].
	updaterProcess := [
	                  | builder |
	                  builder := AlbSubtextElementsBuilder new.
	                  builder
		                  parentElement: target;
		                  fullText: target enlargedSubTextOnScreen;
		                  subtext: target selectedText.
	                  builder createDecorations.
	                  remanentSubtexts := builder decorations.
	                  target frontLayer addChildren: remanentSubtexts.
	                  updaterProcess := nil ]
		                  forkAt: Processor systemBackgroundPriority
		                  named: 'Album subtext elements builder task'
]

{ #category : #private }
AlbSubtextElementsUpdater >> terminateUpdater [

	updaterProcess ifNotNil: #terminate.
	updaterProcess := nil
]
