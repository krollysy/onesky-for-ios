//
//  Localization.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 05.06.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/**
 Localization for local controllers.
 Will change later.

 - Author:
 OneSky

 */

class PrivateLocalization {

    static let translatedlList: [String: [String: Any]] = [
        "en": ["locale_settings": "Locale settings",
               "language_should_be_displayed": "In which language should the news be translated?",
               "save_locale_settings": "Save"],
        "ru": ["locale_settings": "Настройки локали",
               "language_should_be_displayed": "На какие языки должны быть переведены комментарии?",
               "save_locale_settings": "Сохранить"],
        "ar": ["locale_settings": "الإعدادات المحلية",
               "language_should_be_displayed": "بأي لغة يجب ترجمة الخبر؟",
               "save_locale_settings": "حفظ"],
        "zh_Hans_CN": ["locale_settings": "区域设置",
                       "language_should_be_displayed": "新闻应该用哪种语言翻译？",
                       "save_locale_settings": "保存"],
        "zh_Hant_TW": ["locale_settings": "區域設置",
                       "language_should_be_displayed": "新聞應該用哪種語言翻譯？",
                       "save_locale_settings": "保存"]
    ]

    static func translate(type localizationType: LocalizationType, key: LocalizationKey) -> String? {
        return translatedlList[localizationType.rawValue]?[key.rawValue] as? String
    }

}

enum LocalizationKey: String {
    case localizationSettings = "locale_settings"
    case languageDisplayed = "language_should_be_displayed"
    case save = "save_locale_settings"
}

enum LocalizationType: String {
    case en = "en"
    case ru = "ru"
    case ar = "ar"
    case zhHansCN = "zh_Hans_CN"
    case zhHantTW = "zh_Hant_TW"
}
