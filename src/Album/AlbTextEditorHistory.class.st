Class {
	#name : #AlbTextEditorHistory,
	#superclass : #Object,
	#instVars : [
		'undoCommands',
		'redoCommands',
		'isEnabled',
		'shouldGroup',
		'currentGroup'
	],
	#category : #'Album-History'
}

{ #category : #private }
AlbTextEditorHistory >> addCommand: aCommand [
	isEnabled
		ifFalse: [ ^ self ].
		
	shouldGroup
		ifTrue: [ currentGroup addCommand: aCommand ]
		ifFalse: [ undoCommands add: aCommand ].
	redoCommands removeAll
]

{ #category : #'api - history' }
AlbTextEditorHistory >> cursorsMovedFrom: aCollectionOfFromIndices to: aCollectionOfToIndices [
	self addCommand: (AlbTextEditorHistoryCursorMovementCommand new
		fromIndices: aCollectionOfFromIndices;
		toIndices: aCollectionOfToIndices)
]

{ #category : #'api - history' }
AlbTextEditorHistory >> deletedTexts: aCollectionOfTexts undo: aCollectionOfUndoIndices redo: aCollectionOfRedoIndices [
	self addCommand: (AlbTextEditorHistoryDeletionCommand new
		texts: aCollectionOfTexts;
		undoIndices: aCollectionOfUndoIndices;
		redoIndices: aCollectionOfRedoIndices)
]

{ #category : #'api - history' }
AlbTextEditorHistory >> disableDuring: aBlock [
	| wasEnabled |
	
	wasEnabled := isEnabled.
	isEnabled := false.
	
	aBlock ensure: [ isEnabled := wasEnabled ]
]

{ #category : #'api - history' }
AlbTextEditorHistory >> groupDuring: aBlock [
	| wasGrouped |
	
	wasGrouped := shouldGroup.
	wasGrouped
		ifFalse: [
			currentGroup := AlbTextEditorHistoryCompositeCommand new.
			undoCommands add: currentGroup ].
	
	shouldGroup := true.
	aBlock ensure: [
		shouldGroup := wasGrouped.
		shouldGroup ifFalse: [
			currentGroup commands
				ifEmpty: [ undoCommands remove: currentGroup ]
				ifNotEmpty: [ :theCommands |
					theCommands size = 1
						ifTrue: [
							undoCommands remove: currentGroup.
							undoCommands addAll: theCommands ] ] ] ]
]

{ #category : #initialization }
AlbTextEditorHistory >> initialize [
	super initialize.
	
	self setUpToStart 
]

{ #category : #'api - history' }
AlbTextEditorHistory >> insertedStrings: aCollectionOfStrings undo: aCollectionOfUndoIndices redo: aCollectionOfRedoIndices [
	self addCommand: (AlbTextEditorHistoryInsertionCommand new
		strings: aCollectionOfStrings;
		undoIndices: aCollectionOfUndoIndices;
		redoIndices: aCollectionOfRedoIndices)
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistory >> redoOn: aTextEditor [
	redoCommands ifNotEmpty: [ :theCommands |
		self disableDuring: [ undoCommands add: (theCommands removeLast redoOn: aTextEditor) ] ]
]

{ #category : #initialization }
AlbTextEditorHistory >> setUpToStart [

	undoCommands := OrderedCollection new.
	redoCommands := OrderedCollection new.

	isEnabled := true.
	
	"when set to false all commands are added individually, otherwise they end up in a composite group"
	shouldGroup := false.
	currentGroup := AlbTextEditorHistoryCompositeCommand new
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistory >> undoOn: aTextEditor [
	undoCommands ifNotEmpty: [ :theCommands |
		self disableDuring: [ redoCommands add: (theCommands removeLast undoOn: aTextEditor) ] ]
]
