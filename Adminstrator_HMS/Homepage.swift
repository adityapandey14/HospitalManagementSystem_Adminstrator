//
//  Homepage.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 22/04/24.
//

import SwiftUI

struct Homepage: View {
    @EnvironmentObject var viewModel : AuthViewModel
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.signOut()
            }) {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color.blue)
            }
            .padding(.all, 10)
        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    Homepage()
}
