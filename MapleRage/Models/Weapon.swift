//
//  Weapon.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-02-02.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

class Weapon: Item{
    
    var Id: Int
    var Name: String
    
    var Attack: Int
    var WeaponRarity: Rarity.ItemRarity
    var DropRate: Double
    
    var Icon: String
    
    init(_ id: Int, _ name: String, _ attack: Int, _ dropRate: Double, _ icon: String){
        self.Id = id
        self.Name = name
        self.Attack = attack
        self.DropRate = dropRate
        self.WeaponRarity = Rarity.ConvertRateToRarity(dropRate)
        self.Icon = icon
    }
    
    public static func LoadWeaponData(_ path: String) -> [Weapon]{
        let weaponsData: Dictionary<String, AnyObject> = IOHelper.ReadFromJSONFile(path)
        
        if let weaponsDict = weaponsData["Weapons"] as? [Dictionary<String, AnyObject>] {
            
            var weapons: Array<Weapon> = Array()
            
            for weaponData in weaponsDict {
                let id = weaponData["Id"] as? Int ?? 0
                let name = weaponData["Name"] as? String ?? ""
                let attack = weaponData["Attack"] as? Int ?? 0
                let dropRate = weaponData["Drop"] as? Double ?? 0
                let icon = weaponData["Icon"] as? String ?? ""
                
                let weapon = Weapon(id, name, attack, dropRate, icon)
                weapons.append(weapon)
            }
            
            print("successfully loaded weapon data")
            
            return weapons
        } else {
            print("could not get weapons as a dictionary")
        }
        
        return []
    }
    
    public static func GetEmptyWeapon() -> Weapon{
        return Weapon(-1, "Hands", 0, 0.0, "sprites/items/weapons/sword.png")
    }
}
