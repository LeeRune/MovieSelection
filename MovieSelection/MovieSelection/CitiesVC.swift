//
//  CitiesVC.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/7.
//

import UIKit

class CitiesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var stations: [String]?
    var selectedStation = ""
    var selectedCity = ""
    var cities = ["台北",
                  "桃園",
                  "新竹",
                  "苗栗",
                  "台中",
                  "台南",
                  "高雄"]
    var stationDictionary = ["台北":["台北信義威秀影城","台北美麗華大直影城","台北京站威秀影城","板橋大遠百威秀影城","喜樂時代影城南港店"],
                             "桃園":
                                ["桃園新光影城","桃園in89統領影城","桃園統領威秀影城"],
                             "新竹":
                                ["新竹大遠百威秀影城","新竹巨城威秀影城"],
                             "苗栗":
                                ["頭份尚順威秀影城"],
                             "台中":["台中豐原in89豪華影城","台中大遠百威秀影城","台中新光影城","台中新時代凱擘影城"],
                             "台南":["台南南紡威秀影城","台南大遠百威秀影城","台南FOCUS威秀影城","台南新光影城","台南真善美劇院"],
                             "高雄":["高雄大遠百威秀影城","喜滿客夢時代影城","高雄in89駁二電影院"]]
    var indexPathRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.width
        flowLayout?.itemSize = CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DateCell.self)", for: indexPath) as! DateCell
        cell.dateLabel.text = cities[indexPath.row]
        selectedCity = cities[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        print(indexPath)
        indexPathRow = indexPath[1]
        pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        stations = stationDictionary[cities[indexPathRow]]
        return stationDictionary[cities[indexPathRow]]?.count ?? 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        selectedStation = stations?[row] ?? ""
        return stations?[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDateVC"{
            if let vc = segue.destination as? DateVC {
                vc.station = selectedStation
            }
        }
        saveData()
    }
    
    //將縣市、影城地點資料存入UserDefault
    func saveData(){
        
        let userDefaults = UserDefaults.standard
        let citySelection = "\(selectedCity)"
        let stationSelection = "\(selectedStation)"
        userDefaults.set(citySelection, forKey: "citySelection")
        userDefaults.set(stationSelection, forKey: "stationSelection")
    }
}
