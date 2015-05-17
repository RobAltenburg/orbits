//
//  EndScene.swift
//  
//
//  Created by Robert Altenburg on 5/15/15.
//
//

import SpriteKit


class EndScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = NSColor.blackColor()
        
        var replayButton = SKLabelNode(text: "Replay Game")
        replayButton.fontSize = 40
        replayButton.fontColor = SKColor.cyanColor()
        replayButton.position = CGPointMake(self.size.width/2, self.size.height * 0.25)
        replayButton.name = "replay"
        
        self.addChild(replayButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func mouseDown(theEvent: NSEvent) {
        let scene = GameScene(size: self.size)
        self.view?.presentScene(scene, transition: SKTransition.crossFadeWithDuration(1))
    }
}