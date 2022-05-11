Class {
	#name : #AlbTextEditorEditableCodeMode,
	#superclass : #AlbTextEditorEditableMode,
	#category : #'Album-Model'
}

{ #category : #defaults }
AlbTextEditorEditableCodeMode >> returnKeyAndAction [
	^ AlbEditorCarriageReturnShortcut new
]
