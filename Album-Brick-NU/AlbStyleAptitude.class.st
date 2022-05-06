Class {
	#name : #AlbStyleAptitude,
	#superclass : #AlbAptitude,
	#traits : 'TBlElementStyles + TBlElementQuery',
	#classTraits : 'TBlElementStyles classTrait + TBlElementQuery classTrait',
	#instVars : [
		'styles',
		'target'
	],
	#category : #'Album-Brick-NU-Styles'
}

{ #category : #'private - adding' }
AlbStyleAptitude >> basicAddStyle: aStyle [
	styles basicAddStyle: aStyle
]

{ #category : #'private - adding' }
AlbStyleAptitude >> for: aTargetObject [
	^ styles for: aTargetObject
]

{ #category : #initialization }
AlbStyleAptitude >> initialize [
	super initialize.

	styles := BlStyles new.

	"empty selector, means we apply it on the widget itself"
	target := BlElementLazyQuery new.

	self addChange:
		(AlbLookChange new
			up: [ :thisLook | self halt.
				target isEmpty
					ifFalse: [ styles := styles asForwarded: target ].
				thisLook widget styles addStyles: styles styles ];
			down: [ :thisLook | thisLook widget styles removeStyles: styles styles ];
			yourself)
]

{ #category : #initialization }
AlbStyleAptitude >> propagateStylesToWidget [
	"Call me if this look is updated after its creation"

	self widgetDo: [ :aWidget |
		aWidget styles addStyles: styles styles.
		aWidget requestStyle ]
]

{ #category : #accessing }
AlbStyleAptitude >> queryStep: aBlElementStep [
	target queryStep: aBlElementStep
]

{ #category : #accessing }
AlbStyleAptitude >> state [
	^ BlElementState
]

{ #category : #'private - adding' }
AlbStyleAptitude >> styleForState: aState ifFound: aFoundBlock ifNone: aNoneBlock [
	^ styles
		styleForState: aState
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'private - adding' }
AlbStyleAptitude >> when: aStateBlock style: aStyleBlock [
	| aTargetState |
	
	aTargetState := aStateBlock glamourValueWithArgs: { self state }.
	aStyleBlock value: (self styleFor: aTargetState)
]
