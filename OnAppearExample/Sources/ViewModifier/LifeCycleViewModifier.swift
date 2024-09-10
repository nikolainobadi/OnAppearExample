//
//  LifeCycleViewModifier.swift
//  OnAppearExample
//
//  Created by Nikolai Nobadi on 9/10/24.
//

import SwiftUI

struct LifeCycleViewModifier: ViewModifier {
    @State private var taskCallCount = 0
    @State private var appearedCount = 0
    @State private var disappearedCount = 0
    
    let viewName: String
    
    func body(content: Content) -> some View {
        content
            .task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                
                taskCallCount += 1
                print("\(viewName) async task has been called, count: \(taskCallCount)")
                
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
    func checkingLifeCycleMethods(_ viewName: String) -> some View {
        modifier(LifeCycleViewModifier(viewName: viewName))
    }
}

