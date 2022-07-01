"
I represent a scrollable editor element. I support scrolling, selection and other various features.
"
Class {
	#name : #AlbEditorElement,
	#superclass : #BlInfiniteElement,
	#instVars : [
		'hasFocus',
		'textStyleHandler'
	],
	#category : #'Album-UI'
}

{ #category : #converting }
AlbEditorElement >> asScrollableElement [
	^ self
]

{ #category : #accessing }
AlbEditorElement >> cursor [
	^ self editor cursor
]

{ #category : #initialization }
AlbEditorElement >> defaultLayout [
	^ BlInfiniteLinearLayout vertical
]

{ #category : #accessing }
AlbEditorElement >> editor [
	<return: #AlbTextEditor>

	^ self dataSource
]

{ #category : #accessing }
AlbEditorElement >> editor: aTextEditor [
	self editor removeEventHandler: textStyleHandler.
	self dataSource: aTextEditor.
	self editor addEventHandler: textStyleHandler.
]

{ #category : #'focus testing' }
AlbEditorElement >> hasFocus [
	^ hasFocus or: [ self isFocused ]
]

{ #category : #initialization }
AlbEditorElement >> initialize [
	super initialize.

	hasFocus := false.
	self when: BlFocusInEvent do: [ hasFocus := true ].
	self when: BlFocusOutEvent do: [ hasFocus := false ].
	
	textStyleHandler := BlEventHandler
		on: AlbTextEditorTextStyleRequested
		do: [ :anEvent | self editor stylerStrategy styleTextInEditorElement: self thenDo: anEvent afterAction ]
]

{ #category : #scrolling }
AlbEditorElement >> scrollToLast [
	"Scroll instantly to the last segment"
	
	self scrollToPosition: self editor segmentCollector computedSegmentsCount
]
