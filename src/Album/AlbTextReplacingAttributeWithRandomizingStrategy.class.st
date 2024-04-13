Class {
	#name : #AlbTextReplacingAttributeWithRandomizingStrategy,
	#superclass : #AlbTextReplacingAttributeStrategy,
	#instVars : [
		'special'
	],
	#category : #'Album-Attributes - Support'
}

{ #category : #initialization }
AlbTextReplacingAttributeWithRandomizingStrategy >> initialize [
	super initialize.
	
	special := ('-/\*~<>=,%|&?!' , (String
		   with: Character centeredDot
		   with: Character divide
		   with: Character plusOrMinus
		   with: Character times))
]

{ #category : #replacing }
AlbTextReplacingAttributeWithRandomizingStrategy >> replaceCharacter: aCharacter [

	aCharacter isDigit
		ifTrue: [ ^ ($0 to: $9) atRandom ].
		
	aCharacter isLetter
		ifTrue: [ ^ aCharacter isUppercase
			ifTrue: [ ($A to: $Z) atRandom ]
			ifFalse: [ ($a to: $z) atRandom ] ].
		
	(self special includes: aCharacter)
		ifTrue: [ ^ self special atRandom ].

	^ aCharacter
]

{ #category : #accessing }
AlbTextReplacingAttributeWithRandomizingStrategy >> special [
	^ special
]

{ #category : #accessing }
AlbTextReplacingAttributeWithRandomizingStrategy >> special: anObject [
	special := anObject
]

{ #category : #replacing }
AlbTextReplacingAttributeWithRandomizingStrategy >> swapString: aString [
	<return: #String>
	
	^ aString collect: [ :eachCharacter | self replaceCharacter: eachCharacter ]
]
