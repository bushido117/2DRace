//
//  GameplayViewController.swift
//  2DRaceHW
//
//  Created by Вадим Сайко on 19.09.22.
//

import UIKit

struct Score: Codable {
    var score: Int
}

class GameplayViewController: UIViewController {
    var scoresArray: [Score] = {
        do {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
                .appendingPathComponent("score.json")
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let scores = try decoder.decode([Score].self, from: data)
            return scores
        } catch {
            print(error.localizedDescription)
            return []
        }
    }()
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 30, y: 50, width: 80, height: 65)
        label.text = "0"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.3)
        label.layer.cornerRadius = 20
        label.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        label.layer.borderWidth = 4
        label.clipsToBounds = true
        return label
    }()
    let myCar: UIImageView = {
        let myCar = UIImageView(image: UIImage(named: ProjectImages.sportCarImage))
        myCar.tintColor = .white
        myCar.frame = CGRect(x: 15, y: 730, width: 50, height: 75)
        let segment = UserDefaults.standard.integer(forKey: UserDefaultsKeys.myCarSegmentIndex)
        if segment == 0 {
            myCar.image = UIImage(named: ProjectImages.sportCarImage)
        } else {
            myCar.image = UIImage(named: ProjectImages.blackCarImage)
        }
        return myCar
    }()
    lazy var moveMyCarGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(gestureTapped))
        return gesture
    }()
    let road: UIView = {
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
        addSubviews()
    }
    
    func addSubviews() {
        view.addSubview(road)
        view.addSubview(myCar)
        view.addGestureRecognizer(moveMyCarGesture)
        view.addSubview(scoreLabel)
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
            UIView.animate(withDuration: 1.65, delay: 0, options: [.curveLinear]) { [unowned self] in
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
        let policeCar = UIImageView(image: UIImage(named: ProjectImages.policeCarImage))
        let segment = UserDefaults.standard.integer(forKey: UserDefaultsKeys.enemyCarSegmentIndex)
        if segment == 0 {
            policeCar.image = UIImage(named: ProjectImages.policeCarImage)
        } else {
            policeCar.image = UIImage(named: ProjectImages.truckImage)
        }
        policeCar.frame.size = CGSize(width: 50, height: 75)
        let trafficLine = Int.random(in: 0...3)
        if trafficLine == 0 {
            policeCar.frame.origin = CGPoint(x: 15, y: -100)
        } else if trafficLine == 1 {
            policeCar.frame.origin = CGPoint(x: 125, y: -100)
        } else if trafficLine == 2 {
            policeCar.frame.origin = CGPoint(x: 222, y: -100)
        } else if trafficLine == 3 {
            policeCar.frame.origin = CGPoint(x: 320, y: -100)
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
                self?.scoreLabel.text = "\(self?.scoreCounter ?? 0)"
                intersectsTimer.invalidate()
            }
        }
    }
    @objc func backToMenuButtonTap() {
        scoresArray.append(Score(score: scoreCounter))
        writeJSON(scores: scoresArray)
        dismiss(animated: true)
    }
    func writeJSON(scores: [Score]) {
        do {
            let fileURL = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
                .appendingPathComponent("score.json")
            let encoder = JSONEncoder()
            try encoder.encode(scoresArray).write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }
}
