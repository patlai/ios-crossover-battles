import SpriteKit

class GameScene: SKScene {
    let player = Player.Shared
    
    var canHitMonster: Bool = true
    
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
    
    var playerLevelLabel = SKLabelNode()
    var playerAttackLabel = SKLabelNode()
    var playerExpLabel = SKLabelNode()
    var playerExpBar = SKShapeNode()
    var killCountLabel = SKLabelNode()
    
    let label = SKLabelNode(text: "Tap the screen to start")
    let maxLabelSize = 90.0
    let maxDamage = 99999.0
    let minDamage = 10000.0
    let spriteFrameCount = 6
    let defaultFontSize = 45.0
    let labelFontSize = 25.0
    let uiFontSize = 16.0
    
    var damageSound = SKAction.playSoundFileNamed("sound/mushroom_damage.mp3", waitForCompletion: false)
    
    func updateMonsterHPLabel(_ label: SKLabelNode, _ monster: Monster){
        label.text = String(Int(monster.CurrentHP)) + " / " + String(Int(monster.MaxHP))
    }
    
    func playSound(sound : SKAction)
    {
        run(sound)
    }
    
    func loadUi(_ view: SKView){
        let monsterHPLocation = CGPoint(
            x: view.frame.width / 2,
            y: 5.25 * view.frame.height / 6
        )
        
        let uiBackgroundWidth = self.frame.width
        let uiBackgroundHeight = self.frame.height / 6
        let margin = 4
        let horizontalOffset = 10
        
        let uiBackground = SKShapeNode(rectOf: CGSize(width: uiBackgroundWidth, height: uiBackgroundHeight))
        uiBackground.fillColor = SKColor.gray
        uiBackground.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 12)
        uiBackground.zPosition = -10
        
        self.addChild(monsterNameLabel)
        
        monsterHPLabel.position = monsterHPLocation
        monsterHPLabel.fontName = "Avenir"
        monsterHPLabel.fontSize = 24
        self.addChild(monsterHPLabel)
        
        playerLevelLabel = SKLabelNode(text: "LV: " + String(player.Level))
        playerLevelLabel.fontName = "Avenir-Medium"
        playerLevelLabel.fontSize = CGFloat(uiFontSize)
        playerLevelLabel.fontColor = SKColor.yellow
        playerLevelLabel.horizontalAlignmentMode = .left
        //playerLevelLabel.verticalAlignmentMode = .top
       
        playerLevelLabel.position = CGPoint(
            x: -uiBackgroundWidth / 2 + CGFloat(horizontalOffset),
            y: uiBackgroundHeight / 4
        )
        uiBackground.addChild(playerLevelLabel)
        
        playerAttackLabel = SKLabelNode(text: "ATT: " + String(player.Attack))
        playerAttackLabel.fontName = defaultFontName
        playerAttackLabel.fontSize = CGFloat(uiFontSize)
        playerAttackLabel.horizontalAlignmentMode = .left
        playerAttackLabel.position = CGPoint(
            x: playerLevelLabel.position.x,
            y: playerLevelLabel.position.y - playerLevelLabel.fontSize - CGFloat(margin)
        )
        uiBackground.addChild(playerAttackLabel)
        
        playerExpBar = SKShapeNode(rectOf: CGSize(
            width: uiBackgroundWidth,
            height: 20))
        playerExpBar.fillColor = SKColor.yellow
        playerExpBar.position = CGPoint(
            x: 0,//playerLevelLabel.position.x + 50,
            y: -10
        )
        playerExpBar.zPosition = 1
        
        playerExpLabel.fontSize = CGFloat(uiFontSize)
        playerExpLabel.fontName = defaultFontName
        playerExpLabel.fontColor = SKColor.black
        playerExpLabel.position = CGPoint(
            x: 0,
            y: -10
        )
        playerExpLabel.zPosition = 20
        uiBackground.addChild(playerExpLabel)
        uiBackground.addChild(playerExpBar)
        
        updateExpLabel()
        
        killCountLabel.text = "Kills: " + String(player.NumberOfKills)
        killCountLabel.fontName = defaultFontName
        killCountLabel.fontSize = CGFloat(uiFontSize)
        killCountLabel.fontColor = SKColor.white
        killCountLabel.position = CGPoint(
            x: 0,
            y: killCountLabel.fontSize * 2
        )
        uiBackground.addChild(killCountLabel)
        
        self.addChild(uiBackground)
    }
    
    func loadMonster(_ monster: Monster, _ location: CGPoint){
        monsterNameLabel.text = monster.Name
        monsterNameLabel.fontName = defaultFontName
        monsterNameLabel.fontSize = CGFloat(labelFontSize)
        monsterNameLabel.position = CGPoint(x: frame.width / 2, y: 11 * frame.height / 12)
        
        monster.CurrentHP = monster.MaxHP
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
        backgroundImage.zPosition = -1000
        self.addChild(backgroundImage)
        
        let firstMonster = level.Monsters[currentMonsterIndex]
        loadMonster(firstMonster, location)
        
        currentLevel = level
    }
    
    // runs immediately after the scene is presented
    override func didMove(to view: SKView){
        view.ignoresSiblingOrder = false
        
        let center = CGPoint(
            x: view.frame.width / 2,
            y: view.frame.height / 2
        )
        
        loadUi(view)
        
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
    
    func updateExpLabel(){
        let scale = (CGFloat(player.CurrentExp) / CGFloat(player.ExpToNextLevel))
        playerExpLabel.text = String(player.CurrentExp) + " / " + String(player.ExpToNextLevel)
        playerExpBar.xScale = scale
        playerExpBar.position = CGPoint(
            x: -self.frame.width / 2 + (scale * self.frame.width / 2) + 10,
            y: 0
        )
    }
    
    func handleLevelUp(){
        player.levelUp()
        playerLevelLabel.text = "LV: " + String(player.Level)
        playerAttackLabel.text = "ATT: " + String(player.Attack)
        
        let levelUpAnimation = Monster.getDefaultAnimation("sprites/level_up/l", ".png", 21, 0.1)
        let levelUpSound = Monster.getSoundClip("sprites/level_up/sound.mp3")
        let levelUpAnimationNode = SKSpriteNode(imageNamed: "sprites/level_up/l0.png")
        levelUpAnimationNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 4)
        levelUpAnimationNode.zPosition = 20
        
        self.playSound(sound: levelUpSound)
        self.addChild(levelUpAnimationNode)
        levelUpAnimationNode.run(levelUpAnimation, completion: {
            levelUpAnimationNode.removeFromParent()
        })
    }
    
    func giveExp (_ amount: Int){
        player.CurrentExp += amount
        if (player.CurrentExp >= player.ExpToNextLevel){
            handleLevelUp()
        }
        updateExpLabel()
    }
    
    func handleDeath(_ monster: Monster){
        giveExp(monster.Exp)
        
        self.canHitMonster = false
        // get rid of the current monster
        self.playSound(sound: monster.DeathSound)
        monster.Node.run(monster.DeathAnimation, completion: {
            monster.Node.removeFromParent()
            
            // load the next monster
            self.currentMonsterIndex = Int.random(in: 0 ..< self.currentLevel.Monsters.count)
            self.monsterHPLabel.text = ""
            if (self.currentMonsterIndex < self.currentLevel.Monsters.count){
                // there are still monsters in the current level
                self.loadMonster(
                    self.currentLevel.Monsters[self.currentMonsterIndex],
                    CGPoint( x: self.frame.width / 2, y: self.frame.height / 2)
                )
            } else {
                // no more monsters in current level -> load the next level
            }
            self.canHitMonster = true
        })
        player.NumberOfKills += 1
        killCountLabel.text = "Kills: " + String(player.NumberOfKills)
    }
    
    func handleHit(_ monster: Monster, _ tapPoint: CGPoint){
        let damageLabel = SKLabelNode()
        damageLabel.fontName = "Avenir-Medium"
        damageLabel.fontSize = CGFloat(defaultFontSize)
        damageLabel.fontColor = SKColor.yellow
        damageLabel.position = tapPoint
        
        let hit = monster.HitBox.contains(tapPoint)
        
        if (hit){
            let attackResult = player.attackMonster(monster)
            let damage = attackResult.0
            let isCriticalHit = attackResult.1
            
            currentMonster.CurrentHP = max(0, currentMonster.CurrentHP - damage)
            updateMonsterHPLabel(monsterHPLabel, currentMonster)
            
            if (currentMonster.CurrentHP <= 0){
                handleDeath(currentMonster)
            }
            
            damageLabel.text = String(Int(damage))
            if (isCriticalHit){
                damageLabel.fontColor = SKColor.orange
                damageLabel.fontName = "Avenir-Black"
                damageLabel.fontSize *= 1.5
            }
    
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
        if (canHitMonster){
            handleHit(currentMonster, tapLocation)
        }
    }
}
