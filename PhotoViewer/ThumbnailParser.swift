//
//  ThumbnailParser.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import SwiftyJSON

struct ThumbnailParser {
    static func parseThumbnails(json: JSON) -> [Thumbnail] {
        let photos = json["photos"]["photo"]

        var thumbnails = [Thumbnail]()
        for photo in photos.arrayValue {
            let thumbnail = Thumbnail(json: photo)

            // During testing some corrupt URL strings were discovered.
            if thumbnail.url != nil && thumbnail.thumbnailSizeUrl != nil {
                thumbnails.append(thumbnail)
            }
        }

        return thumbnails
    }
}
