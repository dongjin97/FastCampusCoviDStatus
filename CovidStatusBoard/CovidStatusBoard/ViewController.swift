//
//  ViewController.swift
//  CovidStatusBoard
//
//  Created by 원동진 on 2022/09/28.
//
//KW3gzmX6xGnwIpshdA7ifuycqtBa5UlDS
import UIKit
import Charts
import Alamofire
class ViewController: UIViewController {
    
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indichatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indichatorView.startAnimating()
        self.fetchCovidOverview(completionHandler: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                self.indichatorView.stopAnimating()
                self.indichatorView.isHidden = true
                self.labelStackView.isHidden = false
                self.pieChartView.isHidden = false
                self.configureStackView(koreaCovidOverView: result.korea)
                let covidOverViewList = self.makeCovidOverViewList(cityCovidOverView: result)
                self.configureChartView(covidOverViewlist: covidOverViewList)
            case let .failure(error):
                debugPrint("error \(error)")
            }
            
        })
        
    }
    func makeCovidOverViewList(cityCovidOverView: CityCovidOverview) -> [CovidOverView]{
        
        return [
            cityCovidOverView.seoul,
            cityCovidOverView.busan,
            cityCovidOverView.daegu,
            cityCovidOverView.incheon,
            cityCovidOverView.gwangju,
            cityCovidOverView.daejeon,
            cityCovidOverView.ulsan,
            cityCovidOverView.sejong,
            cityCovidOverView.gyeonggi,
            cityCovidOverView.chungbuk,
            cityCovidOverView.chungnam,
            cityCovidOverView.gyeongbuk,
            cityCovidOverView.gyeongnam,
            cityCovidOverView.jeju
        ]
    }
    func configureChartView(covidOverViewlist : [CovidOverView]){
        self.pieChartView.delegate = self
        let entries = covidOverViewlist.compactMap { [weak self] overview -> PieChartDataEntry? in
            guard let self = self else {return nil}
            return PieChartDataEntry(value: self.removeFormatString(string: overview.newCase), label: overview.countryName, data: overview)
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        dataSet.sliceSpace = 1 //간격
        dataSet.entryLabelColor = .black // 항목이름 색상
        dataSet.valueTextColor = . black // piechart 항목안에 있는 색상
        dataSet.xValuePosition = .outsideSlice // 항목이름을 밖에 표시
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3
        dataSet.colors = ChartColorTemplates.vordiplom() +
        ChartColorTemplates.joyful() +
        ChartColorTemplates.liberty() +
        ChartColorTemplates.material() // pie차트 항목이 다양한 색상으로 표시됨
        self.pieChartView.data = PieChartData(dataSet: dataSet)
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80) // 현재 앵글에서 pirChart를 80도 회전
    }
    //string -> Double
    func removeFormatString(string : String) -> Double{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
        
    }
    func configureStackView(koreaCovidOverView : CovidOverView){
        self.totalCaseLabel.text = "\(koreaCovidOverView.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverView.newCase)명"
    }
    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey": "KW3gzmX6xGnwIpshdA7ifuycqtBa5UlDS"
        ]
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
}



extension ViewController :ChartViewDelegate{
    //차트에서 항목을 선택 했을때 호출되는함수
    //entry 선택된 항목에 저장된 데이터르 가져 올 수 있음.
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else{ return }
        guard let covidOVerView = entry.data as? CovidOverView else {return} //CovidOverView로 다운캐스팅
        covidDetailViewController.covidOverview = covidOVerView
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
