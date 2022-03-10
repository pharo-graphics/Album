Class {
	#name : #AlbDefaultTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'link',
		'status',
		'default',
		'editor',
		'button',
		'item',
		'header'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultTheme >> button [
	^ button
]

{ #category : #accessing }
AlbDefaultTheme >> button: anObject [
	button := anObject
]

{ #category : #accessing }
AlbDefaultTheme >> default [
	^ default
]

{ #category : #accessing }
AlbDefaultTheme >> default: anObject [
	default := anObject
]

{ #category : #accessing }
AlbDefaultTheme >> editor [
	^ editor
]

{ #category : #accessing }
AlbDefaultTheme >> editor: anObject [
	editor := anObject
]

{ #category : #accessing }
AlbDefaultTheme >> header [
	^ header
]

{ #category : #accessing }
AlbDefaultTheme >> header: anObject [
	header := anObject
]

{ #category : #initialization }
AlbDefaultTheme >> initialize [
	super initialize.
	link := AlbDefaultLinkTheme new.
	status := AlbDefaultStatusTheme new.
	default := AlbDefaultDefaultTheme new.
	editor := AlbDefaultEditorTheme new.
	button := AlbDefaultButtonTheme new.
	item := AlbDefaultItemTheme new.
	header := AlbDefaultHeaderTheme new
]

{ #category : #accessing }
AlbDefaultTheme >> item [
	^ item
]

{ #category : #accessing }
AlbDefaultTheme >> item: anObject [
	item := anObject
]

{ #category : #accessing }
AlbDefaultTheme >> link [
	^ link
]

{ #category : #accessing }
AlbDefaultTheme >> link: anObject [
	link := anObject
]

{ #category : #accessing }
AlbDefaultTheme >> status [
	^ status
]

{ #category : #accessing }
AlbDefaultTheme >> status: anObject [
	status := anObject
]
