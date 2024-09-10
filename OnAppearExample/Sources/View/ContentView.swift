//
//  ContentView.swift
//  OnAppearExample
//
//  Created by Nikolai Nobadi on 9/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var path: [ChildviewType] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            GrandparentView {
                path.append(.parent)
            }
            .navigationTitle("Grandparent")
            .navigationDestination(for: ChildviewType.self) { viewType in
                GenericChildView(view: viewType, showNextView: { path.append($0) })
            }
        }
        .checkingLifeCycleMethods(CONTENT_VIEW)
    }
}


// MARK: - GrandparentView
fileprivate struct GrandparentView: View {
    let showNextView: () -> Void
    
    var body: some View {
        VStack {
            Text("I am the grandparent")
            
            Button("show next view", action: showNextView)
        }
        .checkingLifeCycleMethods("grandparent")
    }
}


// MARK: - GenericChildView
fileprivate struct GenericChildView: View {
    let view: ChildviewType
    let showNextView: (ChildviewType) -> Void
    
    var body: some View {
        VStack {
            Text("I am the \(view.rawValue) view")
            
            if let nextView = view.nextView {
                Button("Show \(nextView.rawValue) View") {
                    showNextView(nextView)
                }
            }
        }
        .checkingLifeCycleMethods(view.rawValue)
    }
}


// MARK: - Preview
#Preview {
    ContentView()
}


// MARK: - Dependencies
let CONTENT_VIEW = "ContentView"

enum ChildviewType: String {
    case parent, child, grandchild
    
    var nextView: ChildviewType? {
        switch self {
        case .parent:
            return .child
        case .child:
            return .grandchild
        case .grandchild:
            return nil
        }
    }
}
