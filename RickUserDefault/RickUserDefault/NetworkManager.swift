//
//  NetworkManager.swift
//  RickUserDefault
//
//  Created by Рахим Габибли on 03.07.2024.
//

import Foundation

struct ReturnedClass: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let image: String
    let species: String
    let gender: String
    let status: String
    let origin: Location
}

struct Location: Codable {
    let name: String
}

class NetworkManager {

    let defaults = UserDefaults.standard
    let urlString = "https://rickandmortyapi.com/api/character"

    func getCharacters(complition: @escaping ([Character]) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Error URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            guard let data else {
                print("No data")
                return
            }

            do {
                let characters = try JSONDecoder().decode(ReturnedClass.self, from: data).results
                print("Good")

                    complition(characters)

            } catch {
                print("Error", error.localizedDescription)
            }
        }.resume()

    }

    func saveCharactersToUserDefaults(_ characters: [Character]) {
        do {
            let encodedData = try JSONEncoder().encode(characters)
            defaults.setValue(encodedData, forKey: "characters")
            print("Characters saved to UserDefaults")
        } catch {
            print("Error saving characters to UserDefaults: ", error.localizedDescription)
        }
    }

}
