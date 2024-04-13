Class {
	#name : #AlbTextEditorCursorRemoveCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'cursor'
	],
	#category : #'Album-Commands'
}

{ #category : #accessing }
AlbTextEditorCursorRemoveCommand >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorRemoveCommand >> cursor: anObject [
	cursor := anObject
]

{ #category : #executing }
AlbTextEditorCursorRemoveCommand >> executeOn: aTextEditor [

	"Attribute handling: some attribute are eventHandlers."

	self flag: 'We have to think about attributes later become this code is too crappy'.
	self processAttributesOn: aTextEditor.

	"Now move the cursor within the cached text segments"
	aTextEditor segmentCollector
		cachedSegmentAt: cursor position
		ifFound: [ :aSegment | 
			aTextEditor notifyItems: (aSegment index to: aSegment index) event: self newHolderEvent ]
		ifNotFound: [  ]
]

{ #category : #'instance creation' }
AlbTextEditorCursorRemoveCommand >> newHolderEvent [
	^ AlbTextEditorCursorRemovedHolderEvent new context: self context
]

{ #category : #executing }
AlbTextEditorCursorRemoveCommand >> processAttributesOn: aTextEditor [
	| anEditorText thePotentialHandlerTextInterval theEventHandlingAttributes eventHandlingAttributesOutside eventHandlingAttributesInside |
	self flag: 'what a crap!'.
	aTextEditor hasEventHandlerAttribute ifFalse: [ ^self ].
	anEditorText := aTextEditor text.

	self cursor position > anEditorText size
		ifTrue: [ ^ self ].

	self cursor position <= 0
		ifTrue: [ ^ self ].
	self flag: 'why not use position here instead of an interval ?'.
	"only chars to the left from the cursor handle cursor events"
	thePotentialHandlerTextInterval := self cursor position to: self cursor position.

	theEventHandlingAttributes := ((thePotentialHandlerTextInterval
		flatCollect: [ :eachTextIndex | anEditorText attributesAt: eachTextIndex ])
			select: [ :eachAttribute | eachAttribute isEventHandler ]) asSet.

	theEventHandlingAttributes
		ifEmpty: [ ^ self ].
	
	eventHandlingAttributesOutside := OrderedCollection new.
	eventHandlingAttributesInside := OrderedCollection new.

	anEditorText
		findAttributes: theEventHandlingAttributes
		indicesDo: [ :eachEventHandlerStart :eachEventHandlerEnd :eachEventHandlerAttribute |
			aTextEditor cursors do: [ :eachCursor |
				(eachCursor position between: eachEventHandlerStart and: eachEventHandlerEnd)
					ifTrue: [ eventHandlingAttributesInside add: eachEventHandlerAttribute -> (eachEventHandlerStart to: eachEventHandlerEnd) ]
					ifFalse: [ eventHandlingAttributesOutside add: eachEventHandlerAttribute -> (eachEventHandlerStart to: eachEventHandlerEnd) ] ] ].
	
	eventHandlingAttributesOutside do: [ :eachEventHandlerAttributeAndInterval |
		| eachAttribute eachInterval anEvent |
		
		eachAttribute := eachEventHandlerAttributeAndInterval key.
		eachInterval := eachEventHandlerAttributeAndInterval value.

		anEvent := AlbTextCursorAttributeLeaveEvent new textEditor: aTextEditor; interval: eachInterval.
		(eachAttribute wantsEvent: anEvent )
			ifTrue: [ eachAttribute handleEvent: anEvent ] ].

	eventHandlingAttributesInside do: [ :eachEventHandlerAttributeAndInterval |
		| eachAttribute eachInterval anEvent |
		
		eachAttribute := eachEventHandlerAttributeAndInterval key.
		eachInterval := eachEventHandlerAttributeAndInterval value.
		anEvent := AlbTextCursorAttributeEnterEvent new textEditor: aTextEditor; interval: eachInterval.
		(eachAttribute wantsEvent: anEvent)
			ifTrue: [ eachAttribute handleEvent: anEvent ] ]
]
