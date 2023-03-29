#!/bin/bash
PROGRAM="$(basename $0)"
proofofwork(){
	TEST="$1"
	PRE="$2"
	MINER="$3"
	i=1
	l=1; while [ $l = 1 ]
	do
		TIMESTAMP="$(date -u +%s)"
		SHA="$(echo $TEST'"zpairs":'$(cat /home/$USER/.arching-kaos/mempool/szch)',"nonce":"'$i'","previous":"'$PRE'","timestamp":"'$TIMESTAMP'","miner":"'$MINER'","reward":"40"}' | sha512sum | awk '{ print $1 }')"

        # Static difficulty for securing the sblock
		echo $SHA | grep -e '^000'
		if [ "$?" == 0 ] ;
		then
			echo "SHA512 is $SHA"
			echo "Mined block:"
			echo $TEST'"zpairs":'$(cat /home/$USER/,arching-kaos/mempool/szch)',"nonce":"'$i'","previous":"'$PRE'","timestamp":"'$TIMESTAMP'","miner":"'$MINER'","reward":"40"}' | jq --compact-output > /home/$USER/.arching-kaos/mined_blocks/$SHA
			cat /home/$USER/.arching-kaos/mined_blocks/$SHA | jq
			# exit 0
			# Instead of exiting, we will now sleep for 60 seconds
			# after that we continue mining on top of the just mined
			# block.
			sleep 60
			proofofwork "$1" "$SHA" "$MINER"
		fi
		i=$(expr $i + 1);
	done
}

usage(){
	echo "$PROGRAM <somethings> <previous> <miner_address>"
	echo " hit enter after that !!! "
}

if [ -z "$1" ] ;
then
	usage
	exit;
elif [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ]
then
    proofofwork "$1" "$2" "$3";
else
    usage
fi

exit


