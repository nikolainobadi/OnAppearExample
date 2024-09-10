//
//  ContentView.swift
//  OnAppearExample
//
//  Created by Nikolai Nobadi on 9/10/24.
//

import SwiftUI

/// The main content view that starts the navigation stack and contains the grandparent view.
struct ContentView: View {
    @State private var path: [ChildviewType] = [] // Tracks the navigation path through the stack.
    
    var body: some View {
        NavigationStack(path: $path) {
            // The initial view in the navigation stack.
            GrandparentView {
                path.append(.parent) // Appends the next view (parent) to the navigation path.
            }
            .navigationTitle("Grandparent") // Sets the title for the navigation view.
            .navigationDestination(for: ChildviewType.self) { viewType in
                // Dynamically navigates to the next view based on the type.
                GenericChildView(view: viewType, showNextView: { path.append($0) })
            }
        }
        .checkingLifeCycleMethods(CONTENT_VIEW) // Applies the lifecycle view modifier to monitor `ContentView`.
    }
}

// MARK: - GrandparentView

/// The first view in the navigation stack that acts as a grandparent.
fileprivate struct GrandparentView: View {
    let showNextView: () -> Void // Closure to show the next view in the navigation stack.
    
    var body: some View {
        VStack {
            Text("I am the grandparent") // Displays the text label for the grandparent view.
            Button("show next view", action: showNextView) // Button to navigate to the next view.
        }
        .checkingLifeCycleMethods("grandparent") // Applies the lifecycle view modifier to monitor `GrandparentView`.
    }
}

// MARK: - GenericChildView

/// A generic view representing child views (parent, child, grandchild) in the navigation stack.
fileprivate struct GenericChildView: View {
    let view: ChildviewType // The type of the child view (parent, child, grandchild).
    let showNextView: (ChildviewType) -> Void // Closure to show the next child view.
    
    var body: some View {
        VStack {
            Text("I am the \(view.rawValue) view") // Displays the text label for the current child view.
            if let nextView = view.nextView {
                // Button to navigate to the next child view, if available.
                Button("Show \(nextView.rawValue) View") { showNextView(nextView) }
            }
        }
        .checkingLifeCycleMethods(view.rawValue) // Applies the lifecycle view modifier to monitor `GenericChildView`.
    }
}

// MARK: - Preview

#Preview {
    ContentView() // Provides a preview of the `ContentView`.
}


// MARK: - Dependencies
let CONTENT_VIEW = "ContentView" // Constant string representing the `ContentView` name.

/// Enumeration representing different child view types and their navigation logic.
enum ChildviewType: String {
    case parent, child, grandchild
    
    /// Computes the next child view in the navigation hierarchy.
    var nextView: ChildviewType? {
        switch self {
        case .parent: return .child
        case .child: return .grandchild
        case .grandchild: return nil
        }
    }
}
