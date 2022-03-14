//
//  UpdateView.swift
//  CRUDAPIDemo
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

import SwiftUI

struct UpdateView: View {
    @ObservedObject var networkManager = NetworkManager()
   
    @State var firstName:String = ""
    @State var lastName:String = ""
    @State var age:String = ""
    @State var activeDate = "2022-02-01 14:19:20"
    @State  var id: Int = 0
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                 .edgesIgnoringSafeArea(.vertical)
                 .overlay(
                    
                    VStack(alignment:.leading,spacing:20){
                        TextField("FirstName",text:$firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("LastName",text:$lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Age",text:$age)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("ActiveDate",text:$activeDate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: {
                            let person: People = People(id: nil, first_name: self.firstName, last_name: lastName, age: age, active_date: activeDate, created_at: "", updated_at: "")
                         
                            networkManager.updatePerson(id:id,person: person)
                           
                        }, label: {
                            Text("Save")
                        })
                        Spacer()
                    }.alert(isPresented: $networkManager.isUpdated, content: { self.alert })
                    .navigationBarTitle("Update User").padding(.all,30)
                  
             )
      
    }
    var alert: Alert {
           Alert(title: Text("Message"), message: Text("Record Deleted"), dismissButton: .default(Text("Close")))
       }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView()
    }
}
