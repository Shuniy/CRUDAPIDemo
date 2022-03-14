//
//  ContentView.swift
//  CRUDAPIDemo
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

struct ContentView: View {
    //MARK: PROPERTIES
    var alert: Alert {
        Alert(title: Text("Message"), message: Text("Record Deleted"), dismissButton: .default(Text("Close")))
    }
    
    @ObservedObject var networkManager = NetworkManager()
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    }
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background 5").edgesIgnoringSafeArea(.all)
                LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.vertical)
                    .overlay(
                        List {
                            ForEach(networkManager.people, id:\.id){ person in
                                
                                NavigationLink(destination:UpdateView(firstName: person.first_name, lastName: person.last_name, age: person.age, activeDate: person.active_date,id:person.id!)){
                                    HStack(alignment:.center,spacing:10){
                                        Image("Logo Figma")
                                        VStack(alignment:.leading){
                                            Text(person.first_name).fontWeight(.bold)
                                            Text(person.last_name).font(.caption)
                                        }
                                        Spacer()
                                        Text(person.created_at).font(.system(size:12 ))
                                    }
                                }.alert(isPresented: $networkManager.isDeleted, content: { self.alert })
                            }
                            .onDelete(perform: {
                                
                                indexSet in
                                
                                indexSet.forEach{
                                    (index) in
                                    networkManager.deletePeople(id: index)
                                }
                            }
                            ).listRowBackground(Color.white)
                        }.listStyle(InsetGroupedListStyle())
                            .navigationTitle("List People")
                        
                            .toolbar{
                                ToolbarItem(placement: .navigationBarTrailing)
                                {
                                    NavigationLink(destination:CreateView()){
                                        Text("Create").foregroundColor(.white)
                                        
                                    }
                                }
                            }
                            .onAppear() {
                                self.networkManager.performRequest()
                                
                            }
                    )
            }
        }
    }
}

//MARK: PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
