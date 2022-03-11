Class {
	#name : #AlbRequest,
	#superclass : #BlEvent,
	#instVars : [
		'response',
		'isOneWay'
	],
	#category : #'Album-Brick-Core-Events'
}

{ #category : #'instance creation' }
AlbRequest class >> oneWay [
	^ self new oneWay
]

{ #category : #testing }
AlbRequest >> canRespond [
	"Not all requests support responses, return true if I am one of them"
	<return: #Boolean>

	^ self responseClass = AlbNoResponse
]

{ #category : #initialization }
AlbRequest >> initialize [
	super initialize.
	
	response := self responseClass new.
	isOneWay := false.
	self canBePropagated: true
]

{ #category : #testing }
AlbRequest >> isOneWay [
	^ isOneWay
]

{ #category : #accessing }
AlbRequest >> oneWay [
	isOneWay := true
]

{ #category : #accessing }
AlbRequest >> response [
	^ response
]

{ #category : #accessing }
AlbRequest >> response: anObject [
	response := anObject
]

{ #category : #initialization }
AlbRequest >> responseClass [
	<return: #'AlbResponse class'>

	^ BrNoResponse
]

{ #category : #accessing }
AlbRequest >> responseFor: aWidgetModel [
	^ self response
]
