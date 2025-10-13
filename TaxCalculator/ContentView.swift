//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Takuma Nezu on 2025/04/09.
//

import SwiftUI

struct ContentView: View {
    @State var inputText = ""
    @State var tax8 = 0.0
    @State var tax10 = 0.0

    var body: some View {
        VStack(spacing: 20) {
            TextField("ここに金額を入力", text: $inputText)
                .keyboardType(.numberPad)

            Button("計算"){
                //ここに処理を記載
                tax8 = (Double(inputText) ?? 0) * 1.08
                tax10 = (Double(inputText) ?? 0) * 1.10
            }
            
            Text("価格：\(inputText)")
                .padding()
            Text("消費税8%：\(tax8)")
            Text("消費税10%：\(tax10)")

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
