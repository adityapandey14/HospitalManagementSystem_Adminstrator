import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    var subject: String
    var recipients: [String]
    var body: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setSubject(subject)
        controller.setToRecipients(recipients)
        controller.setMessageBody(body, isHTML: false)
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // No updates required
    }
}

struct MessageView: View {
    @State private var isShowingMailComposer = false

       var body: some View {
           VStack {
               Button("Send Email") {
                   if MFMailComposeViewController.canSendMail() {
                       isShowingMailComposer = true
                   } else {
                       print("Cannot send mail from this device")
                   }
               }
           }
           .sheet(isPresented: $isShowingMailComposer) {
               if MFMailComposeViewController.canSendMail() {
                   MailComposeView(isShowing: $isShowingMailComposer, recipients: ["an6189@srmist.edu.in"], subject: "Hello", body: "This is a test email from SwiftUI!")
               } else {
                   Text("Mail services are not available.")
               }
           }
       }
   }
#Preview {
    MessageView() // Default initial state without additional arguments
}




import SwiftUI
import MessageUI

struct MailComposeView: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    var recipients: [String]
    var subject: String
    var body: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(recipients)
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(body, isHTML: false)
        
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        // No updates are required
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true) {
                self.parent.isShowing = false
            }
        }
    }
}
