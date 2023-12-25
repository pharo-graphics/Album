Class {
	#name : #AlbTextEditorShortcuts,
	#superclass : #Object,
	#instVars : [
		'shortcuts'
	],
	#category : 'Album-Model'
}

{ #category : #'adding / removing' }
AlbTextEditorShortcuts >> add: aNewEditorShortcut ifAdded: anAddedBlock ifReplaced: aReplacedBlock [
	"I add a new interaction shortcut or replace an existing one for the same combination and evaluate aReplacedBlock if it was the case"

	shortcuts
		at: aNewEditorShortcut combination
		ifPresent: [ :anExistingEditorShortcut |
			shortcuts at: aNewEditorShortcut combination put: aNewEditorShortcut.
			aReplacedBlock value: anExistingEditorShortcut.
			anAddedBlock value: aNewEditorShortcut ]
		ifAbsent: [
			shortcuts at: aNewEditorShortcut combination put: aNewEditorShortcut.
			anAddedBlock value: aNewEditorShortcut ]
]

{ #category : #enumerating }
AlbTextEditorShortcuts >> do: aBlock [
	shortcuts do: aBlock
]

{ #category : #initialization }
AlbTextEditorShortcuts >> initialize [
	super initialize.
	
	shortcuts := Dictionary new
]

{ #category : #copying }
AlbTextEditorShortcuts >> postCopy [
	shortcuts := shortcuts copy
]

{ #category : #'adding / removing' }
AlbTextEditorShortcuts >> remove: anEditorShortcut ifFound: aFoundBlock [
	
	shortcuts
		at: anEditorShortcut combination
		ifPresent: [ :anExistingEditorShortcut |
			anExistingEditorShortcut = anEditorShortcut
				ifTrue: [
					shortcuts removeKey: anEditorShortcut combination.
					aFoundBlock value: anExistingEditorShortcut ] ]
]

{ #category : #'adding / removing' }
AlbTextEditorShortcuts >> removeAllShortcutsAndDo: aFoundBlock [
	| theOldShortcuts |
	
	theOldShortcuts := shortcuts.
	shortcuts := Dictionary new.
	theOldShortcuts valuesDo: aFoundBlock
]
