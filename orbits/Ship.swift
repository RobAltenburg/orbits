//
//  Ship.swift
//  orbits
//
//  Created by Robert Altenburg on 5/16/15.
//  Copyright (c) 2015 Robert Altenburg. All rights reserved.
//

import SpriteKit

class Ship : SKSpriteNode {
    var id:String?
    var controlLeft:UInt16?
    var controlRight:UInt16?
    var controlThrust:UInt16?
    var controlFire:UInt16?
    
    
    init(imageNamed: String, name: String, controlLeft: UInt16, controlRight: UInt16,
        controlThrust: UInt16, controlFire:UInt16) {
        self.controlLeft = controlLeft
        self.controlRight = controlRight
        self.controlThrust = controlThrust
        self.controlFire = controlFire //49 TODO: Set up missle firing
        let texture = SKTexture(imageNamed: imageNamed)

        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = name
        self.setScale(0.1)
        
        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        if let p = self.physicsBody {
            p.categoryBitMask = BodyType.ship.rawValue
            p.contactTestBitMask = BodyType.star.rawValue | BodyType.weapon.rawValue
            p.collisionBitMask = 0
            p.affectedByGravity = false
            p.allowsRotation = true
            p.dynamic = true;
            p.linearDamping = 0.00
            p.angularDamping = 0.00
            p.mass = 10000.0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func thrust () -> Void {
        let angle = zRotation + CGFloat(M_PI_2)
        physicsBody!.applyImpulse(CGVectorMake(1000 * cos(angle), 1000 * sin(angle)))
    }
    
    func left () -> Void {
        physicsBody!.applyAngularImpulse(0.01)
    }
    func right () -> Void {
        physicsBody!.applyAngularImpulse(-0.01)
    }
    
}

