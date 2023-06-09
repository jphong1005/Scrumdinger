//
//  ContentView.swift
//  Scrumdinger
//
//  Created by 홍진표 on 2023/06/01.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    
    // MARK: - State Binding-Prop
    @Binding var scrum: DailyScrum
    
    // MARK: - StateObject-Props
    @StateObject var scrumTimer: ScrumTimer = ScrumTimer()
    @StateObject var speechRecognizer: SpeechRecognizer = SpeechRecognizer()
    
    // MARK: - State-Prop
    @State private var isRecording: Bool = false
    
    // MARK: - Computed-Prop
    private var player: AVPlayer {
        
        AVPlayer.sharedDingPlayer
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                
                MeetingTimerView(speakers: scrumTimer.speakers, theme: scrum.theme, isRecording: isRecording)
                
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear(perform: {
            startScrum()
        })
        .onDisappear(perform: {
            endScrum()
        })
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Methods
    private func startScrum() -> Void {
        
        scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
        scrumTimer.speakerChangedAction = {
            
            player.seek(to: .zero)
            player.play()
        }
        
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
        scrumTimer.startScrum()
    }
    
    private func endScrum() -> Void {
        
        scrumTimer.stopScrum()
        speechRecognizer.stopTranscribing()
        isRecording = false
        
        let newHistory: History = History(attendees: scrum.attendees, transcript: speechRecognizer.transcript)
        
        scrum.history.insert(newHistory, at: 0)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
