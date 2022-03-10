Class {
	#name : #AlbDefaultEditorTheme,
	#superclass : #AlbTheme,
	#instVars : [
		'borderColor',
		'focusedBorderColor'
	],
	#category : #'Album-Theme-Default'
}

{ #category : #accessing }
AlbDefaultEditorTheme >> borderColor [
	^ borderColor
]

{ #category : #accessing }
AlbDefaultEditorTheme >> borderColor: anObject [
	borderColor := anObject
]

{ #category : #accessing }
AlbDefaultEditorTheme >> focusedBorderColor [
	^ focusedBorderColor
]

{ #category : #accessing }
AlbDefaultEditorTheme >> focusedBorderColor: anObject [
	focusedBorderColor := anObject
]

{ #category : #initialization }
AlbDefaultEditorTheme >> initialize [
	super initialize.
	borderColor := AlbDefaultColors editorBorderColor.
	focusedBorderColor := AlbDefaultColors focusedEditorBorderColor
]
