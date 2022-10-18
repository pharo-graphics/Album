Class {
	#name : #AlbEditorPharoCodeModel,
	#superclass : #AlbEditorWithSaveTransactionModel,
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbEditorPharoCodeModel >> classOrMetaClass: aClass [

	self styler classOrMetaClass: aClass
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> defaultFontName [

	^ AeFontManager defaultCodeFontFamilyName
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> defaultStyler [

	^ BlRBTextStyler new fontName: self fontName 
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> isForWorkspace: aBoolean [

	self styler isForWorkspace: aBoolean
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> workspace: aWorkspace [

	self styler workspace: aWorkspace
]
