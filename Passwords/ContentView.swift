//
//  ContentView.swift
//  Passwords
//
//  Created by Braeden Norman on 2021-06-23.
//

import SwiftUI
import Swifter



struct ContentView: View {
    @State var passwordInfo = PasswordInfo()
    @StateObject  var passwordList = PasswordList()
    @State var server: HttpServer = serverInit()
    @State var ipAddress = getWiFiAddress()
    @State var show = false
    
    var body: some View {
        VStack() {
            ScrollView {
                VStack() {
                    ForEach(passwordList.list, id: \.self) { passwordInfo in
                        PasswordInfoRow(passwordInfo: passwordInfo, list: passwordList)
                    }
                }
            }
            VStack(){
                let usernameTF: TextField = TextField("Username", text: $passwordInfo.username)
                usernameTF.frame(width: 200, height: 20, alignment: .center)
                let passwordTF: TextField = TextField("Password", text: $passwordInfo.password)
                passwordTF.frame(width: 200, height: 20, alignment: .center)
                let descriptionTF: TextField = TextField("Description", text: $passwordInfo.description)
                descriptionTF.frame(width: 200, height: 20, alignment: .center)
                let identifierTF: TextField = TextField("Identifier", text: $passwordInfo.identifier)
                identifierTF.frame(width: 200, height: 20, alignment: .center)
            }
            
            
            Button(action: { buttonEnterCallback()})
            { Text("Enter") }
            
            Button(action :{passwordList.resetList() })
            { Text("Reset List") }
            
            Button(action :{ try! server.start() })
            { Text("Server Start") }
            
            Button(action :{ server.stop() })
            { Text("Stop Server") }
            
            Button(action :{ self.show.toggle() })
            { Text("Toggle") }
            
            Text(ipAddress!)
        }.opacity(self.show ? 0 : 1)
        
        if self.show {
            GeometryReader{_ in
                PasswordOptionsPopup()
            }.background (
                Color.white.opacity(0.65)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {})
            
            Button(action: { withAnimation {
                self.show.toggle()
            }})
            { Text("Close") }
        }
        
        
    }
    
    func buttonEnterCallback() {
        passwordList.addCopyOfPasswordInfo(passwordInfo: passwordInfo)
        passwordInfo.password = ""
        passwordInfo.username = ""
        passwordInfo.description = ""
        passwordInfo.identifier = ""
    }
}


func serverInit() -> HttpServer{
    let server = HttpServer()
    server["dumbass"] = scopes {
        html {
            body {
            h1 { inner = "Amir is a fucking dumbass" }
          }
        }
      }
    server[""] = { request in
        return HttpResponse.ok(.text(getHTMLString(password: "somestupidpassword")))
    }
    return server
}


func getHTML() -> String {
    var html = "test"
    if let htmlPathURL = Bundle.main.url(forResource: "server", withExtension: "html"){
        do {
            html = try String(contentsOf: htmlPathURL, encoding: .utf8)
        } catch  {
            print("Unable to get the file.")
        }
    }

    return html
}




