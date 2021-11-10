//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Igor Polousov on 10.11.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var sprite1: SKSpriteNode!
    var sprite2: SKSpriteNode!
    var sprite3: SKSpriteNode!
    
    var gameOver = false
    var gameTimer: Timer?
    var possibleTargets = ["bear", "lion", "penguin", "dontShoot", "franky", "madam", "redHat"]
    
    //var possibleTargets = ["ball", "hammer", "tv"]
   
    override func didMove(to view: SKView) {
        
        backgroundColor = .darkGray
      
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
        
    }
    
    @objc func createTargets() {
        guard let target = possibleTargets.randomElement() else { return }
        
        sprite1 = SKSpriteNode(imageNamed: target)
        sprite2 = SKSpriteNode(imageNamed: target)
        sprite3 = SKSpriteNode(imageNamed: target)
        
        if target == "dontShoot" {
            sprite1.name = "dontShoot"
            sprite2.name = "dontShoot"
            sprite3.name = "dontShoot"
        } else if target == "penguin" || target == "lion" || target == "bear"  {
            sprite1.name = "s"
            sprite2.name = "s"
            sprite3.name = "s"
        } else {
            sprite1.name = "s1"
            sprite2.name = "s1"
            sprite3.name = "s1"
        }
        
       
        
        
        
        
        sprite1.xScale = 0.2
        sprite1.yScale = 0.2
        
        sprite2.xScale = 0.2
        sprite2.yScale = 0.2
        
        sprite3.xScale = 0.2
        sprite3.yScale = 0.2
        
        sprite1.texture = SKTexture(imageNamed: target)
        
        sprite1.position = CGPoint(x: 1200, y: 600)
        sprite2.position = CGPoint(x: -200, y: 400)
        sprite3.position = CGPoint(x: 1200, y: 150)
        
        sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 7))
        sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 7))
        sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 7))
        
        addChild(sprite1)
        addChild(sprite2)
        addChild(sprite3)
        
       
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1300 {
                node.removeFromParent()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else { return }
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        for node in object {
            switch node.name {
            case "dontShoot":
                score -= 20
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.removeFromParent()
      
            case "s":
                score += 5
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.removeFromParent()
               
            case "s1":
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.removeFromParent()
                
            default:
                score -= 1
            }
        }
            
    }
    
}
