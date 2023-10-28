//
//  Toast.swift
//  Hoppitt Calendar
//
//  Created by Matt Hoppitt on 28/10/2023.
//

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 2
    var width: Double = .infinity
    
    init(style: ToastStyle, message: String, width: Double) {
        self.style = style
        self.message = message
        self.width = width
    }
}
