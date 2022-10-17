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

	^ BlRBTextStyler new.
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> isForWorkspace: aBoolean [

	self styler isForWorkspace: aBoolean
]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> onInstalledIn: anElement [

	super onInstalledIn: anElement.
	"self styler: (BlRBTextStyler new fontName: self defaultFontName)"
]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> onUninstalledIn: anElement [

	super onUninstalledIn: anElement
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> text: aText [
	^ super text: (aText fontName: self defaultFontName)  
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> workspace: aWorkspace [

	self styler workspace: aWorkspace
]
