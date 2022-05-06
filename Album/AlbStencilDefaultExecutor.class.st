Class {
	#name : #AlbStencilDefaultExecutor,
	#superclass : #AlbStencilExecutor,
	#instVars : [
		'stencil'
	],
	#category : #'Album-Attributes-Stencil'
}

{ #category : #'api - running' }
AlbStencilDefaultExecutor >> execute [
	<return: #BlElement>

	^ self stencil buildDefault
]

{ #category : #'api - arguments' }
AlbStencilDefaultExecutor >> push: anArgumentObject [
]

{ #category : #'api - arguments' }
AlbStencilDefaultExecutor >> resetArguments [
]

{ #category : #accessing }
AlbStencilDefaultExecutor >> stencil [
	^ stencil
]

{ #category : #accessing }
AlbStencilDefaultExecutor >> stencil: anObject [
	stencil := anObject
]
