//
//  DoctorDetail.swift
//  Adminstrator_HMS
//
//  Created by admin on 10/05/24.
//

import SwiftUI

struct DoctorListDetail: View {
    @ObservedObject var departmentViewModel = DepartmentViewModel()
    @ObservedObject var doctorviewModel = DoctorViewModel()
    @State private var selectedSkillType: DepartmentDetail?
    @ObservedObject var doctorViewModel = DoctorViewModel.shared
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    ForEach(departmentViewModel.departmentTypes) { departmentType in
                        VStack(alignment: .leading){
                            Text(departmentType.departmentType)
                            ForEach(departmentType.specialityDetails) { detail in
                                if let doctor = doctorViewModel.doctorDetails.first(where: { $0.id == detail.doctorId }) {
                                    topDoctorCard(fullName: doctor.fullName, specialist: doctor.speciality, doctorUid: doctor.id, imageUrl: doctor.profilephoto ?? "", doctorDetail: doctor)
                                }
                            }
                        }
                        .padding()
//                        .background(Color(uiColor: .secondarySystemBackground))
                        .onAppear() {
                            selectedSkillType = departmentType
                            departmentViewModel.fetchSpecialityOwnerDetails(for: departmentType.id)
                        }
                    }
                }
            }
            .onAppear() {
                Task {
                    await doctorviewModel.fetchDoctorDetails()
                }
            }
        }
        .navigationTitle("All Doctors")
    }
}

#Preview {
    DoctorListDetail()
}
