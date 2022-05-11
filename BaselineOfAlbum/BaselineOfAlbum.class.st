Class {
	#name : #BaselineOfAlbum,
	#superclass : #BaselineOf,
	#category : #BaselineOfAlbum
}

{ #category : #baselines }
BaselineOfAlbum >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec 
			baseline: 'OnBloc' with: [
				spec repository: 'github://plantec/OnBloc/src' ].

		spec 
			package: #'Album' with: [
				spec repository: 'github://plantec/Album/src'.
				spec requires: #(#'OnBloc') ]
			 ].
]
