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
    @Binding var sharedText: String?
    @State private var result = ""
    private var requests: [MyRequest] = []
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Requests.dateTime, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Requests>
    
    public init(sharedText: Binding<String?>) {
        self._sharedText = sharedText
    }
    
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
                print(result)
                addItem(myRequest: MyRequest(requestString: inputText, result: Result(rawValue: result.lowercased()) ?? .fake))
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
            
            RequestHistoryView(lastRequests: convertToMyRequests(requests: fetchLastRequests()))
                .background(.requests)
            Spacer()
        }
        .onAppear {
            if let sharedText = sharedText {
                inputText = sharedText
                self.sharedText = nil
            }
        }
    }
    
    private func addItem(myRequest: MyRequest) {
        withAnimation {
            let newRequest = Requests(context: viewContext)
            newRequest.id = myRequest.id
            newRequest.text = myRequest.requestString
            newRequest.result = myRequest.result.rawValue == "positive" ? true : false
            newRequest.dateTime = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func fetchLastRequests() -> [Requests] {
        let fetchRequest: NSFetchRequest<Requests> = Requests.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Requests.dateTime, ascending: false)]
        fetchRequest.fetchLimit = 20
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch last 10 requests: \(error)")
            return []
        }
    }
    
    private func convertToMyRequests(requests: [Requests]) -> [MyRequest] {
        return requests.map {
            MyRequest(requestString: $0.text ?? "", result: $0.result ? .positive : .fake)
        }
    }
}

#Preview {
    ContentView(sharedText: .constant("123"))
}
