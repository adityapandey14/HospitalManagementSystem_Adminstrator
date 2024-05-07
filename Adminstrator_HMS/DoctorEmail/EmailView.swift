import SwiftUI
import Combine
import Foundation

// Utility function for Base64 encoding (for Basic Auth)
func base64Encode(key: String, secret: String) -> String {
    let concatenated = "\(key):\(secret)"
    guard let data = concatenated.data(using: .utf8) else {
        return ""
    }
    return data.base64EncodedString()
}

// Example API key and secret (to be replaced with your actual values)
let apiKey = "9a1aea214144ef860f3c3a25cee53afe"   // Replace with your actual API key
let apiSecret = "4d1d8a92d6222e7b82d81d6c94ce1985"  // If required, otherwise leave as an empty string
let base64Key = base64Encode(key: apiKey, secret: apiSecret)

// ObservableObject for managing the email state and sending the POST request
class EmailViewModel: ObservableObject {
    @Published var fromEmail: String = "an6189@gmail.com"
    @Published var fromName: String = "Aditya Pandey"
    @Published var toEmail: String = "anshu61796@gmail.com"
    @Published var subject: String = "Hello!"
    @Published var bodyText: String = "Greetings from SwiftUI."
    
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    func sendEmail() {
        // Correct Mailjet endpoint for sending emails
        guard let apiURL = URL(string: "https://api.mailjet.com/v3.1/send") else {
            errorMessage = "Invalid URL"
            return
        }
        
        // Construct the correct JSON body for Mailjet's API
        let body: [String: Any] = [
            "Messages": [
                [
                    "From": [
                        "Email": fromEmail,
                        "Name": fromName
                    ],
                    "To": [
                        [
                            "Email": toEmail,
                            "Name": "Recipient"
                        ]
                    ],
                    "Subject": subject,
                    "TextPart": bodyText
                ]
            ]
        ]
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64Key)", forHTTPHeaderField: "Authorization")
        
        // Serialize the JSON body
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            errorMessage = "Error during JSON serialization"
            return
        }
        
        // URLSession data task for sending the POST request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error during request: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        self.successMessage = "Email sent successfully!"
                    } else {
                        self.errorMessage = "Failed to send email. Status code: \(httpResponse.statusCode)"
                        
                        if let data = data,
                           let responseText = String(data: data, encoding: .utf8) {
                            print("Response body: \(responseText)")
                        }
                    }
                }
            }
        }
        
        task.resume()  // Start the task
    }
}

// SwiftUI view for sending an email
struct EmailView: View {
    @StateObject private var viewModel = EmailViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            VStack{
                AddAnnouncementView()
            }
            TextField("From Email", text: $viewModel.fromEmail)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("From Name", text: $viewModel.fromName)
                .autocapitalization(.words)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("To Email", text: $viewModel.toEmail)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Subject", text: $viewModel.subject)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextEditor(text: $viewModel.bodyText)
                .frame(height: 100)
                .border(Color.gray, width: 1)
            
            if let successMessage = viewModel.successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Send Email") {
                viewModel.sendEmail()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

// SwiftUI App entry point

struct EmailApp: App {
    var body: some Scene {
        WindowGroup {
            EmailView()
        }
    }
}
