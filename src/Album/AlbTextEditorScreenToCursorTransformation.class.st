Class {
	#name : 'AlbTextEditorScreenToCursorTransformation',
	#superclass : 'Object',
	#instVars : [
		'resultBlock',
		'resultIndex'
	],
	#category : 'Album-Model-Cursor',
	#package : 'Album',
	#tag : 'Model-Cursor'
}

{ #category : 'dispatching' }
AlbTextEditorScreenToCursorTransformation >> evaluateOn: anObject [
	self subclassResponsibility
]

{ #category : 'dispatching' }
AlbTextEditorScreenToCursorTransformation >> evaluateOn: anObject for: anEvent [
	self subclassResponsibility
]

{ #category : 'testing' }
AlbTextEditorScreenToCursorTransformation >> hasResult [
	^ resultIndex isNotNil
]

{ #category : 'accessing' }
AlbTextEditorScreenToCursorTransformation >> transformed: aTextIndex [
	resultIndex := aTextIndex.
	resultBlock value: aTextIndex
]

{ #category : 'accessing' }
AlbTextEditorScreenToCursorTransformation >> whenTransformed: aBlock [
	resultBlock := aBlock
]
