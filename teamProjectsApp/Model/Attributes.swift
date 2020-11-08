//
//  Attributes.swift
//  teamProjectsApp
//
//  Created by McEntire, Allison on 11/8/20.
//

import Foundation

class Attributes: Codable {
    let updated_at: String?
    let name: String?
    var date: Date?
   
    public func formatProjectDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        if let updatedAt = updated_at {
            date = dateFormatter.date(from: updatedAt)
        }
        
    }
}


