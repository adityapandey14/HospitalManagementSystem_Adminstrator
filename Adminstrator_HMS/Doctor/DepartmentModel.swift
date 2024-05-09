//
//  DepartmentModal.swift
//  Adminstrator_HMS
//
//  Created by Aditya Pandey on 09/05/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import Combine


// DepartmentDetail struct with a list of SpecialityDetail objects
struct DepartmentDetail: Identifiable, Equatable, Hashable {
    var id: String
    var departmentType: String
    var specialityDetails: [SpecialityDetail] = []
    static func == (lhs: DepartmentDetail, rhs: DepartmentDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}


// SpecialityDetail struct
struct SpecialityDetail: Identifiable, Codable, Hashable {
    var id: String
    var doctorId: String
    var cabinNo: String
    var department: String
}



// ViewModel for fetching department and specialisation data
class DepartmentViewModel: ObservableObject {
 //   @EnvironmentObject var viewModel: AuthViewModel
    @Published var departmentTypes: [DepartmentDetail] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchDepartmentTypes()
    }

    func fetchDepartmentTypes() {
        Task {
            do {
                let querySnapshot = try await Firestore.firestore()
                    .collection("department")
                    .getDocuments()

                let departments = querySnapshot.documents.map { document in
                    let data = document.data()
                    return DepartmentDetail(
                        id: document.documentID,
                        departmentType: data["departmentTypes"] as? String ?? ""
                    )
                }
                
                DispatchQueue.main.async {
                    self.departmentTypes = departments
                }
            } catch {
                print("Error fetching Department types: \(error.localizedDescription)")
            }
        }
    }

    func fetchSpecialityOwnerDetails(for departmentId: String) {
        Task {
            do {
                let querySnapshot = try await Firestore.firestore()
                    .collection("department")
                    .document(departmentId)
                    .collection("allSpecialisation")
                    .getDocuments()

                let specialityDetails = querySnapshot.documents.map { document in
                    let data = document.data()
                    return SpecialityDetail(
                        id: document.documentID,
                        doctorId: data["doctorId"] as? String ?? "",
                        cabinNo: data["cabinNo"] as? String ?? "",
                        department: data["department"] as? String ?? ""
                    )
                }

                DispatchQueue.main.async {
                    if let index = self.departmentTypes.firstIndex(where: { $0.id == departmentId }) {
                        self.departmentTypes[index].specialityDetails = specialityDetails
                    }
                }
            } catch {
                print("Error fetching speciality owner details: \(error.localizedDescription)")
            }
        }
    }
}

// SwiftUI View
struct DepartmentModel: View {
    @ObservedObject var viewModel = DepartmentViewModel()
    @State private var selectedSkillType: DepartmentDetail?
    let userId = Auth.auth().currentUser?.uid
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.departmentTypes) { departmentType in
                VStack(alignment: .leading) {
                    Text("department Type: \(departmentType.departmentType)")
                        .font(.headline)
                        .onTapGesture {
                            selectedSkillType = departmentType
                            viewModel.fetchSpecialityOwnerDetails(for: departmentType.id)
                        }
                        .padding()
                    
                    ForEach(departmentType.specialityDetails) { detail in
                        VStack(alignment: .leading) {
                            Text("Doctor ID: \(detail.doctorId)")
                                .padding()
                            Text("Cabin No: \(detail.cabinNo)")
                                .padding()
                            Text("Department: \(detail.department)")
                                .padding()
                        }
                    }
                }
                .padding()
            }
        }
    }
}



// New View for displaying Specializations


// SwiftUI Preview
#Preview {
    DepartmentModel()
}
