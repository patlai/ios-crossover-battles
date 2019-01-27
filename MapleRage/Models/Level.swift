//
//  Level.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-27.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

public class Level{
    var Name: String
    var BackgroundMusicPath: String
    var BackgroundImagePath: String
    var Monsters: [Monster]
    
    init(){
        self.Name = ""
        self.BackgroundMusicPath = ""
        self.BackgroundImagePath = ""
        self.Monsters = []
    }
    
    init(_ name: String, _ backgroundMusicPath: String, _ backgroundImagePath: String, _ monsters: [Monster]){
        self.Name = name
        self.BackgroundMusicPath = backgroundMusicPath
        self.BackgroundImagePath = backgroundImagePath
        self.Monsters = monsters
    }
    
    public static func LoadLevelFromJSON(_ path: String) -> Level? {
        let levelData = JSONHelper.ReadFromJSONFile(path)
        
        if(levelData.count > 0 && VerifyLevelData(levelData)){
            let name = levelData["name"] as? String ?? ""
            let bgm = levelData["backgroundMusic"] as? String ?? ""
            let bgi = levelData["backgroundImage"] as? String ?? ""
            
            let monsterData = levelData["monsters"]
            if let monsters = monsterData as? [Dictionary<String, AnyObject>] {
                let monsterObjects = ParseMonsterData(monsters)
                return Level(name, bgm, bgi, monsterObjects)
            } else {
                print("level contains no valid monsters")
            }
        } else{
            print("unable to parse level data")
        }
        return nil
    }
    
    static func ParseMonsterData(_ data: [Dictionary<String, AnyObject>]) -> [Monster]{
        var levelMonsters: Array<Monster> = Array()
        
        for monster in data{
            let name = monster["name"] as? String ?? ""
            let hp = Double(monster["hitpoints"] as? Int ?? 0)
            let animationPrefix = monster["animationPrefix"] as? String ?? ""
            let animationSuffix = monster["animationSuffix"] as? String ?? ""
            let startingFrame = monster["defaultAnimation"] as? String ?? ""
            let damageSound = monster["damageSound"] as? String ?? ""
            let deathSound = monster["deathSound"] as? String ?? ""
            let hitAnimationPath = monster["hitAnimation"] as? String ?? ""
            let numberOfAnimationFrames = monster["numberOfAnimationFrames"] as? Int ?? 0
            
            let currentMonster = Monster(
                name,
                hp,
                startingFrame,
                Monster.getDefaultAnimation(animationPrefix, animationSuffix, numberOfAnimationFrames, 0.2),
                Monster.getSpecialAnimation(hitAnimationPath, 0.2),
                Monster.getSpecialAnimation(hitAnimationPath, 0.2),
                Monster.getSoundClip(damageSound),
                Monster.getSoundClip(deathSound)
            )
            
            levelMonsters.append(currentMonster)
        }
        
        return levelMonsters
    }
    
    static func VerifyLevelData(_ data: Dictionary<String, AnyObject>) -> Bool{
        return data.keys.contains("name")
            && data.keys.contains("backgroundMusic")
            && data.keys.contains("backgroundImage")
            && data.keys.contains("monsters")
    }
}
