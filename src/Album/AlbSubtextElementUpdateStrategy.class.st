Class {
	#name : 'AlbSubtextElementUpdateStrategy',
	#superclass : 'Object',
	#category : 'Album-UI-Text-Portion',
	#package : 'Album',
	#tag : 'UI-Text-Portion'
}

{ #category : 'api - install/uninstall  hook' }
AlbSubtextElementUpdateStrategy >> onInstalledIn: aSubTextElement [

	aSubTextElement whenLayoutedDoOnce: [ aSubTextElement updateVertices ]
]

{ #category : 'api - install/uninstall  hook' }
AlbSubtextElementUpdateStrategy >> onUninstalledIn: aSubTextElement [
]
