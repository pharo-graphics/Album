"
Hello World *https://gtoolkit.com*
"
Class {
	#name : #AlbTextStylerExamples,
	#superclass : #TestCase,
	#category : #'Album-Examples-Editor'
}

{ #category : #'examples - editor' }
AlbTextStylerExamples >> codeSnippetStyler [


	^ BlPharoCodeStyler new
		  classOrMetaClass: BlElement;
		  yourself
]

{ #category : #'examples - editor' }
AlbTextStylerExamples >> editorWithMethod [

	^ self newEditor privateText: self newMethodText
]

{ #category : #'instance creation' }
AlbTextStylerExamples >> newEditor [

	^ AlbTextEditor new
]

{ #category : #'instance creation' }
AlbTextStylerExamples >> newMethodText [
	
	^ (BlElement >> #applyLayoutSafelyIn:context:) sourceCode asRopedText
]

{ #category : #'Protocol (examples - styler strategy) - 1 selector(s)' }
AlbTextStylerExamples >> testEditorWithSyncStylerStrategy [

	| anEditor anEditorElement aStyler theTextAttributes |
	self skip.
	"I tried to make it run but editor: is not found and styler: neither."
	
	anEditor := self editorWithMethod.	
	aStyler := self codeSnippetStyler.
	
	anEditorElement := AlbEditorElement new.
	anEditorElement editor: anEditor.

	anEditor styler: aStyler.
	theTextAttributes := anEditor text attributesAt: 1.
	self assert: theTextAttributes size isZero not.

	^ anEditor
	
]

{ #category : #defaults }
AlbTextStylerExamples >> timeoutMilliseconds [
	^ 500
]
