Class {
	#name : #AlbEditorPharoCodeModel,
	#superclass : #AlbEditorModel,
	#instVars : [
		'stylerHolder'
	],
	#category : #'Album-Model'
}

{ #category : #accessing }
AlbEditorPharoCodeModel >> classOrMetaClass: aClass [

	self stylerHolder classOrMetaClass: aClass
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> defaultFontName [

	^ AeFontManager defaultCodeFontFamilyName
	
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> defaultStyler [
self fontName traceCr.
	^ BlRBTextStyler new fontName: self fontName 
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> fontName: aFontName [

	super fontName: aFontName.
	self stylerHolder fontName: aFontName 
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> isForWorkspace: aBoolean [

	self stylerHolder isForWorkspace: aBoolean
]

{ #category : #'text style' }
AlbEditorPharoCodeModel >> launchTextStyle [

	" ask the stylerHolder through its observale slot "
	self stylerHolder unstyledText: self text 
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> modeChanged [

	super modeChanged.
	self stylerHolder styler: self defaultStyler.
	self launchTextStyle 

]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> onInstalledIn: anElement [

	"Is sent when I am added to an element "

	super onInstalledIn: anElement.

	stylerHolder := AlbStylerHolder new
		                referentElement: anElement;
		                styler: self defaultStyler;
		                yourself.
	
	stylerHolder whenStyledTextChangedDo: [ :styledText | 
		self text takeInternalRepresentationOf: styledText.
		self withEditorElementDo: [ :element | element textInternalRepresentationChanged ] ].


]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> onUninstalledIn: anElement [

	"Is sent when I am added to an element "

	super onUninstalledIn: anElement.
	stylerHolder terminate.
	stylerHolder := nil
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> stylerHolder [

	^ stylerHolder
]

{ #category : #initialization }
AlbEditorPharoCodeModel >> textChanged [

	super textChanged.
	" ask the stylerClient to style through its observal slot"
	self launchTextStyle 

]

{ #category : #'api - hooks' }
AlbEditorPharoCodeModel >> textModifiedByTextEditor [

	super textModifiedByTextEditor.
	self launchTextStyle
]

{ #category : #accessing }
AlbEditorPharoCodeModel >> workspace: aWorkspace [

	self stylerHolder workspace: aWorkspace
]
