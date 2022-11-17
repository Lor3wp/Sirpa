//
//  ProfileView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isPostingVisible:Bool
    var body: some View {
        ZStack{
            Color.blue
                VStack{
                    Image(systemName:"person.fill.turn.down")
                        .font(.system(size: 150))
                    
                    NavigationLink(destination: DetailImageView(data: "Image")){
                        Text("Open image")
                            .frame(width: 200, height: 100)
                            .background(Color.yellow)
                            .foregroundColor(.red)
                        
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        if (isPostingVisible){
                            isPostingVisible.toggle()
                        }
                    })
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isPostingVisible: .constant(true))
    }
}
