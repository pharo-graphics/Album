Class {
	#name : #AlbStencilDynamicExecutor,
	#superclass : #AlbStencilExecutor,
	#instVars : [
		'valuable'
	],
	#category : #'Album-Basic-Stencil'
}

{ #category : #running }
AlbStencilDynamicExecutor >> execute: aCollectionOfArguments [
	self subclassResponsibility
]
