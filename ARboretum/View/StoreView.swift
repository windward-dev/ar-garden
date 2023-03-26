//
//  StoreView.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//

import SwiftUI

struct StoreItem {
    let name: String
    let image: Image
    let cost: Int
}

struct StoreView: View {
    @ObservedObject var gardenerManager = GardenerManager.shared
    @Binding var appState: ARViewMain.UIState
    
    let storeItems = [
        StoreItem(name: "Generic", image: Image("Generic"), cost: 0),
        StoreItem(name: "Sunflower", image: Image("Sunflower"), cost: 5),
        StoreItem(name: "Lily", image: Image("Lily"), cost: 10),
        StoreItem(name: "Hydrangea", image: Image("Hydrangea"), cost: 20),
    ]
    
    @State private var currentFunds = GardenerManager.shared.getMoney()
    @State private var lastPurchase = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Store")
                    .font(.title)
                    .padding(.top, 12)
                    .foregroundColor(Color("ThemeGreen"))
                Text("Your money: $\(currentFunds)")
                    .font(.subheadline)
                    .foregroundColor(Color("ThemeGreen"))
                Text(lastPurchase)
                    .font(.subheadline)
                    .foregroundColor(Color("ThemeGreen"))
                    .padding(.top, 3)

                // Show collection view of seed types with more than 0 seeds
                ScrollView {
                    // Attribution: https://www.appcoda.com/swiftui-lazyvgrid-lazyhgrid/
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(storeItems, id: \.name) { item in
                            VStack {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(Color("ThemeGreen"))
                                    .padding(.top, 8)
                                
                                // Attribution: https://stackoverflow.com/questions/57269651/add-a-border-with-cornerradius-to-an-image-in-swiftui-xcode-beta-5
                                item.image
                                    .resizable()
                                    .cornerRadius(10)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("ThemeGreen"), lineWidth: 4))
                                    .shadow(radius: 2)
                                
                                Button(action: {
                                    if gardenerManager.getMoney() >= item.cost {
                                        gardenerManager.removeMoney(money: item.cost)
                                        gardenerManager.addSeed(seedType: item.name)
                                        currentFunds -= item.cost
                                        lastPurchase = "Bought \(item.name) seed!"
                                    } else {
                                        lastPurchase = "Insufficient funds!"
                                    }
                                }) {
                                    Text("Buy: $\(item.cost)")
                                        .font(.subheadline)
                                        .foregroundColor(Color("ThemeWhite"))
                                        .padding(5)
                                        .background(Color("ThemeGreen"))
                                        .cornerRadius(8)
                                }
                            }
                            .background(.clear)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("", displayMode: .inline)
            } .background(Color("ThemeWhite"))
        }
    }
}


struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView(appState: .constant(.arMainUI))
    }
}
