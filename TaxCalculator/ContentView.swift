//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Takuma Nezu on 2025/04/09.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var tax0 = "0"
    @State private var tax8 = "0"
    @State private var tax10 = "0"
    @State private var saveText = 0.0
    @State var ClacFlg = false
    @State var flg = 0

    private let formatter = NumberFormatter()
    private let buttons = [
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "x"],
        ["1", "2", "3", "+"],
        ["0", "C", "="]
    ]

    //ディスプレイ
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // 背景を黒に
            VStack() {
                Spacer()

                //金額表示スペース
                VStack(alignment: .leading, spacing: 25) {
                    displayRow(label: "  0%", value: tax0, color: .white)
                    displayRow(label: "  8%", value: tax8, color: .yellow)
                    displayRow(label: "10%", value: tax10, color: .red)
                }
                .padding(.horizontal, 20)
                //金額表示スペース

                Spacer()

                //ボタンスペース
                VStack(spacing: 10) { // ← 縦の間隔を狭く
                    ForEach(buttons, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(row, id: \.self) { label in
                                Button(action: {
                                    buttonTapped(label)
                                }) {
                                    Text(label)
                                        .font(.system(size: 36))
                                        .frame(width: label == "0" ? 180 : 85, height: 85)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(35)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
                //ボタンスペース
            }
        }
    }
    //ディスプレイ
    // MARK: - Display Component
    func displayRow(label: String, value: String, color: Color) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundColor(color)
            Spacer()
            Text(value)
                .monospacedDigit()
                .font(.system(size: 40, weight: .medium, design: .rounded))
                .foregroundColor(color)
        }
    }

    // ボタンが押された時の処理
    func buttonTapped(_ label: String) {
        switch label {
        case "÷":
            operator_Common()
            flg = 3
            break
        case "x":
            operator_Common()
            flg = 2
            break
        case "+":
            operator_Common()
            flg = 1
            break
        case "=":
            Clac()
            flg = 0
            inputText = "0"
            saveText = 0.0
            break
        case "C":
            if tax0 == "0" {
                saveText = 0.0
                flg = 0
            }
            inputText = "0"
            tax0 = "0"
            tax8 = "0"
            tax10 = "0"
            ClacFlg = false
            break
        default:
            //演算子確認
            if ClacFlg == true {
                inputText = "0"
                tax0 = "0"
                tax8 = "0"
                tax10 = "0"
                ClacFlg = false
            }

            //文字数制限
            if tax0.count >= 11 {
                return
            }

            if inputText == "0" {
                inputText = label
                //税金自動計算
                calculateTax()
            } else {
                inputText += label
                //税金自動計算
                calculateTax()
            }
        }
    }

    //演算子共通処理
    func operator_Common() {
        if flg > 0{
            Clac()
        } else {
            if inputText != "0" {
                calculateTax()
            }
        }
        saveText = Double(tax0.replacingOccurrences(of: ",", with: ""))!
        ClacFlg = true
    }

    // 税金計算
    func calculateTax() {
        if var value = Double(inputText) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","

            var zeroTax = value
            var eightTax = value * 1.08
            var tenTax = value * 1.10

            zeroTax = round(zeroTax)
            eightTax = round(eightTax)
            tenTax = round(tenTax)

            if zeroTax > 999999999 {
                print("a")
                tax0 = "NaN"
                tax8 = "NaN"
                tax10 = "NaN"
            } else {
                tax0 = formatter.string(from: NSNumber(value: zeroTax)) ?? ""
                tax8 = formatter.string(from: NSNumber(value: eightTax)) ?? ""
                tax10 = formatter.string(from: NSNumber(value: tenTax)) ?? ""
            }
        }
    }

    //Add
    func Clac(){
        if var value = Double(inputText) {
            switch(flg){
            case 0:
                break
            case 1:
                value = saveText + value
                break
            case 2:
                value = saveText * value
                break
            case 3:
                value = saveText / value
                break
            default:
                break
            }

            var zeroTax = value
            var eightTax = value * 1.08
            var tenTax = value * 1.10

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = ","

            zeroTax = round(zeroTax)
            eightTax = round(eightTax)
            tenTax = round(tenTax)

            if zeroTax > 999999999 {
                print("a")
                tax0 = "NaN"
                tax8 = "NaN"
                tax10 = "NaN"
            } else {
                tax0 = formatter.string(from: NSNumber(value: zeroTax)) ?? ""
                tax8 = formatter.string(from: NSNumber(value: eightTax)) ?? ""
                tax10 = formatter.string(from: NSNumber(value: tenTax)) ?? ""
            }
        }
    }
    //Add
    

/*
    //数字ボタン
    func TapNumButton {
        if ClacFlg == true {
            Clear()
        }
        ClacFlg = false

        //tax0に書いてある数字
        guard let labelNum = tax0 else{ return }
        //文字数制限
        guard  strlen(labelNum!) < 9 else { return }
        //今押された数字
        guard let inputText = label else{ return }

        //加算
        var zeroTaxString = labelNum + senderNum
        //カンマ削除
        zeroTaxString = zeroTaxString.replacingOccurrences(of: ",", with: "")
        //型変換
        let zeroTax = Double(zeroTaxString)
        //税金計算
        TaxClac(Number: zeroTax!)
    }
*/
}


#Preview {
    ContentView()
}
/*
    /*----------------関数-------------------*/

    //Add
    func transform() -> Double {
        //tax0に書いてある数字
        guard let labelNum = tax0.text else{
            return 0.0
        }
        //カンマ削除
        let zeroTaxString = labelNum.replacingOccurrences(of: ",", with: "")

        //型変換
        return Double(zeroTaxString)!
    }
    //Add

    //Add
    func TaxClac(Number: Double){
        let zeroTax = Number
        var eightTax = Number * 1.08
        var tenTax = Number * 1.10

        eightTax = round(eightTax)
        tenTax = round(tenTax)

        tax0.text = String(formatter.string(from: zeroTax as NSNumber)!)
        tax8.text = String(formatter.string(from: eightTax as NSNumber)!)
        tax10.text = String(formatter.string(from: tenTax as NSNumber)!)
    }
    //Add
 */














/*

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate  {

    @IBOutlet weak var tax0: UILabel!
    @IBOutlet weak var tax8: UILabel!
    @IBOutlet weak var tax10: UILabel!
    let formatter = NumberFormatter()



    //バナー広告
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3

        //広告開始
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        //addBannerViewToView(bannerView)
        //本番　ca-app-pub-4013798308034554/7920663953
        //テスト　ca-app-pub-3940256099942544/2934735716
        //bannerView.adUnitID = "ca-app-pub-4013798308034554/7920663953"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"  //テスト
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        //広告終わり
    }

    //数字ボタン
    @IBAction func TapNumButton(_ sender: UIButton) {
        if ClacFlg == true {
            Clear()
        }
        ClacFlg = false

        //tax0に書いてある数字
        guard let labelNum = tax0.text else{
            return
        }
        //文字数制限
        guard  strlen(tax0.text!) < 9 else {
            return
        }
        //今押された数字
        guard let senderNum = sender.titleLabel?.text else{
            return
        }
        //加算
        var zeroTaxString = labelNum + senderNum
        //カンマ削除
        zeroTaxString = zeroTaxString.replacingOccurrences(of: ",", with: "")
        //型変換
        let zeroTax = Double(zeroTaxString)
        //税金計算
        TaxClac(Number: zeroTax!)
    }

    //クリアボタン
    @IBAction func TapClearButton(_ sender: UIButton) {
        if ClacFlg == true {
            saveText = 0.0
        }
        Clear()
        ClacFlg = false
    }

    func Clear(){
        tax0.text = ""
        tax8.text = ""
        tax10.text = ""
    }

    func TaxClac(Number: Double){
        let zeroTax = Number
        var eightTax = Number * 1.08
        var tenTax = Number * 1.10

        eightTax = round(eightTax)
        tenTax = round(tenTax)

        tax0.text = String(formatter.string(from: zeroTax as NSNumber)!)
        tax8.text = String(formatter.string(from: eightTax as NSNumber)!)
        tax10.text = String(formatter.string(from: tenTax as NSNumber)!)
    }

    @IBAction func pushDivide(_ sender: Any) {
        flg = 3
        a()
    }

    @IBAction func pushMultiply(_ sender: Any) {
        flg = 2
        a()
    }

    @IBAction func pushAdd(_ sender: Any) {
        flg = 1
        a()
    }

    func a (){
        if tax0.text != "" && tax0.text != "0" {
            saveText = transform()
            ClacFlg = true
        }
    }



    @IBAction func pushEqual(_ sender: Any) {
        Clac()
        flg = 0
    }



*/
