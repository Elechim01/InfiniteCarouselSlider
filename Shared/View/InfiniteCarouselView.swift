//
//  InfiniteCarouselView.swift
//  InfiniteCarouselSlider (iOS)
//
//  Created by Michele Manniello on 25/09/21.
//

import SwiftUI

struct InfiniteCarouselView: View {
//    Tabs...
    @Binding var tabs : [Tab]
    @Binding var currentIndex : Int
    
    @State var fakeIndex: Int = 0
    @State var offset : CGFloat = 0
    @State var genricTabs : [Tab] = []
    
    var body: some View {
        TabView(selection: $fakeIndex){
            ForEach(genricTabs){ tab in
//                Cards View...
                VStack(spacing: 18){
                    
                    Spacer()
                    
                    Text("Your Condition")
                        .font(.title3.bold())
                        .foregroundColor(.gray)
                    
                    Text(tab.title)
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 75,weight: .light))
                        .foregroundColor(.green)
                        .padding(.bottom)
                    Spacer()
                }
                .padding(.horizontal,20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .clipShape(CustomCardShape())
                .cornerRadius(30)
                .padding(.horizontal,50)
                .overlay(
                    GeometryReader{ proxy in
                        Color.clear
                            .preference(key: Offsetkey.self, value: proxy.frame(in: .global).minX)
                    }
                )
                .onPreferenceChange(Offsetkey.self, perform: { offset in
                    self.offset = offset
                })
                .tag(getIndex(tab: tab))
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
//        max size...
        .frame(height: 350)
        .padding(.top,20)
        .onChange(of: offset) { newValue in
//            Logic...
//            Add First Item last and when ever content is scrolled to last just scrolllback to first widthout animation
//            Add Last item to first and do the same
//            So it will create Infinite Crousel Type Animation....
            if fakeIndex == 0 && offset == 0{
//                moving to last -1...
                fakeIndex = genricTabs.count - 2
            }
            if fakeIndex == genricTabs.count - 1 && offset == 0{
                fakeIndex = 1
            }
        }
        .onAppear {
            genricTabs = tabs
//            Add first and last extra tow items...
            guard var first = genricTabs.first else {
                return
            }
            guard var last = genricTabs.last else {
                return
            }
//            updating ID else it will create issues in view bcz of same ID...
            first.id = UUID().uuidString
            last.id = UUID().uuidString
            
            genricTabs.append(first)
            genricTabs.insert(last, at: 0)
            fakeIndex = 1
        }
//        Updating Real Time...
        .onChange(of: tabs) { newValue in
            genricTabs = tabs
//            Add first and last extra tow items...
            guard var first = genricTabs.first else {
                return
            }
            guard var last = genricTabs.last else {
                return
            }
//            updating ID else it will create issues in view bcz of same ID...
            first.id = UUID().uuidString
            last.id = UUID().uuidString
            
            genricTabs.append(first)
            genricTabs.insert(last, at: 0)
            fakeIndex = 1
        }
//        Updating CurrentIndex...
        .onChange(of: fakeIndex) { newValue in
            currentIndex = fakeIndex - 1
        }
        
    }
    
    func getIndex(tab: Tab) -> Int {
        let index = genricTabs.firstIndex { currentTab in
            return currentTab.id == tab.id
        } ?? 0
        return index
    }
}

struct Home_Previews1: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Offsetkey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
