//
//  ViewController.swift
//  RickUserDefault
//
//  Created by Рахим Габибли on 03.07.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var tableView: UITableView!
    let image = UIImageView()
    let networkManager = NetworkManager()


    var characters = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.rowHeight = 150

        networkManager.getCharacters { [weak self] characters in


            if let savedData = UserDefaults.standard.data(forKey: "characters") {
                do {
                    let savedCharacters = try JSONDecoder().decode([Character].self, from: savedData)
                    self?.characters = savedCharacters
                    print("Characters loaded from UserDefaults")
                } catch {
                    print("Error loaded characters from UserDefaults: ", error.localizedDescription)
                }
            } else {
                self?.characters = characters
                self?.networkManager.saveCharactersToUserDefaults(characters)
                print("Characters loaded from network")
            }

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.dataSource = self

        tableView.snp.makeConstraints { make in
            make.top.bottom.height.width.equalToSuperview()
        }

    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }


        let character = characters[indexPath.row]

        guard let url = URL(string: character.image) else { return cell }
        DispatchQueue.global(qos: .utility).async {
            guard let imageData = try? Data(contentsOf: url) else { return }

            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell else { return }
                cell.configure(
                    imageData: imageData,
                    name: character.name,
                    species: character.species,
                    gender: character.gender,
                    origin: character.origin.name,
                    status: character.status
                )
            }
        }
        return cell
    }

}

