"
I am a special type of stencil whose `=#create`= method can be dynamically defined with the help of a valuable object.

To get a Statefull version of the Stencil users can provide a collection of `=#arguments`= that will be passed to the valuable in the same order as in argument collection.

"
Class {
	#name : #AlbValuableStencil,
	#superclass : #AlbStencil,
	#instVars : [
		'valuable',
		'arguments'
	],
	#category : #'Album-Attributes-Stencil'
}

{ #category : #'instance creation' }
AlbValuableStencil class >> from: aValuable [
	<return: #AlbStencil>

	^ self new valuable: aValuable
]

{ #category : #accessing }
AlbValuableStencil >> arguments [
	<return: #Collection of: #Object>

	^ arguments
]

{ #category : #accessing }
AlbValuableStencil >> arguments: aCollectionOfObjects [
	arguments := aCollectionOfObjects
]

{ #category : #'api - instantiation' }
AlbValuableStencil >> create [
	<return: #Object>
	
	^ self valuable glamourValueWithArgs: self arguments
]

{ #category : #accessing }
AlbValuableStencil >> valuable [
	^ valuable
]

{ #category : #accessing }
AlbValuableStencil >> valuable: anObject [
	valuable := anObject
]
