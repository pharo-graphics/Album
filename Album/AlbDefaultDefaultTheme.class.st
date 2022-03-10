Class {
	#name : #AlbDefaultDefaultTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'defaultShadowColor',
		'backdropColor',
		'primaryBorderColor',
		'darkBorderColor',
		'distinctTenStrongColors',
		'newsBackgroundColor',
		'lightBorderColor',
		'expandCollapseTriangleBackgroundColor',
		'shadowColor',
		'distinctTenLightColors',
		'contentBackgroundColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultDefaultTheme >> backdropColor [
	^ backdropColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> backdropColor: anObject [
	backdropColor := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> contentBackgroundColor [
	^ contentBackgroundColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> contentBackgroundColor: aColor [
	contentBackgroundColor := aColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> darkBorderColor [
	^ darkBorderColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> darkBorderColor: anObject [
	darkBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> defaultShadowColor [
	^ defaultShadowColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> defaultShadowColor: anObject [
	defaultShadowColor := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> distinctTenLightColors [
	^ distinctTenLightColors
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> distinctTenLightColors: anObject [
	distinctTenLightColors := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> distinctTenStrongColors [
	^ distinctTenStrongColors
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> distinctTenStrongColors: anObject [
	distinctTenStrongColors := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> expandCollapseTriangleBackgroundColor [
	^ expandCollapseTriangleBackgroundColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> expandCollapseTriangleBackgroundColor: anObject [
	expandCollapseTriangleBackgroundColor := anObject
]

{ #category : #initialization }
AlbDefaultDefaultTheme >> initialize [
	super initialize.
	contentBackgroundColor := Color white.
	defaultShadowColor := AlbDefaultColors defaultShadowColor.
	backdropColor := AlbDefaultColors backdropColor.
	primaryBorderColor := AlbDefaultColors primaryBorderColor.
	darkBorderColor := AlbDefaultColors darkBorderColor.
	distinctTenStrongColors := AlbDefaultColors distinctTenStrongColors.
	newsBackgroundColor := AlbDefaultColors newsBackgroundColor.
	lightBorderColor := AlbDefaultColors lightBorderColor.
	expandCollapseTriangleBackgroundColor := AlbDefaultColors
		expandCollapseTriangleBackgroundColor.
	shadowColor := AlbDefaultColors shadowColor.
	distinctTenLightColors := AlbDefaultColors distinctTenLightColors
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> lightBorderColor [
	^ lightBorderColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> lightBorderColor: anObject [
	lightBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> newsBackgroundColor [
	^ newsBackgroundColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> newsBackgroundColor: anObject [
	newsBackgroundColor := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> primaryBorderColor [
	^ primaryBorderColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> primaryBorderColor: anObject [
	primaryBorderColor := anObject
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> shadowColor [
	^ shadowColor
]

{ #category : #accessing }
AlbDefaultDefaultTheme >> shadowColor: anObject [
	shadowColor := anObject
]
