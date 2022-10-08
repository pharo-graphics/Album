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
	self mode: AlbTextEditorMode editable
]

{ #category : #accessing }
AlbEditorModel >> beEditableCode [
	self mode: AlbTextEditorMode editable
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithSelection [ 
	self mode: AlbTextEditorMode readonlyWithSelection
]

{ #category : #accessing }
AlbEditorModel >> beReadonlyWithoutSelection [ 
	self mode: AlbTextEditorMode readonlyWithoutSelection
]

{ #category : #initialization }
AlbEditorModel >> defaultTextEditorMode [
	^ AlbTextEditorMode editable
]

{ #category : #initialization }
AlbEditorModel >> initialize [
	super initialize.
	
	text := '' asRopedText
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
	self dispatchEvent: (AlbEditorModeChangedEvent new mode: self mode)
]

{ #category : #'api - hooks' }
AlbEditorModel >> onInstalledIn: anElement [
	super onInstalledIn: anElement.
	self mode: self defaultTextEditorMode 

]

{ #category : #accessing }
AlbEditorModel >> styler [

	^ styler
]

{ #category : #accessing }
AlbEditorModel >> styler: aStyler [

	styler = aStyler ifTrue: [ ^ self ].

	styler := aStyler.
	self dispatchEvent: (AlbEditorStylerChangedEvent styler: self styler)
]

{ #category : #accessing }
AlbEditorModel >> text [
	^ text
]

{ #category : #accessing }
AlbEditorModel >> text: aText [

	text == aText ifTrue: [ ^ self ].

	text := aText.
	self dispatchEvent: (AlbEditorTextChangedEvent text: self text)
]

{ #category : #accessing }
AlbEditorModel >> textStyled: aText [
	text := aText fontName: 'Source Code Pro'.
	self dispatchEvent: (AlbEditorTextStyledEvent text: self text)
]
