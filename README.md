# shtop — Shell Top for Linux
NOTE: This is the Linux twin of [ptop](https://github.com/stavrostzagadouris/powershellTop), which Gemini Argon made for me. Claude ported it to Linux. Feel free to use it if you want.

A fast, flicker-free, **zero-root** `btop`-style Terminal UI (TUI) system and GPU monitor for Linux, written as a single standalone Python 3 script with **no dependencies** beyond the standard library.

It has the same layout, themes and keys as `ptop`. Under the hood it reads `/proc` and `/sys` directly, so no daemons, kernel modules or `sudo` are needed.

---

## ✨ Features

* **Zero root, zero dependencies:** Python 3.7+ standard library only. Works over SSH, in WSL, and on locked-down boxes.
* **NVIDIA GPU telemetry (via `nvidia-smi`):**
  * Live **GPU Core %** meter + history sparkline
  * **VRAM** usage, **Power Draw** (`W / Cap W`), **Temperature**, **Fan %**, **Graphics & Memory Clocks**, **Memory Controller %**, and **P-State**
  * **Per-process GPU activity** from `nvidia-smi pmon`
* **AMD GPUs (amdgpu sysfs, no tools needed):** GPU %, VRAM, power + cap, temperature, fan, core/memory clocks, and memory controller %
* **Intel / other DRM GPUs:** GPU % and core clock. VRAM shows as shared memory.
* **Per-process GPU activity for AMD/Intel:** read from the kernel's DRM client stats in `/proc/<pid>/fdinfo`. You can see your own processes without root.
* **CPU & RAM:** overall + **per-core grid** (`P`) from `/proc/stat`, RAM and swap from `/proc/meminfo`
* **Disks & network:** capacity bars per real mount with live **Read/Write** throughput (`/proc/diskstats`), plus **Download/Upload** rates and totals for physical NICs (`/proc/net/dev`). Bridges, Docker veths and VPN tunnels aren't double-counted.
* **Battery (laptops):** charge % plus charging status or time remaining in the header, hidden on desktops
* **Interactive process manager:** sort by CPU / memory / GPU, filter with `/`, select with `↑`/`↓`, and kill with `K`. The highlight stays on the process you picked while the list re-sorts, so you can't kill the wrong one.
* **5 TrueColor themes:** Midnight, Cyberpunk, Matrix, Gruvbox, Nord
* **Flicker-free:** alternate screen buffer and single-write frames. Redraws instantly on a key press or terminal resize.

---

## 🖥️ Interface Layout

```
 shtop │ thirteen600 │ Up: 2d 08h 55m │ 1000ms   [P]Cores [T]heme [C/M/G]Sort [↑↓/K]Kill [Q]uit │ 15:30:00
╭─ CPU (13th Gen Intel(R) Core(TM) i5-13600KF) ───────╮╭─ GPU (NVIDIA GeForce RTX 3080 [P5]) ────────────────╮
│ CPU Total  ████████░░░░░░░░░░░░░░░░░░░░░  26.4%     ││ GPU Core   ██████████████░░░░░░░░░░░  61.0%         │
│ History    ▁▂▃▄▃▂▁▂▃▅▆▄▃▂▁▂▃▄▃▂▁▂▃▄▅▄▃▂▁▂▃▄▃▂▁▂▃    ││ History    ▁▁▂▄▆▇▆▅▄▅▆▇█▇▆▅▄▅▆▆▅▄▃▄▅▆▅▄▅▆▅▄▃▄▅▆    │
│ RAM        ███████████░░░░░░░░░░░░░░░░░░ 14.2/31.2G ││ VRAM       ██████████░░░░░░░░░░░  4.8/10.0G (48%)   │
│ Swap       ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  0.0/4.0G  ││ Power      ████████████████░░░░░ 245.0/340W         │
│ Cores: 20 ([P] Per-Core)   Procs: 312               ││ Temp: 64°C  Fan: 58%  Clocks: 1950/9501MHz  MemC… │
├─ Disks ─────────────────────────────────────────────┤├─ Network ───────────────────────────────────────────┤
│ /     ████████░░░░  412/931G  44% R 1.2M/s W 640K/s ││ ▼ Download 12.45 MB/s     Total RX: 48.21 GB        │
│ /home █████░░░░░░░  301/931G  32% R   0K/s W  12K/s ││ ▲ Upload   420.5 KB/s     Total TX: 6.14 GB         │
╰─────────────────────────────────────────────────────╯╰─────────────────────────────────────────────────────╯
╭─ Processes (Sort: CPU │ [/]Filter │ GPU Apps: 4 │ Theme: Midnight) ────────────────────────────────────────╮
│     PID  PROCESS NAME                                        CPU %   MEM (MB)   MEM %  GPU STATUS          │
│    4828  firefox                                              4.2%     884.2M    2.8%  ● RTX 3080 (Active) │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

---

## 🚀 Quick Start

```bash
git clone https://github.com/stavrostzagadouris/shelltop.git
cd shelltop
./shtop
```

### Put it on your PATH (optional)
```bash
mkdir -p ~/.local/bin
ln -s "$PWD/shtop" ~/.local/bin/shtop
shtop
```
(`~/.local/bin` is on `PATH` by default on most distros. A symlink means a `git pull` updates it.)

---

## ⌨️ Keyboard Controls

| Key | Action |
| :--- | :--- |
| **`C`** | Sort processes by **CPU %** |
| **`M`** | Sort processes by **Memory Usage** |
| **`G`** | Sort **Active GPU processes** to the top |
| **`P`** | Toggle **Per-Core CPU Utilization** grid |
| **`T`** | Cycle **Color Themes** (*Midnight → Cyberpunk → Matrix → Gruvbox → Nord*) |
| **`↑` / `↓`** | Move process selection highlight up / down |
| **`K` / `Del`** | Send **SIGTERM** to the highlighted process. Press again within 3s to **SIGKILL** it |
| **`/`** | Filter processes by name or PID (`Enter` keeps the filter, `Esc` clears it) |
| **`+` / `-`** | Speed up / slow down the refresh interval (`250ms` – `5000ms`) |
| **`Q` / `Esc` / `Ctrl+C`** | Quit and restore the terminal (`Esc` clears an active filter first) |

---

## ⚙️ Command-Line Options

```bash
shtop -r 500            # refresh every 500 ms (alias: --refresh-ms)
shtop -t gruvbox        # start with a different theme (alias: --theme)
```

---

## 🧠 How It Works Without Root

1. **CPU:** `/proc/stat` jiffy deltas, overall and per core. The CPU name comes from `/proc/cpuinfo`.
2. **Memory:** `/proc/meminfo` (`MemAvailable`, `SwapTotal`/`SwapFree`).
3. **GPU:**
   * **NVIDIA:** `nvidia-smi --query-gpu` for the card and `nvidia-smi pmon` for processes.
   * **AMD:** `/sys/class/drm/cardN/device/` (`gpu_busy_percent`, `mem_info_vram_*`, `mem_busy_percent`) plus the card's `hwmon` sensors.
   * **Intel / others:** engine busy time summed from DRM `fdinfo`, with clocks from `gt_act_freq_mhz`.
   * The GPU name comes from the kernel or `pci.ids`.
4. **Processes:** `/proc/<pid>/stat` for CPU ticks, RSS and kernel-thread flag. Kernel threads are hidden, and full names are recovered from `cmdline` when `comm` is truncated.
5. **Disks:** `/proc/mounts` + `statvfs` for capacity (like `df`), and `/proc/diskstats` for throughput. Loop, snap, read-only, tmpfs and `/boot` mounts are skipped.
6. **Network:** `/proc/net/dev`, counting interfaces that have a physical `device` in sysfs.
7. **Battery:** `/sys/class/power_supply/BAT*`.

---

## 🙌 Credits

Original `ptop` design by **Argo** (*Gemini 4 Argon*) in collaboration with **stavros**. Linux port by **Claude**.

## 📄 License

Released under the [MIT License](LICENSE).
