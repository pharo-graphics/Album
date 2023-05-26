Class {
	#name : #AlbPrimarySelectionElementUpdateStrategy,
	#superclass : #AlbSubtextElementUpdateOnExtentChangeStrategy,
	#instVars : [
		'focusHandler',
		'blurHandler',
		'selectionHandler',
		'editorChangeHandler'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #'api - install/uninstall  hook' }
AlbPrimarySelectionElementUpdateStrategy >> onInstalledIn: aSubTextElement [

	super onInstalledIn: aSubTextElement.

	selectionHandler := BlEventHandler on: AlbSelectionChangedEvent do: [ aSubTextElement updateVertices ].
	focusHandler := BlEventHandler on: BlFocusEvent do: [ aSubTextElement onGotFocus ].
	blurHandler := BlEventHandler on: BlBlurEvent do: [ aSubTextElement onLostFocus ].

	editorChangeHandler := 
		BlEventHandler 
			on: AlbTextEditorReplacedEvent 
			do: [ :event | 
				event previous ifNotNil: [ :prev | prev removeEventHandler: selectionHandler ].
				event current ifNotNil: [ :curr | curr addEventHandler: selectionHandler ] ].

	aSubTextElement editorElement editor addEventHandler: selectionHandler.
	aSubTextElement editorElement infinite addEventHandler: editorChangeHandler.
	aSubTextElement editorElement infinite addEventHandler: focusHandler.
	aSubTextElement editorElement infinite addEventHandler: blurHandler
]

{ #category : #'api - install/uninstall  hook' }
AlbPrimarySelectionElementUpdateStrategy >> onUninstalledIn: aSubTextElement [
	
	aSubTextElement editorElement editor removeEventHandler: selectionHandler.
	aSubTextElement editorElement infinite removeEventHandler: editorChangeHandler.
	aSubTextElement editorElement infinite removeEventHandler: focusHandler.
	aSubTextElement editorElement infinite removeEventHandler: blurHandler.
	
	selectionHandler := nil.
	editorChangeHandler := nil.
	focusHandler := nil.
	blurHandler := nil.

	super onUninstalledIn: aSubTextElement


]
