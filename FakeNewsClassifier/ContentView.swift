//
//  ContentView.swift
//  FakeNewsClassifier
//
//  Created by Viktor Sovyak on 6/14/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Binding var sharedText: String?
    @State private var inputText = ""
    @State private var showAlert = false
    @State private var result = ""
    @FocusState private var isFocused: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Requests.dateTime, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Requests>
    
    public init(sharedText: Binding<String?>) {
        self._sharedText = sharedText
    }
    
    var body: some View {
        VStack (spacing: 0) {
            Text("Check the news")
                .font(.title)
                .bold()
                .padding(.vertical, 10)
            Divider()
                .background(.primary)
            VStack {
                Text("Input your text here:")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding(.leading, 20)
                    .padding(.top, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextEditor(text: $inputText)
                    .frame(width: 360, height: 200)
                    .padding(EdgeInsets(top: 12, leading: 15, bottom: 5, trailing: 15))
                    .cornerRadius(50)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? Color.yellow : Color.primary, lineWidth: 1)
                    )
                    .tint(.black)
            }
            Button {
                result = ModelController.classify(input: inputText)
                print(result)
                addItem(myRequest: MyRequest(requestString: inputText, result: Result(rawValue: result.lowercased()) ?? .fake))
                showAlert = true
            } label: {
                Text("Detect")
                    .font(.system(size: 22))
            }
            .frame(width: 130, height: 50)
            .foregroundColor(.primary)
            .background(Color(.systemYellow))
            .cornerRadius(10)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Response"),
                    message: Text("The result of classification: \(result)"),
                    dismissButton: .default(Text("OK")))
            }
            .padding()
            
            Divider()
                .background(.primary)
                .padding(.bottom, 10)
            
            RequestHistoryView(lastRequests: convertToMyRequests(requests: fetchLastRequests()))
                .ignoresSafeArea()
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
