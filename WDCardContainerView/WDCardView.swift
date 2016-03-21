//
//  WDCardView.swift
//  WDCardContainerView
//
//  Created by Winslow DiBona on 3/21/16.
//  Copyright © 2016 expandshare. All rights reserved.
//


import UIKit

class WDCardView: UIView {
    
    var orientation : UIDeviceOrientation!
    var hasAppeared : Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        addDropShadow()
    }
    
    func willAppear() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        rotated()
        hasAppeared = true
    }
    
    func appeared() {
        
    }
    
    func rotated() {
        let deviceOrientation = UIDevice.currentDevice().orientation
        if deviceOrientation == .FaceDown || deviceOrientation == .FaceUp {
            deviceOrientation.isLandscape ? (orientation = .LandscapeLeft) : (orientation = .Portrait)
        } else {
            orientation = deviceOrientation
        }
    }
    
    func dismissed() {
        
    }
    
    func addDropShadow() {
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0, 3)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowPath = shadowPath.CGPath
    }
    
    
    
}