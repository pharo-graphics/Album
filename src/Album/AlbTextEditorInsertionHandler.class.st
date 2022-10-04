Class {
	#name : #AlbTextEditorInsertionHandler,
	#superclass : #AlbTextEditorToElementHandler,
	#category : #'Album-UI-Handlers'
}

{ #category : #'api - accessing' }
AlbTextEditorInsertionHandler >> eventsToHandle [
	^ { BlTextInputEvent }
]

{ #category : #'event handling' }
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

{ #category : #'event handling' }
AlbTextEditorInsertionHandler >> textInputEvent: anEvent [

	"we don't want to insert anything if primary modifier key is pressed.
    without this check if users try to use shortcuts that may don't exist such as (meta+s) the action will result in typing
    which lead to unwanted effects"

	(anEvent text allSatisfy: [ :aCharacter | 
		 Unicode isPrintable: aCharacter ]) ifFalse: [ ^ self ].

	anEvent modifiers isPrimaryModifier ifTrue: [ ^ self ].

	anEvent consumed: true.
	
	self
		insert: anEvent text asString
		atCursorIn: anEvent currentTarget editor
		context: anEvent currentTarget
]
