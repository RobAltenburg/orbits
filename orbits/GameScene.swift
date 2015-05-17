//
//  GameScene.swift
//  orbits
//
//  Created by Robert Altenburg on 5/13/15.
//  Copyright (c) 2015 Robert Altenburg. All rights reserved.
//

import SpriteKit


enum BodyType:UInt32 {
    case star = 1
    case ship = 2
    case weapon = 4
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let star = SKSpriteNode(imageNamed:"Sun")
    
    let ship = [Ship(imageNamed: "Spaceship", name: "Player One", controlLeft: 123, controlRight: 124, controlThrust: 126, controlFire: 49),
    Ship(imageNamed: "Ship2", name: "Player Two", controlLeft: 0, controlRight: 2,
        controlThrust: 13, controlFire: 1)]
    
    var missle = [Missle]()
    
    
    override func didMoveToView(view: SKView) {
        
        //set up physics
        physicsWorld.contactDelegate = self
        let gravField = SKFieldNode.radialGravityField(); // Create grav field
        gravField.position = CGPoint(x: size.width/2.0, y: size.height/2)
        addChild(gravField); // Add to world
        
        // setting graphics
        self.backgroundColor = NSColor.blackColor()
        
        // set up star in center
        star.position = gravField.position
        star.setScale(0.08)
        star.name = "Star"
        star.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Sun"), size: star.size)
        if let physics = star.physicsBody {
            physics.dynamic = false
            physics.categoryBitMask = BodyType.star.rawValue
        }
        self.addChild(star)
        
        // place the ships
        ship[0].position = CGPoint(x: size.width * 0.25, y:size.height * 0.5)
        ship[0].physicsBody?.velocity = CGVectorMake(0, 100)
        self.addChild(ship[0])
        
        ship[1].position = CGPoint(x: size.width * 0.75, y:size.height * 0.5)
        ship[1].physicsBody?.velocity = CGVectorMake(0, -100)
        self.addChild(ship[1])
    }
   
    func endGame() {
       
      
        self.runAction(SKAction.waitForDuration(4), completion: {
            let scene = EndScene(size: self.size)
            self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(2))
        })
            
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        var actionBody:SKPhysicsBody
        var otherBody:SKPhysicsBody

        switch(contactMask) {
     
        // contactMask 3 = ship hit the star
        case BodyType.ship.rawValue | BodyType.star.rawValue:
            
            // make sure action takes place on the ship
            if contact.bodyA.node!.name == "Star" {
                actionBody = contact.bodyB
            } else {
                actionBody = contact.bodyA
            }
            
            explosion(actionBody.node!.position)
            actionBody.node!.removeFromParent()
            endGame()

            
        // contactMask = 5: weapon hit star
        case BodyType.weapon.rawValue | BodyType.star.rawValue:
            
            // make sure action takes place on the ship
            if contact.bodyA.node!.name == "Star" {
                actionBody = contact.bodyB
            } else {
                actionBody = contact.bodyA
            }
            
            actionBody.node!.removeFromParent()
            
            
        // contactMask = 5: weapon hit ship
        case BodyType.weapon.rawValue | BodyType.ship.rawValue:
        
            // make sure action takes place on the ship
            if contact.bodyA.node!.name == "Missle" {
                actionBody = contact.bodyB
                otherBody = contact.bodyA
            } else {
                actionBody = contact.bodyA
                otherBody = contact.bodyB
            }
            
            explosion(actionBody.node!.position)
            actionBody.node!.removeFromParent()
            otherBody.node!.removeFromParent()
            endGame()

        default:
            println("Uncaught contact made: \(contactMask)")
            return
            
        }
    }
    
    func explosion(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "explosion.sks")
        emitterNode.particlePosition = pos
        self.addChild(emitterNode)
        // Don't forget to remove the emitter node after the explosion
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode.removeFromParent() })
        
    }
    
    // F
    func fire(s: Ship) {
       
        let angle = s.zRotation + CGFloat(M_PI_2)
        let x = s.position.x + cos(angle) * 50
        let y = s.position.y + sin(angle) * 50
        
        //println("Angle: \((angle / 3.14) * 180 )")
        let dx = cos(angle) * 250
        let dy = sin(angle) * 250

        missle.append(Missle())
        missle.last!.position = CGPoint(x:x, y:y)
        missle.last!.zRotation = s.zRotation
            //s.position
        missle.last!.physicsBody!.velocity = CGVector(dx: dx, dy: dy)
        self.addChild(missle.last!)
        
    }
    
    override func keyDown(theEvent: NSEvent) {
      
        //println(theEvent.keyCode)
        // respond to ship events
        for s in ship {
            if theEvent.keyCode == s.controlThrust {
                s.thrust()
            } else if theEvent.keyCode == s.controlLeft {
                s.left()
            } else if theEvent.keyCode == s.controlRight {
                s.right()
            } else if theEvent.keyCode == s.controlFire {
                fire(s)
            } /*else {
                println("Key: \(theEvent.keyCode)")
            }*/
            
        }
        
    }
   
    func screenWrap(node:SKSpriteNode)->Void {
        
        // wrap if object exits screen
        if node.position.x < 0 {
            node.position.x = size.width
        } else if node.position.x > size.width {
            node.position.x = 0
        }
        if node.position.y < 0 {
            node.position.y = size.height
        } else if node.position.y > size.height {
            node.position.y = 0
        }
    }
  
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        for s in ship {
            screenWrap(ship[0])
        }
        
        
    }
}
