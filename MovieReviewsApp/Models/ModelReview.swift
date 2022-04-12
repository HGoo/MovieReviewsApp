//
//  Reviews.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import Foundation

struct Review: Decodable {
    let status: String?
    let copyright: String?
    let hasMore: Bool?
    let numResults: Int?
    let results: [Result]?
}


struct Result: Decodable {
    let displayTitle: String?
    let mpaaRating: String?
    let criticsPick: Int?
    var byline: String?
    let headline: String?
    let summaryShort: String?
    let publicationDate: String?
    let openingDate: String?
    let dateUpdated: String?
    let link: Link?
    let multimedia: Multimedia?
}

struct Link: Decodable {
    let type: String?
    let url: String?
    let suggestedLinkText: String?
}

struct Multimedia: Decodable {
    let type: String?
    let src: String?
    let height: Int?
    let width: Int?
}


