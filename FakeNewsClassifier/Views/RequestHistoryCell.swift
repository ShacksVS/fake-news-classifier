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
                .font(.system(size: 16).bold())
                .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                .padding(.leading, 13)
            Spacer()
            Text(request.result.rawValue.uppercased())
                .foregroundStyle(request.result.rawValue == "fake" ? .red : .green)
                .bold()
                .padding(.trailing, 13)
        }
    }
}

#Preview {
    RequestHistoryCell(request: MyRequest.mock)
}
