Class {
	#name : #AlbTextEditorOnObjectPrintStringExamples,
	#superclass : #AlbTextEditorExamples,
	#category : #'Album-Examples-Editor'
}

{ #category : #'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> elementOnObjectPrintString [
	<sampleInstance>

	^ self newElement
		text: self textObjectPrintString;
		yourself
]

{ #category : #'example - Object>>#printString' }
AlbTextEditorOnObjectPrintStringExamples >> textObjectPrintString [
	
	^ (Object>>#printString) sourceCode asRopedText monospace
]
