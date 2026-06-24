Class {
	#name : #AlbTextEditorOnObjectPrintStringExamples,
	#superclass : #AlbTextEditorExamples,
	#category : #'Album-Examples-Editor'
}

{ #category : #'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> editorOnObjectPrintString [
	<sampleInstance>

	^ self newEditor text: self textObjectPrintString
]

{ #category : #'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> elementOnObjectPrintString [
	<sampleInstance>
	
	^ self newElement editor: self editorOnObjectPrintString
]

{ #category : #'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> textObjectPrintString [
	<sampleInstance>
	
	^ (Object>>#printString) sourceCode asRopedText monospace
]
