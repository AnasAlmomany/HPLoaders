//
//  HPCubeLoader.swift
//  HPLoaders
//
//  Created by Henrik Panhans on 24.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable public class HPCubeLoader: SKView {
    
    private var loaderScene: HPCubeScene?
    @IBInspectable public var firstCubeColor: UIColor = UIColor.white {
        didSet {
            
        }
    }
    
    @IBInspectable public var secondCubeColor: UIColor = UIColor.white {
        didSet {
            
        }
    }
    
    @IBInspectable public var thirdCubeColor: UIColor = UIColor.white {
        didSet {
            
        }
    }
    
    public var isAnimating: Bool = false
    
    public func startAnimating(_ duration: TimeInterval = 4.5) {
        if !isAnimating {
            loaderScene?.startAnimating(duration)
            isAnimating = true
        }
    }
    
    public func stopAnimating() {
        isAnimating = false
        loaderScene?.stopAnimating()
    }
    
    func setupScene() {
        let scene = HPCubeScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderScene = scene
        self.presentScene(scene)
        self.ignoresSiblingOrder = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScene()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
}

class HPCubeScene: SKScene {
    var boxes = [SKShapeNode]()
    private var boxPositions = [CGPoint]()
    
    public var boxColor: UIColor = UIColor.white {
        didSet {
            boxes.forEach { (box) in
                box.fillColor = boxColor
            }
        }
    }
    
    public var boxSpacing: CGFloat = 10 {
        didSet {
            setupScene()
        }
    }
    
    public var cornerRadius: CGFloat = 10 {
        didSet {
            setupScene()
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene() {
        self.removeChildren(in: boxes)
        self.boxes.removeAll()
        self.boxPositions = makePositions()
        
        let boxSize = CGSize(width: (self.size.width - boxSpacing) / 2, height: (self.size.height - boxSpacing) / 2)
        for i in 0...2 {
            let shapeNode = SKShapeNode(rectOf: boxSize, cornerRadius: cornerRadius)
            shapeNode.position = self.boxPositions[i]
            shapeNode.fillColor = self.boxColor
            shapeNode.lineWidth = 0
            boxes.append(shapeNode)
            self.addChild(shapeNode)
        }
    }
    
    func makePositions() -> [CGPoint] {
        let boxSize = CGSize(width: (self.size.width - boxSpacing) / 2, height: (self.size.height - boxSpacing) / 2)
        
        let firstPosition = CGPoint(x: (boxSpacing / 2) + (boxSize.width / 2), y: (boxSpacing / 2) + (boxSize.height / 2))
        let secondPosition = CGPoint(x: (boxSpacing / 2) + (boxSize.width / 2), y: (-boxSpacing / 2) - (boxSize.height / 2))
        let thirdPosition = CGPoint(x: (-boxSpacing / 2) - (boxSize.width / 2), y: (-boxSpacing / 2) - (boxSize.height / 2))
        let fourthPosition = CGPoint(x: (-boxSpacing / 2) - (boxSize.width / 2), y: (boxSpacing / 2) + (boxSize.height / 2))
        
        return [firstPosition, secondPosition, thirdPosition, fourthPosition]
    }
    
    func startAnimating(_ duration: TimeInterval = 4.5) {
        let phaseDuration = duration / 10
        for i in 0...boxes.count - 1 {
            boxes[i].run(SKAction.wait(forDuration: Double(2 - i) * phaseDuration), completion: {
                self.boxes[i].run(SKAction.repeatForever(self.animationsFrom(i, duration: phaseDuration)))
            })
        }
    }
    
    func stopAnimating() {
        
    }
    
    func animationsFrom(_ index: Int, duration: TimeInterval) -> SKAction {
        var sequence = [SKAction]()
        
        switch index {
        case 0:
            sequence = [SKAction.move(to: self.boxPositions[1], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[2], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[3], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[0], duration: duration),
                        SKAction.wait(forDuration: duration * 2)]
        case 1:
            sequence = [SKAction.move(to: self.boxPositions[2], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[3], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[0], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[1], duration: duration),
                        SKAction.wait(forDuration: duration * 2)]
        case 2:
            sequence = [SKAction.move(to: self.boxPositions[3], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[0], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[1], duration: duration),
                        SKAction.wait(forDuration: duration * 2),
                        SKAction.move(to: self.boxPositions[2], duration: duration),
                        SKAction.wait(forDuration: duration * 2)]
        default:
            return SKAction.fadeOut(withDuration: 2)
        }
        
        return SKAction.sequence(sequence)
    }
}


