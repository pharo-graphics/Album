"
Sometimes multiple commands should be grouped in one undo/redo sequence
"
Class {
	#name : #AlbTextEditorHistoryCompositeCommand,
	#superclass : #AlbTextEditorHistoryCommand,
	#instVars : [
		'commands'
	],
	#category : #'Album-History'
}

{ #category : #initialization }
AlbTextEditorHistoryCompositeCommand >> addCommand: aCommand [
	"Commands should be added in the order they are performed in the editor"

	commands add: aCommand
]

{ #category : #accessing }
AlbTextEditorHistoryCompositeCommand >> commands [
	^ commands
]

{ #category : #initialization }
AlbTextEditorHistoryCompositeCommand >> initialize [
	super initialize.
	
	commands := OrderedCollection new
]

{ #category : #testing }
AlbTextEditorHistoryCompositeCommand >> isGroup [
	^ true
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCompositeCommand >> redoOn: aTextEditor [
	commands do: [ :eachCommand | eachCommand redoOn: aTextEditor ]
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCompositeCommand >> undoOn: aTextEditor [
	commands reverseDo: [ :eachCommand | eachCommand undoOn: aTextEditor ]
]
