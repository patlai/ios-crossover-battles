//
//  Player.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-27.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

public class Player{
    
    static let Shared = Player()
    
    var Level: Int
    var HP: Double
    var MP: Double
    var Attack: Double
    var CritChance: Double
    var CurrentExp: Int
    var ExpToNextLevel: Int
    var NumberOfKills: Int = 0
    var ExpRate: Double = 1.0
    var AttackMultiplier: Double = 1.0
    var HasSuperAttack: Bool = false {
        willSet{
            if (newValue) {
                AttackMultiplier *= 50.0
            } else {
                AttackMultiplier /= 50.0
            }
        }
    }
    
    var HasSuperExp: Bool = false {
        willSet{
            if (newValue) {
                ExpRate *= 100.0
            } else {
                ExpRate /= 100.0
            }
        }
    }
    
    init(){
        self.Level = 1
        self.HP = 100.0
        self.MP = 100.0
        self.Attack = 50.0
        self.CritChance = 0.5
        self.CurrentExp = 0
        self.ExpToNextLevel = 500
    }
    
    func levelUp(){
        self.Level += 1
        self.HP += 30.0
        self.MP += 30.0
        self.Attack += 10.0
        self.CritChance += 0.01
        self.CurrentExp = 0
        self.ExpToNextLevel += Int(10.0 * pow(Double(self.Level), 3.0))
    }
    
    func attackMonster(_ monster: Monster) -> (Double, Bool){
        let isCriticalHit = Double.random(in: 0 ... 1) < self.CritChance
        let criticalMultiplier = isCriticalHit ? 1.6 : 1.0
        let minDamage = 1.0 * self.Attack
        let maxDamage = 10.0 * self.Attack - Double(monster.Defense)
        var damage = self.AttackMultiplier * criticalMultiplier * Double.random(in: minDamage ... maxDamage)
        damage.round()
        return (damage, isCriticalHit)
    }
    
    func ToggleSuperAttack(){
        HasSuperAttack = !HasSuperAttack
    }
    
    func ToggleSuperExp(){
        HasSuperExp = !HasSuperExp
    }
}
