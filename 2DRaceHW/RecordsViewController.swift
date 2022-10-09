//
//  RecordsViewController.swift
//  2DRaceHW
//
//  Created by Вадим Сайко on 30.09.22.
//

import UIKit

class RecordsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ProjectImages.backgroundImage))
        imageView.contentMode = .scaleToFill
        imageView.frame = UIScreen.main.bounds
        return imageView
    }()
    let highScoresLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 100, width: 300, height: 100)
        label.text = "\(UserDefaults.standard.string(forKey: UserDefaultsKeys.playerNickname) ?? "")'s highscores"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    let highScoresTableView: UITableView = {
        let tableView = UITableView()
        tableView.frame = CGRect(x: 160, y: 210, width: 70, height: 220)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    let cellArray = ["1", "2", "3", "4", "5"]
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
        addSubviews()
        highScoresTableView.delegate = self
        highScoresTableView.dataSource = self
    }
    
    func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(backToMenuButton)
        view.addSubview(highScoresLabel)
        view.addSubview(highScoresTableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let scoresArray: [Score] = {
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
        let sortedScoresArray = scoresArray.sorted { $0.score < $1.score }
        if let scoreNumber = sortedScoresArray[safe: (sortedScoresArray.count - 1) - indexPath.row]?.score {
            cell.textLabel?.text = cellArray[indexPath.row] + ". " + "\(scoreNumber)"
        }
        return cell
    }
    @objc func backToMenuButtonTap() {
        dismiss(animated: true)
    }
}
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
