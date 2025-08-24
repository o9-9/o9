# o9 Windows Utility

[![Version](https://img.shields.io/github/v/release/o9-9/o9?color=%230567ff&label=Latest%20Release&style=for-the-badge)](https://github.com/o9-9/o9/releases/latest)
![GitHub Downloads (specific asset, all releases)](https://img.shields.io/github/downloads/o9-9/o9/o9.ps1?label=Total%20Downloads&style=for-the-badge)
[![](https://dcbadge.limes.pink/api/server/https://discord.com/users/1146203933811953713?theme=default-inverted&style=for-the-badge)](https://discord.com/users/1146203933811953713)
[![Static Badge](https://img.shields.io/badge/Documentation-_?style=for-the-badge&logo=bookstack&color=grey)](https://docs.o9ll.com/)

This utility is a compilation of Windows tasks I perform on each Windows system I use. It is meant to streamline *installs*, debloat with *tweaks*, troubleshoot with *config*, and fix Windows *updates*. I am extremely picky about any contributions to keep this project clean and efficient.

![screen-install](https://raw.githubusercontent.com/o9-9/o9-docs/refs/heads/main/assets/images/Title-Screen.png)

## 💡 Usage

o9 must be run in Admin mode because it performs system-wide tweaks. To achieve this, run PowerShell as an administrator. Here are a few ways to do it:

1. **Start menu Method:**
   - Right-click on the start menu.
   - Choose "Windows PowerShell (Admin)" (for Windows 10) or "Terminal (Admin)" (for Windows 11).

2. **Search and Launch Method:**
   - Press the Windows key.
   - Type "PowerShell" or "Terminal" (for Windows 11).
   - Press `Ctrl + Shift + Enter` or Right-click and choose "Run as administrator" to launch it with administrator privileges.

### Launch Command

#### Stable Branch (Recommended)

```ps1
irm "https://o9ll.com/o9" | iex
```
#### Dev Branch

```ps1
irm "https://o9ll.com/o99" | iex
```

If you have Issues, refer to [Known Issues](https://docs.o9ll.com/knownissues/)

## 🎓 Documentation

> [!NOTE]
> To contribute to the documentation, please visit [o9 Docs Repo](https://github.com/o9-9/o9-docs) for more info.

### [o9 Official Documentation](https://docs.o9ll.com/)

## 🛠️ Build & Develop

> [!NOTE]
> o9 is a relatively large script, so it's split into multiple files which're combined into a single `.ps1` file using a custom compiler. This makes maintaining the project a lot easier.

Get a copy of the source code, this can be done using GitHub UI (`Code -> Download ZIP`), or by cloning (downloading) the repo using git.

If git is installed, run the following commands under a PowerShell window to clone and move into project's directory:
```ps1
git clone --depth 1 "https://github.com/o9-9/o9.git"
cd o9
```

To build the project, run the Compile Script under a PowerShell window (admin permissions IS NOT required):
```ps1
.\Compile.ps1
```

You'll see a new file named `o9.ps1`, which's created by `Compile.ps1` script, now you can run it as admin and a new window will popup, enjoy your own compiled version of o9 :)

> [!TIP]
> For more info on using o9 and how to develop for it, please consider reading [the Contribution Guidelines](https://docs.o9ll.com/contributing/), if you don't know where to start, or have questions, you can ask over on [Discord](https://discord.com/users/1146203933811953713).

## 🏅 Thanks to all Contributors
Thanks a lot for spending your time helping o9 grow. Thanks a lot! Keep rocking 🍻.

[![Contributors](https://contrib.rocks/image?repo=o9-9/o9)](https://github.com/o9-9/o9/graphs/contributors)

## 📊 GitHub Stats

![Alt](https://repobeats.axiom.co/api/embed/aad37eec9114c507f109d34ff8d38a59adc9503f.svg "Repobeats analytics image")
