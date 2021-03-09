//
//  MovieHomeVC.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/2.
//

import UIKit
import Kingfisher

class MovieHomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //TMDBapikey
    let apiKey = "0c40b109d6b189238bd73f7934cb3a4a"
    
    var moviesArray = [MoviesData]()
    var searchMoviesArray = [MoviesData]()
    var index = 0
    var movieName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMoiveInfo()
        
    }
    
    //抓取電影資訊
    func getMoiveInfo(){
        let urlStr = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&sort_by=popularity.desc&include_adult=false&include_video=false&page=3&year=2020&language=zh-TW"
        if let url = URL(string: urlStr) {
            
            
            URLSession.shared.dataTask(with: url) { (data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                //解析JSON
                if let data = data , let moviesData = try? decoder.decode(Film.self, from: data){
                    self.moviesArray = moviesData.results
                    self.searchMoviesArray = self.moviesArray
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTVC
        let movieList = searchMoviesArray[indexPath.row]
        
        cell.movieName.text = movieList.title
        cell.releaseDate.text = movieList.release_date
        if let vote = movieList.vote_average {
            cell.tmbdVote.text = String(vote)
        }
        
        //抓取電影封面
        if let imageAddress = movieList.poster_path{
            if let imageURL = URL(string: "https://image.tmdb.org/t/p/w500/" + imageAddress){
                let task = URLSession.shared.dataTask(with: imageURL){(data, response, error ) in
                    if let data = data{
                        DispatchQueue.main.async {
                            cell.movieImage.image = UIImage(data:data)
                        }
                    }
                }
                task.resume()
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //傳資料至MovieIntroVC頁面
        if let indexPath = tableView.indexPathForSelectedRow {
            let movieName = searchMoviesArray[indexPath.row].title
            let releaseDate = searchMoviesArray[indexPath.row].release_date
            let tmbdVoteList = searchMoviesArray[indexPath.row]
            let movieOverview = searchMoviesArray[indexPath.row].overview
            let backdrop_path = searchMoviesArray[indexPath.row].backdrop_path
            
            let movieIntroVC = segue.destination as! MovieIntroVC
            movieIntroVC.movieName = movieName
            movieIntroVC.releaseDate = releaseDate
            if let tmbdVote = tmbdVoteList.vote_average {
                movieIntroVC.tmbdVote = tmbdVote
            }
            movieIntroVC.movieOverview = movieOverview
            movieIntroVC.backdrop_path = backdrop_path
        }
        
        saveData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            searchMoviesArray = moviesArray
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchMoviesArray = moviesArray.filter({ (movie) -> Bool in
                return
                (movie.title?.uppercased().contains(text.uppercased()) ?? true)
            })
        }
        tableView.reloadData()
    }
    
    //將登入者資料存入UserDefault
    func saveData(){
        
        let userDefaults = UserDefaults.standard
        let loginUser = "Lee"
        userDefaults.set(loginUser, forKey: "loginUser")
    }
}
