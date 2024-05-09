//
//  MAIL.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 09/05/24.
//


import SwiftUI
import MessageUI
import Firebase
import FirebaseFirestore




struct MailComposeView: UIViewControllerRepresentable {
    // MARK: - Properties
    var subject: String
    var body: String
    var toEmails: [String]
    var fromEmail: String
 
    var onComplete: ((MFMailComposeResult, Error?) -> Void)? = nil

    // MARK: - UIViewControllerRepresentable Methods
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        // Ensure that the device is capable of sending mail
        guard MFMailComposeViewController.canSendMail() else {
            fatalError("Mail services are not available on this device.")
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator  // Connect delegate to the coordinator
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        composer.setToRecipients(toEmails)
        composer.setPreferredSendingEmailAddress(fromEmail)

        
        return composer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Not needed here, since we are not updating the UI view controller dynamically
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onComplete: onComplete)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var onComplete: ((MFMailComposeResult, Error?) -> Void)?

        init(onComplete: ((MFMailComposeResult, Error?) -> Void)?) {
            self.onComplete = onComplete
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            // Notify when the mail operation is completed
            onComplete?(result, error)
            controller.dismiss(animated: true, completion: nil)
        }
    }
}




struct MAIL: View {
    @State private var generatedCode: String = ""
    @State private var errorMessage: String? = nil
    @State private var mailId: String = "" // State variable for storing the mail ID

    var body: some View {
        VStack(spacing: 16) {
//            Text("Generated Code:")
//                .font(.headline)
//
//            // Display the generated code
//            if !generatedCode.isEmpty {
//                Text(generatedCode)
//                    .font(.largeTitle)
//                    .bold()
//            } else {
//                Text("No code generated yet")
//                    .foregroundColor(.gray)
//            }
//
//            // Button to generate a new code
//            Button("Generate and Store Code") {
//                Task {
//                    do {
//                        generatedCode = try await generateAndStoreRandomCode()
//                        errorMessage = nil
//                    } catch {
//                        errorMessage = "Error storing code: \(error.localizedDescription)"
//                    }
//                }
//            }
//            .buttonStyle(.borderedProminent)
//
//            // Display error message if any
//            if let errorMessage = errorMessage {
//                Text(errorMessage)
//                    .foregroundColor(.red)
//            }

            // TextField for entering the email address
            TextField("Enter email address", text: $mailId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Button to send the email
            Button("Send Email") {
                Task {
                    do {
                        generatedCode = try await generateAndStoreRandomCode()
                        errorMessage = nil
                        print(generatedCode)
                    } catch {
                        errorMessage = "Error storing code: \(error.localizedDescription)"
                    }
                }
                
                presentMailCompose()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    func generateRandomCode() -> String {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).compactMap { _ in allowedCharacters.randomElement() })
    }

    func generateAndStoreRandomCode() async throws -> String {
        let firestore = Firestore.firestore()
        let collection = firestore.collection("codeGenerator")

        // Generate a 10-digit random code
        let randomCode = generateRandomCode()

        // Store the code in Firestore
        _ = try await collection.addDocument(data: ["code": randomCode])

        return randomCode
    }

    func presentMailCompose() {
        // Ensure mail ID is not empty
        guard !mailId.isEmpty else {
            errorMessage = "Email address cannot be empty"
            return
        }

        // Create the mail compose view with relevant information
        let mailComposeView = MailComposeView(
            subject: "Generated Code",
            body: "Hello,\n\nHere is your generated code: \(generatedCode)\n\nBest regards,\nYour App",
            toEmails: [mailId], // Use the provided mailId
            fromEmail: ""
        )

        // Present the SwiftUI view as a UIKit view controller
        let hostingController = UIHostingController(rootView: mailComposeView)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(hostingController, animated: true)
        }
    }
}




