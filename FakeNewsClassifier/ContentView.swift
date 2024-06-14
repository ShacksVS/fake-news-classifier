//
//  ContentView.swift
//  FakeNewsClassifier
//
//  Created by Viktor Sovyak on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var showAlert = false
    @State private var result = ""
    
    var body: some View {
        VStack {
            TextEditor(
                text: $inputText
            )
            .frame(width: 332, height: 100)
            .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
            
            Button {
                // Change it with actual model response
                result = "Fake or Not Fake"
                showAlert = true
            } label: {
                Text("Detect")
                    .font(.system(size: 16))
            }
            .frame(width: 100, height: 50)
            .foregroundColor(.primary)
            .background(Color(UIColor.systemYellow))
            .cornerRadius(10)
            .padding(.top)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Response"),
                    // Add probability of each classes??
                    message: Text("The result of classification: \(result)"),
                    dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
