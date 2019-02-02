//
//  UIHelper.swift
//  CrossoverBattles
//
//  Created by Patrick Lai on 2019-02-01.
//  Copyright © 2019 Patrick Lai. All rights reserved.
//

import Foundation
import SpriteKit

public class UIHelper{
    
    /// Plays a haptic feedback of the specified strength
    public static func vibrateWithHaptic(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Adds a button to the speicied view at the chosen position relative to that view
    public static func addButton(_ button: inout SKSpriteNode, _ view: SKScene, _ iconPath: String, x: CGFloat, y: CGFloat){
        button = SKSpriteNode(imageNamed: iconPath)
        button.position = CGPoint(x: x, y: y)
        view.addChild(button)
    }
}
