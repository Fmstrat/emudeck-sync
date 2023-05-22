#!/bin/bash

# Vars
ESPATH=${HOME}/.local/share/emudeck-sync
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
KONSOLE="konsole --hide-menubar --hide-tabbar --fullscreen --notransparency --workdir ${HOME} -e ${SCRIPT_DIR}/emudeck-sync.sh"

# SERVER_DESCS=()
# SERVER_TYPES=()
# Get list from:
# rclone config providers |egrep '"Prefix":|"Description"' |sed 's|        "Prefix": |SERVER_TYPES+=(|g;s|        "Description": |SERVER_DESCS+=(|g;s|,$|)|g'
# SERVER_DESCS+=("Alias for an existing remote")
# SERVER_TYPES+=("alias")
# SERVER_DESCS+=("Amazon Drive")
# SERVER_TYPES+=("acd")
# SERVER_DESCS+=("Microsoft Azure Blob Storage")
# SERVER_TYPES+=("azureblob")
# SERVER_DESCS+=("Backblaze B2")
# SERVER_TYPES+=("b2")
# SERVER_DESCS+=("Box")
# SERVER_TYPES+=("box")
# SERVER_DESCS+=("Encrypt/Decrypt a remote")
# SERVER_TYPES+=("crypt")
# SERVER_DESCS+=("Cache a remote")
# SERVER_TYPES+=("cache")
# SERVER_DESCS+=("Transparently chunk/split large files")
# SERVER_TYPES+=("chunker")
# SERVER_DESCS+=("Combine several remotes into one")
# SERVER_TYPES+=("combine")
# SERVER_DESCS+=("Compress a remote")
# SERVER_TYPES+=("compress")
# SERVER_DESCS+=("Google Drive")
# SERVER_TYPES+=("drive")
# SERVER_DESCS+=("Dropbox")
# SERVER_TYPES+=("dropbox")
# SERVER_DESCS+=("1Fichier")
# SERVER_TYPES+=("fichier")
# SERVER_DESCS+=("Enterprise File Fabric")
# SERVER_TYPES+=("filefabric")
# SERVER_DESCS+=("FTP")
# SERVER_TYPES+=("ftp")
# SERVER_DESCS+=("Google Cloud Storage (this is not Google Drive)")
# SERVER_TYPES+=("gcs")
# SERVER_DESCS+=("Google Photos")
# SERVER_TYPES+=("gphotos")
# SERVER_DESCS+=("Better checksums for other remotes")
# SERVER_TYPES+=("hasher")
# SERVER_DESCS+=("Hadoop distributed file system")
# SERVER_TYPES+=("hdfs")
# SERVER_DESCS+=("HiDrive")
# SERVER_TYPES+=("hidrive")
# SERVER_DESCS+=("HTTP")
# SERVER_TYPES+=("http")
# SERVER_DESCS+=("OpenStack Swift (Rackspace Cloud Files, Memset Memstore, OVH)")
# SERVER_TYPES+=("swift")
# SERVER_DESCS+=("Hubic")
# SERVER_TYPES+=("hubic")
# SERVER_DESCS+=("Internet Archive")
# SERVER_TYPES+=("internetarchive")
# SERVER_DESCS+=("Jottacloud")
# SERVER_TYPES+=("jottacloud")
# SERVER_DESCS+=("Koofr, Digi Storage and other Koofr-compatible storage providers")
# SERVER_TYPES+=("koofr")
# SERVER_DESCS+=("Local Disk")
# SERVER_TYPES+=("local")
# SERVER_DESCS+=("Mail.ru Cloud")
# SERVER_TYPES+=("mailru")
# SERVER_DESCS+=("Mega")
# SERVER_TYPES+=("mega")
# SERVER_DESCS+=("In memory object storage system.")
# SERVER_TYPES+=("memory")
# SERVER_DESCS+=("Akamai NetStorage")
# SERVER_TYPES+=("netstorage")
# SERVER_DESCS+=("Microsoft OneDrive")
# SERVER_TYPES+=("onedrive")
# SERVER_DESCS+=("OpenDrive")
# SERVER_TYPES+=("opendrive")
# SERVER_DESCS+=("Pcloud")
# SERVER_TYPES+=("pcloud")
# SERVER_DESCS+=("premiumize.me")
# SERVER_TYPES+=("premiumizeme")
# SERVER_DESCS+=("Put.io")
# SERVER_TYPES+=("putio")
# SERVER_DESCS+=("QingCloud Object Storage")
# SERVER_TYPES+=("qingstor")
# SERVER_DESCS+=("Amazon S3 Compliant Storage Providers including AWS, Alibaba, Ceph, China Mobile, Cloudflare, ArvanCloud, Digital Ocean, Dreamhost, Huawei OBS, IBM COS, IDrive e2, Lyve Cloud, Minio, Netease, RackCorp, Scaleway, SeaweedFS, StackPath, Storj, Tencent COS and Wasabi")
# SERVER_TYPES+=("s3")
# SERVER_DESCS+=("seafile")
# SERVER_TYPES+=("seafile")
# SERVER_DESCS+=("SSH/SFTP")
# SERVER_TYPES+=("sftp")
# SERVER_DESCS+=("Citrix Sharefile")
# SERVER_TYPES+=("sharefile")
# SERVER_DESCS+=("Sia Decentralized Cloud")
# SERVER_TYPES+=("sia")
# SERVER_DESCS+=("Storj Decentralized Cloud Storage")
# SERVER_TYPES+=("storj")
# SERVER_DESCS+=("Storj Decentralized Cloud Storage")
# SERVER_TYPES+=("tardigrade")
# SERVER_DESCS+=("Sugarsync")
# SERVER_TYPES+=("sugarsync")
# SERVER_DESCS+=("Union merges the contents of several upstream fs")
# SERVER_TYPES+=("union")
# SERVER_DESCS+=("Uptobox")
# SERVER_TYPES+=("uptobox")
# SERVER_DESCS+=("WebDAV")
# SERVER_TYPES+=("webdav")
# SERVER_DESCS+=("Yandex Disk")
# SERVER_TYPES+=("yandex")
# SERVER_DESCS+=("Zoho")
# SERVER_TYPES+=("zoho")

function addToShortcut() {
    if [ -f ${1} ]; then
        if [ -z "$(grep emudeck-sync.sh ${1})" ]; then
            # set -x
            sed -i "2i ${KONSOLE}" ${1}
            echo "" >> ${1}
            echo "${KONSOLE}" >> ${1}
            # { set +x; } 2>/dev/null
        fi
    fi
}

function clearShortcut() {
    rm -f /tmp/emudeck-tmp
    grep -v emudeck-sync.sh ${1} > /tmp/emudeck-tmp
    mv /tmp/emudeck-tmp ${1}
    chmod 755 ${1}
}

function edsReset() {
    echo "This will reset ALL files and cache. Be sure you want to do this!"
    echo ""
    read -p "Press Y to confirm [n]: " CONFIRM
    if [ "${CONFIRM}" = "Y" ] || [ "${CONFIRM}" = "y" ]; then
        rm -rf ${ESPATH}
        echo ""
        echo "Run emudeck-sync.sh again to configure."
    fi
}

function edsConfig() {
    # Install Rclone and set variables
    RCLONE_VERSION=1.62.2
    RCLONE_URL="https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-amd64.zip"
    set -x
    mkdir -p ${ESPATH}
    curl -s -o ${ESPATH}/rclone.zip ${RCLONE_URL}
    unzip ${ESPATH}/rclone.zip rclone-v${RCLONE_VERSION}-linux-amd64/rclone -d ${ESPATH}
    mv ${ESPATH}/rclone-v${RCLONE_VERSION}-linux-amd64/rclone ${ESPATH}/rclone
    rmdir ${ESPATH}/rclone-v${RCLONE_VERSION}-linux-amd64
    rm -f ${ESPATH}/rclone.zip
    { set +x; } 2>/dev/null
    echo ""
    echo "Server types:
1) Nextcloud
2) Dropbox
3) Google Drive"
    read -p "Choose a server type: " SERVER_TYPE
    EXTRA_URL=""
    case ${SERVER_TYPE} in
        "1")
            SERVER_TYPE=nextcloud
            read -p "Type the server URL <Ex: 'https://nextcloud.mydomain.ext:port'>: " SERVER_URL
            read -p "Server username/email: " SERVER_USER
            read -s -p "Server password: " SERVER_PASS
            echo ""
            ;;
        "2")
            SERVER_TYPE=dropbox
            ;;
        "3")
            SERVER_TYPE=drive
            ;;
        *)
            echo "Error"
            exit 2
            ;;
    esac
    # echo "Now set up your provider based on the instructions provided here: https://rclone.org/#providers"
    # echo ""
    # ${ESPATH}/rclone config
    read -p "Enter the path on the server to use for EmuDeck Sync [emudeck-sync]: " SERVER_PATH
    rm -rf  ${ESPATH}/${SERVER_TYPE}
    rm -rf "${HOME}/.cache/rclone/bisync"
    mkdir -p ${ESPATH}/${SERVER_TYPE}
    if [ -z "${SERVER_PATH}" ]; then
        SERVER_PATH="emudeck-sync"
    fi
    echo "SERVER_PATH='${SERVER_PATH}'" > ${ESPATH}/emudeck-sync.conf
    cat ~/.config/rclone/rclone.conf |grep "\[" |tail -n1 |sed 's|\[|SERVER_TYPE=|g;s|\]||g' >> ${ESPATH}/emudeck-sync.conf
    case ${SERVER_TYPE} in
        nextcloud)
            EXTRA_URL="/remote.php/webdav"
            echo "+ ${ESPATH}/rclone config create ${SERVER_TYPE} webdav url=${SERVER_URL}${EXTRA_URL} vendor=${SERVER_TYPE} user=${SERVER_USER} pass=<redacted>"
            ${ESPATH}/rclone config create ${SERVER_TYPE} webdav url=${SERVER_URL}${EXTRA_URL} vendor=${SERVER_TYPE} user="${SERVER_USER}" pass="${SERVER_PASS}"
            ;;
        dropbox | drive)
            set -x
            ${ESPATH}/rclone config create ${SERVER_TYPE} ${SERVER_TYPE}
            { set +x; } 2>/dev/null
            ;;
        *)
            echo "Error"
            exit 3
            ;;
    esac
    # Check if remote sync exists
    ${ESPATH}/rclone ls ${SERVER_TYPE}:${SERVER_PATH}/.emudeck-sync 1>/dev/null 2>&1
    if (( $? != 0 )); then
        touch /tmp/.emudeck-sync
        ${ESPATH}/rclone copy /tmp/.emudeck-sync ${SERVER_TYPE}:${SERVER_PATH}
        rm -f /tmp/.emudeck-sync
    fi
    # if [ ! -f ${ESPATH}/${SERVER_TYPE}/.emudeck-sync.donotdelete ]; then
    #     set -x
    #     touch ${ESPATH}/${SERVER_TYPE}/.emudeck-sync.donotdelete
    #     ${ESPATH}/rclone copy -v ${ESPATH}/${SERVER_TYPE}/.emudeck-sync.donotdelete ${SERVER_TYPE}:${SERVER_PATH}
    #     ${ESPATH}/rclone bisync --resync -v ${SERVER_TYPE}:${SERVER_PATH} ${ESPATH}/${SERVER_TYPE}
    #     { set +x; } 2>/dev/null
    # fi
    echo "$(date +"%Y/%M/%d %H:%M:%S") INFO  : Starting first sync"
    set -x
    ${ESPATH}/rclone bisync --resync -v ${SERVER_TYPE}:${SERVER_PATH} ${ESPATH}/${SERVER_TYPE}
    { set +x; } 2>/dev/null
    echo "$(date +"%Y/%M/%d %H:%M:%S") INFO  : Finished first sync"
}

function edsSync() {
    echo "$(date +"%Y/%M/%d %H:%M:%S") INFO  : Starting sync"
    set -x
    #${ESPATH}/rclone bisync -v --check-access --check-filename .emudeck-sync.donotdelete ${SERVER_TYPE}:${SERVER_PATH} ${ESPATH}/${SERVER_TYPE}
    { set +x; } 2>/dev/null
    ${ESPATH}/rclone bisync -v ${SERVER_TYPE}:${SERVER_PATH} ${ESPATH}/${SERVER_TYPE}
    echo "$(date +"%Y/%M/%d %H:%M:%S") INFO  : Finished sync"
}

function edsEmuConfig() {
    # These configuration changes should happen every run in case an update occurs
    # ----------------------------------------------------------------------------
    # Configure Yuzu save folder
    if [ -f ${HOME}/.config/yuzu/qt-config.ini ]; then
        if [ -z "$(grep "nand_directory=${HOME}/.local/share/emudeck-sync/${SERVER_TYPE}/yuzu/nand" ${HOME}/.config/yuzu/qt-config.ini)" ]; then
            # set -x
            sed -i "s|^nand_directory=.*|nand_directory=${HOME}/.local/share/emudeck-sync/${SERVER_TYPE}/yuzu/nand|g" ${HOME}/.config/yuzu/qt-config.ini
            # { set +x; } 2>/dev/null
        fi
    fi
    if [ ! -d ${ESPATH}/${SERVER_TYPE}/yuzu/nand ]; then
        mkdir -p ${ESPATH}/${SERVER_TYPE}/yuzu/nand
    fi
    # Configure Yuzu shortcuts
    #clearShortcut "${HOME}/.config/EmuDeck/backend/tools/launchers/yuzu.sh"
    #clearShortcut "/run/media/mmcblk0p1/Emulation/tools/launchers/yuzu.sh"
    addToShortcut "${HOME}/.config/EmuDeck/backend/tools/launchers/yuzu.sh"
    addToShortcut "/run/media/mmcblk0p1/Emulation/tools/launchers/yuzu.sh"
}

function edsMain() {
    . ${ESPATH}/emudeck-sync.conf 2> /dev/null
    if [ -z "${SERVER_TYPE}" ]; then
        echo "You must run the configuration first."
        exit 1
    fi
    edsEmuConfig

    case ${SERVER_TYPE} in
        *)
            edsSync
            ;;
    esac
}

if [ "${1}" = "reset" ]; then
    edsReset
elif [ ! -d ${ESPATH} ] || [ "${1}" = "config" ]; then
    edsConfig
else 
    edsMain > >(tee -a ${ESPATH}/${SERVER_TYPE}.log) 2> >(tee -a ${ESPATH}/${SERVER_TYPE}.log >&2)
fi