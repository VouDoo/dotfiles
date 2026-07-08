- [Setup `linux`](#setup-linux)
  - [Before you start](#before-you-start)
  - [How to install Arch Linux](#how-to-install-arch-linux)
  - [Bootstrap](#bootstrap)

---

## Before you start

This guide will assist you in setting up your Linux environment based on **Arch Linux** Linux distribution.

> Arch Linux is my distribution of choice for several key reasons:
>
> - Its minimalist approach allows me to customize the system exactly to my needs, without any unnecessary bloat.
> - The rolling release model ensures I always have access to the latest software updates.
> - The documentation is excellent and very helpful.
> - Installing and maintaining Arch is a more hands-on experience than many other distributions.
>
> Learn more about ["The Arch Way"](https://wiki.archlinux.org/title/Arch_terminology#The_Arch_Way) and how it defines the Arch philosophy!

## How to install Arch Linux

### Vanilla Arch Linux

> As we all know, installing Arch Linux can feel like a rite of passage… if that passage involves a maze and a few panic attacks, especially for newbies.
>
> But fear not! With a magical installer, you can now skip the hair-pulling, headache-inducing parts and get straight to the fun stuff!

Follow the **archinstall** documentation to install Arch Linux on your computer: <https://wiki.archlinux.org/title/Archinstall>.

### CachyOS

> If you want the power of Arch but fine-tuned for ultimate performance right out of the box, CachyOS is the way to go.
>
> It uses advanced x86-64-v3/v4 optimized binaries, custom performance kernels, and a gorgeous, user-friendly graphical installer. Think of it as Arch Linux on steroids.

Follow the official installation guide to deploy CachyOS on your hardware: <https://wiki.cachyos.org/>.

## Bootstrap

After a fresh install of Arch Linux, you can kick off the entire installation process with a single command.

This automated script will update your system repositories, bootstrap the AUR helper if missing, pull down your dotfiles configuration via Chezmoi, and install your entire stack of applications completely unattended.

Open a terminal and run the following command to download and execute the script:

```sh
sh <(curl -sSL https://raw.githubusercontent.com/VouDoo/dotfiles/main/setup/linux/rice-my-arch.sh)
```
