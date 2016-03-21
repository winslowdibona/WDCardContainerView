//
//  WDCardContainerView.swift
//  WDCardContainerView
//
//  Created by Winslow DiBona on 3/21/16.
//  Copyright © 2016 expandshare. All rights reserved.
//

import UIKit

protocol WDCardContainerViewDelegate {
    func allowSwipe(cardContainerView : WDCardContainerView, direction : SwipeDirection, index : Int) -> Bool
    func swipedLastCard(cardContainerView : WDCardContainerView)
}

protocol WDCardContainerViewDataSource {
    func numberOfCards(cardContainerView : WDCardContainerView) -> Int
    func sizeForCards(cardContainerView : WDCardContainerView) -> CGSize
    func viewForIndex(cardContainerView : WDCardContainerView, index : Int) -> WDCardView
}

public enum SwipeDirection {
    case Up
    case Down
    case Left
    case Right
}

private enum CardAnimation {
    case ToLeft
    case ToRight
    case ToBottom
    case ToTop
    case BecomeTop
    case BecomeMiddle
    case BecomeBottom
}

class WDCardContainerView: UIView {
    
    var delegate : WDCardContainerViewDelegate?
    var dataSource : WDCardContainerViewDataSource?
    var numberOfCards : Int!
    var cards : [Int : WDCardView] = [Int : WDCardView]()
    var currentIndex : Int = 0
    var cardSize : CGSize!
    var topCardFrame : CGRect!
    var middleCardFrame : CGRect!
    var bottomCardFrame : CGRect!
    
    var bottomOffscreenCenter : CGPoint!
    var leftOffscreenCenter : CGPoint!
    var rightOffscreenCenter : CGPoint!
    var topOffscreenCenter : CGPoint!
    var topCardCenter : CGPoint!
    var middleCardCenter : CGPoint!
    var bottomCardCenter : CGPoint!
    
    var xFromCenter : Float = 0
    var yFromCenter : Float = 0
    var originPoint : CGPoint!
    let rotationStrength : Float = 320
    let rotationAngle : Float = 3.14/8
    let actionMargin : Float = 120
    let scaleStrength : Float = 4
    let scaleMax : Float = 0.93
    let rotationMax : Float = 1
    var ignore : Bool = false
    var swipingDown : Bool = false
    var windowView : UIWindow!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame : CGRect, delegate : WDCardContainerViewDelegate, dataSource : WDCardContainerViewDataSource) {
        super.init(frame: frame)
        windowView = (UIApplication.sharedApplication().delegate as! AppDelegate).window!
        self.delegate = delegate
        self.dataSource = dataSource
        self.backgroundColor = UIColor.clearColor()
    }
    
    func reloadData() {
        if let dataSource = dataSource {
            cardSize = dataSource.sizeForCards(self)
            setupCardFrames()
            numberOfCards = dataSource.numberOfCards(self)
            for i in 0...2 {
                loadView(i)
            }
            cards[2]!.center = bottomCardCenter
            cards[1]!.center = middleCardCenter
            cards[0]!.center = topCardCenter
            windowView.addSubview(cards[2]!)
            windowView.addSubview(cards[1]!)
            windowView.addSubview(cards[0]!)
            cycleUp()
        }
    }
    
    func hideCards() {
        let _ = cards.map({$0.1.hidden = true})
    }
    
    func showCards() {
        let _ = cards.map({$0.1.hidden = false})
    }
    
    func dismiss() {
        for card in cards {
            card.1.removeFromSuperview()
        }
        removeFromSuperview()
    }
    
    func hide() {
        hideCards()
        hidden = true
    }
    
    func show() {
        showCards()
        hidden = false
    }
}

// Private Functions
extension WDCardContainerView {
    private func loadView(forIndex : Int) {
        if let dataSource = dataSource {
            //            if forIndex > numberOfCards {
            //                cards[forIndex] = CardView(frame: bottomCardFrame)
            //                cards[forIndex]!.center = bottomCardCenter
            //            } else {
            if cards[forIndex] == nil {
                cards[forIndex] = dataSource.viewForIndex(self, index: forIndex)
                cards[forIndex]!.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragging:"))
            }
            //}
        }
    }
    
    private func removeView(forIndex : Int) {
        if let _ = cards[forIndex] {
            cards.removeValueForKey(forIndex)
        }
    }
    
    private func cleanDeck() {
        let t = [currentIndex - 1, currentIndex, currentIndex + 1, currentIndex + 2]
        for tuple in cards {
            if !t.contains(tuple.0) {
                removeView(tuple.0)
            }
        }
    }
    
    private func swiped(swipeDirection : SwipeDirection) {
        if swipeDirection == .Up || swipeDirection == .Left || swipeDirection == .Right {
            if currentIndex != numberOfCards {
                if swipeDirection == .Up { animate(currentIndex, animation: .ToTop) }
                if swipeDirection == .Left { animate(currentIndex, animation: .ToLeft) }
                if swipeDirection == .Right { animate(currentIndex, animation: .ToRight) }
                currentIndex++
                if (currentIndex + 1) < numberOfCards {
                    loadView(currentIndex + 1)
                    cards[currentIndex + 1]!.center = bottomCardCenter
                    windowView.insertSubview(cards[currentIndex + 1]!, belowSubview: cards[currentIndex]!)
                }
                if (currentIndex + 2) < numberOfCards {
                    loadView(currentIndex + 2)
                    cards[currentIndex + 2]!.center = bottomCardCenter
                    windowView.insertSubview(cards[currentIndex + 2]!, belowSubview: cards[currentIndex + 1]!)
                }
                cycleUp()
            } else {
                delegate!.swipedLastCard(self)
                animate(currentIndex, animation: .BecomeTop)
            }
        } else if swipeDirection == .Down {
            if currentIndex != 0 {
                currentIndex--
                loadView(currentIndex)
                cards[currentIndex]!.center = topOffscreenCenter
                windowView.addSubview(cards[currentIndex]!)
                cycleDown()
            }
        }
    }
    
    private func animate(index : Int, animation : CardAnimation) {
        if let card = cards[index] {
            if animation == .BecomeTop && !card.hasAppeared {
                card.willAppear()
            }
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                if animation == .ToLeft {
                    card.center = self.leftOffscreenCenter
                } else if animation == .ToRight {
                    card.center = self.rightOffscreenCenter
                } else if animation == .ToBottom {
                    card.center = self.bottomOffscreenCenter
                } else if animation == .ToTop {
                    card.center = self.topOffscreenCenter
                }else if animation == .BecomeTop {
                    card.center = self.topCardCenter
                } else if animation == .BecomeMiddle {
                    card.center = self.middleCardCenter
                } else if animation == .BecomeBottom {
                    card.center = self.bottomCardCenter
                }
                card.transform = CGAffineTransformIdentity
                }, completion: { (success) -> Void in
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        if animation == .ToLeft || animation == .ToRight || animation == .ToTop {
                            card.removeFromSuperview()
                            card.dismissed()
                        } else if animation == .BecomeTop {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                card.appeared()
                            })
                        }
                    })
            })
        }
    }
    
    private func setupCardFrames() {
        let windowHalfWidth = windowView.bounds.size.width/2
        let windowHalfHeight = windowView.bounds.size.height/2
        let cardHalfWidth = cardSize.width/2
        let cardHalfHeight = cardSize.height/2
        let middleX = windowHalfWidth - cardHalfWidth
        let middleY = windowHalfHeight - cardHalfHeight
        topCardFrame = CGRectMake(middleY, middleY, cardSize.width, cardSize.height)
        middleCardFrame = CGRectMake(middleX, middleY + 10, cardSize.width, cardSize.height)
        bottomCardFrame = CGRectMake(middleX, middleY + 20, cardSize.width, cardSize.height)
        
        topCardCenter = windowView.center
        middleCardCenter = CGPointMake(windowView.center.x, windowView.center.y + 10)
        bottomCardCenter = CGPointMake(windowView.center.x, windowView.center.y + 20)
        
        bottomOffscreenCenter = CGPointMake(windowView.center.x, 5000)
        leftOffscreenCenter = CGPointMake(-5000, windowView.center.y)
        rightOffscreenCenter = CGPointMake(5000 + windowView.frame.size.width, windowView.center.y)
        topOffscreenCenter = CGPointMake(windowView.center.x, -5000)
    }
    
    func dragging(sender : UIPanGestureRecognizer) {
        xFromCenter = Float(sender.translationInView(windowView).x)
        yFromCenter = Float(sender.translationInView(windowView).y)
        if sender.state == .Began {
            let velocity = sender.velocityInView(windowView)
            if velocity.y > velocity.x && velocity.y > 200 {
                ignore = true
            } else {
                if let card = self.cards[self.currentIndex] {
                    originPoint = card.center
                }
            }
        } else if sender.state == .Changed {
            if !ignore {
                if let card = cards[currentIndex] {
                    let strength : Float = min(xFromCenter/rotationStrength, rotationMax)
                    let angle : Float = rotationAngle * strength
                    let scale = max(1 - fabsf(strength) / scaleStrength, scaleMax)
                    self.cards[self.currentIndex]!.center = CGPointMake(self.originPoint.x + CGFloat(xFromCenter), self.originPoint.y + CGFloat(yFromCenter))
                    let transform = CGAffineTransformMakeRotation(CGFloat(angle))
                    let scaleTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
                    card.transform = scaleTransform
                }
            }
        } else if sender.state == .Ended {
            if let _ = cards[currentIndex] {
                if !ignore {
                    let velocity = sender.velocityInView(windowView)
                    if abs(velocity.x) > abs(velocity.y) {
                        velocity.x > 0 ? (allow(.Right) ? swiped(.Right) : animate(currentIndex, animation: .BecomeTop)) : (allow(.Left) ? swiped(.Left) : animate(currentIndex, animation: .BecomeTop))
                    } else {
                        velocity.y < 0 ? swiped(.Up) : animate(currentIndex, animation: .BecomeTop)
                    }
                } else {
                    ignore = false
                    let velocity = sender.velocityInView(windowView)
                    if velocity.y > 700 {
                        if allow(.Down) {
                            swiped(.Down)
                        }
                    }
                }
            }
        } else if sender.state == .Possible || sender.state == .Cancelled || sender.state == .Failed {
            if !ignore {
                ignore = false
            }
        }
    }
    
    private func allow(swipeDirection : SwipeDirection) -> Bool {
        if let delegate = delegate {
            return delegate.allowSwipe(self, direction: swipeDirection, index: currentIndex)
        }
        return true
    }
    
    private func cycleUp() {
        animate(currentIndex, animation: .BecomeTop)
        animate(currentIndex + 1, animation: .BecomeMiddle)
    }
    
    private func cycleDown() {
        animate(currentIndex, animation: .BecomeTop)
        animate(currentIndex + 1, animation: .BecomeMiddle)
        animate(currentIndex + 2, animation: .BecomeBottom)
    }
}