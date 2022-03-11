Class {
	#name : #AlbBenchmarkStyler,
	#superclass : #BlTextStyler,
	#instVars : [
		'duration'
	],
	#category : #'Album-Styler'
}

{ #category : #accessing }
AlbBenchmarkStyler >> duration [
	^ duration
]

{ #category : #accessing }
AlbBenchmarkStyler >> duration: anObject [
	duration := anObject
]

{ #category : #initialization }
AlbBenchmarkStyler >> initialize [
	super initialize.

	duration := 100 milliSeconds
]

{ #category : #private }
AlbBenchmarkStyler >> privateStyle: aText [ 
	<return: #BlText>
	| aStartTime anEndTime |
	
	aStartTime := DateAndTime now.
	anEndTime := aStartTime + duration.

	[ DateAndTime now < anEndTime ] whileTrue: [
		| aString |
		1000 factorial.
		Smalltalk allClasses collect: #name.
		aString := String loremIpsum: 20000.
		aString includesSubstring: ((String loremIpsum: 20000) copyFrom: 1050 to: 1100) ].
	
	aText foreground: Color random.
	^ aText
]
