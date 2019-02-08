//
//  EffectsHelper.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-28.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation
import SpriteKit

public class EffectsHelper{
    private static func degreesToRadians(_ degrees: Double) -> Double{
        return degrees * .pi / 180.0
    }
    
    public static func playSpriteAnimation(_ scene: SKScene, _ prefix: String, _ suffix: String, _ startingFrame: String, _ numberOfFrames: Int, _ frameDuration: Double, _ x: Double, y: Double, offset: Int = 0) -> SKSpriteNode {
        let animation = createSpriteAnimation(prefix, suffix, numberOfFrames, frameDuration, offset)
        let animationNode = SKSpriteNode(imageNamed: startingFrame)
        animationNode.position = CGPoint(x: x, y: y)
        scene.addChild(animationNode)
        return animationNode
    }
    
    public static func createSpriteAnimation(_ prefix: String, _ suffix: String, _ numberOfFrames: Int, _ frameDuration: Double, _ offset: Int = 0) -> SKAction{
        var frames: [SKTexture] = Array()
        for i in 0 ..< numberOfFrames {
            let current = SKTexture.init(imageNamed: prefix + String(i + offset) + suffix)
            frames.append(current)
        }
        
        return SKAction.animate(with: frames, timePerFrame: frameDuration)
    }
    
    /// Effect that happens right after an item is dropped
    public static func getItemDropEffect() -> SKAction {
        let moveUp = SKAction.moveBy(x: 0, y: 100, duration: 0.5)
        let moveDown = SKAction.moveBy(x: 0, y: -100, duration: 0.5)
        let rotate = SKAction.rotate(byAngle: CGFloat(degreesToRadians(720.0)), duration: 0.5)
    
        let firstGroup = SKAction.group([SKAction.sequence([moveUp, rotate])])
        let dropActions = SKAction.sequence([firstGroup, moveDown])
    
        return dropActions
    }
    
    /// Animation that happens until an item is picked up
    public static func getItemDropAnimation() -> SKAction {
        let bobbingAction = SKAction.moveBy(x: 0, y: 10, duration: 0.5)
        let reversed = bobbingAction.reversed()
        let dropAnimationSequence = SKAction.sequence([bobbingAction, reversed])
        
        return dropAnimationSequence
    }
    
}
