//
//  PasswordList.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-27.
//

import Foundation
import SwiftUI
import Swifter

class PasswordList: ObservableObject {
    @Published var list: [PasswordInfo]!
    
    init() {
        list = self.getSavedPasswordList()
    }
    
    // Adds new item to list and saves list
    func addCopyOfPasswordInfo(passwordInfo: PasswordInfo) {
        var newPassInfo = PasswordInfo()
        newPassInfo.username = passwordInfo.username
        newPassInfo.identifier = passwordInfo.identifier
        newPassInfo.description = passwordInfo.description
        newPassInfo.password = passwordInfo.password
        list.append(newPassInfo)
        savePasswordList()
    }
    
    // remove index from list and saves list
    func deleteItem( index: Int) {
        list.remove(at: index)
        savePasswordList()
    }
    
    // removes all items from list and saves list !!! should be removed later
    func resetList() {
        list = []
        savePasswordList()
    }
    
    func savePasswordList() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "passwordList")
        }
    }

    // On success gets a list of PasswordInfo otherwise returns []
    func getSavedPasswordList() -> [PasswordInfo] {
        let defaults = UserDefaults.standard
        if let list = defaults.object(forKey: "passwordList") as? Data {
            let decoder = JSONDecoder()
            if let passwordList = try? decoder.decode([PasswordInfo].self, from: list) {
                return passwordList
            }
        }
        return []
    }
}




struct PasswordInfo: Codable, Identifiable, Hashable {
    var id = UUID()
    var identifier: String
    var username: String
    var password: String
    var description: String
    init() {
        self.username = ""
        self.password = ""
        self.description = ""
        self.identifier = ""
    }
}

struct PasswordRow: View {
    let item: PasswordInfo
    let list: PasswordList
    let server: HttpServer
    
    init(item: PasswordInfo, list: PasswordList){
        self.item = item
        self.list = list
        self.server = serverInit(htmlString: getHTMLString(password: item.password))
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("ID: \(item.identifier)")
            Text("Username: \(item.username)")
            Text("Password: \(item.password)")
            Text("Description: \(item.description)")
            
            Button(action :{
                presentationMode.wrappedValue.dismiss()
                if let i = list.list.firstIndex(of: item) {
                    list.deleteItem(index: i)
               }
            })
            { Text("Delete") }
            
            Button(action :{ try! server.start() })
            { Text("Server Start") }
            
            Button(action :{ server.stop() })
            { Text("Stop Server") }
            
            
            
        }
    }
}
