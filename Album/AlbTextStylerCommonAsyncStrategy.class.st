"
I am an abstract text styler strategy used by ${class:AlbTextEditor}$.
My concrete subclass strategies should style text in a background process.
The common styling logic, that should be executed in the background process is implemented in ${method:AlbTextStylerCommonAsyncStrategy>>#doStyle:afterDo:}$ and should be called from concete 
The subclasses should implement ${method:AlbTextStylerStrategy>>#style:afterDo:}$ implementations.

See ${class:AlbTextStylerStrategy}$ for futher explanation.

See my subclasses for concrete async strategies: ${class:AlbTextStylerCommonAsyncStrategy|expanded=true|show=gtSubclassesFor:}$

"
Class {
	#name : #AlbTextStylerCommonAsyncStrategy,
	#superclass : #AlbTextStylerStrategy,
	#instVars : [
		'monitor',
		'isStylingRequested'
	],
	#category : #'Album-Styler'
}

{ #category : #testing }
AlbTextStylerCommonAsyncStrategy class >> isAbstract [
	^ self name = #AlbTextStylerCommonAsyncStrategy 
]

{ #category : #'mutual exclusion' }
AlbTextStylerCommonAsyncStrategy >> critical: aBlock [
	monitor critical: aBlock
]

{ #category : #initialization }
AlbTextStylerCommonAsyncStrategy >> initialize [
	super initialize.

	monitor := Monitor new.
	isStylingRequested := false
]

{ #category : #accessing }
AlbTextStylerCommonAsyncStrategy >> isStylingRequested [
	^ isStylingRequested
]

{ #category : #accessing }
AlbTextStylerCommonAsyncStrategy >> isStylingRequested: aBoolean [
	isStylingRequested := aBoolean
]

{ #category : #private }
AlbTextStylerCommonAsyncStrategy >> scheduleStyleTextInEditorElement: aEditorElement thenDo: aBlock [
	self subclassResponsibility
]

{ #category : #styling }
AlbTextStylerCommonAsyncStrategy >> styleTextInEditorElement: aEditorElement thenDo: aBlock [

	monitor critical: [ 
		self isStylingRequested ifTrue: [ ^ self ].

		aEditorElement isAttachedToSceneGraph
			ifTrue: [ 
				self
					scheduleStyleTextInEditorElement: aEditorElement
					thenDo: aBlock ]
			ifFalse: [ 
				self isStylingRequested: true.
				"othrewise we should defer the styling until some time in the future when the element appears in the scene"
				aEditorElement enqueueTask: (AlbTextStylerDeferringTask new
						 stylerAsyncStrategy: self;
						 textEditor: aEditorElement;
						 afterBlock: aBlock) ]
		"if the editor is already attached to the scene graph we can style it directly" ]
]
