#!/bin/bash

set -e # Exits on failure

IDENTITY=""
BUNDLE=""
ENTITLEMENTS=""
EXTRA_ENTITLEMENTS=""
ENTITLEMENTS_SCRIPT=""

function __show_usage {
    echo ""
    echo "Usage: $0 [-h] --identity <identity> --bundle <path_to_sign>"
    echo "Options:"
    echo "  -h, --help                      Display this help message"
    echo "  --identity <identity>           Code signing identity (required)"
    echo "  --bundle <path_to_sign>         Path to bundle to sign (required)"
    echo "  --standard-entitlements <path>  Path to standard entitlements (optional)"
    echo "  --extra-entitlements <path>     Path to extended entitlements (optional)"
    echo ""
    exit 1
}

function __get_entitlments_script {
    local type="$1"
    ENTITLEMENTS_SCRIPT=$(dirname "$0")/generate_entitlements.sh
    if ! __is_file "$ENTITLEMENTS_SCRIPT"; then
        echo -e "\nError: no $type entitlements passed and cannot fall back on generate_entitlements.sh script
       because it cannot be found in the same directory as $0\n"
        exit 1
    fi
}

function __generate_entitlements {
    local path="$1"
    local entitlements="$2"
    if [ -z "$path" ] || ! __is_file "$path"; then
        echo -e "\nError: cannot generate entitlements into file $path"
        exit 1
    fi
    source "$ENTITLEMENTS_SCRIPT" -o "$path" $entitlements
}

function __generate_standard_entitlements {
    __get_entitlments_script "standard"
    local tmp_file=$(mktemp -t tmp_standard_entitlements)
    __generate_entitlements "$tmp_file" "--apple-events \
--disable-library-validation \
--allow-dyld-env-vars \
--audio-input \
--camera \
--location \
--addressbook \
--calendars \
--photos \
--allow-jit"

    ENTITLEMENTS=$tmp_file
}

function __generate_extra_entitlements {
    __get_entitlments_script "extra"
    local tmp_file=$(mktemp -t tmp_extra_entitlements)
    __generate_entitlements "$tmp_file" "--debugger \
--disable-executable-memory-protection \
--apple-events \
--disable-library-validation \
--allow-dyld-env-vars \
--audio-input \
--camera \
--location \
--addressbook \
--calendars \
--photos \
--allow-jit"

    EXTRA_ENTITLEMENTS=$tmp_file
}

function __parse_arguments {
    while [ "$#" -gt 0 ]; do
        case "$1" in
        -h) __show_usage ;;
        --help) __show_usage ;;
        --identity)
            IDENTITY="$2"
            shift 2
            ;;
        --bundle)
            BUNDLE="$2"
            shift 2
            ;;
        --standard-entitlements)
            ENTITLEMENTS="$2"
            shift 2
            ;;
        --extra-entitlements)
            EXTRA_ENTITLEMENTS="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            __show_usage
            ;;
        esac
    done

    if [ -z "$IDENTITY" ] || [ -z "$BUNDLE" ]; then
        echo -e "\nError: both --identity and --bundle options are required."
        __show_usage
    fi

    if [ -z "$ENTITLEMENTS" ]; then
        __generate_standard_entitlements
    fi

    if [ -z "$EXTRA_ENTITLEMENTS" ]; then
        __generate_extra_entitlements
    fi
}

function __check_identity {
    local identity="$1"
    if ! security find-identity -v -p codesigning | grep -q "$identity"; then
        echo -e "\nError: code signing identity not found in the keychain \"$identity\"\n"
        exit 1
    fi
}

function __check_path {
    local path="$1"
    if [ ! -e "$path" ]; then
        echo -e "\nError: path does not exist \"$path\"\n"
        exit 1
    fi
}

function __is_file {
    local path="$1"
    if [ -f "$path" ]; then
        true
        return
    fi
    false
    return
}

function __check_app_bundle_path {
    local path="$1"
    __check_path "$path"

    if __is_file "$BUNDLE"; then
        echo -e "\nError: application bundle path is not a direcotry \"$BUNDLE\"\n"
        exit 1
    fi
}

function __validate_arguments {
    __check_app_bundle_path "$BUNDLE"
    __check_identity "$IDENTITY"
}

function __remove_signature {
    codesign --remove-signature "$BUNDLE"
}

function __remove_attributes {
    xattr -r -d com.apple.FinderInfo "$BUNDLE"
}

function prepare_bundle {
    __remove_signature
    __remove_attributes
#    chmod -R a+w "$BUNDLE/Contents/MacOS/xcomp/obrowser.u_xcomp/Contents/Frameworks/Chromium Embedded Framework.framework/Resources"
}

function sign {
    local path="$1"
    local entitlements="$2"
    local -a params

    if [ ! -e "$BUNDLE$path" ]; then
        echo "$BUNDLE$path does not exist, skipping"
        return
    fi

    if ! __is_file "$path"; then
        params+=("--deep")
    fi

    params+=(-f -o runtime --timestamp -v)

    if [ ! -z "$entitlements" ]; then
        params+=("--entitlements" "$entitlements")
    fi

    params+=("-s" "$IDENTITY" "$BUNDLE$path")
    
    (codesign "${params[@]}")
}

function sign_folder_contents {
    local relative_path="$1"
    if [ ! -d "$BUNDLE$relative_path" ]; then
        echo "$BUNDLE$relative_path is not a folder"
        return
    fi
    
    local entitlements="$2"
    
    for file in "$BUNDLE$relative_path"/*; do
        file="${file#"$BUNDLE"}"
        sign "$file" $entitlements
    done
}

__parse_arguments "$@"
__validate_arguments

prepare_bundle
sign_folder_contents "/Contents/MacOS/xcomp/obrowser.u_xcomp/Contents/Frameworks/Chromium Embedded Framework.framework/Libraries" $ENTITLEMENTS
sign "/Contents/Resources/crashpad/crashpad_handler" $EXTRA_ENTITLEMENTS
sign "/Contents/Resources/nodejs/node" $EXTRA_ENTITLEMENTS
sign "/Contents/MacOS/xcomp/obrowser.u_xcomp/Contents/Frameworks/obrowser Helper.app" $EXTRA_ENTITLEMENTS
sign "/Contents/MacOS/xcomp/obrowser.u_xcomp/Contents/Frameworks/obrowser Helper (GPU).app" $EXTRA_ENTITLEMENTS
sign "/Contents/MacOS/xcomp/obrowser.u_xcomp/Contents/Frameworks/obrowser Helper (Renderer).app" $EXTRA_ENTITLEMENTS
wait

sign "/Contents/MacOS/xcomp/obrowser.u_xcomp" $ENTITLEMENTS
wait

# Sign your components here

sign "" $ENTITLEMENTS
wait

exit 0
