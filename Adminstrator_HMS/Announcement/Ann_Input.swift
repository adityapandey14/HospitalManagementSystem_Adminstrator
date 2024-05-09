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
            Text("Announcement")
            TextField("Enter Announcement", text: $announcementText)
                .padding()

            Button("Add Announcement") {
                viewModel.addAnnouncement(text: announcementText, dateTime: Date())
                isAnnouncementAdded = true
                announcementText = "" // Clear the text field after adding announcement
            }
            .padding()
            .disabled(announcementText.isEmpty) // Disable the button if announcementText is empty
        }
        .alert(isPresented: $isAnnouncementAdded) {
            Alert(title: Text("Announcement Added"), message: nil, dismissButton: .default(Text("OK")))
        }
    }
}

