//
//  ViewController.swift
//  Swift4Playing
//
//  Created by Josh on 10/2/17.
//

import UIKit

class ViewController: UIViewController {
    var popularGames = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.getPopularGames {  [weak self] (games) in
            guard let `self` = self else { return }
            if let games = games {
                self.popularGames = games
                print("Found \(String(describing: self.popularGames.count)) Games")
                
                // Now that all of these games have been decoded into Swift Objects.
                // Let's...go ahead and encode them back into JSON.
                for game in self.popularGames {
                    do {
                        let jsonAsData = try JSONEncoder().encode(game)
                        let jsonAsString = String(data: jsonAsData, encoding: String.Encoding.utf8)
                        print(jsonAsString ?? "ERROR ENCODING!")
                        return
                        
                    } catch {
                        print("AHHHH Can't Encode back to JSON")
                    }
                }
            }
        }
    }
    
}

