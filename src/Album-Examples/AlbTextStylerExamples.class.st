"
Hello World *https://gtoolkit.com*
"
Class {
	#name : #AlbTextStylerExamples,
	#superclass : #Object,
	#category : #'Album-Examples-Editor'
}

{ #category : #'examples - editor' }
AlbTextStylerExamples >> codeSnippetStyler [
	<gtExample>

	^ BlRBTextStyler new classOrMetaClass: BlElement
]

{ #category : #'examples - editor' }
AlbTextStylerExamples >> editorWithMethod [
	<gtExample>

	^ self newEditor text: self newMethodText
]

{ #category : #'examples - styler strategy' }
AlbTextStylerExamples >> editorWithSyncStylerStrategy [
	<gtExample>
	| anEditor anEditorElement aStyler theTextAttributes |

	anEditor := self editorWithMethod.	
	aStyler := self codeSnippetStyler.
	
	anEditorElement := AlbEditorElement new.
	anEditorElement editor: anEditor.

	anEditor styler: aStyler.
	theTextAttributes := anEditor text attributesAt: 1.
	self assert: theTextAttributes size isZero not.

	^ anEditor
	
]

{ #category : #'instance creation' }
AlbTextStylerExamples >> newEditor [
	<gtExample>

	^ AlbTextEditor new
]

{ #category : #'instance creation' }
AlbTextStylerExamples >> newMethodText [
	<gtExample>
	
	^ (BlElement >> #applyLayoutSafelyIn:context:) sourceCode asRopedText
]

{ #category : #defaults }
AlbTextStylerExamples >> timeoutMilliseconds [
	^ 500
]
