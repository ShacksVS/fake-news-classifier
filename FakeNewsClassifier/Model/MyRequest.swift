//
//  MyRequest.swift
//  FakeNewsClassifier
//
//  Created by Daniil on 24.06.2024.
//

import Foundation

enum Result: String {
    case fake
    case truth
}

struct MyRequest: Identifiable {
    let id = UUID()
    let requestString: String
    let result: Result
    
    static var mock: MyRequest {
        MyRequest(requestString: "MY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request messageMY request message", result: .fake)
    }
}
