Class {
	#name : #AlbTextEditorEditableCodeMode,
	#superclass : #AlbTextEditorEditableMode,
	#category : #'Album-Editor-Model'
}

{ #category : #defaults }
AlbTextEditorEditableCodeMode >> returnKeyAndAction [
	^ AlbEditorCarriageReturnShortcut new
]
