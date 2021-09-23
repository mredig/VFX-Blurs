import UIKit

class CustomIntensityVisualEffectView: UIVisualEffectView {
	// MARK: Private
	private var animator: UIViewPropertyAnimator!

	static func defaultKMVfxView() -> CustomIntensityVisualEffectView {
		CustomIntensityVisualEffectView(effect: UIBlurEffect(style: .regular), intensity: 0.6)
	}

	var intensity: CGFloat {
		didSet {
			animator.fractionComplete = intensity
		}
	}

	/// Create visual effect view with given effect and its intensity
	///
	/// - Parameters:
	///   - effect: visual effect, eg UIBlurEffect(style: .dark)
	///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
	init(effect: UIVisualEffect, intensity: CGFloat) {
		self.intensity = intensity
		super.init(effect: nil)
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
			guard let self = self else { return }
			self.effect = effect
		}
		animator.fractionComplete = intensity
	}

	required init?(coder aDecoder: NSCoder) {
		self.intensity = 1
		super.init(coder: aDecoder)
		let effect = self.effect
		self.effect = nil
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
			guard let self = self else { return }
			self.effect = effect
		}
	}

	func updateEffect(_ effect: UIVisualEffect) {
		animator.stopAnimation(false)
		animator.finishAnimation(at: .current)
		animator = nil
		self.effect = nil
		animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: { [weak self] in
			self?.effect = effect
		})
//		animator.pauseAnimation()
		animator.fractionComplete = intensity
	}
}
