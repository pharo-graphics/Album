Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		self declareBlocOn: spec.

		spec
			package: #Album with: [ spec requires: #( #Bloc ) ];
			package: #'Album-Tests' with: [ spec requires: #( #Album ) ];
			package: #'Album-Examples' with: [ spec requires: #( #'Album-Tests' ) ];
			"package: #'Album-Brick-NU' with: [ spec requires: #( #Bloc ) ];"
			package: #'Album-Alexandrie' with: [ spec requires: #( #'Album-Examples' ) ] ]
]

{ #category : #baselines }
BaselineOfAlbum >> declareBlocOn: spec [

	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:v2.1.0/src' ]
]
