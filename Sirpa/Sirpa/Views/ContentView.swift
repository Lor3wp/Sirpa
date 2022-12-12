import SwiftUI
import CoreData
import Firebase
import FirebaseStorage
import CoreLocation
struct ContentView: View {
    
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
    @State var mapMarkers = [MapMarkers]()
    @State var mapMarkerNew = MapMarkers(id: "", coordinate: CLLocationCoordinate2D(), file: "", notes: "", timeStamp: Timestamp(), tripID: "", userID: "")
    @State var userID = ""
    
    //timestamp
    func timeStamp() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        return dateString
    }

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        ZStack{
  
                
            TabContentView(markers: $mapMarkers)
            Button("load markers"){
                addingDataToMapMarkers()
            }
                
        
        }
}
            
    
    func addingDataToMapMarkers() {
        
        for item in model.tripList {
            userID = item.userID
        }
        for item in model.postList {
            
            mapMarkerNew = MapMarkers(id: item.id, coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude), file: item.file, notes: item.notes, timeStamp: Timestamp(), tripID: item.tripID, userID: userID)
            
            print(mapMarkerNew)
                mapMarkers.append(mapMarkerNew)
        }
        print("markkers being added")
        print( mapMarkers)
    }
    
    
    func uploadPhoto () {
        //make sure selected image property isnt nil
        guard selectedImage != nil else {
            return
        }
        
        // Create storage reference
        let storageRef = Storage.storage().reference()
        // turn image into data
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        // Check that we were able to convert it to data
        guard imageData != nil else {
            return
        }
        
        // specify file path and name
        let path = "images/\(UUID().uuidString).jpg"
        let fileRef = storageRef.child(path)
        // upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) {
            metadata, error in
            // check for errors
            if error == nil && metadata != nil {

                // Save the data in the database in post collection
                model.addPostData(file: path, latitude: 0.00, longitude: 0.00, notes: notes, timeAdded: timeStamp(), tripID: "test")
                if selectedImage != nil {
                    DispatchQueue.main.async {
                        self.retrievedImages.append(self.selectedImage!)
                    }
                }
                   
            }
        }
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
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
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
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}



private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
