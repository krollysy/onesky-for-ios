//
//  LocalizationManager.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 17.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Siesta

/**
 Manager for working with localization
 Uses for parsing and fetching localization.strings
 Also uses for building parameters

 - Author:
 OneSky
 */

final class LocalizationManager: NSObject {

    // - MARK: varaible

    /// Shared manager

    static let shared: LocalizationManager = LocalizationManager()

    /// New bundle name

    static let bundleName = "OneSkyLocalization.bundle"

    /// Name of table for locale

    static let tableName = "LocalizableNew"

    /// File manager

    let manager = FileManager.default

    /// Translated languages

    var translations: Translations = Translations()

    /// Persistance service

    let persistance = PersistanceService()

    /// Bundle path

    lazy var bundlePath: URL = {
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                                 .userDomainMask,
                                                                                 true).first!)
        print("\n     DIRECTORY: \(documents.absoluteString)\n")
        let bundlePath = documents.appendingPathComponent(LocalizationManager.bundleName, isDirectory: true)
        return bundlePath
    }()

    /// Init

    private override init() {
        translations = persistance.translations ?? Translations()
    }

    // - MARK: Functions

    /// Read from localizable.strings file
    /// Localizable should be in main bundle

    func read(from file: String = "Localizable",
              sourceLanguage: String? = Locale.current.languageCode) -> [String]?  {
        guard let language = sourceLanguage else { return nil }
        let filePath: String? = Bundle.main.path(forResource: file,
                                                 ofType: "strings",
                                                 inDirectory: nil,
                                                 forLocalization: language)
        guard let path = filePath else { return nil }

        let dict = NSDictionary.init(contentsOfFile: path)
        return dict?.allValues as? [String]
    }

    /// Remove the bundle if there is there is no more files

    func clean() throws {
        for item in manager.enumerator(at: bundlePath, includingPropertiesForKeys: nil, options: [.skipsPackageDescendants])! {
            print(item)
        }
        if manager.fileExists(atPath: bundlePath.path) {
            try manager.removeItem(at: bundlePath)
        }
    }

    /// Implement new Bundle with localization file

    func bundle(with langId: String) throws -> Bundle? {

        if !manager.fileExists(atPath: bundlePath.path) {
            try manager.createDirectory(at: bundlePath, withIntermediateDirectories: true, attributes: nil)
        }
        let language = translations[langId]

        let langPath = bundlePath.appendingPathComponent("\(langId).lproj", isDirectory: true)
        if !manager.fileExists(atPath: langPath.path) {
            try manager.createDirectory(at: langPath, withIntermediateDirectories: true, attributes: nil)
        }
        guard let sentences = language else { return nil }
        let res = sentences.reduce("", { $0 + "\($1.key) = \($1.value)\n" })

        let filePath = langPath.appendingPathComponent("\(LocalizationManager.tableName).strings")
        let data = res.data(using: .utf32)
        manager.createFile(atPath: filePath.path, contents: data, attributes: nil)

        let localBundle = Bundle(url: bundlePath)!

        return localBundle

    }

    /// Setup manager with translation string

    func setup(with translation: String, locale: Locales, execute: @escaping (() -> Void)) {
        guard let languageId = locale.id else { return }
        let separatedStrings = translation.components(separatedBy: "\n")
        var langDictionary: Language = Dictionary()
        separatedStrings.forEach { separate in
            let doubleSepareted = separate.components(separatedBy: "=")
            guard doubleSepareted.count == 2 else { return }
            langDictionary[doubleSepareted[0]] = doubleSepareted[1]
        }
        translations[languageId] = langDictionary
        persistance.translations = translations
        execute()
    }

    /// Parse siesta error
    /// If error code is equal to -1003 (no internet) then return cached Localization

    func checkLocalizationState() -> Localization? {
        if let url = Bundle.main.url(forResource: "configuration", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try BasicDecoder().configuratorDecoder.decode(Localization.self, from: data)
                return jsonData
            } catch let error {
                debugPrint("Error decode cached configuration.json file: \(error)")
            }
        }
        return nil
    }

    /// Parse siesta error
    /// If error code is equal to -1003 (no internet) then return cached Localization

    func checkTranslations(with languageId: String) -> String? {
        if let url = Bundle.main.url(forResource: "Localizable-\(languageId)", withExtension: "strings") {
            do {
                let finishedString = try String(contentsOf: url)
                return finishedString
            } catch let error {
                debugPrint("Error decode cached localizable-\(languageId) file: \(error)")
            }
        } else {
            debugPrint("no such file in localizable-\(languageId)")
        }
        return nil
    }

}
