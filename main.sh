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

code="${code:-200}"
auth_args=()
if [[ -n "$username" ]]; then
  auth_args=(--user "$username:$password")
  echo "Basic Authentication enabled."
fi

function poll_status {
  while true;
  do
    STATUS_CODE=$(curl -A "Web Check" -s --location-trusted --connect-timeout 3 -w "%{http_code}\n" "${auth_args[@]}" "$url" -o /dev/null)
    echo "$(date +%H:%M:%S): The status code is $STATUS_CODE"
    if [[ "$STATUS_CODE" == "$code" ]]; then
      echo "success"
      exit 0
    fi
    sleep $interval;
  done
}

printf "\nPolling '${url%\?*}' every $interval seconds, until status is '200'\n"
poll_status
