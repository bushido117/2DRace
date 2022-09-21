//
//  ViewController.swift
//  2DRaceHW
//
//  Created by Вадим Сайко on 19.09.22.
//

import UIKit

class ViewController: UIViewController, GameplayViewControllerDelegate {
    var highScore = 0
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 130, y: 300, width: 150, height: 50)
        button.backgroundColor = .yellow
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(playRaceGame(_:)), for: .touchUpInside)
        return button
    }()
    lazy var recordsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 130, y: 400, width: 150, height: 50)
        label.backgroundColor = .yellow
        label.text = "  High score:"
        label.textColor = .black
        label.layer.cornerRadius = 20
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.borderWidth = 4
        label.clipsToBounds = true
        return label
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "road"))
        imageView.contentMode = .scaleToFill
        imageView.frame = UIScreen.main.bounds
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(playButton)
        view.addSubview(recordsLabel)
    }
    
    @objc func playRaceGame (_ action: Any) {
        let vc = GameplayViewController()
        vc.gameplayVCDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func scoreCounterToVC(_ scoreCounter: Int) {
        if scoreCounter > highScore {
            highScore = scoreCounter
            self.recordsLabel.text = "  High score: \(highScore)"
        }
    }
}

