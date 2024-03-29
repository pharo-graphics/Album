Class {
	#name : #AlbTextEditorSignalLogger,
	#superclass : #MemoryLogger,
	#category : #'Album-Brick-NU-signals'
}

{ #category : #initialization }
AlbTextEditorSignalLogger >> interestingSignals [
	^ { AlbTextStylerSignal }
]

{ #category : #accessing }
AlbTextEditorSignalLogger >> nextPut: aSignal [
	(self interestingSignals anySatisfy: [ :eachSignalClass |
		aSignal class == eachSignalClass or: [ aSignal class inheritsFrom: eachSignalClass ] ])
			ifFalse: [ ^ self ].

	super nextPut: aSignal
]
