//
//  SAVideoAd2.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//
import UIKit
import SAVideoPlayer

enum AdState {
    case none
    case loading
    case hasAd(ad: AdResponse)
}

@objc(SAVideoAd)
public class VideoAd: NSObject, Injectable {
    private static var adRepository: AdRepositoryType = dependencies.resolve()
    private static var logger: LoggerType = dependencies.resolve(param: InterstitialAd.self)

    static var isTestingEnabled: Bool = Constants.defaultTestMode
    static var isParentalGateEnabled: Bool = Constants.defaultParentalGate
    static var isBumperPageEnabled: Bool = Constants.defaultBumperPage
    static var shouldAutomaticallyCloseAtEnd: Bool = Constants.defaultCloseAtEnd
    static var shouldShowCloseButton: Bool = Constants.defaultCloseButton

    static var shouldShowSmallClickButton: Bool = Constants.defaultSmallClick
    static var orientation: Orientation = Constants.defaultOrientation

    static var isMoatLimitingEnabled: Bool = Constants.defaultMoatLimitingState
    static var delay: AdRequest.StartDelay = Constants.defaultStartDelay

    private static var callback: AdEventCallback? = nil

    private static var ads = Dictionary<Int, AdState>()

    ////////////////////////////////////////////////////////////////////////////
    // Internal control methods
    ////////////////////////////////////////////////////////////////////////////
    
    private static func makeAdRequest() -> AdRequest {
        let size = UIScreen.main.bounds.size
        
        return AdRequest(test: isTestingEnabled,
                         pos: AdRequest.Position.fullScreen,
                         skip: AdRequest.Skip.yes,
                         playbackmethod: AdRequest.PlaybackSoundOnScreen,
                         startdelay: delay,
                         instl: AdRequest.FullScreen.on,
                         w: Int(size.width),
                         h: Int(size.height))
    }
    
    private static func onSuccess(_ placementId: Int, _ response: AdResponse) {
        logger.success("Ad load successful for \(response.placementId)")
        
//        if (!self.isMoatLimitingEnabled) {
//            events.disableMoatLimiting()
//        }
        
        self.ads[placementId] = .hasAd(ad: response)
        callback?(placementId, .adLoaded)
    }
    
    private static func onFailure(_ placementId: Int, _ error: Error) {
        logger.error("Ad load failed", error: error)
        self.ads[placementId] = AdState.none
        callback?(placementId, .adFailedToLoad)
    }

    @objc(load:)
    public static func load(withPlacementId placementId: Int) {
        let adState = ads[placementId] ?? .none

        switch adState {
        case .none:
            ads[placementId] = .loading
            
            logger.info("load() for: \(placementId)")
            
            adRepository.getAd(placementId: placementId, request: makeAdRequest()) { result in
                switch result {
                case .success(let response): self.onSuccess(placementId, response)
                case .failure(let error): self.onFailure(placementId, error)
                }
            }
        case .loading: logger.info("Ad is already loading for: \(placementId)")
            break
        case .hasAd:
            callback?(placementId, .adAlreadyLoaded)
        }
    }

    @objc(play:fromVC:)
    public static func play(withPlacementId placementId: Int, fromVc viewController: UIViewController) {
        let adState = ads[placementId] ?? .none

        switch adState {
        case .hasAd(let ad):
            let config = VideoViewController.Config(showSmallClick: shouldShowSmallClickButton,
                                                    showSafeAdLogo: ad.ad.show_padlock,
                                                    showCloseButton: shouldShowCloseButton,
                                                    shouldCloseAtEnd: shouldAutomaticallyCloseAtEnd,
                                                    isParentalGateEnabled: isParentalGateEnabled,
                                                    isBumperPageEnabled: isBumperPageEnabled,
                                                    orientation: orientation)
            let adViewController = VideoViewController(adResponse: ad, callback: callback, config: config)
            adViewController.modalPresentationStyle = .fullScreen
            adViewController.modalTransitionStyle = .coverVertical
            viewController.present(adViewController, animated: true)
            ads[placementId] = AdState.none
            break
        default:
            callback?(placementId, .adFailedToShow)
            break
        }
    }

    @objc(hasAdAvailable:)
    public static func hasAdAvailable(placementId: Int) -> Bool {
        let adState = ads[placementId] ?? .none
        switch adState {
        case .hasAd: return true
        default: return false
        }
    }
//
//    @objc(getAd:)
//    public static func getAd(placementId: Int) -> SAAd? {
//        let adState = ads[placementId] ?? .none
//        switch adState {
//        case .hasAd(let ad): return ad
//        default: return nil
//        }
//    }

    ////////////////////////////////////////////////////////////////////////////
    // setters
    ////////////////////////////////////////////////////////////////////////////

    public static func setCallback(_ callback: AdEventCallback?) {
        self.callback = callback
    }

    @objc(setTestMode:)
    public static func setTestMode(_ testMode: Bool) {
        isTestingEnabled = testMode
    }

    @objc(enableTestMode)
    public static func enableTestMode() {
        setTestMode(true)
    }

    @objc(disableTestMode)
    public static func disableTestMode() {
        setTestMode(false)
    }

    @objc(setParentalGate:)
    public static func setParentalGate(_ parentalGate: Bool) {
        isParentalGateEnabled = parentalGate
    }

    @objc(enableParentalGate)
    public static func enableParentalGate() {
        setParentalGate(true)
    }

    @objc(disableParentalGate)
    public static func disableParentalGate() {
        setParentalGate(false)
    }

    @objc(setBumperPage:)
    public static func setBumperPage(_ bumperPage: Bool) {
        isBumperPageEnabled = bumperPage
    }

    @objc(enableBumperPage)
    public static func enableBumperPage() {
        setBumperPage(true)
    }

    @objc(disableBumperPage)
    public static func disableBumperPage() {
        setBumperPage(false)
    }

    @objc(setConfigurationProduction)
    public static func setConfigurationProduction() {
//        setConfiguration(SAConfiguration.PRODUCTION)
    }

    @objc(setConfigurationStaging)
    public static func setConfigurationStaging() {
//        setConfiguration(SAConfiguration.STAGING)
    }

    public static func setOriantation(_ orientation: Orientation) {
        self.orientation = orientation
    }

    @objc(setOrientationAny)
    public static func setOrientationAny() {
        setOriantation(.any)
    }

    @objc(setOrientationPortrait)
    public static func setOrientationPortrait() {
        setOriantation(.portrait)
    }

    @objc(setOrientationLandscape)
    public static func setOrientationLandscape() {
        setOriantation(.landscape)
    }

    @objc(setCloseButton:)
    public static func setCloseButton(_ close: Bool) {
        shouldShowCloseButton = close
    }

    @objc(enableCloseButton)
    public static func enableCloseButton() {
        setCloseButton(true)
    }

    @objc(disableCloseButton)
    public static func disableCloseButton() {
        setCloseButton(false)
    }

    @objc(setSmallClick:)
    public static func setSmallClick(_ smallClick: Bool) {
        shouldShowSmallClickButton = smallClick
    }

    @objc(enableSmallClickButton)
    public static func enableSmallClickButton() {
        setSmallClick(true)
    }

    @objc(disableSmallClickButton)
    public static func disableSmallClickButton() {
        setSmallClick(false)
    }

    @objc(setCloseAtEnd:)
    public static func setCloseAtEnd(_ close: Bool) {
        shouldAutomaticallyCloseAtEnd = close
    }

    @objc(enableCloseAtEnd)
    public static func enableCloseAtEnd() {
        setCloseAtEnd(true)
    }

    @objc(disableCloseAtEnd)
    public static func disableCloseAtEnd() {
        setCloseAtEnd(false)
    }

    public static func setPlaybackMode(_ delay: AdRequest.StartDelay) {
        self.delay = delay
    }

    public static func getCallback() -> AdEventCallback? {
        return callback
    }

    @objc(disableMoatLimiting)
    public static func disableMoatLimiting() {
        VideoAd.isMoatLimitingEnabled = false
    }
}