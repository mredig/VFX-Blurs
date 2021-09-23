//
//  ViewController.swift
//  VFX Blurs
//
//  Created by Michael Redig on 9/23/21.
//

import UIKit

class ViewController: UIViewController {

	let textView = UITextView()
	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	let slider = UISlider()

//	enum EffectStyle: Hashable {
//		case blur(style: UIBlurEffect.Style)
//		case vibrancy(blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle)
//	}
	struct Row: Hashable {
		let style: EffectStyle
		let intensity: CGFloat
	}
	typealias EffectStyle = VFXCellConfiguration.EffectStyle
	private var dataSource: UICollectionViewDiffableDataSource<Int, Row>!

	var intensity: CGFloat {
		CGFloat(slider.value)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.

		setupTextView()
		setupHierarchy()
		setupCollectionView()
		setupDataSource()
		applyDataSource()
	}

	private func setupHierarchy() {
		var constraints: [NSLayoutConstraint] = []
		defer { NSLayoutConstraint.activate(constraints) }

		textView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(textView)
		constraints += [
			textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		]

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		constraints += [
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		]

		view.backgroundColor = .systemBackground

		let sliderAction = UIAction { [weak self] action in
			self?.applyDataSource()
		}

		slider.minimumValue = 0
		slider.maximumValue = 1
		slider.value = 1

		navigationItem.titleView = slider
		slider.addAction(sliderAction, for: .valueChanged)
	}

	private func setupCollectionView() {
		let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: size)

		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

		let section = NSCollectionLayoutSection(group: group)
		let layout = UICollectionViewCompositionalLayout(section: section)

		collectionView.collectionViewLayout = layout
		collectionView.backgroundColor = .clear
	}

	private func setupDataSource() {
		let cellConfig: UICollectionView.CellRegistration<UICollectionViewListCell, Row> = UICollectionView.CellRegistration(
			handler: { cell, indexPath, row in
				var config = VFXCellConfiguration()
				config.effectStyle = row.style
				config.intensity = row.intensity
				cell.backgroundConfiguration = .clear()

				cell.contentConfiguration = config
			})

		dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, style in
			collectionView.dequeueConfiguredReusableCell(using: cellConfig, for: indexPath, item: style)
		})
	}

	private func setupTextView() {
		let ipsum = """
			Bacon ipsum dolor amet prosciutto pork chop ball tip, chicken tail alcatra picanha brisket ham hock meatball sausage ground round landjaeger cow shank. Leberkas pastrami t-bone prosciutto beef chicken frankfurter shankle burgdoggen swine turkey boudin cupim. Strip steak fatback beef ribs porchetta. Biltong doner strip steak andouille pig boudin flank meatball filet mignon.

			Venison brisket ribeye short loin landjaeger, fatback turducken spare ribs boudin tri-tip chuck ball tip picanha. Capicola chicken bacon ham hock ribeye beef fatback biltong, meatloaf strip steak frankfurter pork t-bone. Prosciutto tri-tip ham pork venison chuck. Tongue picanha pastrami ground round short loin salami. Beef ribs ribeye shank brisket jerky sirloin spare ribs shoulder pork loin pork chop flank landjaeger.

			Capicola flank rump jowl bresaola. Cupim ribeye t-bone flank pig jerky shank chislic chuck chicken ham doner ham hock. Shankle biltong burgdoggen turkey. Flank drumstick sausage chicken pancetta capicola t-bone porchetta turkey kielbasa meatball biltong pork chop frankfurter bacon. Drumstick salami capicola buffalo, swine jerky beef ribs alcatra pancetta tongue prosciutto. Sausage leberkas ham hock salami ham hamburger tail short loin flank turkey tenderloin. Tri-tip chicken pig spare ribs, jerky beef swine sirloin short ribs shank beef ribs shoulder tongue fatback.

			Tongue jowl pork, shankle chuck shoulder tail ham hock beef ribs pork chop bacon. Pastrami turkey bacon, pork short loin leberkas porchetta shankle. Kielbasa ham spare ribs bresaola, swine short ribs brisket shankle t-bone bacon pancetta cow chuck fatback. Bacon chislic jowl biltong, turkey pork loin ground round filet mignon beef prosciutto sausage capicola landjaeger turducken venison. Doner ground round sausage porchetta swine fatback kevin cow burgdoggen picanha jowl. Beef ground round bacon drumstick spare ribs flank, pork chop t-bone meatloaf filet mignon swine.

			Short loin cow capicola leberkas beef swine doner tail boudin meatloaf jerky turducken, sirloin fatback burgdoggen. Chicken boudin cow venison salami filet mignon bresaola alcatra chislic. Ball tip chislic flank salami pork chop. Pork belly pork loin fatback, pancetta shank sirloin shoulder chicken burgdoggen venison. Spare ribs buffalo burgdoggen, tenderloin corned beef boudin turducken andouille sirloin kielbasa.
			"""

		textView.text = ipsum
		textView.font = .systemFont(ofSize: 24, weight: .regular)
	}

	private func applyDataSource() {
		let vibrancyStyles: [UIVibrancyEffectStyle] = [
			.fill,
			.label,
			.quaternaryLabel,
			.secondaryFill,
			.secondaryLabel,
			.separator,
			.tertiaryFill,
			.tertiaryLabel,
		]

		let blurStyles: [UIBlurEffect.Style] = [
//			.dark,
//			.extraLight,
//			.light,
			.prominent,
			.regular,
			.systemChromeMaterial,
//			.systemChromeMaterialDark,
//			.systemChromeMaterialLight,
			.systemMaterial,
//			.systemMaterialDark,
//			.systemMaterialLight,
			.systemThickMaterial,
//			.systemThickMaterialDark,
//			.systemThickMaterialLight,
			.systemThinMaterial,
//			.systemThinMaterialDark,
//			.systemThinMaterialLight,
			.systemUltraThinMaterial,
//			.systemUltraThinMaterialDark,
//			.systemUltraThinMaterialLight,
		]

		var snap = NSDiffableDataSourceSnapshot<Int, Row>()
		snap.appendSections([0])

		snap.appendItems(blurStyles.map { Row(style: EffectStyle.blur(style:$0), intensity: intensity) }, toSection: 0)

		let vibrancies = vibrancyStyles
			.flatMap { vibStyle in
				blurStyles.map { blurStyle in
					Row(style: EffectStyle.vibrancy(blurStyle: blurStyle, vibrancyStyle: vibStyle), intensity: intensity)
				}
			}

		snap.appendItems(vibrancies, toSection: 0)

		dataSource.apply(snap)
	}
}

extension UIVibrancyEffectStyle: CustomStringConvertible {
	public var description: String {
		switch self {
		case .fill: return "fill"
		case .label: return "label"
		case .quaternaryLabel: return "quaternaryLabel"
		case .secondaryFill: return "secondaryFill"
		case .secondaryLabel: return "secondaryLabel"
		case .separator: return "separator"
		case .tertiaryFill: return "tertiaryFill"
		case .tertiaryLabel: return "tertiaryLabel"
		@unknown default: return "Unknown"
		}
	}
}

extension UIBlurEffect.Style: CustomStringConvertible {
	public var description: String {
		switch self {
		case .dark: return "dark"
		case .extraLight: return "extraLight"
		case .light: return "light"
		case .prominent: return "prominent"
		case .regular: return "regular"
		case .systemChromeMaterial: return "systemChromeMaterial"
		case .systemChromeMaterialDark: return "systemChromeMaterialDark"
		case .systemChromeMaterialLight: return "systemChromeMaterialLight"
		case .systemMaterial: return "systemMaterial"
		case .systemMaterialDark: return "systemMaterialDark"
		case .systemMaterialLight: return "systemMaterialLight"
		case .systemThickMaterialDark: return "systemThickMaterialDark"
		case .systemThickMaterialLight: return "systemThickMaterialLight"
		case .systemThickMaterial: return "systemThickMaterial"
		case .systemThinMaterial: return "systemThinMaterial"
		case .systemThinMaterialDark: return "systemThinMaterialDark"
		case .systemThinMaterialLight: return "systemThinMaterialLight"
		case .systemUltraThinMaterial: return "systemUltraThinMaterial"
		case .systemUltraThinMaterialDark: return "systemUltraThinMaterialDark"
		case .systemUltraThinMaterialLight: return "systemUltraThinMaterialLight"
		@unknown default: return "Unknown"
		}
	}
}
