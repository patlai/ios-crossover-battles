import SpriteKit

class GameViewController: UIViewController{
    override func viewDidLoad(){
        let scene = GameScene(size: view.frame.size)
        let skView = view as! SKView
        skView.presentScene(scene)
    }
}


