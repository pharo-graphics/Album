"
I am sent when a cursor related change happened at a given text position.

It can be that a cursor was removed from this position or added at it
"
Class {
	#name : #AlbTextEditorCursorChangeCommand,
	#superclass : #AlbTextEditorCommand,
	#instVars : [
		'position',
		'cursor'
	],
	#category : #'Album-Commands'
}

{ #category : #accessing }
AlbTextEditorCursorChangeCommand >> cursor [
	<return: #AlbTextEditorSingleCursor>

	^ cursor
]

{ #category : #accessing }
AlbTextEditorCursorChangeCommand >> cursor: anObject [
	cursor := anObject
]

{ #category : #executing }
AlbTextEditorCursorChangeCommand >> executeOn: aTextEditor [
	
	self telemetry
		timeSync: [ 'Process attributes' ]
		during: [ self processAttributesOn: aTextEditor ].

	aTextEditor segmentCollector
		cachedSegmentAt: self position
		ifFound: [ :aSegment |
			self telemetry
				timeSync: [ 'Enqueue cursor changed holder command {1}' format: { aSegment index to: aSegment index } ]
				during: [
					aTextEditor
						enqueueHolderCommand: self newHolderCommand
						interval: (aSegment index to: aSegment index) ] ]
		ifNotFound: [  ].
]

{ #category : #'instance creation' }
AlbTextEditorCursorChangeCommand >> newHolderCommand [
	^ AlbTextEditorCursorChangedHolderCommand new context: self context
]

{ #category : #accessing }
AlbTextEditorCursorChangeCommand >> position [
	^ position
]

{ #category : #accessing }
AlbTextEditorCursorChangeCommand >> position: anObject [
	position := anObject
]

{ #category : #printing }
AlbTextEditorCursorChangeCommand >> printOn: aStream [
	aStream
		nextPutAll: 'Cursor changed at ';
		print: self position
]

{ #category : #executing }
AlbTextEditorCursorChangeCommand >> processAttributesOn: aTextEditor [
	| anEditorText thePotentialHandlerTextInterval theEventHandlingAttributes eventHandlingAttributesOutside eventHandlingAttributesInside |

	anEditorText := aTextEditor text.

	self position > anEditorText size
		ifTrue: [ ^ self ].

	self position <= 0
		ifTrue: [ ^ self ].
	
	"only chars to the left from the cursor handle cursor events"
	thePotentialHandlerTextInterval := self position to: self position.

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

		anEvent := AlbTextCursorAttributeLeaveEvent new interval: eachInterval.
		(eachAttribute wantsEvent: anEvent in: aTextEditor)
			ifTrue: [ eachAttribute handleEvent: anEvent in: aTextEditor on: nil ] ].

	eventHandlingAttributesInside do: [ :eachEventHandlerAttributeAndInterval |
		| eachAttribute eachInterval anEvent |
		
		eachAttribute := eachEventHandlerAttributeAndInterval key.
		eachInterval := eachEventHandlerAttributeAndInterval value.
		anEvent := AlbTextCursorAttributeEnterEvent new interval: eachInterval.
		(eachAttribute wantsEvent: anEvent in: aTextEditor)
			ifTrue: [ eachAttribute handleEvent: anEvent in: aTextEditor on: nil ] ]
]
