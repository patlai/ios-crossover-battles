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
    
}
