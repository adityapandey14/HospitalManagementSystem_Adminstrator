//
//  topDoctorCard.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 09/05/24.
//

import SwiftUI


struct topDoctorCard : View {
    var fullName: String
    var specialist : String
    var doctorUid : String
    var imageUrl : String

    var doctorDetail : DoctorModel
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @ObservedObject var doctorViewModel = DoctorViewModel.shared
    
    @State private var isCopied = false

    var body: some View {
        
        NavigationLink(destination : DoctorProfile(imageUrl: imageUrl, fullName: fullName, specialist: specialist, doctor: doctorDetail)) {
            VStack{
                HStack {
                    VStack {
                        if let imageUrl = URL(string: imageUrl) {
                            AsyncImage(url: imageUrl) { image in
                                image
                                    .resizable()
                                    .frame(width: 85, height: 85) // Square shape with equal width and height
                                    .foregroundColor(.gray) // Optional color
                                    .padding(.trailing, 5)
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 85, height: 85)
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 5)
                                
                            }
                            .frame(width: 90, height: 90)
                        } else {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 85, height: 85)
                                .foregroundColor(.gray)
                                .padding(.trailing, 5)
                            
                        }
                        
                    } //End of VStack
                    
                    VStack(alignment: .leading) {
                        
                        Text("\(fullName)")
                            .font(AppFont.mediumSemiBold)
                            .padding(.top)
                            .foregroundStyle(Color("black"))
                        
                        Text("\(specialist)")
                            .font(AppFont.smallReg)
                            .foregroundStyle(Color("black"))
                            
                        
                        HStack{
                            let reviewsForSkillOwner = reviewViewModel.reviewDetails.filter { $0.doctorId == "\(doctorDetail.id)" }
                            if !reviewsForSkillOwner.isEmpty {
                                //Calculating Average of the doctor
                                let averageRating = reviewsForSkillOwner.reduce(0.0) { $0 + Double($1.ratingStar) } / Double(reviewsForSkillOwner.count)
                        
                                Text("\(averageRating, specifier: "%.1f") ⭐️")
                                    .font(AppFont.smallReg)
                                    .foregroundStyle(Color("black"))
                        
                                Text("\(reviewsForSkillOwner.count) Review\(reviewsForSkillOwner.count == 1 ? "" : "s")")
                                    .font(AppFont.smallReg)
                                    .foregroundStyle(Color("black"))
                            } else {
                                Text("no reviews")
                                    .font(AppFont.smallReg)
                                    .foregroundColor(Color("black")).opacity(0.3)
                
                            }
                            Spacer()
                        }
                        .padding(.bottom)
                        .font(AppFont.smallReg)
                        .foregroundStyle(Color("black"))
                        .onAppear(){
                            reviewViewModel.fetchReviewDetailByDoctorId(doctorId: doctorDetail.id)
                        }

                    }
                    
                    Spacer()
                }
                .padding()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .foregroundColor(Color.black)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
        }
        .onAppear() {
            reviewViewModel.fetchReviewDetail()
            }
        
    }
}
