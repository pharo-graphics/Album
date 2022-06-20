Extension { #name : #TBlTextStyleable }

{ #category : #'*Album' }
TBlTextStyleable >> appendingAdornment: aBrTextAdornmentStencilBuilder [
	"Append a visual element defined by a given stencil builder right after a text on which I am applied.
	A stencil builder can also be a block in the following form:
	[ :aTBrTextEditorTextualPiece :anEditorElement | ] - where aText represents a piece of text after which an element should be append"

	self attributesBuilder attribute: (BrTextAdornmentDynamicAttribute new
		beAppend;
		stencil: aBrTextAdornmentStencilBuilder)
]

{ #category : #'*Album' }
TBlTextStyleable >> hideText [
	"Visually replace a piece of text with a repeating aCharacter"

	self attributesBuilder attribute: BrTextHideAttribute new
]

{ #category : #'*Album' }
TBlTextStyleable >> lineSpacing: aNumber [
	self attributesBuilder attribute: (BrTextParagraphLineSpacingAttribute lineSpacing: aNumber)
]

{ #category : #'*Album' }
TBlTextStyleable >> onClick: aClickAction [
	"Perform actions when a user clicks on a piece of text.
	The click action is a block in the following form: [ :aTBrTextEditorTextualPiece :aWorldElement :anEditorElement :anEvent | ]"

	self attributesBuilder attribute: (BrTextClickAttribute new action: aClickAction)
]

{ #category : #'*Album' }
TBlTextStyleable >> onCursorEnter: anEnterAction leave: aLeaveAction [
	"Perform actions when a cursor enters and leaves a piece of text.
	The enter action is a block in the following form: [ :aTextEditor :aBrTextEditorCursorAddedEvent :anAttributeStart :anAttributeEnd | ]
	The leave action is a block in the following form: [ :aTextEditor :aBrTextEditorCursorRemovedEvent :anAttributeStart :anAttributeEnd | ]"

	self attributesBuilder attribute: (BrTextCursorAttribute new
			enterAction: anEnterAction;
			leaveAction: aLeaveAction)
]

{ #category : #'*Album' }
TBlTextStyleable >> paragraphMargin: anInsets [
	self attributesBuilder attribute: (BrTextParagraphMarginAttribute paragraphMargin: anInsets)
]

{ #category : #'*Album' }
TBlTextStyleable >> replacingAdornment: aBrTextAdornmentStencilBuilder [
	"Visually replace a piece of text with an element defined by a given stencil builder.
	A stencil builder can also be a block in the following form:
	[ :aTBrTextEditorTextualPiece :anEditorElement | ] - where aText represents a piece of text that should be replaced"

	self attributesBuilder attribute: (BrTextAdornmentDynamicAttribute new
		beReplace;
		stencil: aBrTextAdornmentStencilBuilder)
]

{ #category : #'*Album' }
TBlTextStyleable >> replacingText: aCharacter [
	"Visually replace a piece of text with a repeating aCharacter"

	self attributesBuilder attribute: (BrTextReplacingAttribute new withCharacter: aCharacter)
]

{ #category : #'*Album' }
TBlTextStyleable >> roundedBackground: aPaint [
	self attributesBuilder attribute: (BrTextEmbellishmentAttribute new roundedBackground: aPaint)
]

{ #category : #'*Album' }
TBlTextStyleable >> wordPadding: anInsets [
	self attributesBuilder attribute: (BrTextParagraphWordPaddingAttribute wordPadding: anInsets)
]
