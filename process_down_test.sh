TARGET_CONTAINER=process_down_test_01
RESTART_CONTAINER=process_down_test_02
COUNT=100

# check ps output.
PS_1="httpd -DNO_DETACH"

function docker_top_check {
    docker top $1 2>&1 > $1.top
    PS_1_exist=`grep --count "${PS_1}" $1.top`
    echo "$1 ${PS_1}:${PS_1_exist}"

    if [ ${PS_1_exist} -eq 0 ]; then
        echo "exit"
        exit -1
    fi
}

for i in `seq $COUNT`
do
    date
    echo "COUNT:$i"
    echo "docker stop $RESTART_CONTAINER"
          docker stop $RESTART_CONTAINER
    echo "docker_top_check $TARGET_CONTAINER"
          docker_top_check $TARGET_CONTAINER
    echo "docker start $RESTART_CONTAINER"
          docker start $RESTART_CONTAINER
    sleep 10s
done
