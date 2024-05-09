//
//  InventoryHome.swift
//  Adminstrator_HMS
//
//  Created by Arnav on 02/05/24.
//



import SwiftUI

struct InventoryHome: View {
    @EnvironmentObject var viewModel: InventoryViewModel
    @State private var greeting: String = ""
    @State private var isHovering = false
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var departmentViewModel = DepartmentViewModel()
    @ObservedObject var doctorviewModel = DoctorViewModel()
    @State private var selectedSkillType: DepartmentDetail?
    @ObservedObject var doctorViewModel = DoctorViewModel.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        Image(colorScheme == .dark ? "homePageLogoBlue" : "mednexLogoSmall")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.top)
                        
                        VStack(alignment: .leading) {
                            Text(greeting)
                                .font(.headline)
                                .onAppear {
                                    updateGreeting()
                                }
                            Text("Admin")
                        }
                        Spacer()
                        NavigationLink(destination: AddAnnouncementView()) {
                            Image(systemName: "megaphone")
                                .resizable()
                                .frame(width: 23, height: 25)
                                .foregroundStyle(Color("black"))
                        }
                    }
                    .padding()
                    
                    VStack() {
                        
                        VStack{
                            //                        NavigationLink(destination: InventoryManagementView()) {
                            //                            Spacer()
                            //
                            //                            Image(systemName: "square.and.pencil")
                            //
                            //                            Text("Edit")
                            //                                .font(.headline)
                            //                                .fontWeight(.bold)
                            //                                .padding()
                            //                                .cornerRadius(10)
                            //
                            //                        }
                            
                            VStack (alignment: .leading){
                                
                                HStack{
                                    Text("Blood stock")
                                        .font(.title2)
                                    
                                    NavigationLink(destination: InventoryView()) {
                                        Spacer()
                                        Text("View More Details")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .cornerRadius(10)
                                    }
                                }
                                
                                BarChart(data: bloodChartData())
                                    .frame(height: 200)
                                    .padding()
                                
                            }
                            .padding()
                            .cornerRadius(10)
                            
                            
                            
                        }
                        .background(Color(uiColor: .secondarySystemBackground))
                                                    
                        ScrollView(.horizontal) {
                    
                                        ForEach(departmentViewModel.departmentTypes) { departmentType in
                                            HStack{
      
                                                ForEach(departmentType.specialityDetails) { detail in
    
                                                        if let doctor = doctorViewModel.doctorDetails.first(where: { $0.id == detail.doctorId }) {
                                                            topDoctorCard(fullName: doctor.fullName, specialist: doctor.speciality, doctorUid: doctor.id, imageUrl: doctor.profilephoto ?? "", doctorDetail: doctor)
                                                        }
           
                                                    }
                                
                                            }
                                            .padding()
                                            .onAppear() {
                                                selectedSkillType = departmentType
                                                departmentViewModel.fetchSpecialityOwnerDetails(for: departmentType.id)
                                            }
                                        }
                                   
                           
                        } //End of the scroll view
                            .onAppear() {
                                Task {
                                   await doctorviewModel.fetchDoctorDetails()
                                }
                            }
                        
                        
                        NavigationLink(destination: Analytics()) {
                            Text("View Analytics")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 60)
                }
                .padding()
            }
        }
    }

    func bloodChartData() -> [ChartData] {
        var chartData: [ChartData] = []
        for bloodItem in viewModel.bloodItems {
            let data = ChartData(label: bloodItem.id, value: Double(bloodItem.quantity))
            chartData.append(data)
        }
        return chartData
    }
    
    private func updateGreeting() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 6..<12:
            greeting = "Good Morning"
        case 12..<18:
            greeting = "Good Afternoon"
        case 18..<22:
            greeting = "Good Evening"
        default:
            greeting = "Time to sleep"
        }
    }
}


struct InventoryHome_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = InventoryViewModel() // Create a mock InventoryViewModel

        return InventoryHome()
            .environmentObject(viewModel)
    }
}
