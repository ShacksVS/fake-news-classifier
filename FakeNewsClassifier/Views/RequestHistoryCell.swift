//
//  RequestHistoryCell.swift
//  FakeNewsClassifier
//
//  Created by Daniil on 15.06.2024.
//

import SwiftUI

struct RequestHistoryCell: View {
    let request: MyRequest
    var body: some View {
        HStack {
            Text(request.requestString)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(.leading, 13)
            Text(request.result.rawValue.uppercased())
                .foregroundStyle(request.result.rawValue == "fake" ? .red : .green)
                .padding(.trailing, 13)
        }
    }
}

#Preview {
    RequestHistoryCell(request: MyRequest.mock)
}
