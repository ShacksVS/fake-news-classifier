//
//  RequestHistoryCell.swift
//  FakeNewsClassifier
//
//  Created by Daniil on 15.06.2024.
//

import SwiftUI

struct RequestHistoryCell: View {
    let request: Request
    var body: some View {
        HStack {
            Text(request.requestString)
                .frame(maxWidth: 200, maxHeight: 100)
            Text(request.result.rawValue.uppercased())
                .foregroundStyle(request.result.rawValue == "fake" ? .red : .green)
        }
//        .padding(10)
    }
}

#Preview {
    RequestHistoryCell(request: Request.mock)
}
