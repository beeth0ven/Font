//
//  FlatColorsTableViewController.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BNKit

class FlatColorsTableViewController: UITableViewController {
    
    @IBOutlet private weak var sumLabel: UILabel!
    typealias ColorInfo = (color: UIColor, name: String, hex: String)
    
    private let colorInfos: [ColorInfo] = [
        (.flatPowerBlueLight, "深蓝(浅) flatPowerBlueLight", "ABBAF2"),
        (.flatPowerBlueDark, "深蓝(深) flatPowerBlueDark", "8898D0"),
        (.flatSkyBlueLight, "天蓝(浅) flatSkyBlueLight", "3182D9"),
        (.flatSkyBlueDark, "天蓝(深) flatSkyBlueDark", "2769B0"),
        (.flatBlueLight, "蓝(浅) flatBlueLight", "404E95"),
        (.flatBlueDark, "蓝(深) flatBlueDark", "2C3872"),
        (.flatPurpleLight, "紫(浅) flatPurpleLight", "5F42C0"),
        (.flatPurpleDark, "紫(深) flatPurpleDark", "472F97"),
        (.flatMagentaLight, "洋红(浅) flatMagentaLight", "853DAE"),
        (.flatMagentaDark, "洋红(浅) flatMagentaDark", "7728A4"),
        (.flatPinkLight, "粉(浅) flatPinkLight", "E960BB"),
        (.flatPinkDark, "粉(深) flatPinkDark", "C34291"),
        (.flatWatermolonLight, "西瓜(浅) flatWatermolonLight", "E35A66"),
        (.flatWatermolonDark, "西瓜(深) flatWatermolonDark", "C93F45"),
        (.flatRedLight, "红(浅) flatRedLight", "D93829"),
        (.flatRedDark, "红(深) flatRedDark", "AC281C"),
        (.flatOrangeLight, "橙(浅) flatOrangeLight", "D96C00"),
        (.flatOrangeDark, "橙(深) flatOrangeDark", "C24100"),
        (.flatYellowLight, "黄(浅) flatYellowLight", "FBC700"),
        (.flatYellowDark, "黄(深) flatYellowDark", "F99A00"),
        (.flatLimeLight, "酸橙(浅) flatLimeLight", "98BF00"),
        (.flatLimeDark, "酸橙(深) flatLimeDark", "7FA500"),
        (.flatGreenLight, "绿(浅) flatGreenLight", "3BC651"),
        (.flatGreenDark, "绿(深) flatGreenDark", "31A343"),
        (.flatMintLight, "薄荷(浅) flatMintLight", "2EB187"),
        (.flatMintDark, "薄荷(深) flatMintDark", "27916F"),
        (.flatTealLight, "蓝绿(浅) flatTealLight", "305B70"),
        (.flatTealDark, "蓝绿(深) flatTealDark", "2C4F60"),
        (.flatNavyBlueLight, "海军蓝(浅) flatNavyBlueLight", "28384D"),
        (.flatNavyBlueDark, "海军蓝(深) flatNavyBlueDark", "222E40"),
        (.flatBlackLight, "黑(浅) flatBlackLight", "202020"),
        (.flatBlackDark, "黑(深) flatBlackDark", "1D1D1D"),
        (.flatBrownLight, "棕(浅) flatBrownLight", "4A3625"),
        (.flatBrownDark, "棕(深) flatBrownDark", "3E2D1F"),
        (.flatCoffeeLight, "咖啡(浅) flatCoffeeLight", "90745B"),
        (.flatCoffeeDark, "咖啡(深) flatCoffeeDark", "7A5F49"),
        (.flatSandLight, "沙(浅) flatSandLight", "EBD89F"),
        (.flatSandDark, "沙(深) flatSandDark", "CAB77D"),
        (.flatWhiteLight, "白(浅) flatWhiteLight", "E8ECEE"),
        (.flatWhiteDark, "白(深) flatWhiteDark", "B0B6BB"),
        (.flatGrayLight, "灰(浅) flatGrayLight", "849495"),
        (.flatGrayDark, "灰(深) flatGrayDark", "6D797A"),
        (.flatMaroonLight, "褐红(浅) flatMaroonLight", "62231E"),
        (.flatMaroonDark, "褐红(深) flatMaroonDark", "501C18"),
        (.flatForestGreenLight, "森林(浅) flatForestGreenLight", "2B4E2F"),
        (.flatForestGreenDark, "森林(深) flatForestGreenDark", "254026"),
        (.flatPlumLight, "紫红(浅) flatPlumLight", "49244E"),
        (.flatPlumDark, "紫红(深) flatPlumDark", "3C1D40")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        Driver.just(colorInfos) --> binder(tableView.rx.items()) { row, colorInfo, cell in
            cell.imageView?.image = UIImage.form(color: colorInfo.color, size: CGSize(width: 22, height: 22))
            cell.textLabel?.text = "\(row + 1). \(colorInfo.name)"
            cell.textLabel?.textColor = colorInfo.color
            cell.detailTextLabel?.text = colorInfo.hex
        }
        
        sumLabel.text = "共 \(colorInfos.count) 种"
    }
}

extension UIImage {
    
    static func form(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
