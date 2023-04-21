# Fetch Repository Asset

This repository provides bash scripts to download github repository release assets using  github api. I use it to deploy my dist to server. You can use it enjoy yourself.

## Note

Bash installed. It means it can only be used on bash supported system by now.

Api version these scripts using is 2022-11-28

Accessbility of your account to the repository you want to download.

Remember to add execute permission using `chmod u+x,g+x SCRIPT_FILE_NAME`.

## Usage

### Get latest release asset

`bash ./get_github_release_latest.sh OWNER REPO_NAME ASSET_NAME YOUR_GITHUB_TOKEN`

You will get asset file if things were ok.

### Get release asset by tag

`bash ./get_github_release_latest.sh OWNER REPO_NAME TAG_NAME ASSET_NAME YOUR_GITHUB_TOKEN`

## Express

This idea comes from this [website](https://w3toppers.com/how-to-download-github-release-from-private-repo-using-command-line/). Thanks for the auther's sharing.
