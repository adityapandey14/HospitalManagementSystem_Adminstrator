//
//  Ann_Input.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 07/05/24.
//

import Foundation
import SwiftUI

struct AddAnnouncementView: View {
    @State private var announcementText = ""

    @EnvironmentObject var viewModel: AnnouncementsViewModel

    var body: some View {
        VStack {
            Text("Announcement")
            TextField("Enter Announcement", text: $announcementText)
                .padding()

            Button("Add Announcement") {
                viewModel.addAnnouncement(text: announcementText, dateTime: Date())
            }
            .padding()
        }
    }
}
