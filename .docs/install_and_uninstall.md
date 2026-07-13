<!-- https://github.com/Zeronetsec/Oliner -->

# Installation
`install.sh` optional option:
- `--backup`

Use `--backup` to create a backup of the existing Oliner installation before replacing it.

## Termux & Linux (root)
```bash
git clone https://github.com/Zeronetsec/Oliner
cd Oliner
chmod +x install.sh
./install.sh
```

## Linux (user)
```bash
git clone https://github.com/Zeronetsec/Oliner
cd Oliner
chmod +x install.sh
sudo ./install.sh
```

## Uninstallation
```bash
export prefix="${PREFIX:-/usr}"
rm -f "${prefix}/bin/oliner"
rm -rf "${prefix}/opt/oliner"
```

<!-- Copyright (c) 2026 Zeronetsec -->