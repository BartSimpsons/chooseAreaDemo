//
//  BSAreaModel.swift
//  BIGCAR
//
//  Created by Bart Simpsons on 2018/8/20.
//  Copyright © 2018年 PP100. All rights reserved.
//

import UIKit


/// 模型根据你后台的数据自定义
class BSAreaModel: NSObject {
    
    var name: String = ""
    
    var id: String = ""
    
    var firstChar:String{
        return name.firstChar
    }

    convenience init(_ name:String, id:String){
        self.init()
        self.name = name
        self.id = id
    }
}


class AreaInfoModel: NSObject {
    
     // 省
     var provinceName = ""
     var provinceId = ""
    
     // 市
     var cityName = ""
     var cityId = ""
    
     // 区
     var areaName = ""
     var areaId = ""
    
     // 街道
     var streetName = ""
     var streetId = ""
    
     // 村
     var villageName = ""
     var villageId = ""
}

extension UIColor {
    
    public class func ColorHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return proceesHex(hex: hex, alpha: alpha)
    }
    
    
    open class var mainBlue: UIColor { return ColorHex(hex: "1FB6FF") }
    
    open class var A5A5A5: UIColor { return ColorHex(hex: "A5A5A5") }
    
    open class var textBlack: UIColor { return ColorHex(hex: "333333") }
    
    open class var CCCCCC: UIColor { return ColorHex(hex: "CCCCCC") }
}

private func proceesHex(hex: String, alpha: CGFloat) -> UIColor{
    /** 如果传入的字符串为空 */
    if hex.isEmpty {
        return UIColor.clear
    }
    
    /** 传进来的值。 去掉了可能包含的空格、特殊字符， 并且全部转换为大写 */
    var hHex = (hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)).uppercased()
    
    /** 如果处理过后的字符串少于6位 */
    if hHex.characters.count < 6 {
        return UIColor.clear
    }
    
    /** 开头是用0x开始的 */
    if hHex.hasPrefix("0X") {
        hHex = (hHex as NSString).substring(from: 2)
    }
    /** 开头是以＃开头的 */
    if hHex.hasPrefix("#") {
        hHex = (hHex as NSString).substring(from: 1)
    }
    /** 开头是以＃＃开始的 */
    if hHex.hasPrefix("##") {
        hHex = (hHex as NSString).substring(from: 2)
    }
    
    /** 截取出来的有效长度是6位， 所以不是6位的直接返回 */
    if hHex.characters.count != 6 {
        return UIColor.clear
    }
    
    /** R G B */
    var range = NSMakeRange(0, 2)
    
    /** R */
    let rHex = (hHex as NSString).substring(with: range)
    
    /** G */
    range.location = 2
    let gHex = (hHex as NSString).substring(with: range)
    
    /** B */
    range.location = 4
    let bHex = (hHex as NSString).substring(with: range)
    
    /** 类型转换 */
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
    
    Scanner(string: rHex).scanHexInt32(&r)
    Scanner(string: gHex).scanHexInt32(&g)
    Scanner(string: bHex).scanHexInt32(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
}


extension String {
    //截取str[0..<14]
    public subscript (range: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
            return self[Range(startIndex..<endIndex)]
        }
        
        set {
            let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
            let strRange = Range(startIndex..<endIndex)
            self.replaceSubrange(strRange, with: newValue)
        }
    }
    
    /// 获取汉字首字母
    public var firstChar:String {
        let str = NSMutableString.init(string: self) as CFMutableString
        if CFStringTransform(str, nil, kCFStringTransformMandarinLatin, false) == true{
            if CFStringTransform(str, nil, kCFStringTransformStripDiacritics, false) == true {
                let first:String = "\(str)"[0..<1]
                return first.uppercased()
            }
        }
        return ""
    }
}
