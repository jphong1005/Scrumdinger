//
//  ScrumsView.swift
//  Scrumdinger
//
//  Created by 홍진표 on 2023/06/02.
//

import SwiftUI

struct ScrumsView: View {
    
    // MARK: - State Binding-Prop
    @Binding var scrums: [DailyScrum]
    
    // MARK: - State-Prop
    @State private var isPresentingNewScrumView: Bool = false
    
    var body: some View {
        NavigationStack {
            List($scrums) { $scrum in
                
                NavigationLink {
                    DetailView(scrum: $scrum)
                } label: {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
            .navigationTitle("Daily Scrums")
            .toolbar {
                Button {
                    isPresentingNewScrumView = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Scrum")
            }
        }
        .sheet(isPresented: $isPresentingNewScrumView) {
            NewScrumSheet(isPresentingNewScrumView: $isPresentingNewScrumView, scrums: $scrums)
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData))
    }
}
