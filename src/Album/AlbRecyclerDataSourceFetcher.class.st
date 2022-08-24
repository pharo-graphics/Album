Class {
	#name : #AlbRecyclerDataSourceFetcher,
	#superclass : #BlInfiniteRecyclerFetcher,
	#category : #'Album-Recycler'
}

{ #category : #initialization }
AlbRecyclerDataSourceFetcher >> defaultNext [
	^ nil
]

{ #category : #'element fetching' }
AlbRecyclerDataSourceFetcher >> elementFor: aPosition dryRun: dryRun controller: aRecyclerController [
	^ aRecyclerController infiniteElement telemetry
		timeSync: [ 'Fetch element from data source at {1}' format: { aPosition } ]
		during: [
			| holder |

			holder := aRecyclerController createElementHolderOfType: (aRecyclerController itemTypeAt: aPosition).
			holder ifNil: [ Error signal: 'Data source must not return nil holder!' ].

			holder -> false ]
]
