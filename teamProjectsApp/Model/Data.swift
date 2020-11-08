//
//  Data.swift
//  teamProjectsApp
//
//  Created by McEntire, Allison on 11/8/20.
//

import Foundation

struct Data: Codable, Equatable {
    let type: String?
    let id: String?
    let attributes: Attributes?
    let relationships: Relationships?
}
