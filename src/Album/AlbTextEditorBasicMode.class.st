Class {
	#name : #AlbTextEditorBasicMode,
	#superclass : #AlbTextEditorMode,
	#instVars : [
		'eventHandlers',
		'shortcuts'
	],
	#category : #'Album-Model'
}

{ #category : #initialization }
AlbTextEditorBasicMode >> createEventHandlers [
	^ #()
]

{ #category : #initialization }
AlbTextEditorBasicMode >> eventHandlers [
	^ eventHandlers ifNil: [ eventHandlers := self createEventHandlers ]
]

{ #category : #initialization }
AlbTextEditorBasicMode >> initialize [
	super initialize.
	
	"initialized lazily"
	eventHandlers := nil.

	shortcuts := {}
]

{ #category : #'api - hooks' }
AlbTextEditorBasicMode >> installOnEditor: aTextEditor [
	super installOnEditor: aTextEditor.
	
	shortcuts do: [ :eachInteraction |
		aTextEditor addEditorShortcut: eachInteraction ]
]

{ #category : #'api - hooks' }
AlbTextEditorBasicMode >> installOnEditorElement: anEditorElement [
	super installOnEditorElement: anEditorElement.

	self eventHandlers do: [ :eachEventHandler |
		anEditorElement addEventHandler: eachEventHandler ]
]

{ #category : #copying }
AlbTextEditorBasicMode >> postCopy [
	"they will be initialized lazily later"
	eventHandlers := nil.
	shortcuts := shortcuts copy
]

{ #category : #'api - hooks' }
AlbTextEditorBasicMode >> uninstallFromEditor: aTextEditor [
	super uninstallFromEditor: aTextEditor.
	
	shortcuts do: [ :eachInteraction |
		aTextEditor removeEditorShortcut: eachInteraction ]
]

{ #category : #'api - hooks' }
AlbTextEditorBasicMode >> uninstallFromEditorElement: anEditorElement [
	super uninstallFromEditorElement: anEditorElement.

	self eventHandlers do: [ :eachEventHandler |
		anEditorElement removeEventHandler: eachEventHandler ]
]

{ #category : #initialization }
AlbTextEditorBasicMode >> withShortcuts: aCollectionOfShortcuts [
	shortcuts := shortcuts, aCollectionOfShortcuts
]
