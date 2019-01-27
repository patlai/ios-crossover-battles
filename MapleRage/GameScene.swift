import SpriteKit

class Monster{
    var MaxHP: Double
    var CurrentHP: Double
    var Node: SKSpriteNode
    var DefaultAnimation: SKAction
    var DamageAnimation: SKAction
    var DeathAnimation: SKAction
    var DamageSound: SKAction
    var DeathSound: SKAction
    
    init(){
        self.MaxHP = 0
        self.CurrentHP = 0
        self.DefaultAnimation = SKAction()
        self.DamageAnimation = SKAction()
        self.DeathAnimation = SKAction()
        self.DamageSound = SKAction()
        self.DeathSound = SKAction()
        self.Node = SKSpriteNode()
    }
    
    init (_ MaxHP: Double, _ StartingFrame: String, _ DefaultAnimation: SKAction, _ DamageAnimation: SKAction, _ DeathAnimation: SKAction, _ DamageSound: SKAction, _ DeathSound: SKAction){
        self.MaxHP = MaxHP
        self.CurrentHP = MaxHP
        self.DefaultAnimation = DefaultAnimation
        self.DamageAnimation = DamageAnimation
        self.DeathAnimation = DeathAnimation
        self.DamageSound = DamageSound
        self.DeathSound = DeathSound
        self.Node = SKSpriteNode(imageNamed: StartingFrame)
    }
}

class GameScene: SKScene {
    var monsters: [Monster] = Array()
    var currentMonster = Monster()
    
    //let monsterNode = SKSpriteNode(imageNamed: "mushroom/f0.png")
    let monsterNode = SKSpriteNode()
    var defaultMonsterAnimation = SKAction()
    
    let monsterHPLabel = SKLabelNode()
    
    let label = SKLabelNode(text: "Tap the screen to start")
    let maxLabelSize = 90.0
    let maxDamage = 99999.0
    let minDamage = 10000.0
    let spriteFrameCount = 6
    
    var damageSound = SKAction.playSoundFileNamed("sound/mushroom_damage.mp3", waitForCompletion: false)
    
    func getDefaultAnimation(_ prefix: String, _ suffix: String, _ numberOfFrames: Int, _ frameDuration: Double) -> SKAction{
        var frames: [SKTexture] = Array()
        for i in 0 ..< numberOfFrames {
            let current = SKTexture.init(imageNamed: prefix + String(i) + suffix)
            frames.append(current)
        }
        
        return SKAction.animate(with: frames, timePerFrame: frameDuration)
    }
    
    func getSpecialAnimation(_ spritePath: String, _ frameDuration: Double) -> SKAction {
        return SKAction.animate(with: Array([SKTexture.init(imageNamed: spritePath)]), timePerFrame: frameDuration )
    }
    
    func getSoundClip(_ soundFilePath: String, _ wait: Bool = false) -> SKAction {
        return SKAction.playSoundFileNamed(soundFilePath, waitForCompletion: wait)
    }
    
    func updateMonsterHPLabel(_ label: SKLabelNode, _ monster: Monster){
        label.text = String(monster.CurrentHP) + " / " + String(monster.MaxHP)
    }
    
    func handleDeath(_ monster: Monster){
        // get rid of the current monster
        monster.Node.run(monster.DeathAnimation)
        playSound(sound: monster.DeathSound)
        monster.Node.run(SKAction.fadeOut(withDuration: 0.5))
        
        // load the next monster
    }
    
    func playSound(sound : SKAction)
    {
        run(sound)
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
        
        var mushmom = Monster(
            1000000.0,
            "mushroom/f0.png",
            getDefaultAnimation("mushroom/f", ".png", 6, 0.15),
            getSpecialAnimation("mushroom/f_hit.png", 0.3),
            getSpecialAnimation("mushroom/f_hit.png", 0.3),
            getSoundClip("sound/mushroom_damage.mp3"),
            getSoundClip("sound/mushroom_death.mp3")
        )
        mushmom.Node.position = center
        monsters.append(mushmom)
        
//        var frames: [SKTexture] = Array()
//        for i in 0 ..< spriteFrameCount {
//            let current = SKTexture.init(imageNamed: "mushroom/f" + String(i) + ".png")
//            frames.append(current)
//        }
//
//        defaultMonsterAnimation = SKAction.animate(with: frames, timePerFrame: 0.15)
//        monsterNode.position = center
//        monsterNode.run(SKAction.repeatForever(defaultMonsterAnimation))
     
        currentMonster = monsters[0]
        self.addChild(currentMonster.Node)
        currentMonster.Node.run(SKAction.repeatForever(currentMonster.DefaultAnimation))
        
        monsterHPLabel.position = monsterHPLocation
        monsterHPLabel.fontName = "Avenir"
        monsterHPLabel.fontSize = 24
        addChild(monsterHPLabel)
        
        let backgroundSound = SKAudioNode(fileNamed: "sound/hhg_theme.mp3")
        self.addChild(backgroundSound)
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tap)
        )
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func tap (recognizer: UIGestureRecognizer){
        let viewLocation = recognizer.location(in: view)
        let tapLocation = convertPoint(fromView: viewLocation)
        
        var damage = Double.random(in: minDamage ... maxDamage)
        damage.round()
        currentMonster.CurrentHP = max(0, currentMonster.CurrentHP - damage)
        updateMonsterHPLabel(monsterHPLabel, currentMonster)
        
        if (currentMonster.CurrentHP <= 0){
            handleDeath(currentMonster)
        }
        
        let newSize = (2.0/3.0) * (damage / maxDamage) * maxLabelSize
        let damageLabel = SKLabelNode()
        damageLabel.fontName = "GillSans-UltraBold"
        damageLabel.text = String(damage)
        damageLabel.fontSize = CGFloat(newSize)
        damageLabel.fontColor = SKColor.yellow
      
        //let moveToAction = SKAction.move(to: sceneLocation, duration: 1)
        damageLabel.position = tapLocation
        self.addChild(damageLabel)
        let moveByAction = SKAction.moveBy(
            x: 0,
            y: 100,
            duration: 0.25
        )
        
        let rotateByAction = SKAction.rotate(
            byAngle: 20,
            duration: 0.5
        )
        let rotateByReversedAction = rotateByAction.reversed()
        
        let fadeinAction = SKAction.fadeIn(withDuration: 0.5)
        let fadeoutAction = SKAction.fadeOut(withDuration: 0.5)
        
        // Reversed action
        let moveByReversedAction = moveByAction.reversed()
        let moveByActions = [SKAction.group([fadeinAction, moveByAction]), SKAction.group([moveByReversedAction, fadeoutAction])]
        let moveSequence = SKAction.sequence(moveByActions)
        let moveRepeatSequence = SKAction.repeat(moveSequence, count: 1)
        damageLabel.run(moveRepeatSequence)
        playSound(sound: currentMonster.DamageSound)
        
        currentMonster.Node.run(currentMonster.DamageAnimation)
        //monsterNode.run(SKAction.animate(with: Array([SKTexture.init(imageNamed: "mushroom/f_hit.png")]), timePerFrame: 0.3 ))
        //monsterNode.run(SKAction.repeatForever(defaultMonsterAnimation))

        //damageLabel.removeFromParent()
    }
}
