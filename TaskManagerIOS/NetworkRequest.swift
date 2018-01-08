//
//  NetworkRequest.swift
//  TaskManagerIOS
//
//  Created by mac on 03.01.18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequest:class{
    associatedtype Model
    func load(withCompletion completion:@escaping (NetworkError?,Model?)->Void)
    func decode(_ data:Data)->Model?
}




enum NetworkError:Error{
    case NoConnection
    case BadRequest
    case InvalidAddress
    case DescriptiveError(String)
    case ParsingError
    case notAuthorized
}


extension NetworkRequest{
    
    func load(_ url: URL, withCompletion completion: @escaping (NetworkError?,Model?) -> Void){
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = Session.shared.token{
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }else{
            completion(.notAuthorized, nil)
        }
        
        runRequest(request: request, withCompletion: completion)
        
    }
    
    

    
    
     func loadToken(_ url: URL, login:String, password:String, withCompletion completion: @escaping (NetworkError?,Model?) -> Void) {
        
        let bodyStr = "username=\(login)&password=\(password)&grant_type=password"
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = bodyStr.data(using: String.Encoding.utf8)!
    
        runRequest(request: request, withCompletion: completion)
        
    }
    
    
    private func runRequest(request:URLRequest,withCompletion completion: @escaping (NetworkError?,Model?) -> Void){
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                completion( .DescriptiveError(error.localizedDescription), nil)
            }
            guard let data = data else {
                completion(.BadRequest, nil)
                return
            }
            
            if let token = self?.decode(data)  {
                completion(nil, token)
                return
            }
            else{
                completion( .ParsingError, nil)
            }
        }
        task.resume()
        
    }

    
}
    



class ApiRequest<Resource: ApiResource>{
  
    let resource:Resource
    
    init(resource:Resource) {
        self.resource = resource
    }
    
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) -> [Resource.Model]? {
        return resource.makeModel(data: data)
    }
    
    func load(withCompletion completion: @escaping (NetworkError?,[Resource.Model]?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
    
    
}


class LoginRequest{
    let resource:LoginResource
    init(resource:LoginResource) {
        self.resource = resource
    }
}

extension LoginRequest:NetworkRequest {
  
    func load(withCompletion completion: @escaping (NetworkError?, String?) -> Void) {
        loadToken(resource.url, login: resource.login, password: resource.password, withCompletion: completion)
    }
    
    typealias Model = String
    
    func decode(_ data: Data) -> Model? {
        return resource.makeModel(data: data)
    }
    
}







struct ApiWrapper {
    let items: [Serialization]
}

extension ApiWrapper {
    private enum Keys: String, SerializationKey {
        case items
    }
    
    init(serialization: Serialization) {
        items = serialization.value(forKey: Keys.items) ?? []
    }
}



protocol ApiResource {
    associatedtype Model
    var methodPath:String { get }
    func makeModel(serialization:Serialization)->Model
}

class LoginResource{
    var methodPath:String = "token"
    let login:String
    let password:String
    
    init(login:String, password:String) {
        self.login = login
        self.password = password
    }
    
    func makeModel(data:Data)-> String?{
        
        if let serialized = data.serialize(){
            if let token = serialized["access_token"] as? String {
                return token
            }
        }
        
        return nil
    }
}

extension LoginResource {
    var url: URL{
        let baseUrl = "http://192.168.137.83/TaskManager_Back/"
        let url = baseUrl + methodPath
        return URL(string: url)!
    }
}

extension ApiResource {
    var url: URL {
        let baseUrl = "http://192.168.137.83/TaskManager_Back/"
        let url = baseUrl + methodPath
        return URL(string: url)!
    }
    
    func makeModel(data: Data) -> [Model]? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? Serialization else {
            return nil
        }
        let wrapper = ApiWrapper(serialization: jsonSerialization)
        return wrapper.items.map(makeModel(serialization:))
    }
 
}



extension Data{
    func serialize()->Serialization?{
        guard let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? Serialization else {
            return nil
        }
        return jsonSerialization
    }
    
}

























