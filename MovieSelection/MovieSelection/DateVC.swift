
import UIKit

class DateVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate {

    


    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    var dates: [String] = []
    var weekDayFinal: [String] = []
    
    var station: String?
    var times: [String]?
    var selectedDate = ""
    var selectedTime = ""
    var indexPathRow = 0
    var weekDate = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
    var timeDictionary = [
        "星期一":["9:00","11:00","13:00","15:00","17:00","19:00","21:00","23:00"],
        "星期二":["13:00","15:00","17:00","19:00"],
        "星期三":["15:00","17:00"],
        "星期四":["8:00","10:00","12:00","14:00","16:00","18:00","20:00","22:00"],
        "星期五":["10:00","13:00","16:00","19:00","22:00"],
        "星期六":["9:00","11:00","13:00","15:00","17:00","19:00","21:00","23:00"],
        "星期日":["13:00","15:00","17:00","19:00"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //當前時間
        let currentDate = Date()
        let calender = Calendar.current
        var comp = calender.dateComponents([.year, .month, .day, .weekday], from: currentDate)

        //當前時間日期
        let currentDay = comp.day
        let weeKDay = comp.weekday

        let day = currentDay
        let week = weeKDay
        
        //為1時代表星期日
        var currentWeekDay = 0
        if week == 1 {
            currentWeekDay = 7
        } else {
            currentWeekDay = week ?? 0 - 1
        }
        
        for index in 0 ... 6 {
            comp.day = day! + index
            let date = calender.date(from: comp)
            currentWeekDay += 1
            switch (currentWeekDay-2)%7 {
            case 0:
                weekDayFinal.append("星期日")
            case 1:
                weekDayFinal.append("星期一")
            case 2:
                weekDayFinal.append("星期二")
            case 3:
                weekDayFinal.append("星期三")
            case 4:
                weekDayFinal.append("星期四")
            case 5:
                weekDayFinal.append("星期五")
            case 6:
                weekDayFinal.append("星期六")
            default:
                0
            }

            if let _ = date {
                
                var formatter = DateFormatter()
                formatter.dateFormat = "MM/dd"
                let formattedDateInString = formatter.string(from: date!)
                dates.append(formattedDateInString)
            }
        }

        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = UIScreen.main.bounds.width
        flowLayout?.itemSize = CGSize(width: width, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DateCell.self)", for: indexPath) as! DateCell
        if indexPath.row == 0{
            
            cell.dateLabel.text = "今天\n\(dates[indexPath.row])"
        }else {
            
            cell.dateLabel.text = "\(weekDayFinal[indexPath.row])\n\(dates[indexPath.row])"
        }
        
        selectedDate = dates[indexPath.row]
        return cell
    }
    
    //判斷cell準確index
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        indexPathRow = indexPath[1]
        pickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        times = timeDictionary[weekDate[indexPathRow]]
        return timeDictionary[weekDate[indexPathRow]]?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        selectedTime = times?[row] ?? ""
        return times?[row]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        saveData()
    }
    
    //將日期、時段資料存入UserDefault
    func saveData(){
        
        let userDefaults = UserDefaults.standard
        let dateSelection = "\(selectedDate)"
        let timeSelection = "\(selectedTime)"
        userDefaults.set(dateSelection, forKey: "dateSelection")
        userDefaults.set(timeSelection, forKey: "timeSelection")
    }
}
