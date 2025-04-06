//
//  ViewController.swift
//  ios101-project6-tumblr
//
import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchPosts()
        title = "Humans of NY"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        print("ALL VIEW CONTROLLERS:", storyboard.value(forKey: "identifierToNibNameMap") as? [String: Any] ?? [:])
        // In viewDidLoad() of affected controllers:
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        cell.summaryLabel.text = post.summary
        if let photo = post.photos.first {
            Nuke.loadImage(with: photo.originalSize.url, into: cell.postImageView)
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
           let indexPath = sender as? IndexPath,
           let detailVC = segue.destination as? DetailViewController {
            detailVC.post = posts[indexPath.row]
        }
    }

    func fetchPosts() {
        let urlString = "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("❌ Bad server response")
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                DispatchQueue.main.async {
                    self?.posts = blog.response.posts
                    self?.tableView.reloadData()
                    print("✅ We got \(blog.response.posts.count) posts!")
                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
