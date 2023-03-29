#!/usr/bin/env bash

### STATS DECLARATION ###

TOTAL_TESTS=0
SUCCESS_TESTS=0
TEST_ID=$1

### CHECK FUNCTION ###

compare ()
{
    if [ "$1" = "$2" ] && [ "$3" = "$4" ]; then
        printf "%d -\t\033[1;32m[SUCCESS]\033[0m (%s)\n" $TOTAL_TESTS "$5"
        if [ $TEST_ID ]
        then
            printf "\t\033[1;29m./mysh output: \n\033[0m"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29m%s\n\033[0m" "$1"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29m./mysh return value %s\n\n\033[0m" "$3"
            printf "\t\033[1;29mTcsh output:\n\033[0m"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29m%s\n\033[0m" "$2"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29mTcsh return value %s \n\n\033[0m" "$4"
        fi
        SUCCESS_TESTS=$((SUCCESS_TESTS+1))
    else
        printf "%d -\t\033[1;31m[FAIL]\033[0m  \033[4;31m(%s)\n\033[0m" $TOTAL_TESTS "$5"
        printf "\t\033[1;29m./mysh output: \n\033[0m"
        printf "\t\033[1;29m-----------------------\n\033[0m"
        printf "\t\033[1;29m%s\n\033[0m" "$1"
        printf "\t\033[1;29m-----------------------\n\033[0m"
        printf "\t\033[1;29m./mysh return value %s\n\n\033[0m" "$3"
        printf "\t\033[1;29mTcsh output:\n\033[0m"
        printf "\t\033[1;29m-----------------------\n\033[0m"
        printf "\t\033[1;29m%s\n\033[0m" "$2"
        printf "\t\033[1;29m-----------------------\n\033[0m"
        printf "\t\033[1;29mTcsh return value %s \n\n\033[0m" "$4"
    fi
    TOTAL_TESTS=$((TOTAL_TESTS+1))
}

execute ()
{
    if [ $TEST_ID ]
    then
        if [ $TEST_ID -ne $TOTAL_TESTS ]
        then
            TOTAL_TESTS=$((TOTAL_TESTS+1))
            return
        fi
    fi
    rm -rf /tmp/mysh
    mkdir /tmp/mysh

    MYSH=$(echo "$1"| ./mysh 2>&1)
    RET_MYSH=$(echo $?)

    rm -rf /tmp/mysh
    mkdir /tmp/mysh

    if [ "$2" = "1" ]; then
        TCSH=$(echo "$1" | env -i tcsh 2>&1)
    else
        TCSH=$(echo "$1" | tcsh 2>&1)
    fi
    RET_TCSH=$(echo $?)


    compare "$MYSH" "$TCSH" "$RET_MYSH" "$RET_TCSH" "$1"
}

printf "\033[1;36m----- MINISHELL FUNCTIONAL TESTS -----\033[0m\n\n"

## CHECK IF BINARY EXISTS ##

if [ ! -f mysh ]; then
    printf "\033[1;31m[ERROR]\033[0m mysh binary not found\n"
    printf "\033[1;33mPlease compile your project before running this script with make\033[0m\n\n"
    printf "\033[1;36m----- MINISHELL FUNCTIONAL TESTS -----\033[0m\n\n"
    exit 1
fi


### BASICS TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL BASICS TESTS -----\033[0m\n\n"
fi

execute "" "0"
execute "a" "0"
execute "./" "0"
execute "../" "0"
execute "." "0"
execute ".." "0"
execute "ls -l" "0"
execute "exit" "0"
execute "cd ; pwd" "0"
execute "cat toto" "0"
execute "exitt" "0"
execute ".gitignore" "0"
execute "rjzjrjz ppekn" "0"
execute "touch /tmp/mysh/test.sh ; /tmp/mysh/test.sh" "1"

### SPACES AND TABS TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL SPACES AND TABS TESTS -----\033[0m\n\n"
fi

#only spaces
execute "    " "0"
execute "     ls             -l      -all     " "0"
#only tabs
execute "\tls\t-l\t-all\t" "0"
#tabs and spaces
execute "\tls      \t   -l  \t-all      \t   " "0"

### CD TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL CD TESTS -----\033[0m\n\n"
fi

execute "cd / ; pwd" "0"
execute "cd toto tata" "0"
execute "cd fail_dir" "0"
execute "unsetenv OLDPWD ; cd -" "1"

### ENV TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL ENV TESTS -----\033[0m\n\n"
fi

execute "setenv _toto tata" "0"
execute "setenv 8toto tata" "0"
execute "setenv toto tata titi" "0"
execute "setenv toto= tata" "0"
execute "setenv toto9 tata" "0"
execute "setenv Toto9" "0"
execute "setenv Toto" "0"
execute "setenv Abc Abc" "0"
execute "setenv Zbc Zbc" "0"
execute "setenv abc abc" "0"
execute "setenv zbc Zbc" "0"
execute "unsetenv" "0"
execute "unsetenv tototototototo" "0"
execute "unsetenv PATH" "0"
execute "unsetenv PATH HOME OLDPWD PWD LESS" "0"

### EXIT TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL EXIT TESTS -----\033[0m\n\n"
fi

#basics
execute "exit 0" "0"
execute "exit 1" "0"
execute "exit -1" "0"
execute "exit 999999" "0"
execute "exit -999999" "0"
execute "exit -abc" "0"
execute "exit abc" "0"
execute "exit -18abc" "0"

#advance
execute "exit 12; ls" "0"
execute "exit 12; exit 123" "0"
execute "exit 12; exit -a123" "0"
execute "exit -" "0"

### WITHOUT PATH TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL WITHOUT PATH TESTS -----\033[0m\n\n"
fi

execute "unsetenv PATH ; /bin/ls /" "1"
execute "unsetenv HOME ; cd" "1"

### PERMISSIONS AND EXECUTION TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL PERMISSIONS AND EXECUTION TESTS -----\033[0m\n\n"
fi

execute "./mysh" "0"
execute "../bin/ls" "0"
execute "./bin/ls" "0"
execute "/bin/ls" "0"
execute "./lib" "0"

### SEMICOLON TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL SEMICOLON TESTS -----\033[0m\n\n"
fi

execute ";" "1"
execute "ls ; ls ; ls ; ls ; ls ; ls ; ls" "0"
execute "ls;ls;ls;ls;ls;ls;ls" "0"
execute "ls;exit 34;ls" "0"

### PIPE TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL PIPE TESTS -----\033[0m\n\n"
fi

execute "|" "1"
execute "ls|ls" "0"
execute "ls -l | grep lib | cat -e" "0"
execute "ls / | wc -l | cat -e" "0"
execute "ls / | cat -e | cat -e | cat -e | cat -e | cat -e" "0"
execute "ls / | cat -e | cat -e" "0"
execute "ls /|cat -e|cat -e" "0"
execute "| ls | cat -e" "1"
execute "ls | | cat -e" "1"
execute "ls | sort -r | cut -b 1-1 | cat"

#with builtin (cd, exit, setenv, unsetenv, exit)
execute "ls | cd ; ls" "0"

### REDIRECTION TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL REDIRECTION TESTS -----\033[0m\n\n"
fi

execute "cat < >" "1"
execute "cat <" "1"
execute "cat >" "1"
execute "cat < > /tmp/mysh/hoho" "1"
execute "cat < /tmp/mysh/yoyo" "1"
execute "cat > /tmp/mysh/momo" "1"
execute "cat > /tmp/mysh/yuyu > /tmp/mysh/tata < /tmp/mysh/yuyu" "1"
execute "cat > /tmp/mysh/yuyu > /tmp/mysh/tata < /tmp/mysh/yuyu ; cat < /tmp/mysh/yuyu" "1"


## OUTPUT
# Simple
execute "ls -l > /tmp/mysh/toto ; cat /tmp/mysh/toto" "0"

# Double
execute "ls -l > /tmp/mysh/titi ; ls >> /tmp/mysh/titi ; cat /tmp/mysh/titi ; rm /tmp/mysh/titi" "0"
execute "ls -l >> /tmp/mysh/kuku ; cat /tmp/mysh/kuku ; rm /tmp/mysh/kuku" "0"

## INPUT
# Simple
execute "ls -l > /tmp/mysh/mama ; sort -r < /tmp/mysh/mama" "0"

### REDIRECTION && PIPE TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL REDIRECTION && PIPE TESTS -----\033[0m\n\n"
fi

## OUTPUT
# Simple
execute "ls -l > /tmp/mysh/papa ; cat /tmp/mysh/papa | grep lib" "0"
execute "ls -l > /tmp/mysh/lala ; cat /tmp/mysh/lala | grep lib | cat -e" "0"

# Double
execute "ls -l > /tmp/mysh/dada ; ls >> /tmp/mysh/dada ; cat /tmp/mysh/dada | grep lib ; rm /tmp/mysh/dada" "0"

## INPUT
# Simple
execute "ls -l > /tmp/mysh/fafa ; sort -r < /tmp/mysh/fafa | grep lib" "0"
execute "ls -l > /tmp/mysh/gaga ; sort -r < /tmp/mysh/gaga | grep lib | cat -e" "0"

### ECHO TESTS ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL ECHO TESTS -----\033[0m\n\n"
fi

execute "Echo" "0"
execute "ECHO" "0"
execute "echo" "0"
execute "echo " "0"
execute "echo hello" "0"
execute "echo hello world" "0"
execute "echo hello       world" "0"
execute "echo     hello world" "0"
execute "echo hello world    " "0"
execute "echo a '' b '' c '' d" "0"
execute "echo -nhello world" "0"
execute "echo a	hello -nhello world" "0"
execute "echo \"hello world\"" "0"
execute "echo 'hello world'" "0"
execute "echo 'hello world' 'hello world'" "0"


### OTHER TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- OTHER TESTS -----\033[0m\n\n"
fi

execute ";|" "1"
execute ";>>|><" "1"
execute "\0" "0"
execute "unsetenv PATH; setenv PATH /bin/ ; ls /" "0"
execute "./ls" "0"
execute "sleep 0.1" "0"

### TESTS TA ###

execute "cat -e main_map.json | grep o" "0"


### RESULT TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;34m----- MINISHELL RESULT TESTS -----\033[0m\n"

    printf "\n\033[1;34mSuccess: %d/%d\n\033[0m" $SUCCESS_TESTS $TOTAL_TESTS
    printf "\033[1;34mFailed: %d/%d\033[0m\n\n" $((TOTAL_TESTS-SUCCESS_TESTS)) $TOTAL_TESTS

fi
printf "\033[1;36m----- MINISHELL FUNCTIONAL TESTS -----\033[0m\n\n"

