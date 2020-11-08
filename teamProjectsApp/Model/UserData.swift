//
//  UserData.swift
//  teamProjectsApp
//
//  Created by McEntire, Allison on 11/8/20.
//

import Foundation

struct UserData: Codable, Equatable {
    let included: [Included]?
    let data: [Data]?
}
