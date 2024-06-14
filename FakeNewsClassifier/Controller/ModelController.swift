//
//  ModelController.swift
//  FakeNewsClassifier
//
//  Created by Viktor Sovyak on 6/14/24.
//

import Foundation
import CoreML

class ModelController {
    static func classify(input inputText: String) -> String {
        do {
            let model = try BetaFakeNewsClassifier(configuration: .init())
            let prediction = try model.prediction(text: inputText)
            return prediction.label
        } catch {
            return "Something went wrong"
        }
    }
}
