//
//  ModelCritics.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 09.04.2022.
//

import Foundation

struct Critics: Decodable {
    let results: [ResultCritic]?
}

struct ResultCritic: Decodable {
    let displayName: String?
    let bio: String?
    let status: String?
    let multimedia: Resourses?
}

struct Resourses: Decodable {
    let resource: Multimedia?
}

