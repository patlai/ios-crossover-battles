//
//  Monster.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-27.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation
import SpriteKit

class Monster{
    var Name: String
    var MaxHP: Double
    var CurrentHP: Double
    var Node: SKSpriteNode
    var DefaultAnimation: SKAction
    var DamageAnimation: SKAction
    var DeathAnimation: SKAction
    var DamageSound: SKAction
    var DeathSound: SKAction
    var HitBox: CGRect
    var HasVerticalMovement: Bool
    var MoveSpeed: Int
    var Defense: Int
    var Exp: Int
    
    var Width: CGFloat
    var Height: CGFloat
    
    var Position: CGPoint{
        willSet{
            Node.position = newValue
            // the origin of a CGRect is actually the top left corner
            HitBox.origin = CGPoint(x: newValue.x - Node.size.width / 2, y: newValue.y - Node.size.height / 2)
        }
    }
    
    init(){
        self.Name = ""
        self.MaxHP = 0
        self.CurrentHP = 0
        self.DefaultAnimation = SKAction()
        self.DamageAnimation = SKAction()
        self.DeathAnimation = SKAction()
        self.DamageSound = SKAction()
        self.DeathSound = SKAction()
        self.Node = SKSpriteNode()
        self.HitBox = CGRect()
        self.Position = CGPoint()
        self.Width = 0
        self.Height = 0
        self.HasVerticalMovement = false
        self.MoveSpeed = 0
        self.Defense = 0
        self.Exp = 0
    }
    
    init (
        _ Name: String,
        _ MaxHP: Double,
        _ StartingFrame: String,
        _ DefaultAnimation: SKAction,
        _ DamageAnimation: SKAction,
        _ DeathAnimation: SKAction,
        _ DamageSound: SKAction,
        _ DeathSound: SKAction,
        _ moveSpeed: Int = 0,
        _ defense: Int = 0,
        _ exp: Int = 0,
        _ hasVerticalMovement: Bool = false)
    {
        self.Name = Name
        self.MaxHP = MaxHP
        self.CurrentHP = MaxHP
        self.DefaultAnimation = DefaultAnimation
        self.DamageAnimation = DamageAnimation
        self.DeathAnimation = DeathAnimation
        self.DamageSound = DamageSound
        self.DeathSound = DeathSound
        self.Node = SKSpriteNode(imageNamed: StartingFrame)
        self.MoveSpeed = moveSpeed
        self.HasVerticalMovement = hasVerticalMovement
        self.Defense = defense
        self.Exp = exp
        
        self.Width = self.Node.size.width
        self.Height = self.Node.size.height
        self.Position = CGPoint(x: 0, y: 0)
        
        self.HitBox = CGRect(x: 0, y: 0, width: self.Width, height: self.Height)
    }
    
    public static func getDefaultAnimation(_ prefix: String, _ suffix: String, _ numberOfFrames: Int, _ frameDuration: Double) -> SKAction{
        var frames: [SKTexture] = Array()
        for i in 0 ..< numberOfFrames {
            let current = SKTexture.init(imageNamed: prefix + String(i) + suffix)
            frames.append(current)
        }
        
        return SKAction.animate(with: frames, timePerFrame: frameDuration)
    }
    
    public static func getSpecialAnimation(_ spritePath: String, _ frameDuration: Double) -> SKAction {
        return SKAction.animate(with: Array([SKTexture.init(imageNamed: spritePath)]), timePerFrame: frameDuration )
    }
    
    public static func getSoundClip(_ soundFilePath: String, _ wait: Bool = false) -> SKAction {
        return SKAction.playSoundFileNamed(soundFilePath, waitForCompletion: wait)
    }
}

