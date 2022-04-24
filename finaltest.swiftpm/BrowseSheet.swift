//
//  File.swift
//  finaltest
//
//  Created by Anak Agung Gede Agung Davin on 23/04/22.
//

import SwiftUI

struct BrowseSheet: View{
    @Binding var showedBrowse: Bool
    var chosenImage: UIImage
    var chosenDesc: String
    
    var body: some View{
        NavigationView{
            VStack(alignment: .center){
                Text("Rotate the AR Objects to see more").fontWeight(.heavy).foregroundColor(.blue)
                Image(uiImage: chosenImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 350)
                
                HStack(alignment: .center){
                    Spacer(minLength: 100)
                    Text(verbatim: chosenDesc).fontWeight(.regular).font(.subheadline).multilineTextAlignment(.center)
                    Spacer(minLength: 100)
                }
                Spacer()
            }
            .navigationBarTitle(Text("Details"), displayMode: .large)
            .navigationBarItems(trailing: Button(action:{
                self.showedBrowse.toggle()
            }){
                Text("Close").bold().foregroundColor(.red)
            })
        }
    }
}
