Class {
	#name : #AlbEditorAptitude,
	#superclass : #AlbAptitude,
	#traits : 'TBlTextStyleable',
	#classTraits : 'TBlTextStyleable classTrait',
	#instVars : [
		'attributesBuilder',
		'text',
		'styler'
	],
	#category : #'Album-Brick-NU-Actor and Aptitude'
}

{ #category : #accessing }
AlbEditorAptitude >> attributesBuilder [
	<return: #BlTextAttributesBuilder>
	
	^ attributesBuilder
]

{ #category : #initialization }
AlbEditorAptitude >> initialize [

	super initialize.

	styler := BlTextNullStyler new.
	text := '' asRopedText.

	attributesBuilder := BlTextDelegatedAttributesBuilder new 
		                     attributesTarget: text.
	attributesBuilder beNotOverwritableByStyler
]

{ #category : #initialization }
AlbEditorAptitude >> initializeListeners [
	super initializeListeners.
	
	self when: AlbEditorStylerChangedEvent do: [ :anEvent | self styler: anEvent styler ].
	self when: AlbEditorTextChangedEvent do: [ :anEvent | self text: anEvent text ].
	self when: AlbEditorModeChangedEvent do: [ :anEvent | self mode: anEvent mode ]
]

{ #category : #initialization }
AlbEditorAptitude >> initializeRequests [
	super initializeRequests.

	self request: AlbEditorStylerRequest new.
	self request: AlbEditorTextRequest new.
	self request: AlbEditorModeRequest new
]

{ #category : #accessing }
AlbEditorAptitude >> mode: aTextEditorMode [	
	self widgetDo: [ :aWidget |
		aWidget editor editorMode: aTextEditorMode.
		aWidget states addState: (AlbEditorModeState mode: aTextEditorMode class) ]
]

{ #category : #accessing }
AlbEditorAptitude >> styler: aStyler [
	styler := aStyler.
	
	self widgetDo: [ :aWidget | aWidget editor styler: aStyler ]
]

{ #category : #accessing }
AlbEditorAptitude >> text: aText [
	text := aText.
	attributesBuilder attributesTarget: text.
	
	self widgetDo: [ :aWidget | aWidget editor text: aText ]
]
