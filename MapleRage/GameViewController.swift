import SpriteKit

class GameViewController: UIViewController{
    override func viewDidLoad(){
        let scene = GameScene(size: view.frame.size)
        scene.controller = self
        let skView = view as! SKView
        skView.presentScene(scene)
    }
    
    func showAlert(_ title: String = "", _ message: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
