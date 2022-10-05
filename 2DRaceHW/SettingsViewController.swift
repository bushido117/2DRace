//
//  SettingsViewController.swift
//  2DRaceHW
//
//  Created by Вадим Сайко on 30.09.22.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "road"))
        imageView.contentMode = .scaleToFill
        imageView.frame = UIScreen.main.bounds
        return imageView
    }()
    let myCarsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "myCar"))
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 160, y: 330, width: 71, height: 131)
        return imageView
    }()
    let enemyCarsImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "policeCar"))
        imageView.contentMode = .scaleToFill
        imageView.frame = CGRect(x: 160, y: 610, width: 71, height: 131)
        return imageView
    }()
    let playerNicknameTextField: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        textField.placeholder = "Enter your nickname"
        textField.textAlignment = .center
        textField.backgroundColor = .blue.withAlphaComponent(0)
        textField.text = UserDefaults.standard.string(forKey: "playerNickname")
        textField.font = .systemFont(ofSize: 25)
        textField.layer.cornerRadius = 15
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    lazy var segmentedControllerForMyCar: UISegmentedControl = {
        let segmentedController = UISegmentedControl(items: ["1", "2"])
        segmentedController.frame = CGRect(x: 120, y: 470, width: 150, height: 40)
        segmentedController.backgroundColor = .blue
        segmentedController.addTarget(self, action: #selector(segmentForMyCarChange(_:)), for: .valueChanged)
        return segmentedController
    }()
    lazy var segmentedControllerForEnemyCar: UISegmentedControl = {
        let segmentedController = UISegmentedControl(items: ["1", "2"])
        segmentedController.frame = CGRect(x: 120, y: 750, width: 150, height: 40)
        segmentedController.backgroundColor = .blue
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        view.addSubview(backToMenuButton)
        view.addSubview(myCarsImageView)
        view.addSubview(enemyCarsImageView)
        view.addSubview(segmentedControllerForMyCar)
        view.addSubview(segmentedControllerForEnemyCar)
        view.addSubview(playerNicknameTextField)
        initializeHideKeyboard()
        setImagesForCarsImageViews()
        playerNicknameTextField.delegate = self
    }
    
    @objc func backToMenuButtonTap() {
        dismiss(animated: true)
    }
    @objc func segmentForMyCarChange(_ action: UISegmentedControl) {
        if action == segmentedControllerForMyCar {
            let segmentIndex = action.selectedSegmentIndex
            if segmentIndex == 0 {
                myCarsImageView.image = UIImage(named: "myCar")
            } else {
                myCarsImageView.image = UIImage(named: "blackCar")
            }
            UserDefaults.standard.set(segmentIndex, forKey: "myCarSegmentIndex")
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
            UserDefaults.standard.set(segmentIndex, forKey: "enemyCarSegmentIndex")
        }
    }
    func setImagesForCarsImageViews() {
        let selectedSegmentIndexEnemyCar = UserDefaults.standard.integer(forKey: "enemyCarSegmentIndex")
        if selectedSegmentIndexEnemyCar == 0 {
            segmentedControllerForEnemyCar.selectedSegmentIndex = 0
            enemyCarsImageView.image = UIImage(named: "policeCar")
        } else {
            segmentedControllerForEnemyCar.selectedSegmentIndex = 1
                enemyCarsImageView.image = UIImage(named: "truck")
        }
        let selectedSegmentIndexMyCar = UserDefaults.standard.integer(forKey: "myCarSegmentIndex")
        if selectedSegmentIndexMyCar == 0 {
            segmentedControllerForMyCar.selectedSegmentIndex = 0
            myCarsImageView.image = UIImage(named: "myCar")
        } else {
            segmentedControllerForMyCar.selectedSegmentIndex = 1
            myCarsImageView.image = UIImage(named: "blackCar")
        }
    }
    func initializeHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(playerNicknameTextField.text, forKey: "playerNickname")
    }
}
