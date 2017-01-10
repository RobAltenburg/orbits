//
//  EndScene.swift
//  
//
//  Created by Robert Altenburg on 5/15/15.
//
//

import SpriteKit


class EndScene: SKScene {
    
    let replayButton = SKLabelNode(text: "Replay Game")

    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = NSColor.black
        
        
        let label = SKLabelNode(text: "Game Over")
        label.fontSize = 40
        label.position = CGPoint(x: size.width/2, y: size.height * 0.75)
        self.addChild(label)
        
       
        //let replayButton = SKLabelNode(text: "Replay Game")
        replayButton.fontSize = 40
        replayButton.fontColor = SKColor.cyan
        replayButton.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.25)
        replayButton.name = "replay"
        
       
        // put a rectangle around the button
        let rx = replayButton.position.x - 120
        let ry = replayButton.position.y - 10
        let rect = SKShapeNode(rect: CGRect(x: rx, y: ry, width: 240, height: 50 ))
        
        
        self.run(SKAction.wait(forDuration: 1), completion: {
                self.addChild(self.replayButton)
                self.addChild(rect)
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func mouseDown(with theEvent: NSEvent) {
        
        let scene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1)) }
}
