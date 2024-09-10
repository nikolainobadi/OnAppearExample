//
//  LifeCycleViewModifier.swift
//  OnAppearExample
//
//  Created by Nikolai Nobadi on 9/10/24.
//

import SwiftUI

/// A view modifier that monitors the lifecycle events of a view, such as `.onAppear`, `.onDisappear`, and `.task`.
struct LifeCycleViewModifier: ViewModifier {
    @State private var taskCallCount = 0 // Tracks how many times the `.task` modifier is called.
    @State private var appearedCount = 0 // Tracks how many times the `.onAppear` modifier is called.
    @State private var disappearedCount = 0 // Tracks how many times the `.onDisappear` modifier is called.
    
    let viewName: String // The name of the view being monitored.

    func body(content: Content) -> some View {
        content
            .task {
                // Simulate a delay to represent a typical data loading task.
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                taskCallCount += 1
                print("\(viewName) async task has been called, count: \(taskCallCount)")

                // Ensures the `.task` is only called once for ContentView; throws a fatal error if called more than once.
                if viewName == CONTENT_VIEW {
                    print("This is the BEST place for data loading")
                    if taskCallCount > 1 {
                        fatalError("This should NOT be called twice")
                    }
                }
                print("----------------------------------------------------------------\n")
            }
            .onAppear {
                appearedCount += 1
                print("\(viewName) has appeared, count: \(appearedCount)")
                
                // Ensures the `.onAppear` is only called once for ContentView; throws a fatal error if called more than once.
                if viewName == CONTENT_VIEW && appearedCount > 1 {
                    fatalError("This should NOT be called twice")
                }
            }
            .onDisappear {
                disappearedCount += 1
                print("\(viewName) has DISAPPEARED, count: \(disappearedCount)")
            }
    }
}

extension View {
    /// A convenience method for applying the `LifeCycleViewModifier` to a view.
    func checkingLifeCycleMethods(_ viewName: String) -> some View {
        modifier(LifeCycleViewModifier(viewName: viewName))
    }
}
