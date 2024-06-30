#!/bin/bash
source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock
source $AK_LIBDIR/_ak_zchain

ZNEWSDIR="$AK_WORKDIR/news"

if [ ! -d $ZNEWSDIR ]
then
    mkdir $ZNEWSDIR
    if [ $? -ne 0 ]
    then
        _ak_log_error "$ZNEWSDIR couldn't be created"
        exit 1
    fi
    _ak_log_info "$ZNEWSDIR created"
else
    _ak_log_info "$ZNEWSDIR found"
fi

cd $ZNEWSDIR

_ak_modules_news_create(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    cd
    curpath="$(pwd)"
    export NEWS_FILE="$(date +%Y%m%d_%H%M%S)"
    vi $NEWS_FILE
    echo "Renaming..."
    TITLE="$(head -n 1 $NEWS_FILE)"
    TO_FILE=$NEWS_FILE-$(echo $TITLE | tr '[:upper:]' '[:lower:]' | sed -e 's/ /\_/g' )
    IPFS_FILE=$(_ak_ipfs_add $NEWS_FILE)
    mv $NEWS_FILE $ZNEWSDIR/$TO_FILE
    sed -i -e 's,Qm.*,'"$IPFS_FILE"',g' $ZNEWSDIR/README
    _ak_modules_news_add $TO_FILE
    cd $ZNEWSDIR
    # rm -rf $TEMP
}

_ak_modules_news_index(){
    FILES="$(ls -1 $ZNEWSDIR)"
    i=0
    _ak_zchain_extract_cids | sort | uniq > temp
    for FILE in $FILES
    do
        DATE="$(echo $FILE | cut -d - -f 1 | awk '{print $1}')"
        TITLE="$(head -n 1 $ZNEWSDIR/$FILE)"
        IPFS_HASH="$(ipfs add -nQ $ZNEWSDIR/$FILE)"
        ONLINE="offzchain"
        grep "$IPFS_HASH" temp > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
            ONLINE="on-zchain"
        fi
        printf "%3d | %5s | %52s | %10s | %56s \n"\
            "$i" "$ONLINE" "$IPFS_HASH" "$DATE" "$TITLE"
        let i+=1
    done
    rm temp
}

_ak_modules_news_import(){
    echo "#TODO"
    if [ ! -z $1 ]
    then
        if [ ! -d "$1" ]
        then
            echo $1
            echo "Folder does not exist"
            exit 4
        else
            echo "Folder $1 exists"
            fl="$(ls -1 $1)"
            for f in $fl
            do
                echo $1 $f
                _ak_modules_news_add_from_file "$1/$f"
            done
        fi
    else
        echo "No value"
        exit 6
    fi
    exit 224
}

_ak_modules_news_add_from_file(){
    TEMP="$(_ak_make_temp_directory)"
    if [ -f "$1" ]; then
        FILE="$(realpath $1)"
        cp $FILE $ZNEWSDIR
        cp $FILE $TEMP
        FILE="$(basename $1)"
        cd $TEMP
        _ak_log_info "Adding news from " $FILE
        DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $FILE)
        FILE_IPFS_HASH=$(_ak_ipfs_add $FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        cat > data <<EOF
{
   "datetime":"$DATETIME",
   "title":"$TITLE",
   "filename":"$(basename $FILE)",
   "ipfs":"$FILE_IPFS_HASH",
   "detach":"$FILE_SIGNATURE"
}
EOF
    else
        _ak_log_error "File $FILE doesn't exist";
        exit 2
    fi
    _ak_zblock_pack "news/add" $(pwd)/data
    if [ $? == 0 ]
    then
        _ak_log_info "News added successfully"
    else
        _ak_log_error "Failed to pack zblock"
        exit 1
    fi
    rm -rf $TEMP
}

_ak_modules_news_add(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ -f $ZNEWSDIR/$1 ]; then
        FILE="$1"
        _ak_log_info "Adding news from " $FILE
        DATETIME=$(echo $FILE | cut -d - -f 1 | awk '{print $1}')
        TITLE=$(head -n 1 $ZNEWSDIR/$FILE)
        FILE_IPFS_HASH=$(_ak_ipfs_add $ZNEWSDIR/$FILE)
        FILE_SIGN_FILE=$FILE".asc"
        _ak_gpg_sign_detached $FILE_SIGN_FILE $ZNEWSDIR/$FILE
        FILE_SIGNATURE=$(_ak_ipfs_add $FILE_SIGN_FILE)
        cat > data <<EOF
{
   "datetime":"$DATETIME",
   "title":"$TITLE",
   "filename":"$FILE",
   "ipfs":"$FILE_IPFS_HASH",
   "detach":"$FILE_SIGNATURE"
}
EOF
    else
        _ak_log_error "File $1 doesn't exist";
        exit 2
    fi
    _ak_zblock_pack "news/add" $(pwd)/data
    if [ $? == 0 ]
    then
        _ak_log_info "News added successfully"
    else
        _ak_log_error "error??"
        exit 1
    fi
}

_ak_modules_news_read(){
    if [ ! -z $1 ] && [ -n "$1" ] && [ "$1" == "local_latest" ]
    then
        _ak_modules_news_read_latest_local_news
        exit 0
    fi

    ak-enter -l 1 $1 > temp
    if [ $? -ne 0 ]
    then
        echo error
        exit 22
    fi
    module="`cat temp | jq -r '.[].module'`"
    action="`cat temp | jq -r '.[].action'`"
    data="`cat temp | jq -r '.[].data'`"
    linkToText="`cat temp | jq -r ".[].$data.ipfs"`"

    if [ "$module" == "news" ] && [ "$action" == "add" ]
    then

        _ak_ipfs_cat $linkToText
    else
        _ak_log_error "Not a news block."
        echo "ERROR Not a news block."
        exit 1
    fi
    rm temp
}

_ak_modules_news_html(){
    ak-enter -l 1 $1 > temp
    if [ $? -ne 0 ]
    then
        _ak_log_error "Failed to retrieve zblock $1"
        exit 22
    fi
    module="`cat temp | jq -r '.[].module'`"
    action="`cat temp | jq -r '.[].action'`"
    data="`cat temp | jq -r '.[].data'`"
    linkToText="`cat temp | jq -r ".[].$data.ipfs"`"
    zfilename="`cat temp | jq -r ".[].$data.filename"`"
    ztitle="`cat temp | jq -r ".[].$data.title"`"
    zdatetime="`cat temp | jq -r ".[].$data.datetime"`"

    if [ "$module" == "news" ] && [ "$action" == "add" ]
    then
        echo "<table>"
        echo "    <tr>"
        echo "        <td>"
        echo "            <pre>⌚ Date/Time</pre>"
        echo "        </td>"
        echo "        <td>"
        echo "             <pre>$zdatetime</pre>"
        echo "        </td>"
        echo "    </tr>"
        echo "    <tr>"
        echo "        <td>"
        echo "            <pre>✍️ Title</pre>"
        echo "        </td>"
        echo "        <td>"
        echo "             <pre>$ztitle</pre>"
        echo "        </td>"
        echo "    </tr>"
        echo "    <tr>"
        echo "        <td>"
        echo "            <pre>📄 Filename</pre>"
        echo "        </td>"
        echo "        <td>"
        echo "             <pre>$zfilename</pre>"
        echo "        </td>"
        echo "    </tr>"
        echo "    <tr>"
        echo "        <td>"
        echo "            <pre>📄 Content</pre>"
        echo "        </td>"
        echo "        <td>"
        echo "             <style>"
        echo "                .body * {"
        echo "                    border: 0;"
        echo "                    margin: 0;"
        echo "                    padding: 0;"
        echo "                 }"
        echo "                .body a {"
        echo "                    color: #042746;"
        echo "                    background-color: lightyellow;"
        echo "                    border: 0;"
        echo "                    margin: 0;"
        echo "                    padding: 0;"
        echo "                 }"
        echo "                .body p {"
        echo "                    border: 0;"
        echo "                    margin: 0;"
        echo "                    padding: 1vh 1vw;"
        echo "                 }"
        echo "             </style>"
        _ak_ipfs_cat $linkToText | txt2tags -t html -H --infile=- --outfile=-
        echo "        </td>"
        echo "    </tr>"
        echo '</table>'
    else
        _ak_log_error "Not a news block."
        exit 1
    fi
    rm temp
}

_ak_modules_news_specs(){
    datetime_mask=$(printf '^[0-9]\{8\}_[0-9]\{6\}$' | xxd -p)
    ipfs_mask=$(printf '^Qm[a-zA-Z0-9]\{44\}$' | xxd -p)
    text_mask=$(printf '^[a-zA-Z0-9_\-]\{1,128\}$' | xxd -p)
    echo '
        {
           "datetime":"'$datetime_mask'",
           "title":    "'$text_mask'",
           "filename": "'$text_mask'",
           "ipfs":     "'$ipfs_mask'",
           "detach":   "'$ipfs_mask'"
        }' | jq
}

_ak_modules_news_read_latest_local_news(){
    TEMP="$(_ak_make_temp_directory)"
    cd $TEMP
    if [ -z "$1" ]
    then
        ak-enter -l 1 | jq > aktempzblock
    else
        ak-enter -l 1 $1 | jq > aktempzblock
    fi

    curzblock="`cat aktempzblock | jq -r '.[].zblock'`"
    curaction="`cat aktempzblock | jq -r '.[].action'`"
    curmodule="`cat aktempzblock | jq -r '.[].module'`"
    curdata="`cat aktempzblock | jq -r '.[].data'`"
    curipfs="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".ipfs")"
    curprevious="`cat aktempzblock | jq -r '.[].previous'`"

    if [ "$curmodule" == "news" ] && [ "$curaction" == "add" ]
    then
        gpgkey="$(cat aktempzblock | jq -r ".[].gpg")"
        title="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".title")"
        echo "Found zblock: $curzblock"
        echo "$title by $gpgkey"
        _ak_ipfs_get $curipfs
        $PAGER $curipfs
        exit 0
    else
        _ak_modules_news_read_latest_local_news $curprevious
    fi
    rm -rf $TEMP
}
