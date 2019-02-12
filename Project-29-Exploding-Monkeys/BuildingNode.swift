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
    
    var currentImage: UIImage!
    
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    private func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
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
    
    func hitAt(point: CGPoint) {
//        1. Figure out where the building was hit. Remember: SpriteKit's positions things from the center and Core Graphics from the bottom left!
        let convertedPoint = CGPoint(x: point.x + size.width / 2.0, y: abs(point.y - (size.height / 2.0)))
//        2. Create a new Core Graphics context the size of our current sprite.
        let renderer = UIGraphicsImageRenderer(size: size)
//        3. Draw our current building image into the context. This will be the full building to begin with, but it will change when hit.
        let img = renderer.image { ctx in
            currentImage.draw(at: CGPoint(x: 0, y: 0))
            
//        4. Create an ellipse at the collision point. The exact co-ordinates will be 16 points up and to the left of the collision, then 32x32 in size - an ellipse centered on the impact point.
            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 16, y: convertedPoint.y - 16, width: 32, height: 32))
//        5. Set the blend mode .clear then draw the ellipse, literally cutting an ellipse out of our image.
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }

//        6. Convert the contents of the Core Graphics context back to a UIImage, which is saved in the currentImage property for next time we're hit, and used to update our building texture.
        texture = SKTexture(image: img)
        currentImage = img
        
//        7. Call configurePhysics() again so that SpriteKit will recalculate the per-pixel physics for our damaged building.
        configurePhysics()
    }
}
