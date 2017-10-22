//
//  Game.swift
//  Swift4Playing
//
//  Created by Josh on 10/2/17.
//

struct PopularGames : Codable {
    let totalGamesOnTwitch: Int64
    let games: [GameViewerDetails]
    
    enum CodingKeys: String, CodingKey {
        case games = "top"
        case totalGamesOnTwitch = "_total"
    }
}

struct GameViewerDetails : Codable {
    let game: Game
    var channels: Int64?
    var viewers: Int64?
}

struct Game : Codable {
    var id: Int64?
    var giantbombId: Int64?
    var boxArt: BoxArtDetails?
    var logo: LogoDetails?    
    var name: String?
    var popularity: Int64?
    
    var largestLogoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case boxArt = "box"
        case giantbombId = "giantbomb_id"
        
        /// NOTE: If your variable name doesn't deviate from the JSON response structure
        /// You don't need to define it with a string.
        case logo
        case name
        case popularity
    }

    /// Optional initializer that's only necessary because I'm playing with nested containers below otherwise the class would look like it does below.
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int64.self, forKey: .id)
        self.giantbombId = try values.decode(Int64.self, forKey: .giantbombId)
        self.boxArt = try values.decode(BoxArtDetails.self, forKey: .boxArt)
        self.logo = try values.decode(LogoDetails.self, forKey: .logo)
        self.name = try values.decode(String.self, forKey: .name)
        self.popularity = try values.decode(Int64.self, forKey: .popularity)
        
        let logoContainer = try values.nestedContainer(keyedBy: LogoInfoKeys.self, forKey: .logo)
        self.largestLogoUrl = try logoContainer.decode(String.self, forKey: .largestLogoUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(giantbombId, forKey: .giantbombId)
        try container.encode(logo, forKey: .logo)
        try container.encode(name, forKey: .name)
        try container.encode(popularity, forKey: .popularity)
    }
    
    // This jumps down one level into the 'logo' object and uses its 'large' key to fill in
    // largestLogoUrl :-O
    enum LogoInfoKeys: String, CodingKey {
        case largestLogoUrl = "large"
    }
} 

/// This completely decodes the game object json.
fileprivate struct GameSmaller : Decodable {
    var id: Int64
    var giantbombId: Int64
    var boxArt: BoxArtDetails?
    var logo: LogoDetails?
    var name: String
    var popularity: Int64?
    var channels: Int64?
    var viewers: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case boxArt = "box"
        case giantbombId = "giantbomb_id"
        
        /// NOTE: If your variable name doesn't deviate from the JSON response structure
        /// You don't need to define it with a string.
        case logo
        case name
        case popularity
        case channels
        case viewers
    }
}



/* Example of the games/top/ JSON Blob
 {
     "_total": 1678,
     "_links": {
     "self": "https://api.twitch.tv/kraken/games/top?limit=10",
     "next": "https://api.twitch.tv/kraken/games/top?limit=10&offset=10"
     },
     "top": [
     {
     "game": {
         "name": "League of Legends",
         "popularity": 122107,
         "_id": 21779,
         "giantbomb_id": 24024,
         "box": {
             "large": "https://static-cdn.jtvnw.net/ttv-boxart/League%20of%20Legends-272x380.jpg",
             "medium": "https://static-cdn.jtvnw.net/ttv-boxart/League%20of%20Legends-136x190.jpg",
             "small": "https://static-cdn.jtvnw.net/ttv-boxart/League%20of%20Legends-52x72.jpg",
             "template": "https://static-cdn.jtvnw.net/ttv-boxart/League%20of%20Legends-{width}x{height}.jpg"
         },
         "logo": {
             "large": "https://static-cdn.jtvnw.net/ttv-logoart/League%20of%20Legends-240x144.jpg",
             "medium": "https://static-cdn.jtvnw.net/ttv-logoart/League%20of%20Legends-120x72.jpg",
             "small": "https://static-cdn.jtvnw.net/ttv-logoart/League%20of%20Legends-60x36.jpg",
             "template": "https://static-cdn.jtvnw.net/ttv-logoart/League%20of%20Legends-{width}x{height}.jpg"
         },
         "_links": {},
         "localized_name": "League of Legends",
         "locale": "en"
         },
         "viewers": 119456,
         "channels": 2238
         }
     ....... <--- Etc
     ]
 }

*/
