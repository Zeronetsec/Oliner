<!-- https://github.com/Zeronetsec/Oliner -->

<div align="center">
    <img src="https://img.shields.io/badge/Oliner-Version%200.1-blue.svg?style=square&logo=dart&logoColor=green" />
    <img src="https://img.shields.io/badge/Supported%20OS-Linux-blue.svg?style=square&logo=linux" />
    <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=square&logo=github" />
</div>

# Oliner
Oliner is a lightweight CLI utility to store, organize, and access one-liner codes and links.

## Features
- Store, categorize, and modify files or entries.
- Copy keys to clipboard or open links with custom commands.
- Search text globally and scan or auto-remove duplicate lines.
- Import and export categories via zip archives.
- And more features.

## Disclaimer
Please read [.docs/disclaimer.md](.docs/disclaimer.md) before using this tool. </br>
Use this software at your own risk. </br>
The author is not responsible for any damage, data loss, or issues that may result from its use.

## Installation
Quick install:
```bash
git clone https://github.com/Zeronetsec/Oliner
cd Oliner
chmod +x install.sh
./install.sh
```
For more detailed installation and uninstallation instructions, see [.docs/install_and_uninstall.md](.docs/install_and_uninstall.md).

## Usage Example
```bash
oliner --list
oliner --add myoneliner/code "GitHub: code(https://github.com/Zeronetsec).msg(my github profile)"
oliner --copy myoneliner/code GitHub --with 'xclip -selection {}'
oliner --search github
oliner --export myoneliner
```
And more commands.

## License
This project is licensed under the MIT License.

<!-- Copyright (c) 2026 Zeronetsec -->