//
//  StartingView.swift
//  ARboretum
//
//  Created by Patrick Whalen on 3/1/23.
//

import SwiftUI

struct SplashView: View {
    // Attribution: https://www.hackingwithswift.com/quick-start/swiftui/how-to-show-an-alert
    @State private var appLaunchCount = UserDefaults.standard.integer(forKey: "appLaunchCount")
    @State private var showingAlert = false
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        //Attribution: https://designcode.io/swiftui-handbook-light-dark-modes
        NavigationView{
            ZStack {
                Color("ThemeBG").ignoresSafeArea()
                VStack{
                    Text("ARboretum")
                        .font(.largeTitle)
                        .foregroundColor(Color("TextSwitch"))
                        .padding()
                    Spacer()
                    Image(systemName: "leaf")
                        .font(.system(size: 120.0))
                        .foregroundColor(Color("TextSwitch"))
                    NavigationLink(destination: ARViewMain().environmentObject(appState).navigationBarBackButtonHidden(true)
                        .onAppear {
                            AudioManager.shared.playSoundEffect(soundFile: "arboretumStartSound")
                    }) {
                        Text("Open AR Garden")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("TextSwitch"))
                            .padding()
                    }
                    Spacer()
                    Text("Patrick Whalen")
                        .font(.subheadline)
                        .foregroundColor(Color("TextSwitch"))
                        .padding()

                }
            }
        }.background(.clear)
        .onAppear {
            appLaunchCount += 1
            UserDefaults.standard.set(appLaunchCount, forKey: "appLaunchCount")
            
            let stanDefaults = UserDefaults.standard
            
            // Add first launch date for first app launch
            if appLaunchCount == 1 {
                let appDefaults = [
                    "name_preference": "Patrick Whalen",
                    "first_launch": Date()
                ] as [String : Any]
                stanDefaults.register(defaults: appDefaults)
                stanDefaults.synchronize()
            } else {
                let appDefaults = [
                    "name_preference": "Patrick Whalen",
                ]
                stanDefaults.register(defaults: appDefaults)
                stanDefaults.synchronize()
            }
            
            // Trigger rating alert on 3rd launch
            if appLaunchCount == 3 {
                print("Third app launch detected.")
                showingAlert = true
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Rate this App in the App Store"),
                message: Text("If you're enjoying gardening, please give us a rating on the App Store!"),
                primaryButton: .default(
                    Text("Rate")
                ),
                secondaryButton: .destructive(
                    Text("Not now")
                )
            )
        }
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
