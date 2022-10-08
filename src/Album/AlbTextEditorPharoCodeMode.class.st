Class {
	#name : #AlbTextEditorPharoCodeMode,
	#superclass : #AlbTextEditorMode,
	#category : #'Album-Model'
}

{ #category : #'as yet unclassified' }
AlbTextEditorPharoCodeMode >> classOrMetaClass: aClass [

	
]

{ #category : #'as yet unclassified' }
AlbTextEditorPharoCodeMode >> installOnEditorElement: anEditorElement [

	super installOnEditorElement: anEditorElement.
	anEditorElement viewModel styler: BlRBTextStyler new.
	
]
