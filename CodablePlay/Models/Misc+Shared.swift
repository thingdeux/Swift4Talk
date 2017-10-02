//
//  Misc+Shared.swift
//  Swift4Playing
//
//  Created by Josh on 10/2/17.
//

protocol CustomImageSizeGeneratable {
    var template: String? { get set }
}

extension CustomImageSizeGeneratable {
    func createImageUrl(x xSize: String, y ySize: String) -> String? {
        if let template = template {
            let newUrl = template.replacingOccurrences(of: "width", with: xSize)
            return newUrl.replacingOccurrences(of: "height", with: ySize)
        }
        return nil
    }
}

struct BoxArtDetails : CustomImageSizeGeneratable, Codable {
    var small: String?
    var medium: String?
    var large: String?
    var template: String?        
}

struct LogoDetails : CustomImageSizeGeneratable, Codable {
    var large: String?
    var medium: String?
    var small: String?
    var template: String?
}
