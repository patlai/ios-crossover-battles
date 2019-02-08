//
//  Level.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-27.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

public class Level{
    static let LevelDataDirectory = "data/levels"
    
    var Name: String
    var BackgroundMusicPath: String
    var BackgroundImagePath: String
    var IconPath: String
    var KillsRequired: Int
    var Monsters: [Monster]
    var IsCompleted: Bool = false
    
    init(){
        self.Name = ""
        self.BackgroundMusicPath = ""
        self.BackgroundImagePath = ""
        self.IconPath = ""
        self.KillsRequired = 10
        self.Monsters = []
    }
    
    init(_ name: String, _ backgroundMusicPath: String, _ backgroundImagePath: String, _ iconPath: String, _ killsRequired: Int, _ monsters: [Monster]){
        self.Name = name
        self.BackgroundMusicPath = backgroundMusicPath
        self.BackgroundImagePath = backgroundImagePath
        self.IconPath = iconPath
        self.KillsRequired = killsRequired
        self.Monsters = monsters
    }
    
    
    public static func getLevelFiles() -> Array<String> {
        return IOHelper.GetFilePathsWithoutExtension(LevelDataDirectory)
    }
    
    
    /// Loads level data from a JSON file
    public static func LoadLevelFromJSON(_ path: String) -> Level? {
        let levelData = IOHelper.ReadFromJSONFile(path)
        
        if(levelData.count > 0 && VerifyLevelData(levelData)){
            let name = levelData["name"] as? String ?? ""
            let bgm = levelData["backgroundMusic"] as? String ?? ""
            let bgi = levelData["backgroundImage"] as? String ?? ""
            let icon = levelData["icon"] as? String ?? ""
            let killsRequired = levelData["killsRequired"] as? Int ?? 10
            let monsterIds = levelData["monsters"] as? [Int] ?? []
            var monsters: [Monster] = Array()
            
            for id in monsterIds {
                monsters.append(GameController.Shared.LoadMonsterFromJson(id))
            }
            
            return Level (name, bgm, bgi, icon, killsRequired, monsters)
            
        } else{
            print("unable to parse level data")
        }
        
        return nil
    }
    
    /// Parses the JSON data to get the list of monsters contained in the level
    static func ParseMonsterData(_ data: [Dictionary<String, AnyObject>]) -> [Monster]{
        var levelMonsters: Array<Monster> = Array()
        
        for monsterData in data{
            let currentMonster = Monster.loadData(monsterData)
            levelMonsters.append(currentMonster)
        }
        
        return levelMonsters
    }
    
    /// Verifies that the data being read corresponds to monster data
    static func VerifyLevelData(_ data: Dictionary<String, AnyObject>) -> Bool{
        return data.keys.contains("name")
            && data.keys.contains("backgroundMusic")
            && data.keys.contains("backgroundImage")
            && data.keys.contains("monsters")
    }
}
