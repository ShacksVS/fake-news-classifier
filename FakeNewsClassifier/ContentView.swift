//
//  ContentView.swift
//  FakeNewsClassifier
//
//  Created by Viktor Sovyak on 6/14/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var inputText = ""
    @State private var showAlert = false
    @State private var result = ""
    private var requests: [MyRequest] = []
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Requests.dateTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Requests>
    
    var body: some View {
        VStack {
            Text("Check the news")
                .font(.title)
                .bold()
                .padding()
            TextEditor(text: $inputText)
                .frame(width: 332, height: 100)
                .padding(EdgeInsets(top: 12, leading: 15, bottom: 12, trailing: 15))
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.primary, lineWidth: 1)
                )
            
            Button {
                result = ModelController.classify(input: inputText)
                addItem(myRequest: MyRequest(requestString: inputText, result: Result(rawValue: result) ?? .fake))
                showAlert = true
            } label: {
                Text("Detect")
                    .font(.system(size: 16))
            }
            .frame(width: 100, height: 50)
            .foregroundColor(.primary)
            .background(Color(.systemYellow))
            .cornerRadius(10)
            .padding(.top)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Response"),
                    message: Text("The result of classification: \(result)"),
                    dismissButton: .default(Text("OK")))
            }
            .padding()
            
            RequestHistoryView(lastRequests: convertToMyRequests(requests: fetchLast10Requests()))
                .background(.requests)
            Spacer()
        }
        .onDisappear {
            
        }
    }
    
    private func addItem(myRequest: MyRequest) {
        withAnimation {
            let newRequest = Requests(context: viewContext)
            newRequest.id = myRequest.id
            newRequest.text = myRequest.requestString
            newRequest.result = myRequest.result.rawValue == "fake" ? true : false
            newRequest.dateTime = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func fetchLast10Requests() -> [Requests] {
        let fetchRequest: NSFetchRequest<Requests> = Requests.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Requests.dateTime, ascending: false)]
        fetchRequest.fetchLimit = 10
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch last 10 requests: \(error)")
            return []
        }
    }
    
    private func convertToMyRequests(requests: [Requests]) -> [MyRequest] {
        return requests.map {
            MyRequest(requestString: $0.text ?? "", result: $0.result ? .truth : .fake)
        }
    }
}

#Preview {
    ContentView()
}
