import SpriteKit

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
    let defaultFontSize = 45.0
    
    var damageSound = SKAction.playSoundFileNamed("sound/mushroom_damage.mp3", waitForCompletion: false)
    
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
        
        let mushmom = Monster(
            1000000.0,
            "mushroom/f0.png",
            Monster.getDefaultAnimation("mushroom/f", ".png", 6, 0.15),
            Monster.getSpecialAnimation("mushroom/f_hit.png", 0.3),
            Monster.getSpecialAnimation("mushroom/f_hit.png", 0.3),
            Monster.getSoundClip("sound/mushroom_damage.mp3"),
            Monster.getSoundClip("sound/mushroom_death.mp3")
        )
        
        mushmom.Position = center
        monsters.append(mushmom)
     
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
