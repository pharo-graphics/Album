Class {
	#name : #OBlRequest,
	#superclass : #BlEvent,
	#instVars : [
		'response',
		'isOneWay'
	],
	#category : #'Album-Brick-NU'
}

{ #category : #'instance creation' }
OBlRequest class >> oneWay [
	^ self new oneWay
]

{ #category : #testing }
OBlRequest >> canRespond [
	"Not all requests support responses, return true if I am one of them"
	<return: #Boolean>

	^ self responseClass = OBlNoResponse
]

{ #category : #initialization }
OBlRequest >> initialize [
	super initialize.
	
	response := self responseClass new.
	isOneWay := false.
	self canBePropagated: true
]

{ #category : #testing }
OBlRequest >> isOneWay [
	^ isOneWay
]

{ #category : #accessing }
OBlRequest >> oneWay [
	isOneWay := true
]

{ #category : #accessing }
OBlRequest >> response [
	^ response
]

{ #category : #accessing }
OBlRequest >> response: anObject [
	response := anObject
]

{ #category : #initialization }
OBlRequest >> responseClass [
	<return: #'AlbResponse class'>

	^ OBlNoResponse
]

{ #category : #accessing }
OBlRequest >> responseFor: aWidgetModel [
	^ self response
]
