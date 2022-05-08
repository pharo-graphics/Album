Class {
	#name : #AlbEditorModel,
	#superclass : #OblViewModel,
	#instVars : [
		'styler',
		'text',
		'mode'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbEditorModel >> beEditable [
	self mode: AlbTextEditorEditableMode new
]

{ #category : #initialization }
AlbEditorModel >> initialize [
	super initialize.
	
	styler := BlTextNullStyler new.
	text := '' asRopedText.
	mode := AlbTextEditorEditableMode new
]

{ #category : #accessing }
AlbEditorModel >> mode [
	<return: #AlbTextEditorMode>

	^ mode
]

{ #category : #accessing }
AlbEditorModel >> mode: aTextEditorMode [
	mode = aTextEditorMode
		ifTrue: [ ^ self ].

	mode := aTextEditorMode.
	self notifyModeChanged
]

{ #category : #notifying }
AlbEditorModel >> notifyModeChanged [
	self dispatchEvent: (AlbEditorModeChanged new mode: self mode)
]

{ #category : #notifying }
AlbEditorModel >> notifyStylerChanged [
	self dispatchEvent: (AlbEditorStylerChanged styler: self styler)
]

{ #category : #notifying }
AlbEditorModel >> notifyTextChanged [
	self dispatchEvent: (AlbEditorTextChanged text: self text)
]

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [
	super onInstalledIn: anElement.
	self when: AlbEditorStylerRequest reply: [ :aResponse | aResponse styler: self styler ].
	self when: AlbEditorTextRequest reply: [ :aResponse | aResponse text: self text ].
	self when: AlbEditorModeRequest reply: [ :aResponse | aResponse mode: self mode ].
]

{ #category : #accessing }
AlbEditorModel >> styler [
	^ styler
]

{ #category : #accessing }
AlbEditorModel >> styler: aStyler [
	styler = aStyler
		ifTrue: [ ^ self ].

	styler := aStyler.
	self notifyStylerChanged
]

{ #category : #accessing }
AlbEditorModel >> text [
	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [
	text == aText
		ifTrue: [ ^ self ].

	text := aText.
	self notifyTextChanged
]
