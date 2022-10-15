//
//  AirAlarmViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 06.10.2022.
//

import UIKit
import UserNotifications
import BottomSheet

class AirAlarmViewController: UICollectionViewController, Alerting {
    
    // MARK: - Types
    enum Section: Int, CaseIterable, Hashable {
      case selectedState
      case allStates
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, State>
    
    lazy var dataSource = makeDataSource()
    var timer: Timer?
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        let headerTextView = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderTextView.elementKind, withReuseIdentifier: HeaderTextView.reuseIdentifier, for: indexPath) as! HeaderTextView
        headerTextView.set(text: "Choose your current oblast")
        return headerTextView
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            
            switch Section(rawValue: indexPath.section) {
            case .selectedState:
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.selectedStateCell, for: indexPath, item: item
                )
            case .allStates:
                return collectionView.dequeueConfiguredReusableCell(using: self.stateDescriptionCell, for: indexPath, item: item)
            case .none:
                return nil
            }
            
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] collectionView, kind, indexPath in
            let headerTextView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTextView.reuseIdentifier, for: indexPath) as! HeaderTextView
            headerTextView.set(text: "Choose your current oblast")
            return headerTextView
        }
        
        return dataSource
    }
    
    private var airAlarmDataSource = AirAlarmDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HeaderTextView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderTextView.reuseIdentifier)
        airAlarmDataSource.collectionViewDelegate = self
        airAlarmDataSource.subscibeOnCurrentLocation()
        configureLayout()
        applyInitialSnapshots()
        requestPushNotificationPermission()
        setPush()
        self.airAlarmDataSource.fetchAllStates()
        
    }
    
    func setTimerRequests() {
        self.airAlarmDataSource.fetchAllStates()
    }
    
    func requestPushNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Permisssion is granted")
            } else if let error = error {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    func setPush() {
        let content = UNMutableNotificationContent()
        content.title = "Keep calm"
        content.subtitle = "This is a test message"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func configureLayout() {
      let provider = {(sectionIndex: Int, layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
    
        switch Section(rawValue: sectionIndex) {
        case .selectedState:
            var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
            configuration.headerMode = .supplementary
            return .list(using: configuration, layoutEnvironment: layoutEnv)
        case .allStates:
            var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
            configuration.headerMode = .none
            return .list(using: configuration, layoutEnvironment: layoutEnv)
        case .none:
            return nil
        }
        
      }
      collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: provider)
    }

    
    func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, State>()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: false)

        var selectedStatesSnapshot = NSDiffableDataSourceSectionSnapshot<State>()
        selectedStatesSnapshot.append([airAlarmDataSource.selectedState])
        
        dataSource.apply(selectedStatesSnapshot, to: .selectedState, animatingDifferences: true)
    }
    
    let selectedStateCell = UICollectionView.CellRegistration<UICollectionViewListCell, State> { cell, _, state in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = state.name
        configuration.secondaryText = state.alert ? "Тривога" : "Відсутня тривога"
        cell.accessories = [UICellAccessory.disclosureIndicator()]
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .systemBlue
        backgroundConfig.cornerRadius = 5
        backgroundConfig.backgroundInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        cell.backgroundConfiguration = backgroundConfig
        
        cell.contentConfiguration = configuration
        cell.accessories = [UICellAccessory.disclosureIndicator()]
    }
    
    let infoCell = UICollectionView.CellRegistration<UICollectionViewListCell, State> { cell, _, _ in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = "You can select preffered state"
        cell.contentConfiguration = configuration

    }
    
    let stateDescriptionCell = UICollectionView.CellRegistration<UICollectionViewListCell, State> { cell, _, state in
        var configuration = cell.defaultContentConfiguration()
        if state.alert {
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .systemBlue
            backgroundConfig.backgroundColor = .red
            cell.backgroundConfiguration = backgroundConfig
        }
        
        configuration.text = state.name
        configuration.secondaryText = state.alert ? "Тривога" : "Відсутня тривога"
        cell.contentConfiguration = configuration
    }
}

extension AirAlarmViewController: CollectionViewReloadable {
    func reload(with states: [State]) {
        var snapshot = dataSource.snapshot()
        let items = snapshot.itemIdentifiers(inSection: .allStates)
        snapshot.deleteItems(items)
        snapshot.appendItems(states, toSection: .allStates)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateSelectedState(with state: State) {
        let selectedStateSnapshot = dataSource.snapshot(for: .selectedState)
        let items = selectedStateSnapshot.items
        
        if let item = items.first, item.id == state.id {
            showAlert(from: self, title: "Увага", message: state.alert ? "Повітряна тривога, пройдіть до найближчого бомбосховища" : "Відбій повітряної тривоги")
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        
        var snapshot = dataSource.snapshot()

        snapshot.deleteItems(items)
        snapshot.appendItems([state], toSection: .selectedState)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateStateStatus(with state: State) {
        let selectedStateSnapshot = dataSource.snapshot(for: .allStates)
        let items = selectedStateSnapshot.items

        guard let datasourceItem = items.first(where: { item -> Bool in
            return item.id == state.id
        }) else {
            return
        }
        
        var snapshot = dataSource.snapshot()

        snapshot.deleteItems([datasourceItem])
        snapshot.appendItems([state], toSection: .allStates)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension AirAlarmViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .selectedState:
            let vc = SelectStateViewController(airAlarmDataSource: airAlarmDataSource)
            presentBottomSheetInsideNavigationController(
                viewController: vc,
                configuration: .default
            )
        default:
            return
        }
    }
}

