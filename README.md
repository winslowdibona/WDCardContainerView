# WDCardContainerView

A simple CollectionView-like UI element for displaying a stack of swipeable cards. 

### Installation
Simply drag & drop WDCardContainerView and WDCardView into your project

### Usage


#### Delegate Methods
````swift
  func allowSwipe(cardContainerView : WDCardContainerView, direction : SwipeDirection, index : Int) -> Bool
  func swipedLastCard(cardContainerView : WDCardContainerView)
````
#### Datasource Methods
````swift
  func numberOfCards(cardContainerView : WDCardContainerView) -> Int
  func sizeForCards(cardContainerView : WDCardContainerView) -> CGSize
  func viewForIndex(cardContainerView : WDCardContainerView, index : Int) -> WDCardView
````
