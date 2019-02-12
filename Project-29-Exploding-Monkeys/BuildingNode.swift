//
//  BuildingNode.swift
//  Project-29-Exploding-Monkeys
//
//  Created by verebes on 09/02/2019.
//  Copyright © 2019 A&D Progress. All rights reserved.
//

import SpriteKit
import GameplayKit

class BuildingNode: SKSpriteNode {
    
    var currentImega: UIImage!
    
    func setup() {
        name = "building"
        
        currentImega = drawBuilding(size: size)
        texture = SKTexture(image: currentImega)
        
        configurePhysics()
    }
    
    private func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody!.categoryBitMask = CollisionTypes.banana.rawValue
    }
    
    private func drawBuilding(size: CGSize) -> UIImage {
        //1-Create a new Core Graphics Context
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            //2-Fill it with a rectangle that's one of three colors.
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let color: UIColor
            
            switch GKRandomSource.sharedRandom().nextInt(upperBound: 3) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            //3-Draw windows all over the building in one of two colors: either light on (yellow) or not (gray)
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 5, to: Int(size.height - 5), by: 20) {
                for col in stride(from: 5, to: Int(size.width - 5), by: 20) {
                    if Bool.random() {
                        ctx.cgContext.setFillColor(lightOnColor.cgColor)
                    } else {
                        ctx.cgContext.setFillColor(lightOffColor.cgColor)
                    }
                    
                    ctx.cgContext.fill(CGRect(x: col, y: row, width: 8, height: 10))
                }
            }
        }
        //4-Return the result as an UIImage to use elsewhere
        return img
    }
}
