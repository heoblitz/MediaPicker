//
//  ContentView.swift
//  Example-iOS
//
//  Created by Alex.M on 26.05.2022.
//

import SwiftUI
import ExyteMediaPicker
import Combine

struct ContentView: View {

    @EnvironmentObject private var appDelegate: AppDelegate

    @State private var showDefaultMediaPicker = false
    @State private var showCustomizedMediaPicker = false

    @State private var medias: [Media] = []

    let columns = [GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible(), spacing: 1),
                   GridItem(.flexible(), spacing: 1)]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Default") {
                        showDefaultMediaPicker = true
                    }
                    Button("Customized") {
                        showCustomizedMediaPicker = true
                    }
                }

                if !medias.isEmpty {
                    Section {
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(medias) { media in
                                MediaCell(viewModel: MediaCellViewModel(media: media))
                                    .aspectRatio(1, contentMode: .fill)
                            }
                        }
                    }
                }
            }
            .foregroundColor(Color(uiColor: .label))
            .navigationTitle("Examples")
        }

        // MARK: - Default media picker
        .sheet(isPresented: $showDefaultMediaPicker) {
            MediaPicker(
                isPresented: $showDefaultMediaPicker,
                onChange: { medias = $0 }
            )
            .showLiveCameraCell()
            .orientationHandler {
                switch $0 {
                case .lock: appDelegate.lockOrientationToPortrait()
                case .unlock: appDelegate.unlockOrientation()
                }
            }
            .mediaSelectionType(.photo)
        }

        // MARK: - Customized media picker
        .sheet(isPresented: $showCustomizedMediaPicker) {
            CustomizedMediaPicker(isPresented: $showCustomizedMediaPicker, medias: $medias)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
