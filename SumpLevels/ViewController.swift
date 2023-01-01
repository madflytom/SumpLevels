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
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var resetViewButton: UIButton!
    
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
    
    // TODO: put chart in a container so it doesn't take up the full superview?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sump Water Levels"
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        fetchWaterLevels()
    }

    @IBAction func zoomClicked(_ sender: Any) {
        lineChartView.zoomOut()
    }
    @IBAction func resetClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Alert", message: "New data will be fetched", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction!) in
            // Code in this block will trigger when OK button tapped.
            self.fetchWaterLevels()
            print("data refreshed");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    private func fetchWaterLevels(){
        progressBar.isHidden = false
        self.waterData = []
        // Get data points (use weak self to prevent closure from causing a memory leak)
        DataService.shared.fetchWaterLevels { [weak self] (result) in
            switch result{
                case .success(let waterLevels):
                    // TODO: modify the data model so it returns in a format that can be easily charted?  Or maybe mapping it somehow is quicker?
                    for level in waterLevels{
                        let newLevel: ChartDataEntry = ChartDataEntry(x: Double(level.id), y: level.measurement)
                        self?.waterData.append(newLevel)
                        print(newLevel)
                    }
                    // Call to set the chart data after all the data has been retreived
                    print("Resetting data")
                    DispatchQueue.main.async {
                        self?.setData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            
        }
        progressBar.isHidden = true
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: waterData, label: "Water Measurements")
        
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 2
        set1.setColor(.white)
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
        
        data.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
        print("Data changed")
    }
    
}

