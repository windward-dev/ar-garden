//
//  SeedPouchView.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/7/23.
//

import SwiftUI

// Shows all the seeds owned by the gardener and allows them to select one to plant
struct SeedPouchView: View {
    @ObservedObject var gardenerManager = GardenerManager.shared
    @StateObject var vm: SeedViewModel
    @Binding var appState: ARViewMain.UIState

    var body: some View {
        NavigationView {
            VStack {
                Text("Seed Pouch")
                    .font(.title)
                    .padding(.top, 12)
                    .foregroundColor(Color("ThemeGreen"))

                // Show collection view of seed types with more than 0 seeds
                ScrollView {
                    // Attribution: https://www.appcoda.com/swiftui-lazyvgrid-lazyhgrid/
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(gardenerManager.getGardener().seedPouch.filter({ $0.value > 0 }), id: \.key) { seedType, seedCount in
                            VStack {
                                Text(seedType)
                                    .font(.headline)
                                    .padding(.top, 8)
                                    .foregroundColor(Color("ThemeGreen"))
                                
                                Image(seedType)
                                    .resizable()
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("ThemeGreen"), lineWidth: 4))
                                    .shadow(radius: 2)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                
                                Text("Seeds: \(seedCount)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("ThemeGreen"))
                                    .padding(.bottom, 8)
                            }
                            .background(.clear)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                            .onTapGesture {
                                vm.selectedSeed = seedType
                                appState = .seedPlantUI
                                
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("", displayMode: .inline)
            } .background(Color("ThemeWhite"))
        }
    }
}

struct SeedPouchView_Previews: PreviewProvider {
    static var previews: some View {
        // Attribution: https://developer.apple.com/documentation/swiftui/binding/constant(_:)
        SeedPouchView(vm: SeedViewModel(), appState: .constant(.arMainUI))
    }
}
