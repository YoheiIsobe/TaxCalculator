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


//Add
    @State var ClacFlg = false
    @State var saveText: Double = 0.0
    @State var flg = 0
//Add

    let buttons = [
        ["7", "8", "9", "÷"],
        ["4", "5", "6", "x"],
        ["1", "2", "3", "+"],
        ["0", "C", "="]
    ]

    var body: some View {

        VStack() {
            Spacer()

            //金額表示スペース
            VStack(alignment: .leading, spacing: 30) {
                Text("　  0%：\(inputText)")
                Text("　  8%：\(tax8)")
                Text("　10%：\(tax10)")
            }
            .font(.system(size: 36))
            .frame(maxWidth: .infinity, alignment: .leading)
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
                            }
                        }
                    }
                }
            }
            //ボタンスペース
        }
    }
    // ボタンが押された時の処理
    func buttonTapped(_ label: String) {
        switch label {
        case "C":
            inputText = "0"
        case "=":
            inputText = "0"
        default:
            if inputText == "0" {
                inputText = label
            } else {
                inputText += label
            }
        }
        //共通処理
        tax8 = (Double(inputText) ?? 0) * 1.08
        tax10 = (Double(inputText) ?? 0) * 1.10

    }
}

#Preview {
    ContentView()
}



/*
//Add
func Clac(){
    var zeroTax = transform()

    switch(flg){
    case 0:
        break
    case 1:
        zeroTax = saveText + zeroTax
        break
    case 2:
        zeroTax = saveText * zeroTax
        break
    case 3:
        zeroTax = saveText / zeroTax
        break
    default:
        break
    }
    TaxClac(Number: zeroTax)
}
//Add

//Add
func transform() -> Double {
    //zerotextに書いてある数字
    guard let labelNum = ZeroText.text else{
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

ZeroText.text = String(formatter.string(from: zeroTax as NSNumber)!)
EightText.text = String(formatter.string(from: eightTax as NSNumber)!)
TenText.text = String(formatter.string(from: tenTax as NSNumber)!)
}
//Add

*/








/*

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate  {

    @IBOutlet weak var ZeroText: UILabel!
    @IBOutlet weak var EightText: UILabel!
    @IBOutlet weak var TenText: UILabel!
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

        //zerotextに書いてある数字
        guard let labelNum = ZeroText.text else{
            return
        }
        //文字数制限
        guard  strlen(ZeroText.text!) < 9 else {
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
        ZeroText.text = ""
        EightText.text = ""
        TenText.text = ""
    }

    func TaxClac(Number: Double){
        let zeroTax = Number
        var eightTax = Number * 1.08
        var tenTax = Number * 1.10

        eightTax = round(eightTax)
        tenTax = round(tenTax)

        ZeroText.text = String(formatter.string(from: zeroTax as NSNumber)!)
        EightText.text = String(formatter.string(from: eightTax as NSNumber)!)
        TenText.text = String(formatter.string(from: tenTax as NSNumber)!)
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
        if ZeroText.text != "" && ZeroText.text != "0" {
            saveText = transform()
            ClacFlg = true
        }
    }



    @IBAction func pushEqual(_ sender: Any) {
        Clac()
        flg = 0
    }



*/
