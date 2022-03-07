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
	#category : #'Album-Editor-Look'
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
	
	attributesBuilder := BlTextDelegatedAttributesBuilder new attributesTarget: text.
	attributesBuilder beNotOverwritableByStyler.
	"attributesBuilder whenAdded: [  ].
	
	self add: BrLayoutResizerAptitude inherit"
]

{ #category : #initialization }
AlbEditorAptitude >> initializeListeners [
	super initializeListeners.
	
	self when: BrEditorStylerChanged do: [ :anEvent | self styler: anEvent styler ].
	self when: BrEditorTextChanged do: [ :anEvent | self text: anEvent text ].
	self when: BrEditorModeChanged do: [ :anEvent | self mode: anEvent mode ]
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
