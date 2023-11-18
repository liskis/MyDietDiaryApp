//
//  GraphDateTitleFormatter.swift
//  MyDietDiaryApp
//
//  Created by 渡辺健輔 on 2023/11/09.
//

import Foundation
import DGCharts

class GraphDataTitleFormatter: AxisValueFormatter{
    var dateList: [Date] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        guard dateList.count > index else { return "" }
        let targetDate = dateList[index]
        let formatter = DateFormatter()
        let dateFormatString = "M/d"
        formatter.dateFormat = dateFormatString
        return formatter.string(from: targetDate)
    }
}
