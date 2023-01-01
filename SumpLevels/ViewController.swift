//
//  ViewController.swift
//  SumpLevels
//
//  Created by Tom Stahl on 12/30/22.
//

import UIKit
import Charts
import TinyConstraints

class ViewController: UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemGray2
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.labelPosition = .insideChart
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        
        chartView.animate(xAxisDuration: 2.5)
        
        return chartView
    }()
    
    var waterData: [ChartDataEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)

        // Get data points
        DataService.shared.fetchWaterLevels { (result) in
            switch result{
                case .success(let waterLevels):
                    // TODO: modify the data model so it returns in a format that can be easily charted?  Or maybe mapping it somehow is quicker?
                    for level in waterLevels{
                        let newLevel: ChartDataEntry = ChartDataEntry(x: Double(level.id), y: level.measurement)
                        self.waterData.append(newLevel)
                    }
                    // Call to set the chart data after all the data has been retreived
                    self.setData()
                case .failure(let error):
                    print(error)
                }
        }
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    // TODO: add button to refresh data (gets data again from api and redraws
    // TODO: add button to refresh view - zoom out if clicked into zoom
    func setData(){
        let set1 = LineChartDataSet(entries: waterData, label: "Water Measurements")
        
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 2
        set1.setColor(.white)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 5.0),
        ChartDataEntry(x: 2.0, y: 7.0),
        ChartDataEntry(x: 3.0, y: 5.0),
        ChartDataEntry(x: 4.0, y: 10.0)

    ]


}

