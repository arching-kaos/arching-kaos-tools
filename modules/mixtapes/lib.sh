#!/usr/bin/env bash
###
### arching-kaos-tools
### Tools to interact and build an Arching Kaos Infochain
### Copyright (C) 2021 - 2025  kaotisk
###
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation, either version 3 of the License, or
### (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
### GNU General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program.  If not, see <http://www.gnu.org/licenses/>.
###

source $AK_LIBDIR/_ak_log
source $AK_LIBDIR/_ak_ipfs
source $AK_LIBDIR/_ak_gpg
source $AK_LIBDIR/_ak_zblock

# Should return current playlist, current mixtape and seek time on the mixtape
_ak_modules_mixtapes_find_now(){
    current_timestamp="$(date -u +%s)"
    mixtapes_ord=$AK_WORKDIR/mixtapes_ord
    if [ ! -d $mixtapes_ord ]
    then
        mkdir -p $mixtapes_ord
    fi
    mixtapes_playlists=$AK_WORKDIR/mixtapes_playlists
    if [ ! -d $mixtapes_playlists ]
    then
        mkdir -p $mixtapes_playlists
    fi
    # cat $AK_WORKDIR/mixtapes_index | while read TS ZB BL DB IF DUR
    # do
    #     echo "$TS $ZB $DUR"
    # done
    counter=1
    total_number_of_mixtapes="$(cat $AK_WORKDIR/mixtapes_index | wc -l)"
    _ak_log_info "Mixtapes found: $total_number_of_mixtapes"
    if [ $total_number_of_mixtapes -gt 1 ]
    then
        while [ $counter -le $total_number_of_mixtapes ]
        do
            # _ak_log_debug "Loop counter: $counter"
            cat $AK_WORKDIR/mixtapes_index | head -n $counter | tail -n 1 | \
                while read TS ZB BL DB IF DUR
            do
                echo "$TS $ZB $BL $DB $IF $DUR" > $mixtapes_ord/$counter
            done
            counter=$(($counter + 1))
        done
    elif [ $total_number_of_mixtapes -eq 1 ]
    then
        _ak_log_debug "Only 1 mixtape"
        cat $AK_WORKDIR/mixtapes_index | while read TS ZB BL DB IF DUR
        do
            echo "$IF" > $mixtapes_playlists/1
            seek=$(( ($(date -u +%s) - $TS) % $DUR ))
            index=$counter
            echo "$counter $index $seek"
            exit 0
        done
    fi
    # watch -n 1 '
    # TS=$(cat mixtapes_index | cut -d\  -f 1,6 | head -n 1 | cut -d\  -f 1)
    # DUR=$(cat mixtapes_index | cut -d\  -f 1,6 | head -n 1 | cut -d\  -f 2)
    # echo $(( ($(date -u +%s) - $TS) / $DUR )) # Times played
    # echo $(( ($(date -u +%s) - $TS) % $DUR )) # Seek time
    # '

    mixtapes_counter=1
    playlists_counter=1
    while [ $mixtapes_counter -le $total_number_of_mixtapes ]
    do
        _ak_log_debug "Counter: $mixtapes_counter"
        # current_timestamp="$(date -u +%s)"
        current_timestamp="$(cat $mixtapes_ord/$mixtapes_counter | cut -d ' ' -f 1)"
        current_duration="$(cat $mixtapes_ord/$mixtapes_counter | cut -d ' ' -f 6)"
        # diff_ts="$(( $current_timestamp  - $timestamp ))"
        # TPIU="$(( $diff_ts / $duration ))"
        # _ak_log_debug "Times played if unique: $TPIU"

        if [ $mixtapes_counter -eq 1 ] && [ $total_number_of_mixtapes -eq 1 ]
        then
            cat $mixtapes_ord/$mixtapes_counter > $mixtapes_playlists/$playlists_counter
            # Return playlist number, mixtape number and seek time
            time_difference=$(( $(date -u +%s) - $current_timestamp))
            seek_time=$(( $time_difference % $current_duration ))
            echo $playlists_counter $mixtapes_counter $seek_time
            # For this particular instance we would loop for ever in the
            # background and exit the script
            mpv --start=$seek_time --loop=inf \
                $(cat $mixtapes_playlists/$playlists_counter | \
                head -n $mixtapes_counter | \
                tail -n 1 | \
                cut -d ' ' -f 5) &
            exit
            break
        fi
        if [ $mixtapes_counter -eq 1 ]
        then
            cat $mixtapes_ord/$mixtapes_counter > $mixtapes_playlists/$playlists_counter
        elif [ $mixtapes_counter -ge 2 ]
        then
            previous_mixtapes_counter=$(($mixtapes_counter-1))
            previous_timestamp=$(cat $mixtapes_ord/$previous_mixtapes_counter | cut -d ' ' -f 1)
            previous_duration=$(cat $mixtapes_ord/$previous_mixtapes_counter | cut -d ' ' -f 6)
            _ak_log_debug "czts: $current_timestamp, pzts: $previous_timestamp"
            previous_diff_ts=$(($current_timestamp - $previous_timestamp))
            times_played_since_previous=$(( $previous_diff_ts / $previous_duration ))
            if [ $times_played_since_previous -gt 0 ]
            then
                # This means that by the time the current_zblock was added the
                # previous one hadn't finished playing. We suppose that we would
                # allow it to play in full, so we add "1"
                times_would_be_played=$(($times_played_since_previous + 1))
                # Playing X times would give us a new duration
                total_duration=$(($times_would_be_played * $previous_duration))
                # And we now figure out when the previous mix would stop playing
                next_stop=$(($previous_timestamp + $total_duration))
                _ak_log_debug "Next stop: $next_stop"
                _ak_log_debug "Total duration: $total_duration"
                _ak_log_debug "Times would be played: $times_would_be_played"
                next_playlist=$(($playlists_counter + 1))
                _ak_log_debug "Next playlist: $next_playlist"
                if [ ! -f $mixtapes_playlists/$next_playlist ]
                then
                    cat $mixtapes_playlists/$playlists_counter > $mixtapes_playlists/$next_playlist
                fi
                cat $mixtapes_ord/$mixtapes_counter >> $mixtapes_playlists/$next_playlist
                playlists_counter=$next_playlist
                _ak_log_debug "Now playlist counter is: $playlists_counter"
            else
                # But which playlist? When do we increase?
                cat $mixtapes_ord/$mixtapes_counter >> $mixtapes_playlists/$playlists_counter
                _ak_log_debug "Possibly append current one to the previous playlist!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
            fi
            seek_time_since_previous=$(( $previous_diff_ts % $previous_duration ))
            _ak_log_debug "Time passed since previous upload:"
            _ak_log_debug "$current_timestamp - $previous_timestamp = $previous_diff_ts"
            _ak_log_debug "Times played since previous:"
            _ak_log_debug "$previous_diff_ts / $previous_duration = $times_played_since_previous"
            _ak_log_debug "Seek time since previous:"
            _ak_log_debug "$previous_diff_ts % $previous_duration = $seek_time_since_previous"

        elif [ $mixtapes_counter -eq $total_number_of_mixtapes ]
        then
            echo $(( ($(date -u +%s) - $current_timestamp) % $current_duration )) # Seek time
        fi
        mixtapes_counter=$(($mixtapes_counter + 1))
    done
}

_ak_modules_mixtapes_specs(){
    datetime_mask=$(printf '^[0-9]\{8\}_[0-9]\{6\}$' | xxd -p)
    ipfs_mask=$(printf '^Qm[a-zA-Z0-9]\{44\}$' | xxd -p)
    text_dash_underscore_space_mask=$(printf '^[a-zA-Z0-9][a-zA-Z0-9[:space:]\_]\{1,128\}$' | xxd -p -c 64)
    echo '
        {
           "datetime": "'$datetime_mask'",
           "artist":   "'$text_dash_underscore_space_mask'",
           "title":    "'$text_dash_underscore_space_mask'",
           "ipfs":     "'$ipfs_mask'",
           "detach":   "'$ipfs_mask'"
        }' | jq
}

_ak_modules_mixtapes_add(){
    if [ ! -z $3 ];
    then
        echo $1
        PWD="$(pwd)"
        MIXTAPE_ARTIST="$1"
        MIXTAPE_TITLE="$2"
        MIXTAPE_FILE="$PWD/$3"
        _ak_modules_mixtapes_main $1
        cat $PWD/data | jq -M
        _ak_zblock_pack mixtape/add $PWD/data
    fi
}

_ak_modules_mixtapes_main(){
    echo $MIXTAPE_FILE "by" $MIXTAPE_ARTIST "named as" $MIXTAPE_TITLE

    MIXTAPE_IPFS_HASH=$(_ak_ipfs_add $MIXTAPE_FILE)

    MIXTAPE_SIGN_FILE=$MIXTAPE_FILE".asc"
    _ak_gpg_sign_detached $MIXTAPE_SIGN_FILE $MIXTAPE_FILE

    MIXTAPE_SIGNATURE=$(_ak_ipfs_add $MIXTAPE_SIGN_FILE)

    cat > data <<EOF
{
    "timestamp":"$(date -u +%s)",
    "artist":"$MIXTAPE_ARTIST",
    "title":"$MIXTAPE_TITLE",
    "ipfs":"$MIXTAPE_IPFS_HASH",
    "detach":"$MIXTAPE_SIGNATURE"
}
EOF

}

_ak_modules_mixtapes_get_local_latest(){
    tempdir=$(_ak_make_temp_directory)
    cd $tempdir
    if [ -z "$1" ]
    then
        _ak_zchain_crawl -l 1 | jq > aktempzblock
    else
        _ak_zchain_crawl -l 1 $1 | jq > aktempzblock
    fi
    curzblock="`cat aktempzblock | jq -r '.[].zblock'`"
    curaction="`cat aktempzblock | jq -r '.[].action'`"
    curmodule="`cat aktempzblock | jq -r '.[].module'`"
    curdata="`cat aktempzblock | jq -r '.[].data'`"
    curipfs="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".ipfs")"
    curprevious="`cat aktempzblock | jq -r '.[].previous'`"

    if [ "$curmodule" == "mixtape" ] && [ "$curaction" == "add" ]
    then
        artist="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".artist")"
        title="$(cat aktempzblock | jq -r ".[].$curdata" | jq -r ".title")"
        echo "Found zblock: $curzblock"
        echo "$title by $artist"
        _ak_ipfs_get $curipfs
        mpv $curipfs
    else
        seek $curprevious
    fi
    rm -rf $tempdir
    exit 0
}
