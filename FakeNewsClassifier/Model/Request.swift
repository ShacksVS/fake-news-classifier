//
//  Request.swift
//  FakeNewsClassifier
//
//  Created by Daniil on 15.06.2024.
//

import Foundation

enum Result: String {
    case fake
    case truth
}

struct Request: Identifiable {
    let id = UUID()
    let requestString: String
    let result: Result
    
    static var mock: Request {
        Request(requestString: "MY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request message", result: .fake)
    }
}
