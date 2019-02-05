//
//  Rarity.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-02-02.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

class Rarity{
    
    enum ItemRarity{
        case common
        case uncommon
        case rare
        case legendary
    }
    
    public static func ConvertRateToRarity(_ rate: Double) -> ItemRarity{
        if (rate >= 0.9){
            return ItemRarity.legendary
        } else if (rate >= 0.7){
            return ItemRarity.rare
        } else if (rate >= 0.4){
            return ItemRarity.uncommon
        }
        
        return ItemRarity.common
    }
}
