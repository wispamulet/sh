#! /bin/bash

export windows_host=$(ipconfig.exe | grep -n4 WSL | tail -n 1 | awk -F":" '{ print $2 }' | sed 's/^[ \r\n\t]*//;s/[ \r\n\t]*$//')

# params=("--help" "-h" "--port" "-p")
# echo $#

NO_ARGS="error: need more arguments"
ERROR_NO_PORT="error: need specify port number"
ERROR_PARAM1="error: unknown command $1, see --help"
ERROR_PARAM2="error: unknown command $2"
ERROR_PARAM3="error: unknown command $3"
ERROR_PARAM3_NO_PORT="error: unknown command $3, port should be a number"
re="^[0-9]+$"

usage="usage: cli-proxy [--help | -h] <command> [<args>]"

print_usage() {
  cat <<END
$usage

  set     Set proxy port
  get     Get proxy port
  clear   Clear proxy
END
}

print_set_usage() {
  cat <<END
$usage

  --port, -p: Specify http_poxy, https_proxy and NO_PROXY port number
  --http-proxy: Specify http_poxy port number
  --https-proxy: Specify https_poxy port number
  --no-proxy: Specify NO_PROXY, normally should be "localhost,127.0.0.1"
END
}

print_get_usage() {
  cat <<END
$usage

  Print http_proxy, https_proxy and NO_PROXY in current session
END
}

print_clear_usage() {
  cat <<END
$usage

  Clear http_proxy, https_proxy and NO_PROXY in current session
END
}

setPort() {
  export http_proxy=socks5://$windows_host:$1
  export https_proxy=socks5://$windows_host:$1
  export NO_PROXY=localhost,127.0.0.1
}

clear_port() {
  export http_proxy=""
  export https_proxy=""
  export NO_PROXY=""
}

get_port() {
  echo http_proxy=$http_proxy
  echo https_proxy=$https_proxy
  echo NO_PROXY=$NO_PROXY
}

#? cli-proxy 🚩
if [ $# -eq 0 ]; then
  print_usage
#? cli-proxy --help
elif [ "$1" = "--help" -o "$1" = "-h" ]; then
  # cli-proxy --help set
  if [ "$2" = "set" ]; then
    if ! [ -z "$3" ]; then
      echo $ERROR_PARAM3
    else
      print_set_usage
    fi
  # cli-proxy --help get
  elif [ "$2" = "get" ]; then
    if ! [ -z "$3" ]; then
      echo $ERROR_PARAM3
    else
      print_get_usage
    fi
  # cli-proxy --help clear
  elif [ "$2" = "clear" ]; then
    if ! [ -z "$3" ]; then
      echo $ERROR_PARAM3
    else
      print_clear_usage
    fi
  # cli-proxy --abc 💔
  elif ! [ -z "$2" ]; then
    echo $ERROR_PARAM2
  fi
#? cli-proxy set 🚩
elif [ "$1" = "set" ]; then
  # cli-proxy set --help 🍔
  if [ "$2" = "--help" -o "$2" = "-h" ]; then
    # cli-proxy set --abc 💔
    if ! [ -z "$3" ]; then
      echo $ERROR_PARAM3
    # cli-proxy set --help 🍻
    else
      print_set_usage
    fi
  # cli-proxy set --port 🚩
  elif [ "$2" = "--port" -o "$2" = "-p" ]; then
    # cli-proxy set --port "NAN" 💔
    if ! [[ "$3" =~ $re ]]; then
      echo $ERROR_PARAM3_NO_PORT
    # cli-proxy set --port 1080 🍻
    else
      setPort $3
    fi
  # cli-proxy set --http-proxy 🚩
  elif [ "$2" = "--http-proxy" ]; then
    # cli-proxy set --http-proxy "NAN" 💔
    if ! [[ "$3" =~ $re ]]; then
      echo $ERROR_PARAM3_NO_PORT
    # cli-proxy set --http-proxy 1080 🍻
    else
      export http_proxy=http://127.0.0.1:$3
    fi
  elif [ "$2" = "--https-proxy" ]; then
    # cli-proxy set --https-proxy "NAN" 💔
    if ! [[ "$3" =~ $re ]]; then
      echo $ERROR_PARAM3_NO_PORT
    # cli-proxy set --https-proxy 1080 🍻
    else
      export https_proxy=http://127.0.0.1:$3
    fi
  elif [ "$2" = "--no-proxy" ]; then
    # cli-proxy set --no-proxy 💔
    if ! [ -z "$2" ]; then
      echo $NO_ARGS
    # cli-proxy set --no-proxy $3 🍻
    else
      export NO_PROXY=$3
    fi
  # cli-proxy set 💔
  else
    echo $NO_ARGS
  fi
# ? cli-proxy get 🚩
elif [ "$1" = "get" ]; then
  # cli-proxy get --help 🍔
  if [ "$2" = "--help" -o "$2" = "-h" ]; then
    print_get_usage
  # cli-proxy get --abc 💔
  elif ! [ -z "$2" ]; then
    echo $ERROR_PARAM2
  # cli-proxy get 🍻
  else
    get_port
  fi
# ? cli-proxy clear 🚩
elif [ "$1" = "clear" ]; then
  # cli-proxy clear --help 🍔
  if [ "$2" = "--help" -o "$2" = "-h" ]; then
    print_clear_usage
  # cli-proxy clear --xyz 💔
  elif ! [ -z "$2" ]; then
    echo $ERROR_PARAM2
  # cli-proxy clear 🍻
  else
    clear_port
  fi
# ? cli-proxy abc 💔
elif ! [ -z "$1" ]; then
  echo $ERROR_PARAM1
fi

# export http_proxy=http://127.0.0.1:1080
# export https_proxy=http://127.0.0.1:1080
# export NO_PROXY=localhost,127.0.0.1
