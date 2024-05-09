import SwiftUI
import Firebase

struct ForgotPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var isPasswordRecoveryLinkSent: Bool = false
    
    @State private var showAlert = false
    @State private var errorDescription = ""
    
    var body: some View {
        VStack {
            Text("forgot-password-string")
                .font(.title)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .withTextFieldRectangleModifier()
                TextField("enter-your-email-string", text: $email)
                    .withDefaultTextFieldModifier()
            }
            
            Button(action: {
                let auth = Auth.auth()
                
                auth.sendPasswordReset(withEmail: email) { error in
                    if let error = error {
                        errorDescription = error.localizedDescription
                        self.showAlert = true
                    } else {
                        self.isPasswordRecoveryLinkSent = true
                    }
                }
            }) {
                Text("send-recovery-email-string")
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("error-string"), message: Text(errorDescription), dismissButton: .default(Text("ok-string")))
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("password-recovery-string")
        .alert(isPresented: $isPasswordRecoveryLinkSent) {
            Alert(title: Text("password-recovery-string"),
                  message: Text("password-recovery-link-sent-to \(email)"),
                  dismissButton: .default(Text("ok-string")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .background(
            VStack {
            }
        )
    }
}

//#Preview {
    
//    Button {
////        self.isRecoveryViewPresented.toggle()
//    } label: {
//        Text("forgot-password-string")
//    }
//    .sheet(isPresented: true) {
//        ForgotPasswordView()
//        .environmentObject(@Environment(\.presentationMode))
        
//    }

    
//    ForgotPasswordView(presentationMode: .))
//    ForgotPasswordView(presentationMode: ., email: <#T##String#>, isPasswordRecoveryLinkSent: <#T##Bool#>, showAlert: <#T##arg#>, errorDescription: <#T##arg#>)
//}
