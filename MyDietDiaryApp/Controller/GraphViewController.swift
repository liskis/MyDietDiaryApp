//
//  GraphViewController.swift
//  MyDietDiaryApp
//
//  Created by 渡辺健輔 on 2023/11/02.
//

import UIKit
import DGCharts
import RealmSwift

class GraphViewController: UIViewController {
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!

    var recordList: [WeightRecord] = []

    var datePicker: UIDatePicker {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ja-JP")
        return datePicker
    }

    var dateFormatter: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .long
        dateFormat.timeZone = .current
        dateFormat.locale = Locale(identifier: "ja-JP")
        return dateFormat
    }

    var toolBar: UIToolbar {
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40)
        let toolBar = UIToolbar(frame: toolBarRect)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolBar.setItems([doneItem], animated: true)
        return toolBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setRecord()
        updateGraph()
        configureGraph()
        configureTextField()
    }

    func setRecord() {
        let realm = try! Realm()
        var result = Array(realm.objects(WeightRecord.self))
        result.sort(by: { $0.date < $1.date})
        recordList = result
        if let startDateText = startDateTextField.text,
           let endDateText = endDateTextField.text,
           let startDate = dateFormatter.date(from: startDateText),
           let endDate = dateFormatter.date(from: endDateText){
            var filteredRecord = Array(realm.objects(WeightRecord.self).filter("date BETWEEN { %@, %@ }", startDate, endDate))
            filteredRecord.sort(by: { $0.date < $1.date })
            recordList = filteredRecord
        }
    }

    func updateGraph(){
        var entry = [ChartDataEntry]()
        recordList.enumerated().forEach({index, record in
            let data = ChartDataEntry(x: Double(index), y: record.weight)
            entry.append(data)
        })
        let dataSet = LineChartDataSet(entries: entry, label: "体重")
        graphView.data = LineChartData(dataSet: dataSet)
        graphView.data?.notifyDataChanged()
        graphView.notifyDataSetChanged()
    }

    func configureGraph(){
        graphView.xAxis.labelPosition = .bottom
        let titleFormatter = GraphDataTitleFormatter()
        let dateList = recordList.map({ $0.date})
        titleFormatter.dateList = dateList
        graphView.xAxis.valueFormatter = titleFormatter
    }

    func configureTextField(){
        
        let today = Date()
        let pastMonth = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        
        let startDatePicker = datePicker
        startDatePicker.date = pastMonth
        startDateTextField.inputView = startDatePicker
        startDateTextField.text = dateFormatter.string(from: pastMonth)
        startDateTextField.inputAccessoryView = toolBar
        startDatePicker.addTarget(self, action: #selector(didChangeStartDate), for: .valueChanged)
        
        let endDatePicker = datePicker
        endDatePicker.date = today
        endDateTextField.inputView = endDatePicker
        endDateTextField.text = dateFormatter.string(from: today)
        endDateTextField.inputAccessoryView = toolBar
        endDatePicker.addTarget(self, action: #selector(didChangeEndDate), for: .valueChanged)
    }

    @objc func didTapDone() {
        setRecord()
        updateGraph()
        view.endEditing(true)
    }

    @objc func didChangeStartDate(picker: UIDatePicker){
        startDateTextField.text = dateFormatter.string(from: picker.date)
    }

    @objc func didChangeEndDate(picker: UIDatePicker){
        endDateTextField.text = dateFormatter.string(from: picker.date)
    }
}
