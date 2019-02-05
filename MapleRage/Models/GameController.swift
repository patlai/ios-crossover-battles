//
//  GameController.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-02-02.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

class GameController{
    
    static let Shared = GameController()
    static let WeaponDataPath = "data/items/weapons"
    static let LevelDataPath = "data/levels"
    
    var Weapons: Array<Weapon>
    
    init(){
        self.Weapons = Weapon.LoadWeaponData(GameController.WeaponDataPath)
    }
    
    public func GetWeaponById(_ id: Int) -> Weapon{
        return self.Weapons[id]
    }
    
    public func GetDefaultWeapon() -> Weapon{
        return GetWeaponById(0)
    }
}
