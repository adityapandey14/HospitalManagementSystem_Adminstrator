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
    var subject: String
    var body: String
    var toEmails: [String]
    var fromEmail: String

    var onComplete: ((MFMailComposeResult, Error?) -> Void)? = nil

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        guard MFMailComposeViewController.canSendMail() else {
            fatalError("Mail services are not available on this device.")
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setSubject(subject)
        composer.setMessageBody(body, isHTML: false)
        composer.setToRecipients(toEmails)
        composer.setPreferredSendingEmailAddress(fromEmail)

        return composer
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // Not needed in this case
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
            if result == .sent {
                onComplete?(.sent, nil)
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

struct MAIL: View {
    @State private var generatedCode: String = ""
    @State private var errorMessage: String? = nil
    @State private var mailId: String = ""
    @State private var mailSent: Bool = false // State to track if mail has been sent

    var body: some View {
        VStack {
            Text("Unique Code Sender")
                .bold()
                .font(.system(size: 29))
            
            VStack {
                TextField("Enter Doctor's email", text: $mailId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()

                HStack {
                    Image(systemName: "info.circle")
                    Text("Send a one-time code for doctor's sign-up")
                        .font(.system(size: 12))
                        .padding(.leading, 5)
                }

                // Button to send the email
                Button("Send") {
                    Task {
                        do {
                            generatedCode = try await generateAndStoreRandomCode()
                            errorMessage = nil
                            mailSent = false // Reset the mailSent state
                        } catch {
                            errorMessage = "Error storing code: \(error.localizedDescription)"
                        }
                    }
                    
                    presentMailCompose()
                }
                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .foregroundColor(Color("AccentColor 1"))
                .cornerRadius(8)
                .padding(.top, 30)

                // Display success message when mail has been sent
                if mailSent {
                    Text("The mail has been sent")
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }
            }
        }
    }

    func generateRandomCode() -> String {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<10).compactMap { _ in allowedCharacters.randomElement() })
    }

    func generateAndStoreRandomCode() async throws -> String {
        let firestore = Firestore.firestore()
        let collection = firestore.collection("codeGenerator")

        let randomCode = generateRandomCode()

        _ = try await collection.addDocument(data: ["code": randomCode])

        return randomCode
    }

    func presentMailCompose() {
        guard !mailId.isEmpty else {
            errorMessage = "Email address cannot be empty"
            return
        }

        let mailComposeView = MailComposeView(
            subject: "Generated Code",
            body: "Hello,\n\nHere is your generated code: \(generatedCode)\n\nBest regards,\nYour App",
            toEmails: [mailId],
            fromEmail: ""
        ) { result, error in
            if result == .sent {
                mailSent = true // Set the state to true when the mail is sent
            }
        }

        let hostingController = UIHostingController(rootView: mailComposeView)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController?.present(hostingController, animated: true)
        }
    }
}

#Preview {
    MAIL()
}
