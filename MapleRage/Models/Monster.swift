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
    var MaxHP: Double = 0.0
    var CurrentHP: Double = 0.0
    var Node: SKSpriteNode
    var DefaultAnimation: SKAction
    var DamageAnimation: SKAction
    var DeathAnimation: SKAction
    var DamageSound: SKAction
    var DeathSound: SKAction
    var HitBox: CGRect
    var HasVerticalMovement: Bool = false
    var MoveSpeed: Int = 0
    var Defense: Int = 0
    var Exp: Int = 0
    
    var DropRate: Double = 0.0
    var DropRarity: Double = 0.0
    
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
        _ dropRate: Double = 0.0,
        _ dropRarity: Double = 0.0,
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
        
        self.DropRate = dropRate
        self.DropRarity = dropRarity
        
        self.Width = self.Node.size.width
        self.Height = self.Node.size.height
        self.Position = CGPoint(x: 0, y: 0)
        
        self.HitBox = CGRect(x: 0, y: 0, width: self.Width, height: self.Height)
    }
    
    public static func getDefaultAnimation(_ prefix: String, _ suffix: String, _ numberOfFrames: Int, _ frameDuration: Double, _ offset: Int = 0) -> SKAction{
        var frames: [SKTexture] = Array()
        for i in 0 ..< numberOfFrames {
            let current = SKTexture.init(imageNamed: prefix + String(i + offset) + suffix)
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
    
    /// Loads a monster from a dictionary containing monster data
    public static func loadData(_ data: Dictionary<String, AnyObject>) -> Monster {
        let name = data["name"] as? String ?? ""
        let hp = Double(data["hitpoints"] as? Int ?? 0)
        let animationPrefix = data["animationPrefix"] as? String ?? ""
        let animationSuffix = data["animationSuffix"] as? String ?? ""
        let deathAnimationPrefix = data["deathAnimationPrefix"] as? String ?? ""
        let deathAnimationSuffix = data["deathAnimationSuffix"] as? String ?? ""
        let startingFrame = data["defaultAnimation"] as? String ?? ""
        let damageSound = data["damageSound"] as? String ?? ""
        let deathSound = data["deathSound"] as? String ?? ""
        let hitAnimationPath = data["hitAnimation"] as? String ?? ""
        let numberOfAnimationFrames = data["numberOfAnimationFrames"] as? Int ?? 0
        let numberOfDeathAnimationFrames = data["numberOfDeathAnimationFrames"] as? Int ?? 0
        let moveSpeed = data["moveSpeed"] as? Int ?? 0
        let defense = data["defense"] as? Int ?? 0
        let exp = data["exp"] as? Int ?? 0
        let dropRate = data["dropRate"] as? Double ?? 0.0
        let dropRarity = data["dropRarity"] as? Double ?? 0.0
        
        let monst = Monster(
            name,
            hp,
            startingFrame,
            Monster.getDefaultAnimation(animationPrefix, animationSuffix, numberOfAnimationFrames, 0.2),
            Monster.getSpecialAnimation(hitAnimationPath, 0.2),
            Monster.getDefaultAnimation(deathAnimationPrefix, deathAnimationSuffix, numberOfDeathAnimationFrames, 0.2),
            Monster.getSoundClip(damageSound),
            Monster.getSoundClip(deathSound),
            moveSpeed,
            defense,
            exp,
            dropRate,
            dropRarity
        )
        
        return monst
    }
}

