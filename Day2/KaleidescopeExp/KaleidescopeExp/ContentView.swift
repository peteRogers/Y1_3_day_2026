//
//  ContentView.swift
//  KaleidescopeExp
//
//  Created by Peter Rogers on 19/01/2026.
//

import SwiftUI

struct ContentView: View {
    


   
   
    @State private var start = Date.now
    var body: some View {
        VStack{
            TimelineView(.animation) { timeline in
                let time = start.distance(to: timeline.date)
                let animatedCount = 18 + sin(time) * 18
                
                GeometryReader { geo in
                    Image("stainWindow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .distortionEffect(
                            ShaderLibrary.kaleidoscope(
                                .float2(geo.size.width, geo.size.height),
                                .float2(0, 0),
                                .float(10), //how many segments
                                .float(animatedCount / .pi), //rotation
                                .float(animatedCount+1)//scale
                            ),
                            maxSampleOffset: CGSize(
                                width: geo.size.width/2,
                                height: geo.size.height/2
                            )
                        )
                }
            }
                
        }.frame(maxWidth:.infinity,maxHeight:.infinity)
            .padding()
            .background(.black)
    }
    
}

#Preview {
    ContentView()
}
