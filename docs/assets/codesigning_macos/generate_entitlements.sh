#!/bin/bash

# See more about entitlements at https://developer.apple.com/documentation/bundleresources/entitlements

set -e # Exits on failure

OUTPUT_FILE=""
OUTPUT_TEXT=""

function __show_usage {
    echo ""
    echo "Usage: $0 [-h] -o <output file> [ENTITLEMENT OPTIONS...]"
    echo "Options:"
    echo "  -h, --help                              Display this help message"
    echo "  -o <output file>                        Output file path (required)"
    echo ""
    echo "  Sandbox application (https://developer.apple.com/documentation/security/app_sandbox)"
    echo "  --sandbox                               Adds Sandbox entitlement"
    echo ""
    echo "  Network access (https://developer.apple.com/documentation/security/app_sandbox#3111191)"
    echo "  --network-client                        Adds network client entitlement"
    echo "  --network-server                        Adds network server entitlement"
    echo ""
    echo "  Hardware access (https://developer.apple.com/documentation/security/app_sandbox#3111186)"
    echo "  --microphone                            Adds microphone entitlement"
    echo "  --usb                                   Adds USB entitlement"
    echo "  --print                                 Adds printing entitlement"
    echo "  --bluetooth                             Adds Bluetooth entitlement"
    echo ""
    echo "  File access entitlements (https://developer.apple.com/documentation/security/app_sandbox#3111192)"
    echo "  --user-selected-ro                      Adds entitlement for read-only access to user-selected files"
    echo "  --user-selected-rw                      Adds entitlement for read-write access to user-selected files"
    echo "  --downloads-ro                          Adds entitlement for read-only access to Downloads folder"
    echo "  --downloads-rw                          Adds entitlement for read-write access to Downloads folder"
    echo "  --pictures-ro                           Adds entitlement for read-only access to Pictures folder"
    echo "  --pictures-rw                           Adds entitlement for read-write access to Pictures folder"
    echo "  --music-ro                              Adds entitlement for read-only access to Music folder"
    echo "  --music-rw                              Adds entitlement for read-write access to Music folder"
    echo "  --movies-ro                             Adds entitlement for read-only access to Movies folder"
    echo "  --movies-rw                             Adds entitlement for read-write access to Movies folder"
    echo ""
    echo "  Runtime exceptions (https://developer.apple.com/documentation/security/hardened_runtime#3111188)"
    echo "  --allow-jit                             Adds entitlement that allows the app to create writable and
                                          executable memory using the MAP_JIT flag."
    echo "  --allow-unsigned-executable-memory      Adds entitlement that allows the app to create writable and
                                          executable memory without the restrictions imposed by using the MAP_JIT flag."
    echo "  --allow-dyld-env-vars                   Adds entitlement that enables dynamic linker environment variables,
                                          which you can use to inject code into your app’s process."
    echo "  --disable-library-validation            Adds entitlement that enables loading arbitrary plug-ins or
                                          frameworks without requiring code signing."
    echo "  --disable-executable-memory-protection  Adds entitlement that disables all code signing protections while
                                          launching an app, and during its execution."
    echo "  --debugger                              Adds entitlement that indicates whether the app is a debugger and may
                                          attach to other processes."
    echo ""
    echo "  Resource access : https://developer.apple.com/documentation/security/hardened_runtime#3111190"
    echo "  --audio-input                           Adds audio input access entitlement"
    echo "  --camera                                Adds camera access entitlement"
    echo "  --location                              Adds location access entitlement"
    echo "  --addressbook                           Adds address book access entitlement"
    echo "  --calendars                             Adds calendar access entitlement"
    echo "  --photos                                Adds read-write Photo library access entitlement"
    echo "  --apple-events                          Adds Apple events entitlement"
    echo ""
    exit 1
}

function initialise {
    OUTPUT_TEXT='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>'
}

function terminate {
    OUTPUT_TEXT+='
</dict>
</plist>'

    echo -e "$OUTPUT_TEXT" >"$OUTPUT_FILE"
    plutil -lint "$OUTPUT_FILE"
}

# Usage:
#   add_bool_key key.name true
#   add_bool_key key.name false
function add_bool_key {
    local name="$1"
    local value="$2"
    OUTPUT_TEXT+="\n\t<key>$name</key>\n\t<$value/>"
}

# Sandbox App : https://developer.apple.com/documentation/security/app_sandbox
function add_sandbox {
    add_bool_key "com.apple.security.app-sandbox" "true"
}

# Sandbox Netowrk access : https://developer.apple.com/documentation/security/app_sandbox#3111191
function add_network_client {
    add_bool_key "com.apple.security.network.client" "true"
}

function add_network_server {
    add_bool_key "com.apple.security.network.server" "true"
}

# Sandbox Hardware access : https://developer.apple.com/documentation/security/app_sandbox#3111186
function add_microphone {
    add_bool_key "com.apple.security.device.microphone" "true"
}

function add_usb {
    add_bool_key "com.apple.security.device.usb" "true"
}

function add_print {
    add_bool_key "com.apple.security.print" "true"
}

function add_bluetooth {
    add_bool_key "com.apple.security.device.bluetooth" "true"
}

# Sandbox File Access : https://developer.apple.com/documentation/security/app_sandbox#3111192
function add_user_selected_readonly {
    add_bool_key "com.apple.security.files.user-selected.read-only" "true"
}
function add_user_selected_readwrite {
    add_bool_key "com.apple.security.files.user-selected.read-write" "true"
}
function add_downloads_readonly {
    add_bool_key "com.apple.security.files.downloads.read-only" "true"
}
function add_downloads_readwrite {
    add_bool_key "com.apple.security.files.downloads.read-write" "true"
}
function add_pictures_readonly {
    add_bool_key "com.apple.security.assets.pictures.read-only" "true"
}
function add_pictures_readwrite {
    add_bool_key "com.apple.security.assets.pictures.read-write" "true"
}
function add_music_readonly {
    add_bool_key "com.apple.security.assets.music.read-only" "true"
}
function add_music_readwrite {
    add_bool_key "com.apple.security.assets.music.read-write" "true"
}
function add_movies_readonly {
    add_bool_key "com.apple.security.assets.movies.read-only" "true"
}
function add_movies_readwrite {
    add_bool_key "com.apple.security.assets.movies.read-write" "true"
}

# Resource access : https://developer.apple.com/documentation/security/hardened_runtime#3111190
function add_audio_input {
    add_bool_key "com.apple.security.device.audio-input" "true"
}

function add_camera {
    add_bool_key "com.apple.security.device.camera" "true"
}

function add_location {
    add_bool_key "com.apple.security.personal-information.location" "true"
}

function add_addressbook {
    add_bool_key "com.apple.security.personal-information.addressbook" "true"
}

function add_calendars {
    add_bool_key "com.apple.security.personal-information.calendars" "true"
}

function add_photos {
    add_bool_key "com.apple.security.personal-information.photos-library" "true"
}

function add_apple_events {
    add_bool_key "com.apple.security.automation.apple-events" "true"
}

# Runtime exceptions : https://developer.apple.com/documentation/security/hardened_runtime#3111188

function add_jit {
    add_bool_key "com.apple.security.cs.allow-jit" "true"
}

function add_unsigned_executable_memory {
    add_bool_key "com.apple.security.cs.allow-unsigned-executable-memory" "true"
}

function add_dyld_env_vars {
    add_bool_key "com.apple.security.cs.allow-dyld-environment-variables" "true"
}

function add_disable_library_validation {
    add_bool_key "com.apple.security.cs.disable-library-validation" "true"
}

function add_disable_executable_memory_protection {
    add_bool_key "com.apple.security.cs.disable-executable-page-protection" "true"
}

function add_debugger {
    add_bool_key "com.apple.security.cs.debugger" "true"
}

function __parse_arguments {
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -h) __show_usage ;;
        --help) __show_usage ;;
        -o)
            OUTPUT_FILE="$2"
            shift 2
            ;;

        # Sandbox App : https://developer.apple.com/documentation/security/app_sandbox?language=objc
        --sandbox)
            add_sandbox
            shift
            ;;

        # Sandbox Network access : https://developer.apple.com/documentation/security/app_sandbox#3111191
        --network-client)
            add_network_client
            shift
            ;;
        --network-server)
            add_network_server
            shift
            ;;

        # Sandbox Hardware access : https://developer.apple.com/documentation/security/app_sandbox#3111186
        --microphone)
            add_microphone
            shift
            ;;
        --usb)
            add_usb
            shift
            ;;
        --print)
            add_print
            shift
            ;;
        --bluetooth)
            add_bluetooth
            shift
            ;;

        # Sandbox File Access : https://developer.apple.com/documentation/security/app_sandbox#3111192
        --user-selected-ro)
            add_user_selected_readonly
            shift
            ;;
        --user-selected-rw)
            add_user_selected_readwrite
            shift
            ;;
        --downloads-ro)
            add_downloads_readonly
            shift
            ;;
        --downloads-rw)
            add_downloads_readwrite
            shift
            ;;
        --pictures-ro)
            add_pictures_readonly
            shift
            ;;
        --pictures-rw)
            add_pictures_readwrite
            shift
            ;;
        --music-ro)
            add_music_readonly
            shift
            ;;
        --music-rw)
            add_music_readwrite
            shift
            ;;
        --movies-ro)
            add_movies_readonly
            shift
            ;;
        --movies-rw)
            add_movies_readwrite
            shift
            ;;

        # Runtime exceptions : https://developer.apple.com/documentation/security/hardened_runtime#3111188
        --allow-jit)
            add_jit
            shift
            ;;
        --allow-unsigned-executable-memory)
            add_unsigned_executable_memory
            shift
            ;;
        --allow-dyld-env-vars)
            add_dyld_env_vars
            shift
            ;;
        --disable-library-validation)
            add_disable_library_validation
            shift
            ;;
        --disable-executable-memory-protection)
            add_disable_executable_memory_protection
            shift
            ;;
        --debugger)
            add_debugger
            shift
            ;;

        # Resource access : https://developer.apple.com/documentation/security/hardened_runtime#3111190
        --audio-input)
            add_audio_input
            shift
            ;;
        --camera)
            add_camera
            shift
            ;;
        --location)
            add_location
            shift
            ;;
        --addressbook)
            add_addressbook
            shift
            ;;
        --calendars)
            add_calendars
            shift
            ;;
        --photos)
            add_photos
            shift
            ;;
        --apple-events)
            add_apple_events
            shift
            ;;

        *)
            echo "Unknown option: $1"
            __show_usage
            ;;
        esac
    done

    if [ -z "$OUTPUT_FILE" ]; then
        echo -e "\nError: -o option is required."
        __show_usage
    fi
}

initialise
__parse_arguments "$@"
terminate
