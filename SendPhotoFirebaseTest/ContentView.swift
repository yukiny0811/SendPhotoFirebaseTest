//
//  ContentView.swift
//  SendPhotoFirebaseTest
//
//  Created by Yuki Kuwashima on 2024/06/19.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ContentView: View {

    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()

    @State var url: URL?

    var body: some View {
        VStack {
            if let url {
                AsyncImage(url: url)
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("send") {
                let image = UIImage(named: "test")!
                Task{
                    url = try await sendPhoto(image: image)
                }
            }
        }
        .padding()
    }

    func sendPhoto(image: UIImage) async throws -> URL? {
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            throw "image data error"
        }
        let fileName = UUID().uuidString + ".jpg"
        let imageRef = storage.child("images/\(fileName)")
        let metaData = try await imageRef.putDataAsync(imageData)
        let downloadUrl = try await imageRef.downloadURL()
        return downloadUrl
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { self }
}

struct MyData: Codable {
    var test: String = ""
    var number: Int = 0
    var imageURL: String
}

#Preview {
    ContentView()
}
