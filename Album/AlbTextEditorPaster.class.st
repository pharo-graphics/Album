Class {
	#name : #AlbTextEditorPaster,
	#superclass : #AlbTextEditorOperator,
	#instVars : [
		'text',
		'insertionIndices',
		'shouldUpdateCursor',
		'shouldUpdateSelection',
		'shouldDeleteSelected',
		'inputFilter'
	],
	#category : #'Album-Editor-Model - Operators'
}

{ #category : #'api - configuration' }
AlbTextEditorPaster >> at: anIndex [
	"Add a given index as another text paste location"

	(insertionIndices includes: anIndex)
		ifFalse: [ insertionIndices add: anIndex ]
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> atCursor [	
	self cursor do: [ :aCursor | self at: aCursor position ]
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> atEnd [
	"Insert a text at the very end"
	self at: self text size
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> fromClipboard [
	self string: Clipboard clipboardText asString
]

{ #category : #initialization }
AlbTextEditorPaster >> initialize [
	super initialize.
	
	insertionIndices := SortedCollection new.
	shouldUpdateCursor := true.
	shouldUpdateSelection := true.
	shouldDeleteSelected := true.

	inputFilter := AlbTextEditorNoInputFilter new
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> inputFilter: aTextEditorInputFilter [
	inputFilter := aTextEditorInputFilter
]

{ #category : #'api - processing' }
AlbTextEditorPaster >> paste [
	| anInserter |
	
	anInserter := self editor inserter.
	anInserter inputFilter: inputFilter.
	anInserter text: text.
	anInserter shouldDeleteSelected: shouldDeleteSelected.
	anInserter shouldUpdateCursor: shouldUpdateCursor.
	anInserter shouldUpdateSelection: shouldUpdateSelection.
	insertionIndices do: [ :anIndex | anInserter at: anIndex ].

	anInserter insert
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> string: aString [
	text := aString
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> text: aText [
	text := aText
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> withoutCursorUpdate [
	shouldUpdateCursor := false
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> withoutSelectionDelete [
	shouldDeleteSelected := false
]

{ #category : #'api - configuration' }
AlbTextEditorPaster >> withoutSelectionUpdate [
	shouldUpdateSelection := false
]
