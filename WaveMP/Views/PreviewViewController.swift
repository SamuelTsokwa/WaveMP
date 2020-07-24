//
//  PreviewViewController.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-11.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import UIKit
//
//class PreviewViewController: UIViewController {
//
//    @IBOutlet var artwork: UIImageView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        artwork.clipsToBounds = true
//        artwork.contentMode = .scaleAspectFill
//        // Do any additional setup after loading the view.
//
//    }
//
//    static func controller() -> PreviewViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "previewview") as! PreviewViewController
//        return controller
//    }
//    func setImage(image : UIImage)
//    {
//        artwork.image = image
//    }
//
//
//}
class PreviewViewController: UIViewController {
    private let imageView = UIImageView()

    override func loadView() {
        view = imageView
    }

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)

        // Set up our image view and display the pupper
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.image = image
        self.view.translatesAutoresizingMaskIntoConstraints = false

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
