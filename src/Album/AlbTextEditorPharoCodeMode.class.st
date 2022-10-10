Class {
	#name : #AlbTextEditorPharoCodeMode,
	#superclass : #AlbTextEditorMode,
	#instVars : [
		'defaultFontName'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbTextEditorPharoCodeMode >> defaultFontName [
	^ defaultFontName
]

{ #category : #accessing }
AlbTextEditorPharoCodeMode >> defaultFontName: aString [
	defaultFontName := aString
]

{ #category : #initialization }
AlbTextEditorPharoCodeMode >> initialize [
	super initialize.
	defaultFontName := AeFontManager defaultCodeFontFamilyName
]

{ #category : #'api - hooks' }
AlbTextEditorPharoCodeMode >> installOnEditorElement: anEditorElement [

	super installOnEditorElement: anEditorElement.
	anEditorElement viewModel styler: (BlRBTextStyler new fontName: self defaultFontName)
]
