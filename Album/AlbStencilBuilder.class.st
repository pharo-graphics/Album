Class {
	#name : #AlbStencilBuilder,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'executor'
	],
	#category : #'Album-Basic-Stencil'
}

{ #category : #'api - converting' }
AlbStencilBuilder >> asElement [
	"Build a corresponding stencil and ask it to create and return a new element"
	<return: #BlElement>
	
	^ self build asElement
]

{ #category : #'api - converting' }
AlbStencilBuilder >> asStencilBuilder [
	<return: #AlbStencilBuilder>

	^ self
]

{ #category : #'api - converting' }
AlbStencilBuilder >> asStencilBuilder: aStencilBuilderClass [
	<return: #AlbStencilBuilder>

	^ self
]

{ #category : #building }
AlbStencilBuilder >> build [
	<return: #AlbStencil>
	| anExecutor aResult |
	
	anExecutor := executor.
	anExecutor resetArguments.
	self paramsOn: anExecutor.
	aResult := anExecutor execute.
	
	anExecutor resetArguments.
	self reset.
	^ aResult
]

{ #category : #'api - instantiation' }
AlbStencilBuilder >> buildDefault [
	<return: #AlbStencil or: #BlElement>

	^ self subclassResponsibility
]

{ #category : #accessing }
AlbStencilBuilder >> executor: aBrStencilExecutor [
	self
		assert: [ aBrStencilExecutor isNotNil ]
		description: [ 'Executor must not be nil' ].
	
	executor := aBrStencilExecutor
]

{ #category : #initialization }
AlbStencilBuilder >> initialize [
	super initialize.
	
	executor := AlbStencilDefaultExecutor new stencil: self
]

{ #category : #'api - instantiation' }
AlbStencilBuilder >> paramsOn: aStencilExecutor [
]

{ #category : #initialization }
AlbStencilBuilder >> reset [
	"Is called after the #build to de-reference dynamic parameters passed
	by the called of the build"
]

{ #category : #printing }
AlbStencilBuilder >> storeOn: aStream [
	aStream store: executor.
	aStream space.
	aStream nextPutAll: #asStencilBuilder: asString.
	aStream space.
	aStream nextPutAll: self class name.
]
