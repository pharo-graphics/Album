Class {
	#name : #AlbEditorPharoCodeModel,
	#superclass : #AlbEditorCodeModel,
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

	^ BlRBTextStyler new.
]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> onInstalledIn: anElement [

	super onInstalledIn: anElement.
	self styler: (BlRBTextStyler new fontName: self defaultFontName)
]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> onUninstalledIn: anElement [

	super onUninstalledIn: anElement.
	self styler: nil
]
