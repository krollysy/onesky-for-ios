<?php
    $arg = $argv[2];
    echo "arg = " . $arg . "\n";
    $json_url = "https://app-api.oneskyhq-stag.com/v1/apps/cfad03c9-0071-4de4-a58c-71a0d4cd9f31";
    $json = file_get_contents($json_url);
    $data = json_decode($json, TRUE);
    $localesArray = array();
    $locales = $data['app']['selectors'][0]['locales'];
    foreach($locales as $item) {
        array_push($localesArray, $item['id']);
    }

    print_r($localesArray);

    # now get string files
    $new_url = "https://app-api.oneskyhq-stag.com/v1/apps/cfad03c9-0071-4de4-a58c-71a0d4cd9f31/string-files?fileFormat=ios-strings&languageId=";

    foreach($localesArray as $id) {
        $url = $new_url . $id;
        $data = file_get_contents($url);
        echo "data = " . $data . "\n";
        file_put_contents($arg . 'Localizable-' . $id . '.strings', $data);
    }
?>

