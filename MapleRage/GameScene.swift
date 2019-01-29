import SpriteKit
import AVFoundation

class GameScene: SKScene {
    let player = Player.Shared
    var currentLevelNumber = 0
    var controller = GameViewController()
    
    var canHitMonster: Bool = true
    
    var monsters: [Monster] = Array()
    var currentMonster = Monster()
    var currentMonsterIndex = 0
    var currentLevel = Level()
    var levelFiles = Level.getLevelFiles()
    
    //let monsterNode = SKSpriteNode(imageNamed: "mushroom/f0.png")
    let monsterNode = SKSpriteNode()
    var defaultMonsterAnimation = SKAction()
    
    var monsterNameLabel = SKLabelNode()
    let monsterHPLabel = SKLabelNode()
    let defaultFontName = "Avenir"
    
    var specialAttackButton = SKSpriteNode()
    var superDamageButton = SKSpriteNode()
    var superExpButton = SKSpriteNode()
    var levelUpButton = SKSpriteNode()
    
    var backgroundMusicPlayer = AVAudioPlayer()
    var backgroundSound = SKAudioNode()
    var isBgmLoaded = false
    
    var levelNameLabel = SKLabelNode()
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
        
    func updateMonsterHPLabel(_ label: SKLabelNode, _ monster: Monster){
        label.text = String(Int(monster.CurrentHP)) + " / " + String(Int(monster.MaxHP))
    }
    
    func playSound(sound : SKAction)
    {
        run(sound)
    }
    
    
    /// Plays a background track using the AVAudioPlayer
    ///
    /// - Parameter filename: path to the audio file
    func playBackgroundMusic(_ filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            if (isBgmLoaded){
                backgroundMusicPlayer.setVolume(0, fadeDuration: 2)
            }
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
            backgroundMusicPlayer.setVolume(1, fadeDuration: 1)
            isBgmLoaded = true
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
    /// Loads the UI
    ///
    /// - Parameter view: the associated view
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
        playerExpBar.zPosition = 2
        
        playerExpLabel.fontSize = CGFloat(uiFontSize)
        playerExpLabel.fontName = defaultFontName
        playerExpLabel.fontColor = SKColor.black
        playerExpLabel.position = CGPoint(
            x: 0,
            y: -10
        )
        playerExpLabel.zPosition = 3
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
        
        let iconOffset = CGFloat(36.0)
        
        specialAttackButton = SKSpriteNode(imageNamed: "sprites/genesis/icon.png")
        specialAttackButton.position = CGPoint(x: self.frame.width - 16, y: 2 * self.frame.height / 3)
        self.addChild(specialAttackButton)
        
        superDamageButton = SKSpriteNode(imageNamed: "sprites/super_damage/icon.png")
        superDamageButton.position = CGPoint(x: self.frame.width - 16, y: 2 * self.frame.height / 3 - iconOffset)
        self.addChild(superDamageButton)
        
        superExpButton = SKSpriteNode(imageNamed: "sprites/holy_symbol/icon.png")
        superExpButton.position = CGPoint(x: self.frame.width - 16, y: 2 * self.frame.height / 3 - iconOffset * 2)
        self.addChild(superExpButton)
        
        levelUpButton = SKSpriteNode(imageNamed: "sprites/maple_warrior/icon.png")
        levelUpButton.position = CGPoint(x: self.frame.width - 16, y: 2 * self.frame.height / 3 - iconOffset * 3)
        self.addChild(levelUpButton)
    }
    
    
    /// Loads a monster and spawns it at the selected point
    ///
    /// - Parameters:
    ///   - monster: <#monster description#>
    ///   - location: <#location description#>
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
    
    /// Loads the files containing level data from the level data directory
    func getLevelData(){
        
    }
    
    
    /// Loads a level and its sprites into the game scene
    func loadLevel(_ level: Level, _ location: CGPoint){
        levelNameLabel.text = level.Name
        levelNameLabel.fontName = defaultFontName
        levelNameLabel.fontSize = CGFloat(labelFontSize)
        levelNameLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 6)
        if (!self.children.contains(levelNameLabel)){
             self.addChild(levelNameLabel)
        }
        
        playBackgroundMusic(level.BackgroundMusicPath)
        
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
        
        let firstMonster = level.Monsters[0]
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

        if (self.levelFiles.count <= 0){
            print("no level data found")
            exit(1)
        }
        
         // load the first level from JSON data
        if let level = Level.LoadLevelFromJSON(levelFiles[currentLevelNumber]){
           loadLevel(level, center)
        }
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tap)
        )
        view.addGestureRecognizer(recognizer)
    }
    
    func getLabelPopupAnimation() -> SKAction {
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
        
        return moveRepeatSequence
    }
    
    func animateDamageLabel(_ label: SKLabelNode){
        label.run(getLabelPopupAnimation(), completion: {
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
    
    func updateAttackLabel(){
        playerAttackLabel.text = "ATT: " + String(player.Attack) + (player.AttackMultiplier > 1.0 ? " (x" + String(player.AttackMultiplier) + ")" : "")
    }
    
    func handleLevelUp(){
        player.levelUp()
        playerLevelLabel.text = "LV: " + String(player.Level)
        updateAttackLabel()
        
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
    
    func showPopupLabel (_ text: String){
        let popUpLabel = SKLabelNode(text: text)
        popUpLabel.fontSize = CGFloat(defaultFontSize)
        popUpLabel.fontName = defaultFontName
        popUpLabel.position = CGPoint(x: self.frame.width / 2, y: 1.75 * self.frame.height / 3)
        self.addChild(popUpLabel)
        popUpLabel.run(getLabelPopupAnimation(), completion: {
            popUpLabel.removeFromParent()
        })
    }
    
    func showExpGainLabel (_ amount: Int){
        showPopupLabel("+" + String(amount) + " EXP")
    }
    
    func giveExp (_ amount: Int){
        player.CurrentExp += amount
        if (player.CurrentExp >= player.ExpToNextLevel){
            handleLevelUp()
        }
        showExpGainLabel(amount)
        updateExpLabel()
    }
    
    func handleDeath(_ monster: Monster){
        let amount = Int(Double(monster.Exp) * player.ExpRate)
        giveExp(amount)
        
        self.canHitMonster = false
        // get rid of the current monster
        self.playSound(sound: monster.DeathSound)
        monster.Node.run(monster.DeathAnimation, completion: {
            monster.Node.removeFromParent()
            
            // load the next monster
            self.currentMonsterIndex = Int.random(in: 0 ..< self.currentLevel.Monsters.count)
            self.monsterHPLabel.text = ""
            if (self.player.NumberOfKills < self.currentLevel.KillsRequired
                || self.currentLevel.IsCompleted
                || self.currentLevelNumber >= self.levelFiles.count - 1){
                // there are still monsters in the current level
                // or the level is already complete and the player is revisiting it
                // or there are no more levels to load
                // -> spawn the next monster
                self.loadMonster(
                    self.currentLevel.Monsters[self.currentMonsterIndex],
                    CGPoint( x: self.frame.width / 2, y: self.frame.height / 2)
                )
            } else {
                // no more monsters in current level and the player has completed it for the first time
                // -> load the next level
                self.currentLevel.IsCompleted = true
                self.currentLevelNumber += 1
                if let level = Level.LoadLevelFromJSON(self.levelFiles[self.currentLevelNumber]){
                    let center = CGPoint(
                        x: self.frame.width / 2,
                        y: self.frame.height / 2
                    )
                    self.loadLevel(level, center)
                }
            }
            self.canHitMonster = true
        })
        player.NumberOfKills += 1
        killCountLabel.text = "Kills: " + String(player.NumberOfKills)
    }
    
    func dealDamageToMonster(_ monster: Monster, _ damage: Double, _ point: CGPoint, _ isCrit: Bool, _ label: SKLabelNode){
        currentMonster.CurrentHP = max(0, currentMonster.CurrentHP - damage)
        updateMonsterHPLabel(monsterHPLabel, currentMonster)
        
        label.text = String(Int(damage))
        if (isCrit){
            label.fontColor = SKColor.orange
            label.fontName = "Avenir-Black"
            label.fontSize *= 1.5
        }
        
        if (currentMonster.CurrentHP <= 0){
            handleDeath(currentMonster)
        }
        
        showHitAnimation(point)
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
            
            dealDamageToMonster(monster, damage, tapPoint, isCriticalHit, damageLabel)
        } else {
            damageLabel.text = "MISS"
        }
        
        self.addChild(damageLabel)
        animateDamageLabel(damageLabel)
    }
    
    
    func handleSpecialAttack(_ monster: Monster, _ tapPoint: CGPoint){
        let overlay = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: self.frame.height), cornerRadius: 0)
        overlay.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        overlay.fillColor = SKColor.black
        overlay.strokeColor = SKColor.black
        overlay.alpha = 0.0
        overlay.zPosition = -1
        self.addChild(overlay)
        
        let fadeinAction = SKAction.fadeAlpha(to: CGFloat(0.5), duration: 0.5)
        let fadeoutAction = SKAction.fadeOut(withDuration: 0.5)
        
        overlay.run(fadeinAction)
        
        let genesisAngelAnimation = Monster.getDefaultAnimation("sprites/genesis/angel/a_", ".png", 20, 0.15)
        let genesisAngelNode = SKSpriteNode(imageNamed: "sprites/genesis/angel/a_0.png")
        genesisAngelNode.position = CGPoint(x: self.frame.width / 2, y: 2 * self.frame.height / 5)
        self.addChild(genesisAngelNode)
        
        let genesisSkyAnimation1 = Monster.getDefaultAnimation("sprites/genesis/sky/a_", ".png", 10, 0.15)
        let genesisSkyNode1 = SKSpriteNode(imageNamed: "sprites/genesis/sky/a_0.png")
        genesisSkyNode1.position = CGPoint(x: self.frame.width / 2, y: 3.3 * self.frame.height / 5)
        self.addChild(genesisSkyNode1)
        
        let genesisSkyAnimation2 = Monster.getDefaultAnimation("sprites/genesis/sky/a_", ".png", 11, 0.15, 10)
        let genesisSkyNode2 = SKSpriteNode(imageNamed: "sprites/genesis/sky/a_10.png")
        genesisSkyNode2.position = CGPoint(x: self.frame.width / 2, y: 3.3 * self.frame.height / 5)
        
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        genesisAngelNode.run(genesisAngelAnimation, completion: {
            genesisAngelNode.removeFromParent()
            genesisSkyNode1.run(genesisSkyAnimation1, completion: {
                genesisSkyNode1.removeFromParent()
                
                let damageLabel = SKLabelNode()
                damageLabel.position = CGPoint(x: self.frame.width / 2, y: 1.1 * self.frame.height / 2)
                damageLabel.fontSize = CGFloat(self.defaultFontSize)
                damageLabel.zPosition = 10
                self.addChild(damageLabel)
                self.animateDamageLabel(damageLabel)
                
                self.addChild(genesisSkyNode2)
                self.dealDamageToMonster(self.currentMonster, 9999999.0, center, true, damageLabel)
                genesisSkyNode2.run(genesisSkyAnimation2, completion:{
                    genesisSkyNode2.removeFromParent()
                })
            })
        })
        
        run(SKAction.playSoundFileNamed("sound/omae_wa.mp3", waitForCompletion: true), completion: {
            overlay.run(fadeoutAction, completion: {
                overlay.removeFromParent()
            })
        })
    }
    
    func toggleSuperDamage(){
        player.ToggleSuperAttack()
        showPopupLabel("Super damage: " + (player.HasSuperAttack ? "ON" : "OFF"))
        updateAttackLabel()
    }
    
    func toggleSuperExp(){
        player.ToggleSuperExp()
        showPopupLabel("Super EXP: " + (player.HasSuperExp ? "ON" : "OFF"))
    }
    
    @objc func tap (recognizer: UIGestureRecognizer){
        let viewLocation = recognizer.location(in: view)
        let tapLocation = convertPoint(fromView: viewLocation)
        if (canHitMonster){
            if(specialAttackButton.frame.contains(tapLocation)){
                handleSpecialAttack(currentMonster, tapLocation)
            } else if (superDamageButton.frame.contains(tapLocation)){
                toggleSuperDamage()
            } else if (superExpButton.frame.contains(tapLocation) ){
                toggleSuperExp()
            } else if (levelUpButton.frame.contains(tapLocation) ){
                handleLevelUp()
            } else {
                self.handleHit(currentMonster, tapLocation)
            }
        }
    }
}
