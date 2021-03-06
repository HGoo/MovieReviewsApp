//
//  Reviews.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 08.04.2022.
//

import Foundation

struct Review: Decodable {
    let status: String?
    let numResults: Int?
    var results: [Results]?
}

struct Results: Decodable {
    let displayTitle: String?
    let byline: String?
    let headline: String?
    let summaryShort: String?
    let publicationDate: String?
    let openingDate: String?
    let dateUpdated: String?
    let link: Link?
    let multimedia: Multimedia?
}

struct Link: Decodable {
    let url: String?
    let suggestedLinkText: String?
}

struct Multimedia: Decodable, Equatable {
    let type: String?
    let src: String?
}


