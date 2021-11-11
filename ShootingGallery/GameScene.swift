//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Igor Polousov on 10.11.2021.
//

import SpriteKit


class GameScene: SKScene {
    
    
    // Надпись с количеством очков
    var scoreLabel: SKLabelNode!
    // Счётчик количества очков
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // Надпись с таймером
    var timerLabel: SKLabelNode!
    // Счетчик таймера
    var timeRemaimed = 60 {
        didSet {
            timerLabel.text = "Seconds left: \(timeRemaimed)"
        }
    }
    
    // Переменные для строк с мишенями в тире
    var sprite1: SKSpriteNode!
    var sprite2: SKSpriteNode!
    var sprite3: SKSpriteNode!
    
    //var gameOver = false
    // Надпись игра закончена
    var gameOverLabel: SKLabelNode!
    
    // Счетчик для таймера
    var gameTimer: Timer?
    // Счётчик для запуска createTarget()
    var gameTimeCounter: Timer?
    
    // надпись с количеством оставшихся пуль
    var bulletsLabel: SKLabelNode!
    // Счётчик пуль
    var bullets = 5 {
        didSet {
            bulletsLabel.text = "Bullets: \(bullets)"
        }
    }
    
    // Надпись перезарядки патронов
    var reloadLabel: SKLabelNode!
    
    // Массив с изображениями целей
    var possibleTargets = ["bear", "lion", "penguin", "dontShoot", "franky", "madam", "redHat"]
    
    // Объекты которые будут на экране при старте
    override func didMove(to view: SKView) {
        
        // MARK!! установлен фон и сейчас он используется для подсчета промахов. Предлагается просто оставить фон, а для подстчёта промахов использовать node(at:)
        let backGround = SKSpriteNode(imageNamed: "back")
        backGround.position = CGPoint(x: 512, y: 384)
        backGround.blendMode = .replace
        backGround.zPosition = -1
        addChild(backGround)
        backGround.name = "b"
        
        // Установка надписи с таймером
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.position = CGPoint(x: 210, y: 16)
        timerLabel.horizontalAlignmentMode = .left
        addChild(timerLabel)
        
        // Установка надписи перезагрузки
        reloadLabel = SKLabelNode(fontNamed: "Chalkduster")
        reloadLabel.position = CGPoint(x: 710, y: 16)
        reloadLabel.horizontalAlignmentMode = .left
        reloadLabel.text = "Reload"
        reloadLabel.fontSize = 50
        reloadLabel.fontColor = .blue
        reloadLabel.name = "R"
        addChild(reloadLabel)
        
        // Установка надписи с оставшимися пулями
        bulletsLabel = SKLabelNode(fontNamed: "Chalkduster")
        bulletsLabel.position = CGPoint(x: 520, y: 16)
        bulletsLabel.horizontalAlignmentMode = .left
        addChild(bulletsLabel)
      
        // Установка надписи с набранными очками
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        // Начальные значения количества очков, секунд и пуль
        score = 0
        timeRemaimed = 60
        bullets = 5
        
        // Запуск таймера для отсчета 60 секунд
        gameTimeCounter = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondsLeft), userInfo: nil, repeats: true)
        
        // Запуск таймера
        gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
    }
    
    // Функция для работы таймера
    @objc func secondsLeft() {
        // Проверка условия остатка секунд в таймере
        if timeRemaimed >= 1 {
            timeRemaimed -= 1
            // Если секунд в таймере нет
        } else {
            // Установка надписи игра закончена
            gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
            gameOverLabel.position = CGPoint(x: 500, y: 350)
            gameOverLabel.fontSize = 140
            gameOverLabel.fontColor = .systemRed
            gameOverLabel.zPosition = 1
            gameOverLabel.text = "Game Over"
            gameOverLabel.name = "GO"
            addChild(gameOverLabel)
            
            // Остановка таймера для целей
            gameTimer?.invalidate()
            // Остановка таймера для секундомера
            gameTimeCounter?.invalidate()
            
            // Удаление всех nodes с экрана кроме фона и надписи GAME OVER
            for node in children {
                if node.name != "b" && node.name != "GO" {
                    node.removeFromParent()
                }
            }
        }
    }
    
    // Функция создания целей
    @objc func createTargets() {
        // Задание рисунков для целей
        guard let target = possibleTargets.randomElement() else { return }
        
        // Объекты для трех линий бегущих целей
        sprite1 = SKSpriteNode(imageNamed: target)
        sprite2 = SKSpriteNode(imageNamed: target)
        sprite3 = SKSpriteNode(imageNamed: target)
        
        // Установка размеров целей
        sprite1.xScale = 0.25
        sprite1.yScale = 0.25
        sprite1.alpha = 1
        
        sprite2.xScale = 0.25
        sprite2.yScale = 0.25
        
        sprite3.xScale = 0.25
        sprite3.yScale = 0.25
        
        // Установка стартовых позиций целей
        sprite1.position = CGPoint(x: 1200, y: 600)
        sprite2.position = CGPoint(x: -200, y: 400)
        sprite3.position = CGPoint(x: 1200, y: 150)
        
        // Добавление объектов в parent node
        addChild(sprite1)
        addChild(sprite2)
        addChild(sprite3)
        
        // Установка скоростей объектов в зависимости от типа объекта
        switch target {
        case "dontShoot":
            sprite1.name = "dontShoot"
            sprite2.name = "dontShoot"
            sprite3.name = "dontShoot"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 7))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 7))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 7))
            
        case "penguin":
            sprite1.name = "s"
            sprite2.name = "s"
            sprite3.name = "s"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 3))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 3))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 3))
            
        case "lion":
            sprite1.name = "s"
            sprite2.name = "s"
            sprite3.name = "s"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 3))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 3))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 3))
            
        case "bear":
            sprite1.name = "s"
            sprite2.name = "s"
            sprite3.name = "s"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 3))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 3))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 3))
            
        default:
            sprite1.name = "s1"
            sprite2.name = "s1"
            sprite3.name = "s1"
            
            sprite1.run(SKAction.move(to: CGPoint(x: -200, y: 600), duration: 6))
            sprite2.run(SKAction.move(to: CGPoint(x: 1200, y: 400), duration: 6))
            sprite3.run(SKAction.move(to: CGPoint(x: -200, y: 150), duration: 6))
        }
    }
    
    // Метод для удаления объектов которые за экраном
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 || node.position.x > 1300 {
                node.removeFromParent()
            }
        }
    }
    
    // Метод в коором определяются действия при касании к экрану
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first  else { return }
        let location = touch.location(in: self)
        let object = nodes(at: location)
        
        // Проверка условия наличия пуль
        if bullets >= 1 {
            for node in object {
                // Условие начисления очков при касании к объектам, !!! Недостаток в том что при касании к экрану происходит обязательное касание к фону, который начисляет очки за промах и если касание по цели, то происходит начисление очков за цель
                switch node.name {
                case "dontShoot":
                    score -= 17
                    let sound = SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false)
                    let fade = SKAction.fadeOut(withDuration: 0.3)
                    let sequence = SKAction.sequence([sound, fade])
                    node.run(sequence)
                    
                    
                case "s":
                    score += 8
                    let sound = SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false)
                    let fade = SKAction.fadeOut(withDuration: 0.3)
                    let sequence = SKAction.sequence([sound, fade])
                    node.run(sequence)
                     
                case "s1":
                    score += 4
                    let sound = SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false)
                    let fade = SKAction.fadeOut(withDuration: 0.3)
                    let sequence = SKAction.sequence([sound, fade])
                    node.run(sequence)
                    
                case "b":
                    score -= 3
                    let sound = SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false)
                    let sequence = SKAction.sequence([sound])
                    node.run(sequence)
                    
                case "R":
                    bullets = 6
                    run(SKAction.playSoundFileNamed("reload.mp3", waitForCompletion: true))
                default:
                    continue
                        
                }
            }
            // Если пули закончились то при касании к надписи reload происходит добавление патронов
        } else if object.contains(reloadLabel) {
            run(SKAction.playSoundFileNamed("reload.mp3", waitForCompletion: true))
            bullets = 5
        }
    }
}
