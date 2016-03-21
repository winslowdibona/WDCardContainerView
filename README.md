# WDCardContainerView

A simple CollectionView-like UI element for displaying a stack of swipeable cards. 

### Installation
Simply drag & drop WDCardContainerView and WDCardView into your project

### Usage

WDCardView comes with a collection of helper variables and methods.
````swift
var orientation : UIDeviceOrientation! // The current orientation of the device. 
var hasAppeared : Bool = false // Used to determine if the card has already appeared once.
func willAppear() // Called when it is determined the card is the next card to appear.
func appeared() // Called after the card has animated to the top position in the stack. 
func rotated() // Called whenever the deivce orientation changes. Calculates self.orientation
func dismissed() // Called whenever the card is swiped off the stack
````
WDCardContainerView uses a delegate and data source to get info from the ViewController. You can use or subclass WDCardView to display in the container. 

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

A simple example can be found in the Xcode project. 
