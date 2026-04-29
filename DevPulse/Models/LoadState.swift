//
//  LoadState.swift
//  DevPulse
//
//  Created by David Messer on 4/28/26.
//

import Foundation

enum LoadState<T> {
    case idle
    case loading
    case loaded(T)
    case error(String)
}
