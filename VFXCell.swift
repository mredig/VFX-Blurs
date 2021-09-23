import UIKit

struct VFXCellConfiguration: UIContentConfiguration, Hashable {
	var intensity: CGFloat = 1

	enum EffectStyle: Hashable {
		case blur(style: UIBlurEffect.Style)
		case vibrancy(blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle)
	}
	var effectStyle = EffectStyle.blur(style: .regular)

	func makeContentView() -> UIView & UIContentView {
		VFXCell(configuration: self)
	}

	func updated(for state: UIConfigurationState) -> VFXCellConfiguration { self }
}

class VFXCell: CustomIntensityVisualEffectView, UIContentView {

	private let textLabel = UILabel()

	typealias Config = VFXCellConfiguration
	private var appliedConfig: Config!
	var configuration: UIContentConfiguration {
		get { appliedConfig }
		set {
			guard let newConfig = newValue as? Config else { return }
			apply(configuration: newConfig)
		}
	}

	init(configuration: Config) {
		super.init(effect: UIBlurEffect(style: .regular), intensity: 1)
		commonInit()
		apply(configuration: configuration)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func commonInit() {
		var constraints: [NSLayoutConstraint] = []
		defer { NSLayoutConstraint.activate(constraints) }

		textLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(textLabel)

		constraints += [
			textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		]

		textLabel.numberOfLines = 0
	}

	private func apply(configuration: Config) {
		guard appliedConfig != configuration else { return }
		appliedConfig = configuration

		intensity = configuration.intensity

		let text: String

		switch configuration.effectStyle {
		case .blur(style: let style):
			let effect = UIBlurEffect(style: style)
			updateEffect(effect)
			text = "Blur: \(style)\nIntensity: \(configuration.intensity)"
		case .vibrancy(blurStyle: let blurStyle, vibrancyStyle: let vibStyle):
			let effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurStyle), style: vibStyle)
			updateEffect(effect)
			text = "Blur: \(blurStyle)\nVibrancy: \(vibStyle)\nIntensity: \(configuration.intensity)"
		}

		textLabel.text = text
	}
}

