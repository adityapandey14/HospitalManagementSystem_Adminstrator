//
//  Ann_Input.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 07/05/24.
//

import SwiftUI

struct AddAnnouncementView: View {
    @State private var announcementText = ""
    @State private var isAnnouncementAdded = false

    @EnvironmentObject var viewModel: AnnouncementsViewModel

    var body: some View {
        VStack {
            Text("Announcements")
                .bold()
                .padding(.bottom, 25)
                .padding(.trailing, 125)
                .font(.system(size: 30))
            VStack {
                TextField("Enter the announcement", text: $announcementText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 380)
                HStack {
                    Image(systemName: "info.circle")
                        .frame(width: 5, height: 5)
//                    Spacer()
//                        .padding()
                    Text("Post an announcement for the doctors")
                        .font(.system(size: 12))
                        .padding(.leading, 5)
                }
                .padding(.trailing, 100)
                .padding(.bottom)
                Button("Post") {
                    viewModel.addAnnouncement(text: announcementText, dateTime: Date())
                    isAnnouncementAdded = true
                    announcementText = "" // Clear the text field after adding announcement
                }
                .padding()
                .disabled(announcementText.isEmpty) // Disable the button if announcementText is empty
//                .padding()
                .background(Color(uiColor: .secondarySystemBackground))
                .foregroundColor(Color("AccentColor 1"))
                .cornerRadius(8)
                .padding(.top, 20)
            }
            .padding(.bottom, 170)
            
        }
        .padding(.bottom, 250)
        .alert(isPresented: $isAnnouncementAdded) {
            Alert(title: Text("Announcement Added"), message: nil, dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AddAnnouncementView()
}

