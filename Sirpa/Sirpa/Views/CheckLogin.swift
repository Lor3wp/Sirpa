//
//  CheckLogin.swift
//  Sirpa
//
//  Created by iosdev on 12.12.2022.
//

import SwiftUI
import CoreData

struct CheckLogin: View {
    @Environment (\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID:
    FetchedResults<OnlineUser>
    @State var localUserID = ""

    //    let persistenceController = PersistenceController.shared
//        @StateObject private var coreDataManager = CoreDataManager()
//
//        @Environment(\.managedObjectContext) private var viewContext
//
//        @FetchRequest(sortDescriptors: [SortDescriptor(\.userID, order: .reverse)]) var cdUserID: FetchedResults<OnlineUser>
//
//        @State var localUserID = ""
//      // register app delegate for Firebase setup
//      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


      var body: some View {
          VStack{
              FirstPage()
                  
              
          }
        }
        
        
}

struct CheckLogin_Previews: PreviewProvider {
    static var previews: some View {
        CheckLogin()
    }
}
