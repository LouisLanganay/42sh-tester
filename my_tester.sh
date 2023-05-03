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
            printf "\t\033[1;29m./42sh output: \n\033[0m"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29m%s\n\033[0m" "$1"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29m./42sh return value %s\n\n\033[0m" "$3"
            printf "\t\033[1;29mTcsh output:\n\033[0m"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29m%s\n\033[0m" "$2"
            printf "\t\033[1;29m-----------------------\n\033[0m"
            printf "\t\033[1;29mTcsh return value %s \n\n\033[0m" "$4"
        fi
        SUCCESS_TESTS=$((SUCCESS_TESTS+1))
    else
        printf "%d -\t\033[1;31m[FAIL]\033[0m  \033[4;31m(%s)\n\033[0m" $TOTAL_TESTS "$5"
        printf "\t\033[1;29m./42sh output: \n\033[0m"
        printf "\t\033[1;29m-----------------------\n\033[0m"
        printf "\t\033[1;29m%s\n\033[0m" "$1"
        printf "\t\033[1;29m-----------------------\n\033[0m"
        printf "\t\033[1;29m./42sh return value %s\n\n\033[0m" "$3"
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
    rm -rf /tmp/42sh
    mkdir /tmp/42sh

    MYSH=$(echo "$1"| ./42sh 2>&1)
    RET_MYSH=$(echo $?)

    rm -rf /tmp/42sh
    mkdir /tmp/42sh

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

if [ ! -f 42sh ]; then
    printf "\033[1;31m[ERROR]\033[0m 42sh binary not found\n"
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
execute "touch /tmp/42sh/test.sh ; /tmp/42sh/test.sh" "1"

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

execute "./42sh" "0"
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
execute "aa ; ls" "0"
execute "ls ; aa ; ls" "0"

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
execute "cat < > /tmp/42sh/hoho" "1"
execute "cat < /tmp/42sh/yoyo" "1"
execute "cat > /tmp/42sh/momo" "1"
execute "cat > /tmp/42sh/yuyu > /tmp/42sh/tata < /tmp/42sh/yuyu" "1"
execute "cat > /tmp/42sh/yuyu > /tmp/42sh/tata < /tmp/42sh/yuyu ; cat < /tmp/42sh/yuyu" "1"


## OUTPUT
# Simple
execute "ls -l > /tmp/42sh/toto ; cat /tmp/42sh/toto" "0"

# Double
execute "ls -l > /tmp/42sh/titi ; ls >> /tmp/42sh/titi ; cat /tmp/42sh/titi ; rm /tmp/42sh/titi" "0"
execute "ls -l >> /tmp/42sh/kuku ; cat /tmp/42sh/kuku ; rm /tmp/42sh/kuku" "0"

## INPUT
# Simple
execute "ls -l > /tmp/42sh/mama ; sort -r < /tmp/42sh/mama" "0"

### REDIRECTION && PIPE TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL REDIRECTION && PIPE TESTS -----\033[0m\n\n"
fi

## OUTPUT
# Simple
execute "ls -l > /tmp/42sh/papa ; cat /tmp/42sh/papa | grep lib" "0"
execute "ls -l > /tmp/42sh/lala ; cat /tmp/42sh/lala | grep lib | cat -e" "0"

# Double
execute "ls -l > /tmp/42sh/dada ; ls >> /tmp/42sh/dada ; cat /tmp/42sh/dada | grep lib ; rm /tmp/42sh/dada" "0"

## INPUT
# Simple
execute "ls -l > /tmp/42sh/fafa ; sort -r < /tmp/42sh/fafa | grep lib" "0"
execute "ls -l > /tmp/42sh/gaga ; sort -r < /tmp/42sh/gaga | grep lib | cat -e" "0"

### ECHO TESTS ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL ECHO TESTS -----\033[0m\n\n"
fi

# Simple
execute "Echo" "0"
execute "ECHO" "0"
execute "echo" "0"
execute "echo " "0"
execute "echo hello" "0"
execute "echo hello world" "0"
execute "echo hello       world" "0"
execute "echo     hello world" "0"
execute "echo hello world    " "0"

# Quotes
execute "echo a '' b '' c '' d" "0"
execute "echo \"hello world\"" "0"
execute "echo 'hello world'" "0"
execute "echo 'hello world' 'hello world'" "0"

# Specials
execute "echo -nhello world" "0"
execute "echo a	hello -nhello world" "0"

# Variables
execute "echo \$HOME" "0"
execute "echo \$AAA" "0"
execute "echo "\$HOME"" "0"

### VARIABLES ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL VARIABLES TESTS -----\033[0m\n\n"
fi

execute "\$PATH" "0"
execute "\$HOME" "0"
execute "\$SHTESTER" "0"

execute "set test = build/ ; ls \$test" "0"
execute "ls \$test" "0"
execute "set test = toto"
execute "set test=build/ ; ls \$test" "0"
execute "set test=build/" "0"
execute "set test = build tata ; ls \$test" "0"

### HISTORY ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL HISTORY TESTS -----\033[0m\n\n"
fi

# Command
execute "history -c" "0"
execute "history -c ; history" "0"
execute "history -c ; ls" "0"
execute "history -c ; ls ; history" "0"

# "!"
execute "ls ; !ls" "0"
execute "ls src ; !l | cat -e" "0"
execute "ls * 10 ; !100000000000000" "0"
execute "!5454" "1"
execute "history -c ; !10000000 | cat -e ; history" "0"

### WHERE / WHICH ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL WHERE / WHICH TESTS -----\033[0m\n\n"
fi

execute "where ls" "0"
execute "where ls toto" "0"
execute "where ./toto" "0"
execute "where 5" "0"
execute "where cd ls" "0"
execute "where" "0"
execute "which ls" "0"
execute "which ls toto" "0"
execute "which ./toto" "0"
execute "which 5" "0"
execute "which cd ls" "0"
execute "which" "0"

### OPERATORS ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL OPERATORS TESTS -----\033[0m\n\n"
fi

# "&&"
execute "ls && ls" "0"
execute "ls && a && ls" "0"

# "||"
execute "ls || ls" "0"
execute "a || a || ls || ls" "0"

### Alias ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL ALIAS TESTS -----\033[0m\n\n"
fi

execute "alias" "0"
execute "alias popo" "0"
execute "alias bliblablou ls ; bliblablou" "0"
execute "alias blabla toto ; blabla" "0"

### BACKTICKS ###
if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- MINISHELL BACKTICKS TESTS -----\033[0m\n\n"
fi

execute "ls \`ls\`" "0"
execute "echo \`echo hello\`" "0"

### OTHER TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;33m----- OTHER TESTS -----\033[0m\n\n"
fi

execute "\$?" "0"
execute ";|" "1"
execute ";>>|><" "1"
execute "\0" "0"
execute "unsetenv PATH; setenv PATH /bin/ ; ls /" "0"
execute "./ls" "0"
execute "sleep 0.1" "0"
execute "ls /etc ; cat /etc/resolv.conf" "0"

### TESTS TA ###

execute "cat -e 42sh-tester/tests/bigfile.json | grep o" "0"


### RESULT TESTS ###

if [ ! $TEST_ID ]
then
    printf "\n\033[1;34m----- MINISHELL RESULT TESTS -----\033[0m\n"

    printf "\n\033[1;34mSuccess: %d/%d\n\033[0m" $SUCCESS_TESTS $TOTAL_TESTS
    printf "\033[1;34mFailed: %d/%d\033[0m\n\n" $((TOTAL_TESTS-SUCCESS_TESTS)) $TOTAL_TESTS

fi
printf "\033[1;36m----- MINISHELL FUNCTIONAL TESTS -----\033[0m\n\n"

