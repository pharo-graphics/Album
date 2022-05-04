Class {
	#name : #BrEditorModel,
	#superclass : #AlbWidgetModel,
	#instVars : [
		'styler',
		'text',
		'mode'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
BrEditorModel >> beEditable [
	self mode: AlbTextEditorEditableMode new
]

{ #category : #initialization }
BrEditorModel >> initialize [
	super initialize.
	
	styler := BlTextNullStyler new.
	text := '' asRopedText.
	mode := AlbTextEditorEditableMode new
]

{ #category : #initialization }
BrEditorModel >> initializeListeners [
	super initializeListeners.
	
	self when: AlbEditorStylerRequest reply: [ :aResponse | aResponse styler: self styler ].
	self when: AlbEditorTextRequest reply: [ :aResponse | aResponse text: self text ].
	self when: AlbEditorModeRequest reply: [ :aResponse | aResponse mode: self mode ].
]

{ #category : #accessing }
BrEditorModel >> mode [
	<return: #AlbTextEditorMode>

	^ mode
]

{ #category : #accessing }
BrEditorModel >> mode: aTextEditorMode [
	mode = aTextEditorMode
		ifTrue: [ ^ self ].

	mode := aTextEditorMode.
	self notifyModeChanged
]

{ #category : #notifying }
BrEditorModel >> notifyModeChanged [
	self dispatchEvent: (AlbEditorModeChanged new mode: self mode)
]

{ #category : #notifying }
BrEditorModel >> notifyStylerChanged [
	self dispatchEvent: (AlbEditorStylerChanged styler: self styler)
]

{ #category : #notifying }
BrEditorModel >> notifyTextChanged [
	self dispatchEvent: (AlbEditorTextChanged text: self text)
]

{ #category : #accessing }
BrEditorModel >> styler [
	^ styler
]

{ #category : #accessing }
BrEditorModel >> styler: aStyler [
	styler = aStyler
		ifTrue: [ ^ self ].

	styler := aStyler.
	self notifyStylerChanged
]

{ #category : #accessing }
BrEditorModel >> text [
	^ text
]

{ #category : #accessing }
BrEditorModel >> text: aText [
	text == aText
		ifTrue: [ ^ self ].

	text := aText.
	self notifyTextChanged
]
