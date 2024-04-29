

import SwiftUI
import FirebaseAuth

struct loginView: View {
    
    @State private var email = ""
    @State private var password = ""

    @EnvironmentObject var viewModel : AuthViewModel
    
   
    var body: some View {
        NavigationView{
            VStack{
                VStack{

                    VStack{
                        VStack(alignment: .leading){
                            VStack(alignment: .leading) {
                                Text("Welcome back")
                                    .font(.system(size: 30).weight(.light))
                                Text("Enter your Credentials to log in")
                                    .font(.system(size: 17).weight(.light))
                            }
                            .padding(10)

                            TextField("Email addresss", text: $email)
                                .autocapitalization(.none)
                                .textFieldStyle(.plain)
                                .cornerRadius(8)
                                .padding(10)
                                .underlineTextField()
                        }
                        .listRowBackground(Color.clear)
                        VStack(alignment: .leading){

                            SecureField("Password", text: $password)
                                .cornerRadius(8)
                                .padding(10)
                                .underlineTextField()
                        }
                        .padding(.top)
                    }
                    .padding(.top, 20)
                    .listStyle(PlainListStyle())
                    
                    VStack(alignment: .trailing){
                        Text("Forgot Password?")
                            .foregroundColor(.midNightExpress)
                            .padding(.leading,170)
                    }
                    
                    //button
                    Button {
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                            print("Button clicked")
                        }
                        
                    } label :{
                        
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(width: 325, height: 40)
                            .background(Color.midNightExpress)
                            .cornerRadius(10)
                    }
                    .disabled(!FormIsValid)
                    .opacity(FormIsValid ? 1.0 : 0.5)
                }
                NavigationLink(destination: RoomAllocationView()) {
                                    Text("Go to Room Allocation")
                                        .foregroundColor(.white)
                                        .frame(width: 325, height: 40)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.top, 20)
                                
                                
                                Spacer()
                
               
                
            }
            .padding()
            .background(Color.solitude)
            //          .environment(\.colorScheme, .dark)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    loginView()
}

extension loginView: AuthenticationFormProtocol {
    var FormIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}
    
extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(.gray)
            .padding(10)
    }
}
