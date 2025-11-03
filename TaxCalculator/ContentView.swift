//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Takuma Nezu on 2025/04/09.
//

import SwiftUI
import GoogleMobileAds

struct ContentView: View {
    @State private var inputText = ""
    @State private var inputValue = 0.0
    @State private var tax0 = "0"
    @State private var tax8 = "0"
    @State private var tax10 = "0"
    @State private var saveText = 0.0
    @State var ClacFlg = false
    @State var opType = 0

    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        return f
    }()


    private let buttons = [
        ["", "", "", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
        ["0", "C", "="]
    ]

    //ディスプレイ
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack() {
                //テスト広告
                //AdBannerView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                //本番広告
                AdBannerView(adUnitID: "ca-app-pub-4013798308034554/7920663953")
                    .frame(width: 320, height: 50)

                Spacer()

                //金額表示スペース
                VStack(alignment: .leading, spacing: 25) {
                    displayRow(label: "0%  ", value: tax0, color: .white)
                    displayRow(label: "8%  ", value: tax8, color: .yellow)
                    displayRow(label: "10%", value: tax10, color: .red)
                }
                .padding(.horizontal, 20)
                //金額表示スペース

                //ボタンスペース
                VStack(spacing: 10) {
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { label in
                                if label.isEmpty {
                                    Rectangle()
                                        .frame(width: 84, height: 84)
                                        .opacity(0)
                                } else {
                                    Button(action: {
                                        buttonTapped(label)
                                    }) {
                                        Text(label)
                                            .font(.system(size: fontSize(for: label), weight: .medium))
                                            .frame(width: label == "0" ? 180 : 84, height: 84)
                                            .background(buttonColor(for: label))
                                            .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.white.opacity(0.2)))
                                            .cornerRadius(35)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                }
                //ボタンスペース
            }
        }
    }

    //ボタンの色
    func buttonColor(for label: String) -> Color {
        switch label {
        case "÷", "×", "−", "+", "=":
            return Color.orange // 演算子
        case "C", "AC":
            return Color(white: 0.4) // 薄いグレー
        default:
            return Color(white: 0.2) // 濃いグレー（数字）
        }
    }

    //ボタンのフォントサイズ
    func fontSize(for label: String) -> CGFloat {
        switch label {
        case "÷", "×", "−", "+", "=":
            return 44  // 演算子を大きく
        default:
            return 34
        }
    }

    //ディスプレイ
    // MARK: - Display Component
    func displayRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            Spacer()
            Text(value)
                .monospacedDigit()
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(color)
            Text("円")
                .padding(.top)
                .monospacedDigit()
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
        }
    }

    // ボタンが押された時の処理
    func buttonTapped(_ label: String) {
        switch label {
        case "÷":
            operator_Common()
            opType = 4
            break
        case "×":
            operator_Common()
            opType = 3
            break
        case "−":
            operator_Common()
            opType = 2
            break
        case "+":
            operator_Common()
            opType = 1
            break
        case "=":
            if opType != 0 && ClacFlg == false {
                calculateOpe()
                calculateTax()
                inputText = ""
                inputValue = 0.0
                saveText = 0.0
                opType = 0
                ClacFlg = false
            }
            break
        case "C":
            if tax0 == "0" {
                saveText = 0.0
                opType = 0
            }
            clearDisp()
            break
        case "AC":
            break
        case "<":
            //基本的には動くがバグあり
            if !inputText.isEmpty {
                inputText.removeLast()
                if inputText.isEmpty { inputText = "0" }
                inputValue = Double(inputText) ?? 0
                calculateTax()
            }
            break
        default:
            //演算子確認
            if ClacFlg == true {
                clearDisp()
            }
            //文字数制限
            if tax0.count >= 11 {
                return
            }
            //2文字目以降は加算
            if inputText == "0" {
                inputText = label
            } else {
                inputText += label
            }

            //型変換
            inputValue = Double(inputText) ?? 0

            //税金自動計算
            calculateTax()
        }
    }
    

    //演算子共通処理
    func operator_Common() {
        //演算値の後に異なる演算値が押された場合
        if ClacFlg == true{
            print("異なる演算子が入力されました")
        } else {
            //2回目以降演算子が押された場合、計算する
            if opType > 0{
                calculateOpe()
                calculateTax()

                //初めて演算子が押されたときは、画面更新のみ
            } else {
                if inputValue != 0.0 {
                    calculateTax()
                }
            }
        }

        //現在の値を保存
        if let value = Double(tax0.replacingOccurrences(of: ",", with: "")) {
            saveText = value
        } else {
            saveText = 0.0
        }

        //演算子フラグ(+/x/÷)を有効
        ClacFlg = true
    }

    //税金計算
    func calculateTax() {
        var zeroTax = inputValue
        var eightTax = inputValue * 1.08
        var tenTax = inputValue * 1.10

        zeroTax = round(zeroTax)
        eightTax = round(eightTax)
        tenTax = round(tenTax)

        if zeroTax > 999999999 {
            tax0 = "NaN"
            tax8 = "NaN"
            tax10 = "NaN"
        } else {
            tax0 = formatter.string(from: NSNumber(value: zeroTax)) ?? ""
            tax8 = formatter.string(from: NSNumber(value: eightTax)) ?? ""
            tax10 = formatter.string(from: NSNumber(value: tenTax)) ?? ""
        }
    }

    //演算子計算
    func calculateOpe() {
        switch(opType){
        case 0:
            break
        case 1:
            inputValue = saveText + inputValue
            break
        case 2:
            inputValue = saveText - inputValue
            break
        case 3:
            inputValue = saveText * inputValue
            break
        case 4:
            inputValue = saveText / inputValue
            break
        default:
            break
        }
    }

    //画面をクリアする
    func clearDisp() {
        inputText = ""
        inputValue = 0.0
        tax0 = "0"
        tax8 = "0"
        tax10 = "0"
        ClacFlg = false
    }
}



#Preview {
    ContentView()
}

