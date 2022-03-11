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
AlbTextEditorHistoryCompositeCommand >> redoOn: aBrTextEditor [
	commands do: [ :eachCommand | eachCommand redoOn: aBrTextEditor ]
]

{ #category : #'api - undo/redo' }
AlbTextEditorHistoryCompositeCommand >> undoOn: aBrTextEditor [
	commands reverseDo: [ :eachCommand | eachCommand undoOn: aBrTextEditor ]
]
