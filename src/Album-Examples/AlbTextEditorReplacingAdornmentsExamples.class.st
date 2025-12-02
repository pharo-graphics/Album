"
### Replacing adornmens

`testSingleLineTextWithReplacementAll` replaces the whole text with a gray circle. It can be achieved by sending `BlText>>#replacingAdornment:` to an instance of the `BlText`.
 


```
to convert to microdown

By scoping a text using ${method:BlText>>#from:to:}$ we can replace any arbitrary piece of text with a visual element. For example the first word: ${example:AlbTextEditorReplacingAdornmentsExamples>>#singleLineTextWithReplacementFirst|previewShow=#gtTextFor:|previewHeight=40|previewExpanded}$

Or a word in the middle of a sentence: ${example:AlbTextEditorReplacingAdornmentsExamples>>#singleLineTextWithReplacementMiddle|previewShow=#gtTextFor:|previewHeight=40|noCode}$

Or even the last word in the same sentence: ${example:AlbTextEditorReplacingAdornmentsExamples>>#singleLineTextWithReplacementLast|previewShow=#gtTextFor:|previewHeight=40|noCode}$

Replacement attributes can also stack up if applied on the same piece of text. In this case the order of added elements is defined by the order in which replacement attributes are added: ${example:AlbTextEditorReplacingAdornmentsExamples>>#singleLineTextWithMultipleReplacementsOnTopEachOther|previewShow=#gtTextFor:|previewHeight=40|previewExpanded}$

They can also overlapp. In this case attributes that end first take precedence over attributes whose end index is larger and so the elements that they add: ${example:AlbTextEditorReplacingAdornmentsExamples>>#singleLineTextWithMultipleOverlappingReplacements|previewShow=#gtTextFor:|previewHeight=40|previewExpanded}$
```


"
Class {
	#name : #AlbTextEditorReplacingAdornmentsExamples,
	#superclass : #TestCase,
	#category : #'Album-Examples-Documentation'
}

{ #category : #public }
AlbTextEditorReplacingAdornmentsExamples >> testChangingForeground [
	
	| text |
	self skip.
	"we should close the space"
	
	text := 'Hello World
- click here
- second item' asRopedText fontSize: 20.

	(text from: 13 to: 24)
		onCursorEnter: [ :aTextEditor :anEvent :aFromIndex :aToIndex |
			(aTextEditor text from: aFromIndex to: aToIndex) foreground: Color red ]
		leave: [ :aTextEditor :anEvent :aFromIndex :aToIndex |
			(aTextEditor text from: aFromIndex to: aToIndex) foreground: Color blue ].

	^ text onAlbum openInSpace 
]

{ #category : #tests }
AlbTextEditorReplacingAdornmentsExamples >> testSingleLineTextWithMultipleOverlappingReplacements [
	"Multiple replacements can overlapp. In this case the order of the added elements is defined by the end index of the intervals of the attributes"
	
	| aText |
	self skip. 
	"we should make sure that we close the space after."
	aText := 'The Earth is round' asRopedText.
	(aText from: 1 to: 7)
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color blue ].
	(aText from: 5 to: 9)
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color red ].

	^ (AlbEditorElement new text: aText) openInSpace 
]

{ #category : #'examples - replacements' }
AlbTextEditorReplacingAdornmentsExamples >> testSingleLineTextWithMultipleReplacementsOnTopEachOther [
	"Multiple replacements can stack up. The order of added elements is defined by the order in which the attributes are added"
	
	| aText |
	self skip. 
	"we should make sure that we close the space after."
	aText := 'The Earth is round' asRopedText.
	(aText from: 5 to: 9)
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color red ];
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color blue ].

	^ aText onAlbum openInSpace 
]

{ #category : #'examples - replacements' }
AlbTextEditorReplacingAdornmentsExamples >> testSingleLineTextWithReplacementAll [
	"Even the whole line of text can be replaced"
	
	| aText |
	self skip. 
	"we should make sure that we close the space after."
	aText := 'To be replaced' asRopedText
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color gray ].

	^ aText onAlbum openInSpace 
]

{ #category : #'examples - replacements' }
AlbTextEditorReplacingAdornmentsExamples >> testSingleLineTextWithReplacementFirst [
	"We can replace the first word in a sentence"
	
	| aText |
	self skip. 
	"we should make sure that we close the space after."
	aText := 'The Earth is round' asRopedText.
	(aText from: 1 to: 3)
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color blue ].
			
	^ aText onAlbum openInSpace 
]

{ #category : #'examples - replacements' }
AlbTextEditorReplacingAdornmentsExamples >> testSingleLineTextWithReplacementLast [
	"We can replace the last word in a sentence"
	
	| aText |
	self skip. 
	"we should make sure that we close the space after."
	aText := 'The Earth is round' asRopedText.
	(aText from: 14 to: 18)
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color gray ].
			
	^ aText onAlbum openInSpace 
]

{ #category : #'examples - replacements' }
AlbTextEditorReplacingAdornmentsExamples >> testSingleLineTextWithReplacementMiddle [
	"We can replace a word in the middle of a sentence"
	
	| aText |
	self skip. 
	"we should make sure that we close the space after."
	
	aText := 'The Earth is round' asRopedText.
	(aText from: 5 to: 9)
		replacingAdornment: [
			BlElement new
				geometry: BlEllipseGeometry new;
				extent: 20@20;
				background: Color red ].

	^ aText onAlbum openInSpace 
]
