//
//  JSONHelper.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-27.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

class JSONHelper{
    
    public static func ReadFromJSONFile(_ filePath: String) -> Dictionary<String, AnyObject> {
        var p = Bundle.main.path(forResource: filePath, ofType: "json")
        if let path = Bundle.main.path(forResource: filePath, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    print("Successfully parsed " + filePath)
                    return jsonResult
                }
            } catch {
                print("couldn't parse file: " + filePath)
            }
        } else {
            print("couldn't find path to JSON file")
        }
        
        // return an empty dict if parsing failed
        return [:]
    }
    
}
