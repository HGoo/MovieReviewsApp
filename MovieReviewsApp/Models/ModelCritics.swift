//
//  ModelCritics.swift
//  MovieReviewsApp
//
//  Created by Николай Петров on 09.04.2022.
//

import Foundation

struct Critics: Decodable, Equatable {
    let results: [ResultCritic]?
}

struct ResultCritic: Decodable, Equatable {
    let displayName: String?
    let bio: String?
    let status: String?
    let multimedia: Resourses?
}

struct Resourses: Decodable, Equatable {
    let resource: Multimedia?
}



