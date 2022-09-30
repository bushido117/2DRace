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
        button.addTarget(self, action: #selector(playButtonTap(_:)), for: .touchUpInside)
        return button
    }()
    lazy var recordsButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 130, y: 400, width: 150, height: 50)
        button.backgroundColor = .yellow
        button.setTitle("Records", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(recordsButtonTap(_:)), for: .touchUpInside)
        return button
    }()
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 320, y: 50, width: 50, height: 50)
        button.backgroundColor = .yellow
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.imageView?.tintColor = .black
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 4
        button.addTarget(self, action: #selector(settingsButtonTap(_:)), for: .touchUpInside)
        return button
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
        view.addSubview(recordsButton)
        view.addSubview(settingsButton)
    }
    
    @objc func playButtonTap (_ action: Any) {
        let vc = GameplayViewController()
        vc.gameplayVCDelegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func settingsButtonTap (_ action: Any) {
        let vc = SettingsViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func recordsButtonTap (_ action: Any) {
        let vc = RecordsViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func scoreCounterToVC(_ scoreCounter: Int) {
//        if scoreCounter > highScore {
//            highScore = scoreCounter
//            self.recordsLabel.text = "  High score: \(highScore)"
//        }
    }
}
