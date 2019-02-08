//
//  JSONHelper.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-01-27.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation

class IOHelper{
    
    
    /// Reads data from a JSON file
    ///
    /// - Parameter filePath: the path to the JSON file
    /// - Returns: the properties as a dictionary
    public static func ReadFromJSONFile(_ filePath: String) -> Dictionary<String, AnyObject> {
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
    
    
    /// Gets the list of files in a given folder
    ///
    /// - Parameter path: the folder
    /// - Returns: the list of files in that folder
    public static func GetFileNames(_ path: String) -> Array<String> {
        let fileManager = FileManager.default
        do {
            let p = Bundle.main.resourceURL!.appendingPathComponent(path).path
            let files = try fileManager.contentsOfDirectory(atPath: p)
            return files
        } catch {
            print (error)
            print("Error while enumerating files at " + path)
            return []
        }
    }
    
    
    public static func GetFilePathsWithoutExtension(_ path: String) -> [String]{
        let fileNames = GetFileNames(path)
        var paths: Array<String> = Array()
        for name in fileNames {
            paths.append(path + "/" + NSString(string: name).deletingPathExtension)
        }
        return paths
    }
    
}
