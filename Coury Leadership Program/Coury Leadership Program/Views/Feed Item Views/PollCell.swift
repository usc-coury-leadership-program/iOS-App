//
//  PollCell.swift
//  Coury Leadership Program
//
//  Created by Hayden Shively on 2/8/19.
//  Copyright © 2019 USC Marshall School of Business. All rights reserved.
//

import UIKit

class PollCell: AUITableViewCell, FeedViewCell {

    public static let HEIGHT: CGFloat = 104
    public static let REUSE_ID: String = "PollCell"

    public var poll: Poll? = nil
    
    @IBOutlet public weak var insetView: UIView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var answersView: UICollectionView!

    func setSaved(to: Bool) {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        engageCollectionView()
        contentView.layer.masksToBounds = false
        insetView.layer.cornerRadius = 8
        insetView.layer.masksToBounds = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        answersView.reloadData()
        configureShadow()
    }

    func onTap(inContext vc: UIViewController) {}
    func onLongPress(began: Bool) {}

    override public func populatedBy(_ data: TableableCellData) -> AUITableViewCell {
        guard let pollModel = data as? Poll else {return self}
        questionText.text = pollModel.question
        poll = pollModel
        return self
    }
    
}

extension PollCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //cell spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {return 8}
    //cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelLength = poll!.answers[indexPath.item].size(withAttributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)
            ])
        return CGSize(width: labelLength.width + 20, height: collectionView.frame.height)
    }

    //number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {return 1}
    //number of items
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return poll?.answers.count ?? 0}

    //cell generation
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return PollCellAnswerCell.generateCellFor(collectionView, at: indexPath)
    }
    //cell view
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? PollCellAnswerCell)?.answerText.text = poll!.answers[indexPath.row]
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PollCellAnswerCell else {return}
        collectionView.allowsSelection = false
        cell.contentView.backgroundColor = .black
        cell.answerText.textColor = .white
        
        poll?.markAsAnswered(with: cell.answerText.text ?? "")
    }

    //MARK: - convenience functions
    func engageCollectionView() {
        answersView.delegate = self
        answersView.dataSource = self

        PollCellAnswerCell.registerWith(answersView)

        answersView.allowsSelection = true
    }
}
