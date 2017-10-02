//
//  API.swift
//  Swift4Playing
//
//  Created by Josh on 10/2/17.
//

import Foundation
import Alamofire

class APIService {
    // MARK: Constants
    private enum Constants {
        enum urls {
            static let base = "https://api.twitch.tv/kraken"
            static let popularGames = "\(Constants.urls.base)/games/top"
        }
        enum config {
            // TODO: To use this - include your Twitch API Client ID - this is the client-id from the twitch documentation page
            // Not guaranteed to work always.
            static let clientId = "uo6dggojyb8d6soh92zknwmi5ej1q2"
        }
    }
}

// MARK: GAMES
extension APIService {
    typealias PopularGamesResponseHandler = (_ popularGames: [Game]?) -> Void
    static func getPopularGames(_ responseHandler: @escaping PopularGamesResponseHandler) {
        DispatchQueue.global().async {
            let headers: HTTPHeaders = ["Client-ID": Constants.config.clientId]
            let request = Alamofire.request(Constants.urls.popularGames, method: .get, parameters: nil, headers: headers)
            
            request.responseData { (response) in
                if let json = response.result.value {
                    do {
                        let popularGames = try JSONDecoder().decode(PopularGames.self, from: json)
                        let toReturn = popularGames.games.flatMap({ $0.game })
                        responseHandler(toReturn)
                    } catch {
                        print("Unable to decode!")
                        responseHandler(nil)
                    }
                }
            }
        }
    }
}
