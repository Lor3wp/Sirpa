//
//  PostView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        ZStack{
            Color.green
            Image(systemName:"envelope.fill")
                .font(.system(size: 150))
        }
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
