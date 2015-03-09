#lec 3 SPOC Discussion

## 第三讲 启动、中断、异常和系统调用-思考题

## 3.1 BIOS
 1. 比较UEFI和BIOS的区别。
UEFI功能上是为了达到一致操作系统的启动服务。UEFI和BIOS有以下区别　　首先，UEFI已具备文件系统的支持，它能够直接读取FAT分区中的文件。什么是文件系统？简单说，文件系统是操作系统组织管理文件的一种方法，直白点说就是把硬盘上的数据以文件的形式呈现给用户。Fat32、NTFS都是常见的文件系统类型。　　其次，可开发出直接在UEFI下运行的应用程序，这类程序文件通常以efi结尾。既然UEFI可以直接识别FAT分区中的文件，又有可直接在其中运行的应用程序。那么完全可以将Windows安装程序做成efi类型应用程序，然后把它放到任意fat分区中直接运行即可，如此一来安装Windows操作系统这件过去看上去稍微有点复杂的事情突然就变非常简单了，就像在Windows下打开QQ一样简单。而事实上，也就是这么一回事。　　最后，要知道这些都是BIOS做不到的。因为BIOS下启动操作系统之前，必须从硬盘上指定扇区读取系统启动代码（包含在主引导记录中），然后从活动分区中引导启动操作系统。对扇区的操作远比不上对分区中文件的操作更直观更简单，所以在BIOS下引导安装Windows操作系统，我们不得不使用一些工具对设备进行配置以达到启动要求。而在UEFI下，这些统统都不需要，不再需要主引导记录，不再需要活动分区，不需要任何工具，只要复制安装文件到一个FAT32（主）分区/U盘中，然后从这个分区/U盘启动，安装Windows就是这么简单。后面会有专门的文章来详细介绍UEFI下安装Windows7、8的方法。

 1. 描述PXE的大致启动流程。
 客户端个人电脑开机后， 在 TCP/IP Bootrom 获得控制权之前先做自我测试。
 Bootprom 送出 BOOTP/DHCP 要求以取得 IP。
 如果服务器收到个人电脑所送出的要求， 就会送回 BOOTP/DHCP 回应，内容包括客户端的 IP 地址， 预设网关， 及开机映像文件。否则，服务器会忽略这个要求。 Bootprom 由 TFTP 通讯协议从服务器下载开机映像文件。 个人电脑通过这个开机映像文件开机， 这个开机文件可以只是单纯的开机程式也可以是操作系统。 开机映像文件将包含 kernel loader 及压缩过的 kernel，此 kernel 将支持NTFS root系统。 远程客户端根据下载的文件启动机器。
## 3.2 系统启动流程
 1. 了解NTLDR的启动流程。
1)电源自检程序开始运行2)主引导记录被装入内存，并且程序开始执行3)活动分区的引导扇区被装入内存4)NTLDR从引导扇区被装入并初始化5)将处理器的实模式改为32位平滑内存模式6)NTLDR开始运行适当的小文件系统驱动程序。小文件系统驱动程序是建立在NTLDR内部的，它能读FAT或NTFS。7)NTLDR读boot.ini文件8)NTLDR装载所选操作系统如果windows NT/windows 2000/windows XP/windows server 2003这些操作系统被选择，NTLDR运行Ntdetect。对于其他的操作系统，NTLDR装载并运行Bootsect.dos然后向它传递控制。windows NT过程结束。9)Ntdetect搜索计算机硬件并将列表传送给NTLDR，以便将这些信息写进\\HKE Y_LOCAL_MACHINE\HARDWARE中。10)然后NTLDR装载Ntoskrnl.exe，Hal.dll和系统信息集合。11)Ntldr搜索系统信息集合，并装载设备驱动配置以便设备在启动时开始工作12)Ntldr把控制权交给Ntoskrnl.exe，这时,启动程序结束,装载阶段开始

 1. 了解GRUB的启动流程。
装载stage1装载stage1.5装载stage2读取/boot/grub.conf文件并显示启动菜单；装载所选的kernel和initrd文件到内存中

 1. 比较NTLDR和GRUB的功能有差异。

 1. 了解u-boot的功能。
U-Boot，全称 Universal Boot Loader，是遵循GPL条款的开放源码项目系统引导支持NFS挂载、RAMDISK(压缩或非压缩)形式的根文件系统；支持NFS挂载、从FLASH中引导压缩或非压缩系统内核；基本辅助功能强大的操作系统接口功能；可灵活设置、传递多个关键参数给操作系统，适合系统在不同开发阶段的调试要求与产品发布，尤以Linux支持最为强劲；支持目标板环境参数多种存储方式，如FLASH、NVRAM、EEPROM；CRC32校验可校验FLASH中内核、RAMDISK镜像文件是否完好；设备驱动串口、SDRAM、FLASH、以太网、LCD、NVRAM、EEPROM、键盘、USB、PCMCIA、PCI、RTC等驱动支持；上电自检功能SDRAM、FLASH大小自动检测；SDRAM故障检测；CPU型号；特殊功能XIP内核引导；

## 3.3 中断、异常和系统调用比较
 1. 举例说明Linux中有哪些中断，哪些异常？
中断：可屏蔽和不可屏蔽中断.键盘中断，打印机中断等。异常：主要分为故障（fault如缺页异常处理程序）、陷阱（Trap执行没有必要重新执行已终止的指令）、异常终止（用于报告严重的错误）、编程异常（Abort在编程者发出请求是发生。是由int 或(int3)指令时触）、高级可编程中断控制器（Advanced Programmable Interrupt Controller APIC ）。

 1. Linux的系统调用有哪些？大致的功能分类有哪些？  (w2l1)
在Linux2.4.4版本的内核中，狭义的系统调用有221个，可以在<内核源代码目录>中找到原本。但随着内核的更新系统调用的数量也在不断更新 系统调用主要分为以下几类：
1.控制硬件——系统调用往往作为硬件资源和用户空间的抽象接口，比如读写文件时用到的write/read调用。
2.设置系统状态或读取内核数据——因为系统调用是用户空间和内核的唯一通讯手段，所以用户设置系统状态，比如开/关某项内核服务（设置某个内核变量），或读取内核数据都必须通过系统调用。比如getpgid、getpriority、setpriority、sethostname
3.进程管理——一系统调用接口是用来保证系统中进程能以多任务在虚拟内存环境下得以运行。比如 fork、clone、execve、exit等
具体细节包括:
进程控制（fork 创建一个新进程；clone 按指定条件创建子进程等）
文件操作（fcntl 文件控制； open 打开文件）
文件系统操作（access 确定文件的可存取性；chdir 改变当前工作目录）
系统控制（ioctl I/O总控制函数；_sysctl 读/写系统参数）
内存管理（brk 改变数据段空间的分配；mlock 内存页面加锁）
网络管理(getdomainname 取域名;setdomainname 设置域名)
用户管理(getuid 获取用户标识号;setuid 设置用户标志号)

 
 1. 以ucore lab8的answer为例，uCore的系统调用有哪些？大致的功能分类有哪些？(w2l1)
一共有22个
（sys_exit;sys_fork;sys_wait;sys_exec;sys_yield[进程主动让出处理器];sys_kill;sys_getpid[得到进程编号];
sys_putc;sys_pgdir;sys_gettime;sys_lab6_set_priority;sys_sleep;sys_open;sys_close;sys_read;
sys_write;sys_seek;sys_fstat;sys_fsync;sys_getcwd;sys_getdirentry;
sys_dup[“复制”一个打开的文件号，使两个文件号都指向同一个文件];)
大致的功能分类有，文件操作(sys_open;sys_close;sys_read;等),文件系统操作(sys_getdirentry等),进程管理（sys_fork;sys_kill;等） 

 
## 3.4 linux系统调用分析
 1. 通过分析[lab1_ex0](https://github.com/chyyuu/ucore_lab/blob/master/related_info/lab1/lab1-ex0.md)了解Linux应用的系统调用编写和含义。(w2l1)
先说明lab1_ex0.s.include "defines.h".datahello:    .string "hello world\n".globl    mainmain:    movl    $SYS_write,%eax    movl    $STDOUT,%ebx    movl    $hello,%ecx    movl    $12,%edx    int    $0x80    ret可以看到有SYS_write写文件，STDOUT标准输出两个系统调用。然后用int80系统调用（内核态和用户态之间的切换）。程序主要功能是输出hello worldobjdump是Linux下的反汇编目标文件或者可执行文件的命令，当然还有其他作用，如显示头文件信息，反汇编需要执行指令的那些section，显示test的Section Header信息等等。使用objdump –S lab1_ex0.exe 结果下最下页。
nm显示关于对象文件、可执行文件以及对象文件库里的符号信息结果节选：0000000000000001 a STDOUT0000000000000006 a SYS_close000000000000003f a SYS_dup2000000000000000b a SYS_execve0000000000000001 a SYS_exit0000000000000002 a SYS_fork0000000000000013 a SYS_lseek000000000000005a a SYS_mmap000000000000005b a SYS_munmap0000000000000005 a SYS_open0000000000000066 a SYS_socketcall0000000000000005 a SYS_socketcall_accept0000000000000002 a SYS_socketcall_bind0000000000000004 a SYS_socketcall_listen0000000000000001 a SYS_socketcall_socket0000000000000004 a SYS_write可以看到a的都为系统调用，下面进行说明SYS_close 关闭文件；复制一个打开文件号，是两个文件号都能指向同一个文件；SYS_execve执行可执行文件的函数；SYS_exit终止函数；SYS_fork创新进程；SYS_lseek显式地定位一个打开文件；SYS_mmap内核跟踪；SYS_socketcall（跟socket创建等等有关）FileELF 64-bit LSB  executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.24, BuildID[sha1]=1d6484d65fc385b545ae121918d39cb8dec0ff52, not stripped说明这是64位的可执行文件，为x86汇编，动态连接。 
 1. 通过调试[lab1_ex1](https://github.com/chyyuu/ucore_lab/blob/master/related_info/lab1/lab1-ex1.md)了解Linux应用的系统调用执行过程。(w2l1)
strace 命令是一种强大的工具，它能够显示所有由用户空间程序发出的系统调用。
最终输出结果如下：
得到不同系统调用的时间：
% time seconds usecs/call calls errors syscall

30.54 0.000102 26 4 mprotect [ 设置内存映像保护 ]
23.05 0.000077 10 8 mmap [ 将一个文件或者其它对象映射进内存 ]
14.37 0.000048 48 1 write
8.98 0.000030 15 2 open
8.68 0.000029 29 1 munmap [ 解除内存映射 ]
8.38 0.000028 9 3 3 access [ 检查调用进程是否可以对指定的文件执行某种操作 ]
2.10 0.000007 2 3 fstat [ 由文件描述词取得文件状态 ]
1.20 0.000004 4 1 read
0.90 0.000003 2 2 close
0.90 0.000003 3 1 execve
0.60 0.000002 2 1 brk [ 实现虚拟内存到内存的映射 ]
0.30 0.000001 1 1 arch_prctl [ 设置架构特定的线程状态 ]

100.00 0.000334 28 3 total
具体系统调用执行流程为：
execve("./lab1-ex1.exe", ["./lab1-ex1.exe"], [/* 73 vars */]) = 0
brk(0) = 0x11bc000
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff6185c5000
access("/etc/ld.so.preload", R_OK) = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=93381, ...}) = 0
mmap(NULL, 93381, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7ff6185ae000
close(3) = 0
access("/etc/ld.so.nohwcap", F_OK) = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\37\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1845024, ...}) = 0
mmap(NULL, 3953344, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7ff617fdf000
mprotect(0x7ff61819a000, 2097152, PROT_NONE) = 0
mmap(0x7ff61839a000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1bb000) = 0x7ff61839a000
mmap(0x7ff6183a0000, 17088, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7ff6183a0000
close(3) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff6185ad000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff6185ab000
arch_prctl(ARCH_SET_FS, 0x7ff6185ab740) = 0
mprotect(0x7ff61839a000, 16384, PROT_READ) = 0
mprotect(0x600000, 4096, PROT_READ) = 0
mprotect(0x7ff6185c7000, 4096, PROT_READ) = 0
munmap(0x7ff6185ae000, 93381) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7ff6185c4000
write(1, "hello world\n", 12hello world) = 12
exit_group(12) = ?

首先进行虚拟内存到内存的映射，然后判断ld.so.nohwcap与ld.so.preload两个文件是否可以使用。判断之后将文件映射到内存，并设置内存映像保护。然后设置架构特定的线程状态。最终调用write的函数，向屏幕输出制定的字符串。


 
## 3.5 ucore系统调用分析
 1. ucore的系统调用中参数传递代码分析。
 1. ucore的系统调用中返回结果的传递代码分析。
 1. 以ucore lab8的answer为例，分析ucore 应用的系统调用编写和含义。
 1. 以ucore lab8的answer为例，尝试修改并运行代码，分析ucore应用的系统调用执行过程。
 
## 3.6 请分析函数调用和系统调用的区别
 1. 请从代码编写和执行过程来说明。
   1. 说明`int`、`iret`、`call`和`ret`的指令准确功能
 
