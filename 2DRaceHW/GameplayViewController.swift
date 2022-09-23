//
//  GameplayViewController.swift
//  2DRaceHW
//
//  Created by Вадим Сайко on 19.09.22.
//

import UIKit

protocol GameplayViewControllerDelegate: AnyObject {
    func scoreCounterToVC(_ scoreCounter: Int)
}

class GameplayViewController: UIViewController {
    weak var gameplayVCDelegate: GameplayViewControllerDelegate?
    lazy var myCar: UIImageView = {
        let myCar = UIImageView(image: UIImage(named: "myCar"))
        myCar.frame = CGRect(x: 15, y: 730, width: 50, height: 75)
        return myCar
    }()
    lazy var moveMyCarGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(gestureTapped))
        return gesture
    }()
    lazy var road: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.frame = UIScreen.main.bounds
        return view
    }()
    var roadStripTimer: Timer?
    var carsTimer: Timer?
    var scoreCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(road)
        view.addSubview(myCar)
        view.addGestureRecognizer(moveMyCarGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        roadStripTimer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(createRoadStrip),
            userInfo: nil,
            repeats: true)
        carsTimer = Timer.scheduledTimer(
            timeInterval: 0.6,
            target: self,
            selector: #selector(createCars),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func createRoadStrip() {
        for i in 1...3 {
            let view = UIView(frame: CGRect(x: 97.5 * Double(i), y: -100, width: 10, height: 40))
                view.backgroundColor = .white
            UIView.animate(withDuration: 2) { [unowned self] in
                view.frame.origin.y += 1100
                self.road.addSubview(view)
            } completion: { _ in
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func gestureTapped() {
        let translation = moveMyCarGesture.translation(in: self.view)
        let newX = myCar.center.x + translation.x
        myCar.center.x = newX
        moveMyCarGesture.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc func createCars() {
        let policeCar = UIImageView(image: UIImage(named: "policeCar"))
        policeCar.frame.size = CGSize(width: 50, height: 75)
        let trafficLine = Int.random(in: 0...3)
        if trafficLine == 0 {
            policeCar.frame.origin = CGPoint(x: 15, y: -200)
        } else if trafficLine == 1 {
            policeCar.frame.origin = CGPoint(x: 125, y: -200)
        } else if trafficLine == 2 {
            policeCar.frame.origin = CGPoint(x: 222, y: -200)
        } else if trafficLine == 3 {
            policeCar.frame.origin = CGPoint(x: 320, y: -200)
        }
        self.view.addSubview(policeCar)
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] intersectsTimer in
            policeCar.frame.origin.y += 7
            if policeCar.frame.intersects(self?.myCar.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)) {
                self?.moveMyCarGesture.isEnabled = false
                let backToMenuButton = UIButton()
                backToMenuButton.setTitle("Back to menu", for: .normal)
                backToMenuButton.backgroundColor = .red
                backToMenuButton.frame.size = CGSize(width: 200, height: 100)
                backToMenuButton.addTarget(self, action: #selector(self?.backToMenuButtonTap), for: .touchUpInside)
                self?.view.addSubview(backToMenuButton)
                backToMenuButton.center = self?.view.center ?? CGPoint(x: 0, y: 0)
                intersectsTimer.invalidate()
                self?.roadStripTimer?.invalidate()
                self?.carsTimer?.invalidate()
                self?.roadStripTimer = nil
                self?.carsTimer = nil
            }
            if policeCar.frame.origin.y > 1100 {
                policeCar.removeFromSuperview()
                self?.scoreCounter += 1
                intersectsTimer.invalidate()
            }
        }
    }
    
    @objc func backToMenuButtonTap() {
        gameplayVCDelegate?.scoreCounterToVC(scoreCounter)
        dismiss(animated: true)
    }
}
