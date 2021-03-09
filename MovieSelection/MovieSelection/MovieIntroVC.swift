//
//  MovieIntroVC.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/3.
//

import UIKit

class MovieIntroVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    @IBOutlet weak var tmbdVoteLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    
    var movieName: String?
    var releaseDate: String?
    var tmbdVote: Double?
    var movieOverview: String?
    var backdrop_path: String?
    var commentPersons = [
        Comment(comment: "很棒！", imageName: "a", star: 4),
        Comment(comment: "爛透了！", imageName: "b", star: 1),
        Comment(comment: "好看！", imageName: "c", star: 5),
        Comment(comment: "讚！", imageName: "d", star: 4),
        Comment(comment: "Good！", imageName: "e", star: 5),
        Comment(comment: "難看！", imageName: "f", star: 1),
        Comment(comment: "值得二刷！", imageName: "g", star: 4),
        Comment(comment: "無聊的電影！", imageName: "h", star: 1),
        Comment(comment: "男主角好帥！", imageName: "i", star: 5),
        Comment(comment: "女主角好帥！", imageName: "j", star: 4),
        Comment(comment: "有夠爛！", imageName: "k", star: 1),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentCountButton.setTitle("\(commentPersons.count) >", for: .normal)
        movieNameLabel.text = movieName
        releaseDateLabel.text = releaseDate
        if let tmbdVote = tmbdVote{
            tmbdVoteLabel.text = "\(tmbdVote)"
        }
        movieOverviewTextView.text = movieOverview
        if let imageAddress = backdrop_path{
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress){
                let task = URLSession.shared.dataTask(with: imageURL){(data, response, error ) in
                    if let data = data{
                        DispatchQueue.main.async {
                            self.movieImage.image = UIImage(data:data)
                        }
                    }
                }
                task.resume()
            }
        }
        
        //預設按鈕預設圖案及被選取圖案
        self.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        self.likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .selected)
        
        //設定按鈕大小
        likeButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        orderButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentPersons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentPersons", for: indexPath) as! CommentDetailCell
        let comment = commentPersons[indexPath.row]
        
        cell.commentLabel.text = comment.comment
        cell.starImage.image = UIImage(named: "\(comment.star)star")
        cell.photoImage.image = UIImage(named: comment.imageName)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentDetail" {
            if let vc = segue.destination as? CommentDetailVC {
                
                //透過callback更新電影資訊頁面評論資料
                vc.callback = { comment in
                    self.commentPersons.append(comment)
                    self.tableView.reloadData()
                    self.commentCountButton.setTitle("\(self.commentPersons.count) >", for: .normal)
                }
            }
        }
        saveData()
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        if sender.isSelected {
            
            self.likeButton.isSelected = false
            self.likeButton.tintColor = UIColor.black
        } else {
            
            self.likeButton.isSelected = true
            self.likeButton.tintColor = UIColor.systemRed
        }
    }
    
    //將電影名稱資料存入UserDefault
    func saveData(){
        
        let userDefaults = UserDefaults.standard
        let movieName = "\(movieNameLabel.text ?? "")"
        userDefaults.set(movieName, forKey: "movieName")
    }
}
