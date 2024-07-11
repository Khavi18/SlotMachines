//
//  ContentView.swift
//  SlotMachineSwiftUI
//
//  Created by Khavishini on 09/07/2024.
//

import SwiftUI

struct ContentView: View {
    
    let symbols = [bell, cherry, coin, grape, seven, strawberry]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var showingModel: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    
    //Spin reels
    func spinReels() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    //Check winning
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] {
            //Player wins
            playerWins()
            //New HighScore
            if coins > highScore {
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            //Player loses
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highScore = coins
        UserDefaults.standard.setValue(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activateBet20() {
        betAmount = 20
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmount = 10
        isActiveBet10 = true
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    //Game over
    func isGameOver() {
        if coins <= 0 {
            //Show modal
            showingModel = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        UserDefaults.standard.setValue(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
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
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highScore)")
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
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        //Reel 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                        Spacer()
                        
                        //Reel 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                    }) //:HStack
                    .frame(maxWidth: 500)
                    
                    //Spin Button
                    
                    Button(action: {
                        withAnimation {
                            self.animatingSymbol = false
                        }
                        self.spinReels()
                        withAnimation {
                            self.animatingSymbol = true
                        }
                        self.checkWinning()
                        self.isGameOver()
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
                            self.activateBet20()
                        }, label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? .white : .yellow)
                                .modifier(BetNumberModifier())
                        })
                        .modifier(BetCapsuleModifier())
                        
                        Image(casinoChips)
                            .resizable()
                            .offset(x: isActiveBet10 ? 20 : 0)
                            .opacity(isActiveBet10 ? 0 : 1)
                            .modifier(CasinoChipsModifier())
                    } //: HStack
                    Spacer()
                    //Bet 10
                    HStack(alignment: .center, spacing: 10) {
                        Image(casinoChips)
                            .resizable()
                            .offset(x: isActiveBet10 ? 0 : -20)
                            .opacity(isActiveBet10 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.activateBet10()
                        }, label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet10 ? .yellow : .white)
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
                    self.resetGame()
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
            .blur(radius: $showingModel.wrappedValue ? 5 : 0, opaque: false)
            
            //Popup
            if $showingModel.wrappedValue {
                ZStack {
                    Color(blackT)
                        .ignoresSafeArea(edges: .all)
                    
                    VStack(spacing: 0, content: {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded, weight: .heavy))
                            .padding()
                            .background(Color(pink))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16, content: {
                            Image(sevenReel)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all of the coins. \n Let's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModel = false
                                self.animatingModal = false
                                self.activateBet10()
                                self.coins = 100
                            }, label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded, weight: .semibold))
                                    .tint(Color(pink))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .tint(Color(pink))
                                    )
                            })
                        })
                        Spacer()
                    })
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color(blackT), radius: 6, x: 0, y: 8)
                    .opacity($animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModal.wrappedValue ? 0 : -100)
                    .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: animatingModal)
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                }
            }
            
            
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
