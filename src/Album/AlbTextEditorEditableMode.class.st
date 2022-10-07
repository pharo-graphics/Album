Class {
	#name : #AlbTextEditorEditableMode,
	#superclass : #AlbTextEditorMode,
	#category : #'Album-Model'
}

{ #category : #defaults }
AlbTextEditorEditableMode >> returnKeyAndAction [
	^ AlbEditorLineEndingShortcut new
]
