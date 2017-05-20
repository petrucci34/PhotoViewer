//
//  Thumbnail.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import SwiftyJSON

struct Thumbnail {
    let id: String
    let title: String
    let thumbnailSizeUrl: URL? // Backend may return unexpected format in which case we'll need to skip this entry.
    let url: URL?
    let height: Int
    let width: Int

    init(json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue

        if let urlString = json["url_s"].string {
            thumbnailSizeUrl = URL(string: urlString.thumbnailSizeURLString())!
            url = URL(string: urlString.largeSizeURLString())!
        } else {
            thumbnailSizeUrl = nil
            url = nil
        }

        height = json["height_s"].intValue
        width = json["width_s"].intValue
    }
}

extension String {
    func thumbnailSizeURLString() -> String {
        return replacingOccurrences(of: "_m", with: "_t")
    }

    func largeSizeURLString() -> String {
        return replacingOccurrences(of: "_m", with: "_h")
    }
}
