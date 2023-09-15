//
//  Message.swift
//  Pock_Api
//
//  Created by Oliver Santos on 12/09/23.
//

import SwiftUI

struct Message: Hashable {
    let idUser: String
    let text: String
    let personName: String
    let time: String
    var color: Color = .green
}
