//
//  SettingsView.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/9/23.
//
import SwiftUI

struct SettingsView: View {
    @ObservedObject var gardenerManager = GardenerManager.shared
    @Binding var appState: ARViewMain.UIState
    @State var toggleState = AudioManager.shared.audioOn

    var body: some View {
        NavigationView {
            VStack {
                Text("Settings")
                    .font(.title)
                    .padding(.top, 12)
                    .foregroundColor(Color("ThemeGreen"))

                // Show collection view of seed types with more than 0 seeds
                ScrollView {
                    Toggle(isOn: $toggleState) {
                        Text("Sound FX On/Off")
                            .foregroundColor(Color("ThemeGreen"))
                    }
                    .onChange(of: toggleState) { newValue in
                        AudioManager.shared.toggleAudio()
                    }
                    .padding()
                }
                .navigationBarTitle("", displayMode: .inline)
            } .background(Color("ThemeWhite"))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        // Attribution: https://developer.apple.com/documentation/swiftui/binding/constant(_:)
        SettingsView(appState: .constant(.arMainUI))
    }
}
