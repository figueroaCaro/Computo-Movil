//
//  CardButton.swift
//  sensibity
//
//  Created by alumno on 20/04/26.
//
import SwiftUI

struct CardButton: View {
    var title: String

    var body: some View {
        Text(title)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(15)
    }
}
