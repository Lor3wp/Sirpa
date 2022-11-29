import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @State private var oldSelectedTab = 0
    @State private var isPostingVisible = false
    let tabsTotal = 2
    let minDragTranlationForSwipe: CGFloat = 50
    
    
    var body:some View{
        VStack{
            NavigationView{
                TabView(selection : $selectedTab){
                    ZStack(alignment: .bottom){
                        HomeView()
                        if(isPostingVisible){
                            PostView()
                                .frame(height: 250)
                        }
                    }
                    .tabItem(){
                        Image(systemName: "globe.americas")
                        Text("Home")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.black, for: .tabBar)
                    .tag(0)
                        .highPriorityGesture(DragGesture().onEnded(({
                            self.handleSwipe(translation: $0.translation.width)
                        })))
                        .onAppear{
                            print(self.selectedTab)
                            self.oldSelectedTab = self.selectedTab}
                    Text("post")
                    
                        .tabItem(){
                            Image(systemName: "envelope.fill")
                        }
                        .onAppear{
                            self.selectedTab = self.oldSelectedTab
                            self.isPostingVisible.toggle()
                        }
                        .tag(3)
                    ZStack(alignment: .bottom){
                        ProfileView(isPostingVisible: $isPostingVisible)
                        if(isPostingVisible){
                            PostView()
                                .frame(height: 250)
                        }
                    }
                    .tabItem(){
                        Image(systemName: "person.fill")
                        Text("Home")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.black, for: .tabBar)
                    .tag(1)
                        .highPriorityGesture(DragGesture().onEnded(({
                            self.handleSwipe(translation: $0.translation.width)
                        })))
                        .onAppear{
                            
                            self.oldSelectedTab = self.selectedTab
                            
                        }
                    
                    
                }
            }
            
        }
    }
    
    private func handleSwipe(translation: CGFloat){
        if translation > minDragTranlationForSwipe && selectedTab > 0{
            selectedTab -= 1
        } else if translation < -minDragTranlationForSwipe && selectedTab < tabsTotal-1{
            selectedTab+=1
        }
    }
}



struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
