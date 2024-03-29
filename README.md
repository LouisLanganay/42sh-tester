<p align="center">
    <img src="https://img.shields.io/badge/Test%20Count-150+-blue"/>
    <img src="https://img.shields.io/github/stars/LouisLanganay/42sh-tester.svg?style=social&label=Star&maxAge=2592000"/>
    <img src="https://img.shields.io/github/downloads/LouisLanganay/42sh-tester/total.svg"/>
</p>

# 42sh tester
With this tester you can test your own shell.
Based on TCSH.

## Requirements ⚠️
- You must `make` your project.
- Your binary must have the name "42sh".

> [!WARNING]
> Use [epitests-docker](https://hub.docker.com/r/epitechcontent/epitest-docker) for a better fialibity of the tester

## Usage
1. Clone this repo in your 42sh repository `git clone git@github.com:LouisLanganay/42sh-tester.git`
2. Run it with `./42sh-tester/my_tester.sh`

**OR**

1. Go to the [last release](https://github.com/LouisLanganay/42sh-tester/releases/latest) and download the `run_tests.sh` file.
2. Put it in the root of your project.
3. Run it with `./run_tests.sh`.

> [!NOTE]
> You can get informations about a specific test using `./run_tests.sh TEST_NBR`

## Features tested
### Commands builtin
- `cd`
- `exit`
- `env`
- `setenv`
- `unsetenv`
- `echo`
- `history`
- `which`
- `where`
- `alias`

### Separators
- `;`
- `|`
- `>`
- `>>`
- `<`

### Operators
- `&&`
- `||`

### Backticks
- `\``
  
> [!NOTE]
> All return values are tested for each tests

## Example
![image](https://user-images.githubusercontent.com/114762819/228669523-c267f9db-482f-4a7e-bbda-314240a4a23b.png)
![image](https://user-images.githubusercontent.com/114762819/228669619-93e74d4d-d492-4add-9a64-5656182e360f.png)
![image](https://user-images.githubusercontent.com/114762819/228669668-ac1f446c-84f2-416b-bf55-4f44614fe42d.png)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=LouisLanganay&repo=Pushswap_checker-tester&theme=dark&border_radius=8&hide_border=true)](https://github.com/LouisLanganay/Pushswap_checker-tester)

## Credits
[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=M4gie&repo=epi-minishell2-tester&theme=dark&border_radius=8&hide_border=true)](https://github.com/M4gie/epi-minishell2-tester)

![Logo](https://newsroom.ionis-group.com/wp-content/uploads/2021/10/EPITECH-TECHNOLOGY-QUADRI-2021.png)

