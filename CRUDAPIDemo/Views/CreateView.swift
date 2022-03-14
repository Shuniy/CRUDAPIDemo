//
//  CreateView.swift
//  CRUDAPIDemo
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

struct CreateView: View {
    @ObservedObject var networkManager = NetworkManager()

    @State var firstName:String = "" // binding
    @State var lastName:String = ""
    @State var age:String = ""
    @State var activeDate = "2022-02-01 14:19:20"
    
    init() {
      
    }
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                 .edgesIgnoringSafeArea(.vertical)
                 .overlay(
                    VStack(alignment:.leading,spacing:20){
                        
                        TextField("FirstName",text:$firstName)  .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("LastName",text:$lastName)  .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Age",text:$age)  .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("ActiveDate",text:$activeDate)  .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            let person: People = People(id: nil, first_name: self.firstName, last_name: lastName, age: age, active_date: activeDate, created_at: "", updated_at: "")
                         
                         networkManager.createNew(person: person)
                            
                           
                        }, label: {
                            Text("Save").bold()
                        }).alert(isPresented: $networkManager.isCreated, content: { self.alert })
                        Spacer()
                    }
                    .navigationBarTitle("Create New User", displayMode: .inline).foregroundColor(.white).padding()

                  
             )
     
    }
    

    var alert: Alert {
           Alert(title: Text("Message"), message: Text("Record Created"), dismissButton: .default(Text("Close")))
       }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
