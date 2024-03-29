//
//  CommentDetailViewController.swift
//  Takeit_iOS
//
//  Created by 李易潤 on 2021/2/23.
//

import UIKit

class CommentDetailVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var comment: UIButton!
    var test: String = ""
    var xOffset:CGFloat = 35
    var ratingStar = [UIButton]()
    var commentStars = 0
    var commentPersons = [
        Comment(comment: "很棒！", imageName: "a", star: 4, updatetime: "2021-03-10 14:17:44"),
        Comment(comment: "爛透了！", imageName: "b", star: 1, updatetime: "2021-03-10 14:16:44"),
        Comment(comment: "好看！", imageName: "c", star: 5, updatetime: "2021-03-10 14:15:44"),
        Comment(comment: "讚！", imageName: "d", star: 4, updatetime: "2021-03-10 14:14:44"),
        Comment(comment: "Good！", imageName: "e", star: 5, updatetime: "2021-03-10 14:13:44"),
        Comment(comment: "難看！", imageName: "f", star: 1, updatetime: "2021-03-10 14:12:44"),
        Comment(comment: "值得二刷！", imageName: "g", star: 4, updatetime: "2021-03-10 14:11:44"),
        Comment(comment: "無聊的電影！", imageName: "h", star: 1, updatetime: "2021-03-09 14:18:44"),
        Comment(comment: "男主角好帥！", imageName: "i", star: 5, updatetime: "2021-03-10 13:18:44"),
        Comment(comment: "女主角好帥！", imageName: "j", star: 4, updatetime: "2021-03-10 12:18:44"),
        Comment(comment: "有夠爛！", imageName: "k", star: 1, updatetime: "2021-03-10 11:14:44")
    ]
    let reportRes = ["歧視語言","色情內容","散佈廣告","洩漏劇情","重複留言","攻擊他人","其他原因"]
    var callback: ((Comment) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportRes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        test = reportRes[row]
        print("reportRes[row]:\(reportRes[row])")
        return reportRes[row]
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let report = UIContextualAction(style: .normal, title: "檢舉") { (action, view, bool) in
            
            tableView.setEditing(false, animated: true)
            let alert = UIAlertController(title: "檢舉原因", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let ok = UIAlertAction(title: "送出", style: .default, handler: { (_) in
                
                let checkalert = UIAlertController(title: "您的檢舉已送交審查", message: "", preferredStyle: .alert)
                let check = UIAlertAction(title: "確認", style: .default, handler: nil)
                checkalert.addAction(check)
                self.present(checkalert, animated: true, completion: nil)
            })
            
            
            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.frame = CGRect(x: 73, y: 40, width: 120, height: 110)
            
            //設定alert大小
            let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
            
            alert.view.addConstraint(height)
            alert.view.addSubview(pickerView)
            alert.addAction(cancel)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        report.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [report])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentPersons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentPersons", for: indexPath) as! CommentDetailCell
        commentPersons.sort { $0.updatetime > $1.updatetime
        }
        let comment = commentPersons[indexPath.row]
        
        cell.commentLabel.text = comment.comment
        cell.starImage.image = UIImage(named: "\(comment.star)star")
        cell.photoImage.image = UIImage(named: comment.imageName)
        return cell
    }
    
    @IBAction func comment(_ sender: Any) {
        xOffset = 40
        commentStars = 0
        ratingStar.removeAll()
        //        performSegue(withIdentifier: "CommentSegue", sender: 0)
        let commentAlert = UIAlertController(title: "", message: "喜歡這部電影嗎？\n給個評分跟評論吧！", preferredStyle: .alert)
        commentAlert.addTextField(configurationHandler: { textField in
            
            textField.placeholder = "請輸入評論..."
            textField.delegate = self
            textField.returnKeyType = .done
        })
        for i in 0...4{
            let star = UIButton()
            star.tag = i
            commentStars = star.tag
            star.frame = CGRect(x: xOffset, y: 115, width: 40, height: 40)
            star.setImage(UIImage(systemName: "star"), for: .normal)
            star.setImage(UIImage(systemName: "star.fill"), for: .selected)
            star.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
            xOffset = xOffset + 40
            ratingStar.append(star)
            commentAlert.view.addSubview(star)
            star.addTarget(self, action: #selector(rating), for: UIControl.Event.touchUpInside)
            
        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "送出", style: .default, handler: { (_) in
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let result = formatter.string(from: date)
            self.commentPersons.append(Comment(comment: commentAlert.textFields?[0].text ?? "", imageName: "l", star: self.commentStars, updatetime: result))
            self.callback?(Comment(comment: commentAlert.textFields?[0].text ?? "", imageName: "l", star: self.commentStars, updatetime: result))
            
            //評論後重整tableView
            self.tableView.reloadData()
            let checkalert = UIAlertController(title: "評論成功", message: "", preferredStyle: .alert)
            let check = UIAlertAction(title: "確認", style: .default, handler: { (_) in
            })
            checkalert.addAction(check)
            
            self.present(checkalert, animated: true, completion: nil)
        })
        
        commentAlert.addAction(cancel)
        commentAlert.addAction(ok)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: commentAlert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 210)
        commentAlert.view.addConstraint(height)
        self.present(commentAlert, animated: true, completion: nil)
    }
    
    @objc func rating(_ sender: UIButton) {
        
        for i in 0...sender.tag{
            let rating = ratingStar[i]
            rating.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        for i in sender.tag + 1..<5{
            let rating = ratingStar[i]
            rating.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        return true
    }
    
}
