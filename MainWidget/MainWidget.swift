//
//  MainWidget.swift
//  MainWidget
//
//  Created by 曹宇明 on 2020/7/27.
//

import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NextWidget()
        NewWidget()
    }
}
