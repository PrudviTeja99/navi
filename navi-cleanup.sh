run_post_cleanup(){
    rm -f "$@" 2>/dev/null &
}