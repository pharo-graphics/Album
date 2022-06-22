Class {
	#name : #AlbBlinkAnimation,
	#superclass : #BlAnimation,
	#instVars : [
		'background',
		'lastTime'
	],
	#category : #'Album-UI-Stencils'
}

{ #category : #initialization }
AlbBlinkAnimation >> defaultBlinkingDelay [
	"in ms"
	^600
]

{ #category : #'api - running' }
AlbBlinkAnimation >> doStep [

	| now |
	now := DateAndTime now.
	(now - lastTime) asMilliSeconds >= self defaultBlinkingDelay ifFalse: [ ^ self ].
	lastTime := now.
	background := background = self target parent background
		              ifTrue: [ Color red ]
		              ifFalse: [ self target parent background ].
	self target background: background
]

{ #category : #initialization }
AlbBlinkAnimation >> initialize [ 
	super initialize.
	lastTime := DateAndTime now.
	self beInfinite 
]

{ #category : #'api - running' }
AlbBlinkAnimation >> run [
	"workaround: cursors are added then removed many times while editing. Thus, blinking animation is not robust. Many situations can lead to stopping it while #doStep is executing especially when editing a big file. "
	[ super run ]
		on: Error
		do: [ self stop ]
]

{ #category : #accessing }
AlbBlinkAnimation >> target: aBlElement [
	super target: aBlElement.
	background := self target background
]
