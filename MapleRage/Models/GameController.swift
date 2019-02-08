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
    static let MonsterDataPath = "data/monsters"
    
    var monsterCollection: Dictionary<Int, Monster> = Dictionary()
    var currentMonster = Monster()
    var currentMonsterIndex = 0
    var currentLevel = Level()
    var levelFiles = Level.getLevelFiles()
    var levelIcons: [String] = Array()
    
    var Weapons: Array<Weapon>
    
    init(){
        self.Weapons = Weapon.LoadWeaponData(GameController.WeaponDataPath)
        //self.monsterCollection = LoadMonstersFromJson()
    }
    
    private func LoadMonstersFromJson() -> [Int: Monster]{
        var monsterDict: [Int: Monster] = Dictionary()
        let monsterFiles = IOHelper.GetFilePathsWithoutExtension(GameController.MonsterDataPath)
        for file in monsterFiles {
            let data = IOHelper.ReadFromJSONFile(file)
            let monster = Monster.loadData(data)
            monsterDict[monster.Id] = monster
        }
        return monsterDict
    }
    
    public func LoadMonsterFromJson(_ id: Int) -> Monster {
        let data = IOHelper.ReadFromJSONFile(GameController.MonsterDataPath + "/" + String(id))
        return Monster.loadData(data)
    }
    
    public func GetWeaponById(_ id: Int) -> Weapon{
        return self.Weapons[id]
    }
    
    public func GetDefaultWeapon() -> Weapon{
        return GetWeaponById(0)
    }
}
