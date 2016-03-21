//
//  ViewController.swift
//  WDCardContainerView
//
//  Created by Winslow DiBona on 3/21/16.
//  Copyright © 2016 expandshare. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cardContainerView : WDCardContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let x : CGFloat = 10
        let y : CGFloat = 100
        let width = view.frame.size.width - 20
        let height = view.frame.size.height - 130
        let rect = CGRectMake(x, y, width, height)
        cardContainerView = WDCardContainerView(frame: rect, delegate: self, dataSource: self)
        view.addSubview(cardContainerView)
        cardContainerView.reloadData()
    }

}

extension ViewController : WDCardContainerViewDelegate, WDCardContainerViewDataSource {
    func numberOfCards(cardContainerView: WDCardContainerView) -> Int {
        return 20
    }
    
    func sizeForCards(cardContainerView: WDCardContainerView) -> CGSize {
        return CGSizeMake(cardContainerView.frame.size.width, cardContainerView.frame.size.height)
    }
    
    func viewForIndex(cardContainerView: WDCardContainerView, index: Int) -> WDCardView {
        return WDCardView(frame: cardContainerView.bottomCardFrame)
    }
    
    func allowSwipe(cardContainerView: WDCardContainerView, direction: SwipeDirection, index: Int) -> Bool {
        return true
    }
    
    func swipedLastCard(cardContainerView: WDCardContainerView) {
        
    }
}

