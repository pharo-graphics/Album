Class {
	#name : #AlbTextEditorCommand,
	#superclass : #Object,
	#traits : 'TBlDebug',
	#classTraits : 'TBlDebug classTrait',
	#instVars : [
		'context'
	],
	#category : #'Album-Editor-Commands'
}

{ #category : #accessing }
AlbTextEditorCommand >> context [
	^ context
]

{ #category : #accessing }
AlbTextEditorCommand >> context: anObject [
	context := anObject
]

{ #category : #executing }
AlbTextEditorCommand >> executeOn: aTextEditor [
	self subclassResponsibility
]

{ #category : #accessing }
AlbTextEditorCommand >> telemetry [
	<return: #BlTelemetry>

	^ self context
		ifNil: [ BlNullTelemetry uniqueInstance ]
		ifNotNil: [ :aContext | aContext telemetry ]
]
