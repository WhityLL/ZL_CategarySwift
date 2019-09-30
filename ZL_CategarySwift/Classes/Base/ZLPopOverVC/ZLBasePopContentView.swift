//
//  ZLBasePopContentView.swift
//  Paihuo_Swift
//
//  Created by LiuLei on 2018/4/2.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import UIKit

open class ZLBasePopContentView: UIView {

    override open init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required open init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
