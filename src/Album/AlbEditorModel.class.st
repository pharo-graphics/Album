Class {
	#name : #AlbEditorModel,
	#superclass : #OBlViewModel,
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

	mode = aTextEditorMode ifTrue: [ ^ self ].
	mode := aTextEditorMode.
	self dispatchEvent: (AlbEditorModeChanged new mode: self mode)
]

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [
	super onInstalledIn: anElement.

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
	self dispatchEvent: (AlbEditorStylerChanged styler: self styler)
]

{ #category : #accessing }
AlbEditorModel >> text [
	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [

	text == aText ifTrue: [ ^ self ].

	text := aText.
	self dispatchEvent: (AlbEditorTextChanged text: self text)
]
