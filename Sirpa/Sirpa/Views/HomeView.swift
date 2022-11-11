//
//  HomeView.swift
//  Sirpa
//
//  Created by iosdev on 11.11.2022.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack{
            Color.red
            Image(systemName:"globe.americas")
                .font(.system(size: 250))
        }    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
