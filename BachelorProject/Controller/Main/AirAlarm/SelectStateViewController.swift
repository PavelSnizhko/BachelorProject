//
//  SelectStateViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 13.10.2022.
//

import UIKit
import BottomSheet

class SelectStateViewController: UICollectionViewController  {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, State>

    private let airAlarmDataSource: AirAlarmDataSource
    
    enum Section: Int, CaseIterable, Hashable {
        case states
    }
    
    lazy var dataSource = makeDataSource()
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: self.stateDescriptionCell(), for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    
    init(airAlarmDataSource: AirAlarmDataSource) {
        self.airAlarmDataSource = airAlarmDataSource
        super.init(collectionViewLayout: .init())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyInitialSnapshots()
        configureLayout()
        navigationItem.title = "Your current oblast"
        preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.height / 2.0)
    }
    
    func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, State>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        var statesSnapshot = NSDiffableDataSourceSectionSnapshot<State>()
        statesSnapshot.append(airAlarmDataSource.defaultStates)
        
        dataSource.apply(statesSnapshot, to: .states, animatingDifferences: true)
    }
    
    func configureLayout() {
        let provider = {(sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
            configuration.headerMode = .none
            return .list(using: configuration, layoutEnvironment: layoutEnv)
        }
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: provider)
    }
}

extension SelectStateViewController {
    func stateDescriptionCell() -> UICollectionView.CellRegistration<UICollectionViewListCell, State> {
        return .init { cell, _, state in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = state.name
            cell.contentConfiguration = configuration
        }
    }
}


extension SelectStateViewController: ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView? {
        collectionView
    }
}

extension SelectStateViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let state = dataSource.itemIdentifier(for: indexPath) {
            airAlarmDataSource.changeSelectedState(state)
            UserDefaults.standard.save(model: state, for: "selectedState")
        }
        
    }
}
