//
//  NetworkManager.swift
//  CRUDAPIDemo
//
//  Created by Shubham Kumar on 01/02/22.
//

import Foundation
class NetworkManager: ObservableObject {
    //MARK: PROPERTIES
    // Steps to work with HTTP request
    //1. create urlString
    //2. create session
    //3 working with your task
    
    let urlString = "https://peopleinfoapi.herokuapp.com/api/people"
    @Published var people = [People]()
    @Published var isDeleted = false
    @Published var isCreated = false
    @Published var isUpdated = false
    
    //MARK: PERFORM REQUEST
    func performRequest() {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) {
                (data, response, error) in
                
                if (error != nil){
                    print(error!)
                    return
                }
                
                print(response!)
                
                if let safeData = data {
                    self.parseJSON(peopleModel: safeData)
                }
            }.resume()
        }
    }//: perform Request
    
    //MARK: JSON DECODING
    func parseJSON(peopleModel: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(PeopleModel.self, from: peopleModel)
            
            DispatchQueue.main.async {
                self.people = decodedData.data
            }
        } catch {
            print("error parsing JSON : \(error.localizedDescription)")
        }
    }//:ParseJSON
    
    //create new person
    func createNew(person: People){
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let parameters: [String: Any] = [
            "first_name": person.first_name,
            "last_name": person.last_name,
            "age": person.age,
            "active_date": person.active_date,
        ]
        
        let jsonData = try?JSONSerialization.data(withJSONObject: parameters)
        request.httpBody = jsonData
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request){
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            guard let _ = data else {
                return
            }
            
            if error == nil, let resp = response as? HTTPURLResponse {
                if resp.statusCode == 201 {
                    DispatchQueue.main.async {
                        self.isCreated = true
                    }
                }
            }
        }.resume()
        
    }//:CreateNew
    
    func updatePerson(id:Int, person:People) {
        var request = URLRequest(url: URL(string: urlString + "\(id)")!)
        request.httpMethod = "PUT"
        
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //Data
        let parameters: [String: Any] = [
            "first_name": person.first_name,
            "last_name": person.last_name,
            "age": person.age,
            "active_date": person.active_date,
            
        ]
        
        //Converting data or paramters to JSON
        let jsonData = try?JSONSerialization.data(withJSONObject: parameters)
        
        request.httpBody = jsonData
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            if error == nil, let resp = response as? HTTPURLResponse {
                if resp.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.isUpdated = true
                    }
                }
            }
            
            guard let response = data else {return}
            let status = String(data:response,encoding: .utf8) ?? ""
            print(status)
        }.resume()
        
    }//:updatePerson
    
    //Delete person
    func deletePeople(id: Int) {
        let personId = people[id].id
        print("To delete id : \(personId!)")
        
        var request = URLRequest(url:URL(string: "\(urlString)/\(personId!)")!)
        
        request.httpMethod  = "DELETE"
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
            }
            
            if error == nil, let data = data, let resp = response as? HTTPURLResponse  {
                print(resp.statusCode)
                print(data)
                
                DispatchQueue.main.async {
                    self.people.removeAll {
                        (person) -> Bool in
                        return person.id == personId
                    }
                    self.isDeleted = true
                    self.performRequest()
                }
            }
        }.resume()
        
    }//:Delete people
    
}
