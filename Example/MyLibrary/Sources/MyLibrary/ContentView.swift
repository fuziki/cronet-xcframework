//
//  ContentView.swift
//  Example
//
//  Created by fuziki on 2022/06/19.
//

import Cronet
import Foundation
import SwiftUI

public struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    public init() {
        viewModel = ContentViewModel()
    }
    public var body: some View {
        VStack {
            Text("Hello, world!")
            Button {
                viewModel.fetch()
            } label: {
                Text("fetch!!!!!")
                    .padding()
            }
            Text(viewModel.result)
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

@MainActor
class ContentViewModel: ObservableObject {
    @Published var result: String = "no result"

    let configuration: URLSessionConfiguration
    let url = URL(string: "https://storage.cloud.google.com/chromium-cronet/ios/103.0.5060.53/Release-iphoneos/cronet/LICENSE")!
    init() {
        configuration = URLSessionConfiguration.default
    }

    func onAppear() {
        Cronet.setQuicEnabled(true)

        Cronet.start()

        Cronet.install(into: configuration)
        // ↑ or ↓
        Cronet.registerHttpProtocolHandler()
    }

    func fetch() {
        Task {
            let session = URLSession(configuration: configuration) // or URLSession.shared
            let response: (Data, URLResponse) = try! await session.data(from: url)
            result = String(data: response.0, encoding: .utf8) ?? "nil response"
        }
    }
}
