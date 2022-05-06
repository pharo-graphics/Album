Class {
	#name : #AlbStencilValuableExecutor,
	#superclass : #AlbStencilExecutor,
	#instVars : [
		'valuable',
		'arguments'
	],
	#category : #'Album-Attributes-Stencil'
}

{ #category : #'instance creation' }
AlbStencilValuableExecutor class >> from: aValuable [
	<return: #AlbStencilValuableExecutor>

	^ self new valuable: aValuable
]

{ #category : #accessing }
AlbStencilValuableExecutor >> arguments [
	<return: #Collection of: #Object>

	^ arguments
]

{ #category : #'api - running' }
AlbStencilValuableExecutor >> execute [
	<return: #BlElement>

	^ self valuable glamourValueWithArgs: self arguments
]

{ #category : #initialization }
AlbStencilValuableExecutor >> initialize [
	super initialize.
	
	arguments := LinkedList new
]

{ #category : #'api - arguments' }
AlbStencilValuableExecutor >> push: anArgumentObject [
	arguments add: anArgumentObject
]

{ #category : #'api - arguments' }
AlbStencilValuableExecutor >> resetArguments [
	arguments removeAll
]

{ #category : #printing }
AlbStencilValuableExecutor >> storeOn: aStream [
	valuable isBlock
		ifTrue: [ aStream nextPutAll: valuable asString ]
		ifFalse: [ aStream nextPutAll: '[  ]' ]
]

{ #category : #accessing }
AlbStencilValuableExecutor >> valuable [
	^ valuable
]

{ #category : #accessing }
AlbStencilValuableExecutor >> valuable: anObject [
	valuable := anObject
]
