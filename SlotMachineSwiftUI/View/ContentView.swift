//
//  ContentView.swift
//  SlotMachineSwiftUI
//
//  Created by Khavishini on 09/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingInfoView: Bool = false
    
    var body: some View {
        ZStack {
            //Background
            LinearGradient(gradient: Gradient(colors: [Color(pink), Color(purple)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
            
            //Interface
            VStack(alignment: .center, spacing: 5) {
                //Header
                LogoView()
                
                Spacer()
                
                //Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("100")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("200")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }//: HStack
                
                //Slot Machine
                
                VStack(alignment: .center, spacing: 0, content: {
                    //Reel 1
                    ZStack {
                        ReelView()
                        Image(bell)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        //Reel 2
                        ZStack {
                            ReelView()
                            Image(seven)
                                .resizable()
                                .modifier(ImageModifier())
                        }
                        Spacer()
                        
                        //Reel 3
                        ZStack {
                            ReelView()
                            Image(cherry)
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }) //:HStack
                    .frame(maxWidth: 500)
                    
                    //Spin Button
                    
                    Button(action: {
                        print("spin")
                        
                    }, label: {
                        Image(spinString)
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    })
                })//: Slot macshine VStack
                .layoutPriority(2)
                
                //Footer
                Spacer()
                
                HStack {
                    //Bet 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            print("20")
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        Image(casinoChips)
                            .resizable()
                            .opacity(0)
                            .modifier(CasinoChipsModifier())
                    } //: HStack
                    
                    //Bet 10
                    HStack(alignment: .center, spacing: 10) {
                        Image(casinoChips)
                            .resizable()
                            .opacity(1)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            print("10")
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(.yellow)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                    } //: HStack
                } //: HStack
            }//:VStack
            //Buttons
            .overlay(
                //Reset
                Button(action: {
                    print("Reset")
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()), alignment: .topLeading
            )
            .overlay(
                //Info
                Button(action: {
                    self.showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()), alignment: .topTrailing
            )
            
            .padding()
            .frame(maxWidth: 720)
            
            //Popup
        } //: ZStack
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
        .padding(.top, 50)
        .ignoresSafeArea(edges: .all)
        
    }
}

#Preview {
    ContentView()
}
