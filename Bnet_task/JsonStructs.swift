//
//  Model.swift
//  Bnet_task
//
//  Created by Tianid on 18.10.2019.
//  Copyright © 2019 Tianid. All rights reserved.
//

import Foundation


struct NewSessionResponse: Codable {
    let status: Int
    let data: Session
    let error: String?
}

struct Session: Codable {
    let session: String
}

struct Entries: Codable {
    let status: Int
    let data: [[Entry]]
}

struct Entry: Codable {
    let id: String
    let body: String
    let da: String
    let dm: String
}


