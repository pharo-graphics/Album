Class {
	#name : #AlbEditorDresser,
	#superclass : #AlbDresser,
	#traits : 'TBlTextStyleable',
	#classTraits : 'TBlTextStyleable classTrait',
	#instVars : [
		'attributesBuilder',
		'text',
		'styler'
	],
	#category : #'Album-Look'
}

{ #category : #converting }
AlbEditorDresser class >> asLook [
	^ self new asLook
]

{ #category : #converting }
AlbEditorDresser >> asLook [
	^ self
]

{ #category : #accessing }
AlbEditorDresser >> attributesBuilder [
	<return: #BlTextAttributesBuilder>
	
	^ attributesBuilder
]

{ #category : #initialization }
AlbEditorDresser >> initialize [
	super initialize.
	
	styler := BlTextNullStyler new.
	text := '' asRopedText.
	
	attributesBuilder := BlTextDelegatedAttributesBuilder new attributesTarget: text.
	attributesBuilder beNotOverwritableByStyler.
]

{ #category : #initialization }
AlbEditorDresser >> initializeListeners [
	super initializeListeners.
	
	self when: AlbEditorStylerChanged do: [ :anEvent | self styler: anEvent styler ].
	self when: AlbEditorTextChanged do: [ :anEvent | self text: anEvent text ].
	self when: AlbEditorModeChanged do: [ :anEvent | self mode: anEvent mode ]
]

{ #category : #initialization }
AlbEditorDresser >> initializeListenersFrom: anElement [
	super initializeListenersFrom: anElement.
	self when: AlbEditorStylerChanged do: [ :anEvent | anEvent target styler: anEvent styler ].
	self when: AlbEditorTextChanged do: [ :anEvent | self halt. anEvent target text: anEvent text ].
	self when: AlbEditorModeChanged do: [ :anEvent | anEvent target mode: anEvent mode ]
]

{ #category : #initialization }
AlbEditorDresser >> initializeRequests [
	super initializeRequests.

	"self request: AlbEditorStylerRequest new.
	self request: AlbEditorTextRequest new.
	self request: AlbEditorModeRequest new"
]

{ #category : #initialization }
AlbEditorDresser >> initializeRequestsFrom: anElement [
	super initializeRequestsFrom: anElement.
self halt.
	self request: (AlbEditorStylerRequest new target: anElement).
	self request: (AlbEditorTextRequest new target: anElement).
	self request: (AlbEditorModeRequest new target: anElement).
]

{ #category : #accessing }
AlbEditorDresser >> mode: aTextEditorMode [	
	self widgetDo: [ :aWidget |
		aWidget editor editorMode: aTextEditorMode.
		aWidget states addState: (AlbEditorModeState mode: aTextEditorMode class) ]
]

{ #category : #accessing }
AlbEditorDresser >> styler: aStyler [
	styler := aStyler.
	self widgetDo: [ :aWidget | aWidget editor styler: aStyler ]
]

{ #category : #accessing }
AlbEditorDresser >> text: aText [
	text := aText.
	attributesBuilder attributesTarget: text.
	"self widgetDo: [ :aWidget | aWidget editor text: aText ]"
]
