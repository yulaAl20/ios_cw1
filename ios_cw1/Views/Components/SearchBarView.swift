//
//  SearchBarView.swift
//  ios_cw1
//

import SwiftUI

struct SearchBarView: View {
    
    var placeholder: String = "Search"
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)
            Text(placeholder)
                .foregroundColor(.black.opacity(0.6))
            Spacer()
            Image(systemName: "mic.fill")
                .foregroundColor(.black.opacity(0.6))
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

#Preview {
    SearchBarView(placeholder: "Search doctors, services...")
        .padding()
}
