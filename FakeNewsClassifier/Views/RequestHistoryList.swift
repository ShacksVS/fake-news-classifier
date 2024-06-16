//
//  RequestHistoryView.swift
//  FakeNewsClassifier
//
//  Created by Daniil on 15.06.2024.
//

import SwiftUI

struct RequestHistoryView: View {
    let lastRequests: [Request] = [Request.mock, Request.mock,Request.mock,Request.mock,Request.mock,Request.mock,Request.mock,Request.mock,Request.mock,Request.mock]
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach (lastRequests) { request in
                    RequestHistoryCell(request: request)
                }
            }
        }
    }
}

#Preview {
    RequestHistoryView()
}
