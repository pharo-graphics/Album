Class {
	#name : #AlbStencilExecutor,
	#superclass : #Object,
	#category : #'Album-Basic-Stencil'
}

{ #category : #'api - running' }
AlbStencilExecutor >> execute [
	<return: #BlElement>

	self subclassResponsibility
]

{ #category : #'api - arguments' }
AlbStencilExecutor >> push: anArgumentObject [
	self subclassResponsibility
]

{ #category : #'api - arguments' }
AlbStencilExecutor >> resetArguments [
	self subclassResponsibility
]
