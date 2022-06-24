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

{ #category : #accessing }
AlbTextEditorSurroundMap >> definitions [
	^definitions
]

{ #category : #initialization }
AlbTextEditorSurroundMap >> initialize [ 

	super initialize.
	definitions := #().
]

{ #category : #accessing }
AlbTextEditorSurroundMap >> intervalBetweenDelimitersIn: aString at: aPosition ifPresent: aBlockWithIntervalArg ifAbsent: anAbsentBlock [

	" if aString at aPosition is just after of just before a delimiter, then look for the opposite delimiter. If found, then aBlockWithIntervalArg is runned with the interval between delimiters as argument else, anAbsentBlock is runned "

	| string here foundOpposite op |
	string := aString asString.
	here := (string at: aPosition) asString.
	foundOpposite := self
		                 closingFor: here
		                 ifPresent: [ :aSurroundSymbol | 
			                 op := self
				                       positionOfClosingDelimiter: aSurroundSymbol
				                       startingAt: aPosition
				                       in: string.
			                 op > 0 ifTrue: [ 
				                 ^ aBlockWithIntervalArg value:
					                   (aPosition to: op - 1) ] ]
		                 ifAbsent: [ 
			                 here := (string at: aPosition + 1) asString.
			                 foundOpposite := self
				                                  openingFor: here
				                                  ifPresent: [ :aSurroundSymbol | 
					                                  op := self
						                                        positionOfOpeningDelimiter: aSurroundSymbol
						                                        startingAt: aPosition
						                                        in: string.
					                                  op > 0 ifTrue: [ 
						                                  ^ aBlockWithIntervalArg 
							                                    value: (op to: aPosition) ] ]
				                                  ifAbsent: [ 
				                                  ^ anAbsentBlock value ] ]
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

{ #category : #'private - accessing' }
AlbTextEditorSurroundMap >> positionOf: aDelim from: startDelim startingAt: aPosition in: aString forward: aBoolean [
	" scan into aString, forward or backward, to search the position of aDelim which is the opposite delim of startDelim."
	| string level here hereChar incr |
	string := aString asString.
	incr := aBoolean
		        ifTrue: [ 1 ]
		        ifFalse: [ -1 ].
	here := aPosition + 1.
	level := 1.
	[ level > 0 and: [ here > 1 and: [ here <= string size ] ] ] 
		whileTrue: [ 
			here := here + incr.
			here > string size ifTrue: [ ^ 0 ].
			hereChar := (string at: here) asSymbol.
			hereChar = aDelim
				ifTrue: [ 
					level := level - 1.
					level = 0 ifTrue: [ ^ here ] ]
				ifFalse: [ hereChar = startDelim ifTrue: [ level := level + 1 ] ] ].
	^ 0
]

{ #category : #'private - accessing' }
AlbTextEditorSurroundMap >> positionOfClosingDelimiter: aDelim startingAt: aPosition in: aString [

	" return the position of the closing delim aDelim "

	| string oppositeDelim |
	string := aString asString.
	oppositeDelim := (aString at: aPosition) asSymbol.
	^ self
		  positionOf: aDelim
		  from: oppositeDelim
		  startingAt: aPosition
		  in: string
		  forward: true
]

{ #category : #'private - accessing' }
AlbTextEditorSurroundMap >> positionOfOpeningDelimiter: aDelim startingAt: aPosition in: aString [

	" return the position of the opening delim aDelim "

	| string oppositeDelim |
	string := aString asString.
	oppositeDelim := (aString at: aPosition + 1) asSymbol.

	^ self
		  positionOf: aDelim
		  from: oppositeDelim
		  startingAt: aPosition
		  in: string
		  forward: false
]
