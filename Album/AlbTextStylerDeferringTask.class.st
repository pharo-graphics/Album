"
I defer the styling request until the corresponding editor element is added to the scene graph
"
Class {
	#name : #AlbTextStylerDeferringTask,
	#superclass : #BlTask,
	#instVars : [
		'stylerAsyncStrategy',
		'textEditor',
		'afterBlock'
	],
	#category : #'Album-Editor-Styler'
}

{ #category : #accessing }
AlbTextStylerDeferringTask >> afterBlock [
	^ afterBlock
]

{ #category : #accessing }
AlbTextStylerDeferringTask >> afterBlock: anObject [
	afterBlock := anObject
]

{ #category : #'api - running' }
AlbTextStylerDeferringTask >> run [
	self stylerAsyncStrategy
		isStylingRequested: false.
	self stylerAsyncStrategy
		styleTextInEditorElement: self textEditor
		thenDo: self afterBlock
]

{ #category : #accessing }
AlbTextStylerDeferringTask >> stylerAsyncStrategy [
	^ stylerAsyncStrategy
]

{ #category : #accessing }
AlbTextStylerDeferringTask >> stylerAsyncStrategy: anObject [
	stylerAsyncStrategy := anObject
]

{ #category : #accessing }
AlbTextStylerDeferringTask >> textEditor [
	^ textEditor
]

{ #category : #accessing }
AlbTextStylerDeferringTask >> textEditor: anObject [
	textEditor := anObject
]
