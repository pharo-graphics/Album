Class {
	#name : 'AlbTextEditorOnObjectPrintStringExamples',
	#superclass : 'AlbTextEditorExamples',
	#category : 'Album-Examples-Editor',
	#package : 'Album-Examples',
	#tag : 'Editor'
}

{ #category : 'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> editorOnObjectPrintString [
	<gtExample>

	^ self newEditor text: self textObjectPrintString
]

{ #category : 'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> elementOnObjectPrintString [
	<gtExample>
	
	^ self newElement editor: self editorOnObjectPrintString
]

{ #category : 'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> textObjectPrintString [
	<gtExample>
	
	^ (Object>>#printString) sourceCode asRopedText monospace
]
