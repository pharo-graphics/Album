Class {
	#name : #AlbStencilDynamicExecutor,
	#superclass : #AlbStencilExecutor,
	#instVars : [
		'valuable'
	],
	#category : #'Album-Attributes-Stencil'
}

{ #category : #running }
AlbStencilDynamicExecutor >> execute: aCollectionOfArguments [
	self subclassResponsibility
]
