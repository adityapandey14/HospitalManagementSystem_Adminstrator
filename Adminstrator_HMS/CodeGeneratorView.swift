//
//  CodeGeneratorView.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 29/04/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// A simple function to generate a 10-digit random code
func generateRandomCode() -> String {
    let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<10).compactMap { _ in allowedCharacters.randomElement() })
}

// SwiftUI View to generate and store a random code in Firestore
struct CodeGeneratorView: View {
    @State private var generatedCode: String = ""
    @State private var errorMessage: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            Text("Generated Code:")
                .font(.headline)

            // Display the generated code
            if !generatedCode.isEmpty {
                Text(generatedCode)
                    .font(.largeTitle)
                    .bold()
            } else {
                Text("No code generated yet")
                    .foregroundColor(.gray)
            }

            // Button to generate a new code
            Button("Generate and Store Code") {
                Task {
                    do {
                        generatedCode = try await generateAndStoreRandomCode()
                        errorMessage = nil
                    } catch {
                        errorMessage = "Error storing code: \(error.localizedDescription)"
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            // Display error message if any
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    // Function to generate and store a random code, returning the generated code
    func generateAndStoreRandomCode() async throws -> String {
        let firestore = Firestore.firestore()
        let collection = firestore.collection("codeGenerator") // changed collection name to avoid conflicts

        // Generate a 10-digit random code
        let randomCode = generateRandomCode()

        // Store the code in Firestore
        _ = try await collection.addDocument(data: ["code": randomCode])

        return randomCode
    }
}

// Entry point for the SwiftUI app
struct CodeGeneratorView_Preview: View {
    var body: some View {
        CodeGeneratorView()
    }
}

#Preview {
    CodeGeneratorView_Preview()
}
