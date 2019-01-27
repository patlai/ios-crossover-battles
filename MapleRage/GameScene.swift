import SpriteKit

class GameScene: SKScene {
    var monsters: [Monster] = Array()
    var currentMonster = Monster()
    var currentMonsterIndex = 0
    var currentLevel = Level()
    
    //let monsterNode = SKSpriteNode(imageNamed: "mushroom/f0.png")
    let monsterNode = SKSpriteNode()
    var defaultMonsterAnimation = SKAction()
    
    var monsterNameLabel = SKLabelNode()
    let monsterHPLabel = SKLabelNode()
    let defaultFontName = "Avenir"
    
    let label = SKLabelNode(text: "Tap the screen to start")
    let maxLabelSize = 90.0
    let maxDamage = 99999.0
    let minDamage = 10000.0
    let spriteFrameCount = 6
    let defaultFontSize = 45.0
    let labelFontSize = 25.0
    
    var damageSound = SKAction.playSoundFileNamed("sound/mushroom_damage.mp3", waitForCompletion: false)
    
    func updateMonsterHPLabel(_ label: SKLabelNode, _ monster: Monster){
        label.text = String(monster.CurrentHP) + " / " + String(monster.MaxHP)
    }
    
    func handleDeath(_ monster: Monster){
        // get rid of the current monster
        monster.Node.run(monster.DeathAnimation)
        playSound(sound: monster.DeathSound)
        monster.Node.run(SKAction.fadeOut(withDuration: 0.5))
        monster.Node.removeFromParent()
        
        // load the next monster
        currentMonsterIndex += 1
        if (currentMonsterIndex < currentLevel.Monsters.count){
            // there are still monsters in the current level
            loadMonster(
                currentLevel.Monsters[currentMonsterIndex],
                CGPoint( x: frame.width / 2, y: frame.height / 2)
            )
        } else {
            // no more monsters in current level -> load the next level
        }
       
    }
    
    func playSound(sound : SKAction)
    {
        run(sound)
    }
    
    func loadMonster(_ monster: Monster, _ location: CGPoint){
        monsterNameLabel.text = monster.Name
        monsterNameLabel.fontName = defaultFontName
        monsterNameLabel.fontSize = CGFloat(labelFontSize)
        monsterNameLabel.position = CGPoint(x: frame.width / 2, y: 11 * frame.height / 12)
        
        monster.Position = location
        self.addChild(monster.Node)
        monster.Node.run(SKAction.repeatForever(monster.DefaultAnimation))
        currentMonster = monster
    }
    
    func loadLevel(_ level: Level, _ location: CGPoint){
        let levelNameLabel = SKLabelNode(text: level.Name)
        levelNameLabel.fontName = defaultFontName
        levelNameLabel.fontSize = CGFloat(labelFontSize)
        levelNameLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 6)
        self.addChild(levelNameLabel)
        
        let backgroundSound = SKAudioNode(fileNamed: level.BackgroundMusicPath)
        self.addChild(backgroundSound)
        
        let backgroundImage = SKSpriteNode(imageNamed: level.BackgroundImagePath)
        backgroundImage.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        if (backgroundImage.size.height < frame.size.height){
            backgroundImage.size.height = frame.size.height
        }
        else if (backgroundImage.size.width < frame.size.width){
            backgroundImage.size.width = frame.size.width
        }
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        let firstMonster = level.Monsters[currentMonsterIndex]
        loadMonster(firstMonster, location)
        
        currentLevel = level
    }
    
    // runs immediately after the scene is presented
    override func didMove(to view: SKView){
        
        let center = CGPoint(
            x: view.frame.width / 2,
            y: view.frame.height / 2
        )
        
        let monsterHPLocation = CGPoint(
            x: view.frame.width / 2,
            y: 5 * view.frame.height / 6
        )
        
        self.addChild(monsterNameLabel)
        
        monsterHPLabel.position = monsterHPLocation
        monsterHPLabel.fontName = "Avenir"
        monsterHPLabel.fontSize = 24
        self.addChild(monsterHPLabel)
        
        // load the first level from JSON data
        if let level = Level.LoadLevelFromJSON("data/levels/L1"){
           loadLevel(level, center)
        }
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tap)
        )
        view.addGestureRecognizer(recognizer)
    }
    
    func animateDamageLabel(_ label: SKLabelNode){
        let moveByAction = SKAction.moveBy(
            x: 0,
            y: 100,
            duration: 0.25
        )
        
        let fadeinAction = SKAction.fadeIn(withDuration: 0.5)
        let fadeoutAction = SKAction.fadeOut(withDuration: 0.5)
        
        // Reversed action
        let moveByReversedAction = moveByAction.reversed()
        
        // action sequence
        let moveByActions = [SKAction.group([fadeinAction, moveByAction]), SKAction.group([moveByReversedAction, fadeoutAction])]
        let moveSequence = SKAction.sequence(moveByActions)
        let moveRepeatSequence = SKAction.repeat(moveSequence, count: 1)
        
        label.run(moveRepeatSequence, completion: {
            label.removeFromParent()
        })
    }
    
    func showHitAnimation(_ position: CGPoint){
        let hitNode = SKSpriteNode(imageNamed: "hit/hit0.png")
        hitNode.position = position
        let hitAnimation = Monster.getDefaultAnimation("hit/hit", ".png", 4, 0.1)
            
        self.addChild(hitNode)
        hitNode.run(hitAnimation, completion: {
            hitNode.removeFromParent()
        })
        
        playSound(sound: currentMonster.DamageSound)
        currentMonster.Node.run(currentMonster.DamageAnimation)
    }
    
    func handleHit(_ monster: Monster, _ tapPoint: CGPoint){
        let damageLabel = SKLabelNode()
        damageLabel.fontName = "Avenir"
        damageLabel.fontSize = CGFloat(defaultFontSize)
        damageLabel.fontColor = SKColor.yellow
        damageLabel.position = tapPoint
        
        let hit = monster.HitBox.contains(tapPoint)
        
        if (hit){
            var damage = Double.random(in: minDamage ... maxDamage)
            damage.round()
            currentMonster.CurrentHP = max(0, currentMonster.CurrentHP - damage)
            updateMonsterHPLabel(monsterHPLabel, currentMonster)
            
            if (currentMonster.CurrentHP <= 0){
                handleDeath(currentMonster)
            }
            
            let newSize = (2.0/3.0) * (damage / maxDamage) * maxLabelSize
            damageLabel.text = String(damage)
            damageLabel.fontSize = CGFloat(newSize)
    
            showHitAnimation(tapPoint)
        } else {
            damageLabel.text = "MISS"
        }
        
        self.addChild(damageLabel)
        animateDamageLabel(damageLabel)
    }
    
    @objc func tap (recognizer: UIGestureRecognizer){
        let viewLocation = recognizer.location(in: view)
        let tapLocation = convertPoint(fromView: viewLocation)
        handleHit(currentMonster, tapLocation)
    }
}
