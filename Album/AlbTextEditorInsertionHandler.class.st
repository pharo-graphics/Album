Class {
	#name : #AlbTextEditorInsertionHandler,
	#superclass : #BlCustomEventHandler,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Album-UI-Handlers'
}

{ #category : #accessing }
AlbTextEditorInsertionHandler class >> cleanUp [
	super cleanUp.
	
	uniqueInstance := nil
]

{ #category : #accessing }
AlbTextEditorInsertionHandler class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'api - accessing' }
AlbTextEditorInsertionHandler >> eventsToHandle [
	^ { BlTextInputEvent }
]

{ #category : #'api - insertion' }
AlbTextEditorInsertionHandler >> insert: aString atCursorIn: anEditor context: anElement [

	anEditor surroundMap
		closingFor: aString asSymbol
		ifPresent: [ :aSurroundSymbol |
			anEditor inserter
				context: anElement;
				inputFilter: anEditor inputFilter;
				atCursor;
				string: aString;
				surroundings: anEditor surroundMap;
				withoutSelectionDelete;
				insert ]
		ifAbsent: [
			anEditor inserter
				context: anElement;
				inputFilter: anEditor inputFilter;
				atCursor;
				string: aString;
				surroundings: anEditor surroundMap;
				insert ]
]

{ #category : #'api - event managing' }
AlbTextEditorInsertionHandler >> textInputEvent: anEvent [
    "we don't want to insert anything if primary modifier key is pressed.
    without this check if users try to use shortcuts that may don't exist such as (meta+s) the action will result in typing
    which lead to unwanted effects"

	(anEvent text allSatisfy: [ :aCharacter | Unicode isPrintable: aCharacter ])
		ifFalse: [ ^ self ].

    (anEvent modifiers isPrimaryModifier)
        ifTrue: [ ^ self ].

    anEvent consumed: true.

	anEvent currentTarget telemetry
		timeSync: [ 'Insert {1} at cursor' format: { anEvent text asString } ]
		during: [
			self
        		insert: anEvent text asString
        		atCursorIn: anEvent currentTarget editor
				context: anEvent currentTarget ]
]
