# PhotoViewer
This is a demo application that demonstrates downloading and displaying images, infinite scrolling, and a buffered search bar. I'll probably use this project as a sample in a future iOS fundamentals class that I'll teach.

There are a couple of interesting things about how this application operates. First of all, here's what the application does:

![](https://github.com/petrucci34/PhotoViewer/blob/master/photoViewer.gif?raw=true)!

And here are the steps that are taking place above:

![](https://raw.githubusercontent.com/petrucci34/PhotoViewer/master/application-flow.png)

The two interesting things are the buffered search and infinite scrolling. Here's how the buffered search works:

![](https://github.com/petrucci34/PhotoViewer/blob/master/bufferedSearch.gif?raw=true)

As the user's typing, we're keeping track of the text checking to see if the user has stopped typing. We conclude that the user stopped typing if it's been 500ms or more and the text hasn't changed. Look closely above and observe that we're not making a network request until all the way at the end. This is a nice network optimization which also saves us from the trouble of discarding the interim thumbnails.

The second interesting piece is the infinite scrolling and this is actually pretty straightforward.

```
extension ThumbnailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        numberOfRemainingScreens = Int((scrollView.contentSize.height - scrollView.contentOffset.y) / scrollView.frame.height) - 1

        searchBar.resignFirstResponder()
    }
}
```

```
    fileprivate var numberOfRemainingScreens: Int = 0 {
        didSet {
            if numberOfRemainingScreens < allowedNumberOfRemainingScreens {
                SwiftyBeaver.debug("should request more images")
                dataSource.requestMoreThumbnails() { thumbnails in
                    DispatchQueue.main.async {
                        var indexPaths = [IndexPath]()
                        let totalCount = self.dataSource.thumbnails.count
                        for row in (totalCount - thumbnails.count)..<totalCount {
                            indexPaths.append(IndexPath(row: row, section: 0))
                        }
                        self.collectionView.insertItems(at: indexPaths)
                    }
                }
            }
        }
    }
```

Third-party frameworks:
* AFNetworking image downloader:

![](https://github.com/petrucci34/PhotoViewer/blob/master/afnetworking.gif?raw=true)

* SwiftyBeaver:

![](https://github.com/petrucci34/PhotoViewer/blob/master/Screen%20Shot%202017-05-20%20at%2011.26.43%20PM.png?raw=true)

* Spinner:

![](https://github.com/petrucci34/PhotoViewer/blob/master/spinner.gif?raw=true)

* SwiftyJSON

```
struct Thumbnail {
...

    init(json: JSON) {
        id = json["id"].stringValue
        title = json["title"].stringValue

        if let urlString = json["url_s"].string {
            thumbnailSizeUrl = URL(string: urlString.thumbnailSizeURLString())!
            url = URL(string: urlString.largeSizeURLString())!
        } else {
            thumbnailSizeUrl = nil
            url = nil
        }

        height = json["height_s"].intValue
        width = json["width_s"].intValue
    }
}
```
