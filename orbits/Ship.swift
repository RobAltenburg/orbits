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
    var canFire = true
    
    override func removeFromParent() {
        canFire = false
        super.removeFromParent()
    }
    
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
        physicsBody!.applyImpulse(CGVectorMake(100000 * cos(angle), 1000 * sin(angle)))
    }
    
    func left () -> Void {
        physicsBody!.applyAngularImpulse(10.0)
    }
    func right () -> Void {
        physicsBody!.applyAngularImpulse(-10.0)
    }
    // F
    func fire(scene: SKScene, inout missle: [Missle]) {
        
        if canFire {
            let angle = self.zRotation + CGFloat(M_PI_2)
            let x = self.position.x + cos(angle) * 50
            let y = self.position.y + sin(angle) * 50
        
            //println("Angle: \((angle / 3.14) * 180 )")
            let dx = cos(angle) * 250
            let dy = sin(angle) * 250
        
            missle.append(Missle())
            missle.last!.position = CGPoint(x:x, y:y)
            missle.last!.zRotation = self.zRotation
            //s.position
            missle.last!.physicsBody!.velocity = CGVector(dx: dx, dy: dy)
            scene.addChild(missle.last!)
        
        }}
}

