//
//  ShareViewController.swift
//  FakeNewsClassifierShare
//
//  Created by Daniil on 24.06.2024.
//

import UIKit
import SwiftUI
import UniformTypeIdentifiers


class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        
        guard
            let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first
        else {
            close()
            return
        }
        
        let textContentType = UTType.plainText.identifier
        if itemProvider.hasItemConformingToTypeIdentifier(textContentType) {
            itemProvider.loadItem(forTypeIdentifier: textContentType as String, options: nil) { (providedText, error) in
                if let error {
                    print("Error loading item: \(error)")
                    self.close()
                    return
                }
                
                if let text = providedText as? String {
                    DispatchQueue.main.async {
                        let contentView = UIHostingController(rootView: ShareView(text: text, extensionContext: self.extensionContext))
                        contentView.view.frame = self.view.frame
                        self.view.addSubview(contentView.view)
                    }
                } else {
                    print("Unexpected data type: \(String(describing: providedText))")
                    self.close()
                    return
                }
            }
        } else {
            print("Item does not conform to text data type")
            close()
            return
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("close"), object: nil, queue: nil) { _ in
            DispatchQueue.main.async {
                self.close()
            }
        }
    }
    
    func close() {
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    @objc 
    func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}

fileprivate struct ShareView: View {
    @State var text: String
    var extensionContext: NSExtensionContext?
    
    var body: some View {
        VStack {
            Text("Share to app")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay (alignment: .leading) {
                    HStack {
                        Button("Cancel", action: dismiss)
                            .tint(.yellow)
                        Spacer()
                        Button ("Save", action: save)
                            .tint(.yellow)
                    }
                }
            TextField("Text", text: $text, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(.roundedBorder)
                .border(.yellow, width: 1)
                .padding()
            Spacer()
        }
        .padding()
        .onAppear {
            print("View appeared")
        }
    }
    private func dismiss() {
        NotificationCenter.default.post(name: NSNotification.Name("close"), object: nil)
    }
    
    private func save() {
        let urlScheme = "fakenewsclassifier://\(text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        if let url = URL(string: urlScheme) {
            extensionContext?.open(url, completionHandler: { (success) in
                if success {
                    print("Opened URL: \(url)")
                } else {
                    print("Failed to open URL: \(url)")
                }
                self.dismiss()
            })
        } else {
            print("Invalid URL")
            self.dismiss()
        }
    }
}
