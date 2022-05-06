Class {
	#name : #BrickEditorModel,
	#superclass : #AlbWidgetModel,
	#instVars : [
		'styler',
		'text',
		'mode'
	],
	#category : #'Album-Brick-NU-Model'
}

{ #category : #accessing }
BrickEditorModel >> beEditable [
	self mode: AlbTextEditorEditableMode new
]

{ #category : #initialization }
BrickEditorModel >> initialize [
	super initialize.
	
	styler := BlTextNullStyler new.
	text := '' asRopedText.
	mode := AlbTextEditorEditableMode new
]

{ #category : #initialization }
BrickEditorModel >> initializeListeners [
	super initializeListeners.
	
	self when: AlbEditorStylerRequest reply: [ :aResponse | aResponse styler: self styler ].
	self when: AlbEditorTextRequest reply: [ :aResponse | aResponse text: self text ].
	self when: AlbEditorModeRequest reply: [ :aResponse | aResponse mode: self mode ].
]

{ #category : #accessing }
BrickEditorModel >> mode [
	<return: #AlbTextEditorMode>

	^ mode
]

{ #category : #accessing }
BrickEditorModel >> mode: aTextEditorMode [
	mode = aTextEditorMode
		ifTrue: [ ^ self ].

	mode := aTextEditorMode.
	self notifyModeChanged
]

{ #category : #notifying }
BrickEditorModel >> notifyModeChanged [
	self dispatchEvent: (AlbEditorModeChanged new mode: self mode)
]

{ #category : #notifying }
BrickEditorModel >> notifyStylerChanged [
	self dispatchEvent: (AlbEditorStylerChanged styler: self styler)
]

{ #category : #notifying }
BrickEditorModel >> notifyTextChanged [
	self dispatchEvent: (AlbEditorTextChanged text: self text)
]

{ #category : #accessing }
BrickEditorModel >> styler [
	^ styler
]

{ #category : #accessing }
BrickEditorModel >> styler: aStyler [
	styler = aStyler
		ifTrue: [ ^ self ].

	styler := aStyler.
	self notifyStylerChanged
]

{ #category : #accessing }
BrickEditorModel >> text [
	^ text
]

{ #category : #accessing }
BrickEditorModel >> text: aText [
	text == aText
		ifTrue: [ ^ self ].

	text := aText.
	self notifyTextChanged
]
