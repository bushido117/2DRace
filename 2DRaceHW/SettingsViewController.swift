//
//  SettingsViewController.swift
//  2DRaceHW
//
//  Created by Вадим Сайко on 30.09.22.
//

import UIKit

//protocol SettingsViewControllerDelegate: AnyObject {
//    func myCarPick(_ segmentIndex: Int)
//    func enemyCarPick()
//    func playerNameEnter()
//}
class SettingsViewController: UIViewController {
//    weak var myCarPickDelegate: SettingsViewControllerDelegate?
    lazy var segmentedControllerForMyCar: UISegmentedControl = {
        let segmentedController = UISegmentedControl(items: ["1", "2"])
        segmentedController.frame = CGRect(x: 90, y: 340, width: 150, height: 40)
        segmentedController.backgroundColor = .blue
        segmentedController.selectedSegmentIndex = 1
        segmentedController.addTarget(self, action: #selector(segmentForMyCarChange(_:)), for: .valueChanged)
        return segmentedController
    }()
    lazy var segmentedControllerForEnemyCar: UISegmentedControl = {
        let segmentedController = UISegmentedControl(items: ["1", "2"])
        segmentedController.frame = CGRect(x: 90, y: 680, width: 150, height: 40)
        segmentedController.backgroundColor = .blue
        segmentedController.selectedSegmentIndex = 0
        segmentedController.addTarget(self, action: #selector(segmentForEnemyCarChange(_:)), for: .valueChanged)
        return segmentedController
    }()
    lazy var backToMenuButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 15, y: 50, width: 50, height: 50)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 4
        button.setTitle("←", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(backToMenuButtonTap), for: .touchUpInside)
        return button
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "road"))
        imageView.contentMode = .scaleToFill
        imageView.frame = UIScreen.main.bounds
        return imageView
    }()
    let myCarsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "myCar"))
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 130, y: 200, width: 71, height: 131)
        return imageView
    }()
    let enemyCarsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "policeCar"))
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 130, y: 550, width: 71, height: 131)
        return imageView
    }()
    lazy var playerNameTextField: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 130, y: 750, width: 200, height: 30)
        textField.placeholder = "Enter your nickname"
        textField.borderStyle = .roundedRect
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(backToMenuButton)
        view.addSubview(myCarsImageView)
        view.addSubview(enemyCarsImageView)
        view.addSubview(segmentedControllerForMyCar)
        view.addSubview(segmentedControllerForEnemyCar)
        view.addSubview(playerNameTextField)
        initializeHideKeyboard()
    }
    
    @objc func backToMenuButtonTap() {
        dismiss(animated: true)
    }
    
    @objc func segmentForMyCarChange(_ action: UISegmentedControl) {
        if action == segmentedControllerForMyCar {
            let segmentIndex = action.selectedSegmentIndex
//            myCarPickDelegate?.myCarPick(segmentIndex)
            if segmentIndex == 0 {
                myCarsImageView.image = UIImage(named: "myCar")
            } else {
                myCarsImageView.image = UIImage(named: "blackCar")
            }
        }
    }
    
    @objc func segmentForEnemyCarChange(_ action: UISegmentedControl) {
        if action == segmentedControllerForEnemyCar {
            let segmentIndex = action.selectedSegmentIndex
            if segmentIndex == 0 {
                enemyCarsImageView.image = UIImage(named: "policeCar")
            } else {
                enemyCarsImageView.image = UIImage(named: "truck")
            }
        }
    }
    func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
   
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
}
