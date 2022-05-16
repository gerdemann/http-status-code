#! /bin/bash

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "Polling endpoint for status"
      echo " "
      echo "./main.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help           Show brief help"
      echo "--url=URL            url to poll"
      echo "--interval=INTERVAL  Interval between each call, in seconds"
      echo "--timeout=TIMEOUT    Timeout before stop polling, in seconds"
      exit 0
      ;;
    --url*)
      url=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --code*)
      code=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --username*)
      username=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --password*)
      password=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --interval*)
      interval=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

function poll_status {
  while true;
  do
    auth=``
    if [[ "$username" != "" ]]; then
      auth=`-u $username:$password`
    fi;
    STATUS_CODE=`curl -A "Web Check" -sL --connect-timeout 3 -w "%{http_code}\n" $url -o /dev/null`
    echo "$(date +%H:%M:%S): The status code is $STATUS_CODE";
    if [[ "$STATUS_CODE" == "200" ]]; then
          echo "success";
          exit 0;
        break;
    fi;
    sleep $interval;
  done
}

printf "\nPolling '${url%\?*}' every $interval seconds, until status is '200'\n"
poll_status