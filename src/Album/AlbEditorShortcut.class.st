Class {
	#name : #AlbEditorShortcut,
	#superclass : #BlBasicShortcut,
	#category : #'Album-Shortcuts'
}

{ #category : #evaluation }
AlbEditorShortcut >> performDueTo: aShortcutEvent [

	"we consume shortcut event before evaluating a custom action in order to give subclasses a chance to not consume the event"
	aShortcutEvent consumed: true.

	self
		performOnEditor: aShortcutEvent currentTarget editor
		element: aShortcutEvent currentTarget
		dueTo: aShortcutEvent
]

{ #category : #evaluation }
AlbEditorShortcut >> performOnEditor: aTextEditor element: aEditorElement dueTo: aShortcutEvent [
	self subclassResponsibility
]
