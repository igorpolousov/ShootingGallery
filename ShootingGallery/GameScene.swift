//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Igor Polousov on 10.11.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var timeRemaimed = 60 {
        didSet {
            timerLabel.text = "Seconds left: \(timeRemaimed)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var sprite1: SKSpriteNode!
    var sprite2: SKSpriteNode!
    var sprite3: SKSpriteNode!
    
    var gameOver = false
    var gameOverLabel: SKLabelNode!
    
    var gameTimer: Timer?
    var gameTimeCounter: Timer?
    
    var possibleTargets = ["bear", "lion", "penguin", "dontShoot", "franky", "madam", "redHat"]
    
    override func didMove(to view: SKView) {
        
       
        let backGround = SKSpriteNode(imageNamed: "back")
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        backGround.name = "b"
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x: 250, y: 16)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
      
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        timeRemaimed = 60
        
        gameTimeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondsLeft), userInfo: nil, repeats: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
        
    }
    
    @objc func secondsLeft() {
        
        if timeRemaimed >= 1 {
            timeRemaimed -= 1
            
        } else {
            gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.position = CGPoint(x: 500, y: 350)
            gameOverLabel.fontSize = 140
            gameOverLabel.fontColor = .systemRed
            gameOverLabel.zPosition = 1
            gameOverLabel.text = "Game over"
            gameOverLabel.name = "GO"
            addChild(gameOverLabel)
            
            gameTimer?.invalidate()
            gameTimeCounter?.invalidate()
            
            for node in children {
                if node.name != "b" && node.name != "GO" {
                    node.removeFromParent()
                }
            }
          
        }
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
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 7))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 7))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 7))
            
        } else if target == "penguin" || target == "lion" || target == "bear"  {
            sprite1.name = "s"
            sprite2.name = "s"
            sprite3.name = "s"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 3))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 3))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 3))
            
        } else {
            sprite1.name = "s1"
            sprite2.name = "s1"
            sprite3.name = "s1"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 6))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 6))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 6))
        }
        
        sprite1.xScale = 0.25
        sprite1.yScale = 0.25
        
        sprite2.xScale = 0.25
        sprite2.yScale = 0.25
        
        sprite3.xScale = 0.25
        sprite3.yScale = 0.25
        
        sprite1.position = CGPoint(x: 1200, y: 600)
        sprite2.position = CGPoint(x: -200, y: 400)
        sprite3.position = CGPoint(x: 1200, y: 150)
        
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
                score -= 17
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.removeFromParent()
      
            case "s":
                score += 8
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.removeFromParent()
               
            case "s1":
                score += 4
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                node.removeFromParent()
                
            case "b":
                score -= 3
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            default:
                continue
            }
        }
            
    }
    
}
