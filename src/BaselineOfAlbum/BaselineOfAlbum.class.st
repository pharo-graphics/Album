Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'Bloc'
			with: [ spec repository: 'github://pharo-graphics/Bloc:dev/src' ].

"		spec
			baseline: 'Alexandrie'
			with: [ spec repository: 'github://pharo-graphics/Alexandrie:master/src' ].
"
		spec
			package: #Album with: [ spec requires: #( #Bloc ) ];
			package: #'Album-Tests' with: [ spec requires: #( #Album ) ];
			package: #'Album-Examples' with: [ spec requires: #( #'Album-Tests' ) ];
			"package: #'Album-Brick-NU' with: [ spec requires: #( #Bloc ) ];"
			package: #'Album-Alexandrie' with: [ spec requires: #( #'Album-Examples' ) ] ]
]
