Class {
	#name : #AlbTextEditorSurroundMapExamples,
	#superclass : #Object,
	#category : 'Album-Examples-Editor'
}

{ #category : #examples }
AlbTextEditorSurroundMapExamples >> surroundSet [
	<gtExample>

	| definitions |

	definitions := 
		{ { $'. $'. [ :anOperator :anIndex | true ] }.
		{ $". $". [ :anOperator :anIndex | false ]}.
		{ $(. $). nil. }  } collect: 
			[ :each | 
				AlbTextEditorSurroundDefinition new 
					openCharacter: each first;
					closeCharacter: each second;
					condition: each third ].
	^ AlbTextEditorSurroundMap new
		addDefinitions: definitions.

]

{ #category : #examples }
AlbTextEditorSurroundMapExamples >> surroundSetClosing [
	<gtExample>

	| opening |

	opening := self surroundSet
		openingFor: $' 
		ifPresent: [ :def | def ] 
		ifAbsent: [  ].
	self assert: opening equals: $'.
	^opening
]

{ #category : #examples }
AlbTextEditorSurroundMapExamples >> surroundSetClosingAbsent [
	<gtExample>

	| definition |

	definition := self surroundSet
		openingFor: $x
		ifPresent: [ :def | def ] 
		ifAbsent: [ #absent ].
	self assert: definition equals: #absent.
	^definition
]

{ #category : #examples }
AlbTextEditorSurroundMapExamples >> surroundSetOpeningAbsent [
	<gtExample>

	| definition |

	definition := self surroundSet
		closingFor: $x
		in: self at: 0 
		ifPresent: [ :def | def ] 
		ifAbsent: [ #absent ].
	self assert: definition equals: #absent.
	^definition
]

{ #category : #examples }
AlbTextEditorSurroundMapExamples >> surroundSetOpeningConditionRejects [
	<gtExample>

	| definition |

	definition := self surroundSet
		closingFor: $"
		in: self at: 0
		ifPresent: [ :def | def ] 
		ifAbsent: [ #absent ].
	self assert: definition equals: #absent.
	^definition
]

{ #category : #examples }
AlbTextEditorSurroundMapExamples >> surroundSetOpeningPresent [
	<gtExample>

	| closing |

	closing := self surroundSet
		closingFor: $' 
		in: self at: 0
		ifPresent: [ :def | def ] 
		ifAbsent: [  ].
	self assert: closing equals: $'.
	^closing
]
