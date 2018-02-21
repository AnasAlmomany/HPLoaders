//
//  GameViewController.swift
//  Test Application
//
//  Created by Henrik Panhans on 16.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet var hpView: HPCircleLoader!
    @IBOutlet var hpBall: HPBallLoader!
    @IBOutlet var hpWave: HPWaveLoader!
    @IBOutlet var hpPulse: HPSquarePulseLoader!
    @IBOutlet var hpBoxSlider: HPSlidingBoxLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func start(_ sender: Any) {
        hpView.startAnimating(with: 4)
        hpBall.startAnimating(withDurations: 0.2, restore: 1.3)
        hpWave.startAnimating(with: 3, amplitude: .full)
        hpPulse.startAnimating(with: 8, contractionFactor: 0.8)
        hpBoxSlider.startAnimating()
    }
    
    @IBAction func stop(_ sender: Any) {
        hpView.stopAnimating()
        hpBall.stopAnimating()
        hpWave.stopAnimating()
        hpPulse.stopAnimating()
        hpBoxSlider.stopAnimating()
    }
    
    @IBAction func randomizeWave(_ sender: Any) {
        hpBall.ballColor = .random
        hpWave.numberOfDots = Int(arc4random_uniform(10) + 2)
        hpWave.dotColor = .random
        hpView.ringColor = .random
        hpPulse.dotColor = .random
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension SKColor {
    enum ColorType {
        case Red
        case Blue
        case Green
    }
    
    class var random: SKColor {
        let red = CGFloat(arc4random_uniform(256))
        let green = CGFloat(arc4random_uniform(256))
        let blue = CGFloat(arc4random_uniform(256))
        
        return SKColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class func randomColor(type: ColorType) -> SKColor {
        let major = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: 100, highestValue: 255)
        let minor = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: 0, highestValue: 70)
        
        var postRed = CGFloat(minor.nextInt())
        var postGreen = CGFloat(minor.nextInt())
        var postBlue = CGFloat(minor.nextInt())
        
        switch type {
        case .Red:
            postRed = CGFloat(major.nextInt())
        case .Green:
            postGreen = CGFloat(major.nextInt())
        case .Blue:
            postBlue = CGFloat(major.nextInt())
        }
        
        return SKColor(red: postRed/255, green: postGreen/255, blue: postBlue/255, alpha: 1)
    }
}
