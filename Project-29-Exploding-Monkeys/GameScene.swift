//
//  GameScene.swift
//  Project-29-Exploding-Monkeys
//
//  Created by verebes on 09/02/2019.
//  Copyright © 2019 A&D Progress. All rights reserved.
//

import SpriteKit
import GameplayKit

enum CollisionTypes: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene {
    
    var buildings = [BuildingNode]()
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    var currentPlayer = 1
    
    //Reference to the viewController so that the GameScene can comunicate to it
    weak var  viewController: GameViewController!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        
        createBuildings()
        createPlayers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    private func createBuildings() {
        var currentX: CGFloat = -8
        
        while currentX < 667 {
            let size = CGSize(width: Int.random(in: 3 ... 5) * 20, height: Int.random(in: 100 ... 200))
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }
    }
    
    private func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "player")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player1.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(x: player1Building.position.x, y: player1Building.position.y + ((player1Building.size.height + player1.size.height) / 2))
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "player")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player2.physicsBody?.collisionBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(x: player2Building.position.x, y: player2Building.position.y + ((player2Building.size.height + player2.size.height) / 2))
        addChild(player2)
    }
    
    func launch(angle: Int, velocity: Int) {
//        1. Figure out how hard to throw the banana. We accept a velocity parameter and divide it by 10.
        let speed = Double(velocity) / 10.0
//        2. Convert the input angle to radians.
        let radians = deg2rad(degrees: angle)
//        3. If somehow there's a banana already, we'll remove it then create a new one using circle physics.
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = CollisionTypes.banana.rawValue
        banana.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue | CollisionTypes.building.rawValue
        banana.physicsBody?.collisionBitMask = CollisionTypes.player.rawValue | CollisionTypes.building.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
//        4. If player 1 was throwing the banana, we position it up and to the left of the player and give it some spin.
        if currentPlayer == 1 {
            throwBanana(player: 1, angle: radians, speed: speed)
        } else {
//        7. If player 2 was throwing the banana, we position it up and to the right, apply the opposite spin, then make it move in the correct direction.
            throwBanana(player: 2, angle: radians, speed: speed)
        }
        

        
    }
    private func throwBanana(player: Int, angle: Double, speed: Double) {
        banana.position = CGPoint(x: player == 1 ? player1.position.x - 30 : player2.position.x + 30, y: player == 1 ? player1.position.y + 40 : player2.position.y + 40)
        banana.physicsBody?.angularVelocity = player == 1 ? -20 : 20
        //        Animate player 1 or player 2 throwing their arm up then putting it down again.
        let raiseArm = SKAction.setTexture(SKTexture(imageNamed: player == 1 ? "player1Throw" : "player2Throw"))
        let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
        let pause = SKAction.wait(forDuration: 0.15)
        let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
        player == 1 ? player1.run(sequence) : player2.run(sequence)
        //        Make the banana move in the correct direction.
        let impulse = CGVector(dx: player == 1 ? cos(angle) * speed : cos(angle) * -speed, dy: sin(angle) * speed)
        banana.physicsBody?.applyImpulse(impulse)
    }
    
    private func deg2rad(degrees: Int) -> Double {
        return Double(degrees) * Double.pi / 180.0
    }

}
