Class {
	#name : #AlbTriangle,
	#superclass : #BlElement,
	#traits : 'TBrExpandable + TBrEnableable + TBrSizeAdjustable',
	#classTraits : 'TBrExpandable classTrait + TBrEnableable classTrait + TBrSizeAdjustable classTrait',
	#category : #'Album-Triangle-UI'
}

{ #category : #'api - actions' }
AlbTriangle >> action: aBlock [
	"do no handle expand and collapse actions"
	self viewModel action: aBlock
]

{ #category : #'api - expandable' }
AlbTriangle >> collapse [
	self states addState: BrCollapsedState uniqueInstance
]

{ #category : #'api - expandable' }
AlbTriangle >> expand [
	self states addState: BrExpandedState uniqueInstance
]

{ #category : #'api - visibility' }
AlbTriangle >> hide [
	self visibility: BlVisibility hidden
]

{ #category : #'api - visibility' }
AlbTriangle >> hide: aBoolean [
	aBoolean 
		ifTrue: [ self hide ] 
		ifFalse: [ self show ]
]

{ #category : #initialization }
AlbTriangle >> initialize [
	super initialize.
	
	self viewModel: BrButtonModel new.
	self action: [ self toggleExpanded ]
]

{ #category : #'api - expandable' }
AlbTriangle >> isExpanded [
	"Return true if an widget is expanded (has expanded state), false otherwise"
	<return: #Boolean>

	^ self states hasState: BrExpandedState uniqueInstance
]

{ #category : #'api - visibility' }
AlbTriangle >> show [
	self visibility: BlVisibility visible
]

{ #category : #'api - actions' }
AlbTriangle >> toggleAction: aBlock [
	"toggle triangle and then evaluate the block"

	self viewModel action: [ :aWidget :aButtonModel :anEvent |
		self toggleExpanded.
		aBlock glamourValueWithArgs: {
			aWidget.
			aButtonModel.
			anEvent
		} ]
]
