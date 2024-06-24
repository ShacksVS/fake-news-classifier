//
//  RequestHistoryView.swift
//  FakeNewsClassifier
//
//  Created by Daniil on 15.06.2024.
//

import SwiftUI

struct RequestHistoryView: View {
    let lastRequests: [MyRequest]
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach (lastRequests) { request in
                    RequestHistoryCell(request: request)
                }
            }
        }
    }
}

#Preview {
    RequestHistoryView(lastRequests: [MyRequest.mock, MyRequest.mock,MyRequest.mock,MyRequest.mock,MyRequest.mock,MyRequest.mock,MyRequest.mock,MyRequest.mock,MyRequest.mock,MyRequest.mock])
}
