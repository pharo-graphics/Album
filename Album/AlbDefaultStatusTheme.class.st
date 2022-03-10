Class {
	#name : #AlbDefaultStatusTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'successBackgroundColor',
		'successBorderColor',
		'neutralBackgroundColor',
		'errorBorderColor',
		'errorBackgroundColor',
		'failureBorderColor',
		'paleErrorBackgroundColor',
		'failureBackgroundColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultStatusTheme >> errorBackgroundColor [
	^ errorBackgroundColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> errorBackgroundColor: anObject [
	errorBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultStatusTheme >> errorBorderColor [
	^ errorBorderColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> errorBorderColor: anObject [
	errorBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultStatusTheme >> failureBackgroundColor [
	^ failureBackgroundColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> failureBackgroundColor: anObject [
	failureBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultStatusTheme >> failureBorderColor [
	^ failureBorderColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> failureBorderColor: anObject [
	failureBorderColor := anObject
]

{ #category : #initialization }
AlbDefaultStatusTheme >> initialize [
	super initialize.
	successBackgroundColor := AlbDefaultColors successBackgroundColor.
	successBorderColor := AlbDefaultColors successBorderColor.
	neutralBackgroundColor := AlbDefaultColors neutralBackgroundColor.
	errorBorderColor := AlbDefaultColors errorBorderColor.
	errorBackgroundColor := AlbDefaultColors errorBackgroundColor.
	failureBorderColor := AlbDefaultColors failureBorderColor.
	paleErrorBackgroundColor := AlbDefaultColors
		paleErrorBackgroundColor.
	failureBackgroundColor := AlbDefaultColors failureBackgroundColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> neutralBackgroundColor [
	^ neutralBackgroundColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> neutralBackgroundColor: anObject [
	neutralBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultStatusTheme >> paleErrorBackgroundColor [
	^ paleErrorBackgroundColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> paleErrorBackgroundColor: anObject [
	paleErrorBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultStatusTheme >> successBackgroundColor [
	^ successBackgroundColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> successBackgroundColor: anObject [
	successBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultStatusTheme >> successBorderColor [
	^ successBorderColor
]

{ #category : #accessing }
AlbDefaultStatusTheme >> successBorderColor: anObject [
	successBorderColor := anObject
]
