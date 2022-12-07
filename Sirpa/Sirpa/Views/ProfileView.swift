//
//  ProfileView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
struct ProfileView: View {
    @ObservedObject var model = ViewModel()
    @State var tripName = ""
    @State var notes = ""
    @State var id = ""
    @State var timeAdded = ""
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    @State var retrievedImages = [UIImage]()
    @State var tripID = ""
    @State var imageDictionary = [String:UIImage]()
    @State var imageList = [UIImage]()
    @State var filteredImageDictionary = [String:UIImage]()
    @State private var presentAlert = false
    @State var isVisible = false
    
    
    struct SheetView: View {
        @Environment(\.dismiss) var dismiss
        @ObservedObject var model = ViewModel()

        var body: some View {
            ZStack {
                Color(white: 0.1).ignoresSafeArea()
                VStack {
                    Image(systemName: "cross")
                        .onTapGesture(count: 1){
                            dismiss()
                        }
//                    Button("X") {
//                        dismiss()
//                    }
//                    .padding()
//                    .cornerRadius(40)
//                    .offset(x: 130, y: -200)
//                    .foregroundColor(.white)
                    Button("Delete profile") {
        //                model.deleteUser(userToDelete: someUser)
                        print("Delete profile clicked!")
                    }
                    .frame(width: 200, height: 40)
                    .background(.white)
                    .cornerRadius(4)
                    .padding()
                    Button("Edit profile") {
        //                model.updateUserData(username: "newusername", id: "userID")
                        print("Edit profile clicked!")
                    }
                    .frame(width: 200, height: 40)
                    .background(.white)
                    .cornerRadius(4)
                    .padding()

                }.foregroundColor(.black)
            }
        }

    }
    
    var body: some View {
        ZStack{
            VStack{
                VStack (spacing: -10){
                    HStack {
                        VStack {
                            Image("face")
                                .resizable()
                                .frame(width: 100, height: 120)
                                .clipShape(Circle())
                            Text("Username")
                        }
                   
                        
                        
                        VStack{
                            Text("10")
                            Text("trips")
                        }.padding()
                        VStack{
                            Text("10")
                            Text("followers")
                        }
                        .padding()
                        VStack{
                            Image(systemName: "ellipsis")
                                .offset(y: -40)
                                .font(.system(size: 30))
                                .onTapGesture(count: 1) {
                                    isVisible.toggle()
                                }.sheet(isPresented: $isVisible) {
                                    SheetView()
                                }
                   
                            Text("10")
                            Text("following")
                        }.offset(y: -5)
                        
                    }
                    Button(action: {print("moi")}){
                        Text("Follow")
                            .frame(width: 350, height: 40)
                            .border(.white, width: 1)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(4)
//                            .offset(x: 46)
                            .padding(.top, 24)
                            .padding(.bottom, 24)
                    }
                    
                }
                
                ScrollView{
                    VStack{
                        ForEach(0..<5){_ in
                            HStack(spacing: 4){
                                ForEach(0..<2){_ in
                                    NavigationLink(destination: DetailImageView(data: "TripID")){
                                        ForEach(retrievedImages, id: \.self) { item in
                                            Image(uiImage: item)
                                                .resizable()
                                                .frame(width: 200, height: 200)
                                        }
                       
                                    }

                                }
                                
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.background(Color(white: 0.1))
            .foregroundColor(.white)
        .onAppear {
            retreiveAllPostPhotos()
        }
        .navigationBarBackButtonHidden(true)

    }

    func retreiveAllPostPhotos() {
        // get the data from the database
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                var paths = Dictionary<String, String>()
                // loop through all the returned docs
                for doc in snapshot!.documents {
                    // extract the file path
                    paths.updateValue(doc[ "file"] as! String, forKey: doc.documentID)
                }
                
                // loop through each file path and fetch the data from storage
                for path in paths {
                    // get a reference to storage
                    let storageRef = Storage.storage().reference()
                    // specify the path
                    let fileRef = storageRef.child(path.value)
                    
                    // retreive the data
                    fileRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                        // check for errors
                        if error == nil && data != nil {
                            // create a UIImage and put it in our array for display
                            if let image = UIImage(data: data!) {
                                DispatchQueue.main.async {
                                    retrievedImages.append(image)
                                    imageDictionary.updateValue(image, forKey: path.key)
                                    
                                }
                            }
                        }
                    }
                } // end loop throughs
            }
        }
    }
    
    func filteredImagesById(postIDforImage: String) -> Array<UIImage> {
        filteredImageDictionary = imageDictionary.filter{
            $0.key == postIDforImage
        }
        print("image dictionary funkkarissa \(imageDictionary)")
        print("filtered dictionary \(filteredImageDictionary)")
        for item in filteredImageDictionary {
            imageList.append(item.value)
        }
        print("imagelist \(imageList)")
        return imageList
    }
    
    init() {
        model.getTripNames()
        model.getPosts()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
