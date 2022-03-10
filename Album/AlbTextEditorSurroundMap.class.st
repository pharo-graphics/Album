"
AlbTextEditorSurroundSet provides dictionary like lookup for opening and closing surround characters.

See AlbTextEditorSurroundDefinition for more information. 

 
!!Internal Representation and Key Implementation Points.

!!!Instance Variables
	definitions:		<Array>


!!!Implementation Points

The size of the collection is assumed to be small, so a simple search is done instead of using a Dictionary.
"
Class {
	#name : #AlbTextEditorSurroundMap,
	#superclass : #Object,
	#instVars : [
		'definitions'
	],
	#category : #'Album-Model-Operators'
}

{ #category : #'instance creation' }
AlbTextEditorSurroundMap class >> newFromArray: anArrayOfArray [
	^ self newFromArrays: { anArrayOfArray }
]

{ #category : #'instance creation' }
AlbTextEditorSurroundMap class >> newFromArrays: anArrayOfArray [
	"When inserting some special symbols a text editor should surround a cursor or selection with that symbol
	anArrayOfArray is:
		{ { <left-character>. <right-character> <condition> } { ... } ... }
	<condition> is:
		[ :anOperator :anIndex | anOperator hasSpaceAroundIndex: anIndex ]"
	| theDefinitions |
	theDefinitions := anArrayOfArray collect: [ :each |
			AlbTextEditorSurroundDefinition new 
					openCharacter: each first;
					closeCharacter: each second;
					condition: each third ].
	^ self new addDefinitions: theDefinitions.
]

{ #category : #adding }
AlbTextEditorSurroundMap >> addDefinition: aTextEditorSurroundDefinition [

	definitions := definitions copyWith: aTextEditorSurroundDefinition
]

{ #category : #adding }
AlbTextEditorSurroundMap >> addDefinitions: anArray [

	definitions := definitions, anArray
]

{ #category : #accessing }
AlbTextEditorSurroundMap >> associations [
	"Answer an array of openCharacter -> closeCharacter associations"

	^definitions collect: [ :definition |
		definition openCharacter -> definition closeCharacter ]
]

{ #category : #accessing }
AlbTextEditorSurroundMap >> closingFor: aCharacter ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the matching closing character for the supplied opening character"
	| definition |

	definition := definitions
		detect: [ :each | each openCharacter = aCharacter ]
		ifNone: [ ^absentBlock value ].
	^presentBlock value: definition closeCharacter.
]

{ #category : #accessing }
AlbTextEditorSurroundMap >> closingFor: aCharacter in: anOperator at: anIndex ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the matching closing character for the supplied opening character.
	If the receiver has a condition block that evaluates to false, execute the absentBlock."
	| definition |

	definition := definitions
		detect: [ :each | each openCharacter = aCharacter ]
		ifNone: [ ^absentBlock value ].
	definition condition ifNotNil: [ :condition |
		(condition value: anOperator value: anIndex) ifFalse: 
			[ ^absentBlock value ] ].
	^presentBlock value: definition closeCharacter.
]

{ #category : #initialization }
AlbTextEditorSurroundMap >> initialize [ 

	super initialize.
	definitions := #().
]

{ #category : #accessing }
AlbTextEditorSurroundMap >> openingFor: aCharacter ifPresent: presentBlock ifAbsent: absentBlock [
	"Answer the matching opening character for the supplied closing character"
	| definition |

	definition := definitions
		detect: [ :each | each closeCharacter = aCharacter ]
		ifNone: [ ^absentBlock value ].
	^presentBlock value: definition openCharacter.
]
