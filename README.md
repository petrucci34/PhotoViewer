# Photo Viewer
This is a demo application that demonstrates downloading and displaying images, infinite scrolling, and a buffered search bar. I'll probably use this project as a sample in a future iOS fundamentals class that I'll teach.

There are a couple of interesting things about how this application operates. First of all, here's what the application does:

![](https://github.com/petrucci34/PhotoViewer/blob/master/photoViewer.gif?raw=true)!

And here are the steps that are taking place above:

![](https://raw.githubusercontent.com/petrucci34/PhotoViewer/master/application-flow.png)

The two interesting things are the buffered search and infinite scrolling. Here's how the buffered search works:

![](https://github.com/petrucci34/PhotoViewer/blob/master/bufferedSearch.gif?raw=true)

As the user's typing, we're keeping track of the text, checking to see if the user has stopped typing. We conclude that the user stopped typing if it's been 500ms or more and the text hasn't changed. Look closely above and observe that we're not making a network request until all at the bottom of the debug screen. This is a nice network optimization which also saves us from the trouble of having to discard the interim thumbnails.

The second interesting piece is the infinite scrolling and this is actually pretty straightforward. By conforming to `UICollectionViewDelegate`, we can observe the collection view as it scrolls. The two concepts we need to familiarize ourselves with is the `contentSize` and `contentOffset`. `contentSize` is the dimension of all the thumbnails stacked up vertically. `contentOffset` is the point at which the origin of the content view is offset from the origin of the scroll view. We also know the visible screen's height, `scrollView.frame.height`. When we put all this together, we can calculate how many screens worth of thumbnails there are eg.

```
    numberOfScreens = scrollView.contentSize.height / crollView.frame.height
    currentScreenNumber = scrollView.contentOffset.y / scrollView.frame.height
```

so:

```
    numberOfRemainingScreens = numberOfScreens - currentScreenNumber
    numberOfRemainingScreens = (scrollView.contentSize.height - scrollView.contentOffset.y) / scrollView.frame.height
```

We compute this every time the user scrolls:

```
extension ThumbnailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        numberOfRemainingScreens = Int((scrollView.contentSize.height - scrollView.contentOffset.y) / scrollView.frame.height) - 1

        searchBar.resignFirstResponder()
    }
}
```

We can then take advantage of Swift's property observing and implement our application logic inside our property declaration. In our case, this logic is to request more thumbnails and loading the new thumbnails into the collection view:

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

## Third-party Frameworks Make Life Easier
### AlamofireImage
 I used [AlamofireImage](https://github.com/Alamofire/AlamofireImage) for synchronous image downloading. While I'm for using straight up `NSURLSession` for simple requests, this library comes in handy for a number of reasons:

* It will download images in parallel without blocking the main queue.
* It's memory efficient. It uses an in-memory image cache called `AutoPurgingImageCache` to store images up to a given memory capacity. When the memory capacity is reached, the image cache is sorted by last access date, then the oldest image is continuously purged until the preferred memory usage after purge is met. Each time an image is accessed through the cache, the internal access date of the image is updated.
* It prioritizes downloads. In our case, we use a last-in-first-out algorithm so that as the user scrolls we download the thumbnails at the bottom.
* It has a lot of other features that I haven't used such as image filters, placeholder images, image transition animations and more.

Check out `AlamofireImage` in action downloading images in parallel. Oh, I forgot to mention they define a cool extenion on `UIImageView` so that the images can be downloaded and assigned in place!

![](https://github.com/petrucci34/PhotoViewer/blob/master/afnetworking.gif?raw=true)

### SwiftyJSON
[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) for easy JSON parsing. This is a huge time-saver and saves from having to write code like:
```
let username = (json["thumbnail"] as? [String: Any])?["title"] as? String
```

in favor of type-checked code like this:

```
let userName = json["thumbnail"]["title"].string 
```


### SwiftyBeaver
[SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver) is flexible and colorful logging library which I've come to like over the last couple of years. It lets you log messages at five different levels: `verbose` for not so important, `debug` for something to debug, `info` as a nice informational message, `warning` for things that need attention and that could turn into errors, and finally `error` for well, errors.

It looks like this on the console:

![](https://github.com/petrucci34/PhotoViewer/blob/master/Screen%20Shot%202017-05-20%20at%2011.26.43%20PM.png?raw=true)

[A cool feature](https://swiftybeaver.com/) of this library is that it has a cloud platform that helps you monitor your app in production. It sends your logging & analytics data from your app securely to the cloud without the need for own servers or backend systems.

### NVActivityIndicatorView
[NVActivityIndicatorView](https://github.com/ninjaprox/NVActivityIndicatorView) is such a cool library that I've been wanting to use for a long time. It has [31 super cool loading animations](https://raw.githubusercontent.com/ninjaprox/NVActivityIndicatorView/master/Demo.gif) that you should check out!

In this app, I use it to display loading spinners on thumbnails and the high-resolution image while the images are being downloaded.

![](https://github.com/petrucci34/PhotoViewer/blob/master/spinner.gif?raw=true)

Reach out to me if you have any questions or comments!

