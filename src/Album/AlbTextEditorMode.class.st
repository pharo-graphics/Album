Class {
	#name : #AlbTextEditorMode,
	#superclass : #Object,
	#category : #'Album-Model'
}

{ #category : #comparing }
AlbTextEditorMode >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
]

{ #category : #comparing }
AlbTextEditorMode >> hash [
	^ self hash class
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditor: aTextEditor [
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> installOnEditorElement: aTextEditorElement [
]

{ #category : #testing }
AlbTextEditorMode >> isEditable [
	^ false
]

{ #category : #testing }
AlbTextEditorMode >> isReadOnly [
	^ false
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditor: aTextEditor [
]

{ #category : #'api - hooks' }
AlbTextEditorMode >> uninstallFromEditorElement: aTextEditor [
]
