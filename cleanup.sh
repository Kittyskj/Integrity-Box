#!/system/bin/sh

F="/data/adb/tricky_store/keybox.xml"
T="/data/adb/tricky_store/keybox.xml.tmp"
L="/data/adb/Integrity-Box-Logs/remove.log"
X="shine,bright,like,adiamond,moona.xd"

log() {
    echo "- $1" >> "$L"
}

delete_if_exist() {
    path="$1"
    if [ -e "$path" ]; then
        rm -rf "$path"
        log "Deleted: $path"
    fi
}

mkdir -p "$(dirname "$L")"
touch "$L"
{
    echo ""
    echo "••••••• Cleanup Started •••••••"

    if [ ! -f "$F" ]; then
        log "File not found: $F"
        echo "••••••• Cleanup Aborted •••••••"
        exit 1
    fi

    log "Removing leftover files"

Z="$(cat "$F")"

Y=""
FIRST=1
IFS=','

for LINE in $(echo "$Z"); do
    for WORD in $X; do
        LINE="${LINE//$WORD/}"
    done
    if [ "$FIRST" -eq 1 ]; then
        Y="$LINE"
        FIRST=0
    else
        Y="$Y
$LINE"
    fi
done

IFS="$OLD_IFS"

printf "%s\n" "$Y" > "$T"
mv "$T" "$F"

    log "Deleting known leftover files..."
    delete_if_exist /data/adb/Integrity-Box/openssl
    delete_if_exist /data/adb/Integrity-Box/libssl.so.3
    delete_if_exist /data/adb/modules/Integrity-Box/system/bin/openssl
    delete_if_exist /data/data/com.termux/files/usr/bin/openssl
    delete_if_exist /data/data/com.termux/files/lib/openssl.so
    delete_if_exist /data/data/com.termux/files/lib/libssl.so
    delete_if_exist /data/data/com.termux/files/lib/libcrypto.so
    delete_if_exist /data/data/com.termux/files/lib/libssl.so.3
    delete_if_exist /data/data/com.termux/files/lib/libcrypto.so.3
    delete_if_exist /data/local/tmp/keybox_downloader
    delete_if_exist /data/adb/modules_update/integrity_box/keybox_downloader.sh

    if command -v pm >/dev/null 2>&1 && pm list packages | grep -q "meow.helper"; then
        pm uninstall meow.helper >/dev/null 2>&1
        log "Uninstalled: meow.helper"
    else
        log "App not found: meow.helper"
    fi

    echo "••••••• Cleanup Ended •••••••"
    echo ""
} >> "$L" 2>&1