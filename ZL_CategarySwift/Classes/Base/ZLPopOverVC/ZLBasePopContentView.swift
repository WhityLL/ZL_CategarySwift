//
//  ZLBasePopContentView.swift
//  Paihuo_Swift
//
//  Created by LiuLei on 2018/4/2.
//  Copyright © 2018年 LiuLei. All rights reserved.
//

import UIKit

public class ZLBasePopContentView: UIView {

    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
