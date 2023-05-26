Class {
	#name : #AlbSubtextElementUpdateOnExtentChangeStrategy,
	#superclass : #AlbSubtextElementUpdateStrategy,
	#instVars : [
		'extentHandler',
		'scrollHandler'
	],
	#category : #'Album-UI-Text-Portion'
}

{ #category : #'api - install/uninstall  hook' }
AlbSubtextElementUpdateOnExtentChangeStrategy >> onInstalledIn: aSubTextElement [

	super onInstalledIn: aSubTextElement.
	extentHandler := BlEventHandler on: BlElementExtentChangedEvent do: [ aSubTextElement updateVertices ].
	scrollHandler := BlEventHandler on: BlElementScrolledEvent do: [ :event | aSubTextElement updateVertices ].

	aSubTextElement editorElement infinite addEventHandler: extentHandler.
	aSubTextElement editorElement infinite addEventHandler: scrollHandler.

]

{ #category : #'api - install/uninstall  hook' }
AlbSubtextElementUpdateOnExtentChangeStrategy >> onUninstalledIn: aSubTextElement [

	aSubTextElement editorElement infinite removeEventHandler: extentHandler.
	aSubTextElement editorElement infinite removeEventHandler: scrollHandler.
	
	extentHandler := nil.
	scrollHandler := nil.
		
	super onUninstalledIn: aSubTextElement.


]
