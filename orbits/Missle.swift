//
//  Missle.swift
//  orbits
//
//  Created by Robert Altenburg on 5/16/15.
//  Copyright (c) 2015 Robert Altenburg. All rights reserved.
//

import SpriteKit

class Missle: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "Missle")
    
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        physicsBody = SKPhysicsBody(texture: texture, size: self.size)
        self.setScale(0.02)
        self.name = "Missle"
        
        if let p = self.physicsBody {
            p.categoryBitMask = BodyType.weapon.rawValue
            p.contactTestBitMask = BodyType.star.rawValue | BodyType.ship.rawValue
            p.collisionBitMask = 0
            p.affectedByGravity = false
            p.allowsRotation = true
            p.dynamic = true;
            p.linearDamping = 0.00
            p.angularDamping = 0.00
            p.mass = 100.0
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

