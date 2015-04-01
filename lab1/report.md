report lab1
Yuan Yuan
2012011294

#### 练习1：理解通过make生成执行文件的过程。（要求在报告中写出对下述问题的回答）

列出本实验各练习中对应的OS原理的知识点，并说明本实验中的实现部分如何对应和体现了原理中的基本概念和关键知识点。
 
在此练习中，大家需要通过静态分析代码来了解：

1. 操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
```
搜索ucore.img 可以找到makefile中有如下一段话
\------------------------------------------------
\# create ucore.img
UCOREIMG	:= $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img)
\------------------------------------------------

$(UCOREIMG): $(kernel) $(bootblock)
这句意味着需要先生成kernel和bootblock

关于kernel有如下代码
make "V="
有
ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o
可以看到调用了一系列的.o文件
-m打印连接位图到标准输出
-T将kernel.ld作为连接脚本使用
-o结果命名为kernel
-nostdlib仅搜索命令行上显示的库路径

而对于bootblock有
ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o
也调用了如上三个.o文件
-N  设置代码段和数据段均可读写
-e <entry>  指定入口
-Ttext  制定代码段开始位置
```

2. 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？
```
主引导记录一共有512字节，而每个引导扇区的最后两个字节是结束标志55AA，有了这个标志才说明是合法的主引导记录。在/tools/sign.c中也可以看到对应的代码
    buf[510] = 0x55;
    buf[511] = 0xAA;
```

#### 练习2：使用qemu执行并调试lab1中的软件。（要求在报告中简要写出练习过程）

为了熟悉使用qemu和gdb进行的调试工作，我们进行如下的小练习：

1. 从CPU加电后执行的第一条指令开始，单步跟踪BIOS的执行。
```
可以看到tools/gdbinit代码如下
file bin/kernel
target remote :1234
break kern_init
continue

把continue删掉就可以防止qemu的自动运行。
最开始从fff0开始运行，然后break在init.c的第17行，也就是kern_init开始运行，以此初始化console，pmm，中断，然后进入while(1)
```

2. 在初始化位置0x7c00设置实地址断点,测试断点正常。
```
修改gdbinit代码中片段
即加入
break *7c00 #设置断点
x  /2i $pc #反汇编，看到两条指令
	=> 0x7c00:      cli    
	   0x7c01:      cld    
```

3. 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。
```
同2的方法，只是/2i改成/5i，可以看到
	   0x7c00:      cli    
	   0x7c01:      cld    
	   0x7c02:      xor    %eax,%eax
	   0x7c04:      mov    %eax,%ds
	   0x7c06:      mov    %eax,%es
	   0x7c08:      mov    %eax,%ss 


bootasm.S对应的汇编代码为（把相应注释删掉后）
    cli
    cld
    xorw %ax, %ax                                   
    movw %ax, %ds                                   
    movw %ax, %es                                   
    movw %ax, %ss                                   
    movw %ax, %ss
    
此时本人发现当时搭虚拟机时选64位比太好(后来换成32位发现mac上根本跑不了...)，不过可以看出理论上两者是一样的！
```

4. 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。
```
把之前的break kern_init改为break *7c02
有
	   0x7c04:      mov    %eax,%ds
	   0x7c06:      mov    %eax,%es
	   0x7c08:      mov    %eax,%ss 
		...
可以看到断点的位置发生了变化
```

#### 练习3：分析bootloader进入保护模式的过程。（要求在报告中写出分析）

BIOS将通过读取硬盘主引导扇区到内存，并转跳到对应内存中的位置执行bootloader。请分析bootloader是如何完成从实模式进入保护模式的。

```
首先
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment
可以看到是把ds,es,ss都置零

而seta20.1和seta20.2，主要完成对A20接口的开启，第二次的时候置bit1为，这样保证了进入保护模式的时候能够访问到所有空间。最后靠movb $0xdf, %al打开A20。

之后通过lgdt初始化GDT表，再置cr0的PE为1开启保护模式。ljmp跳进32位模式。

protcseg用来set up保护模式，主要是设立好段寄存器，准备堆栈。 最后call bootmain进入boot，正式转入保护模式。
```

####[练习4]：分析bootloader加载ELF格式的OS的过程。
- bootloader如何读取硬盘扇区的？
```
readsect：
1 等待磁盘准备好
     waitdisk();
2 发出读取扇区的指令
    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

3 等待磁盘准备好
    // wait for disk to be ready
    waitdisk();

4 把磁盘扇区数据读到制定内存
    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
    
readseg对readsect函数进行了简单包装，读取一段
``` 

- bootloader是如何加载ELF格式的OS？
```
在bootmain中，
bootmain(void) {
    // 用readseg读第一页
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // 判断是否是有效的ELF，否则跳到bad标签
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // 加载每个segment，忽略ph
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
        //载入ELF文件中数据到ph中
    }
	
    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();
   	//根据ELFHDR中e_entry找到内核入口。
   	
```

#### 练习5：实现函数调用堆栈跟踪函数 （需要编程）
```
按照kdebug.c的注释一步步完成即可
结果为
ebp:0x00007b08  eip:0x001009a6 arg:0x00010094 0x00000000 0x00007b38 0x00100092 
    kern/debug/kdebug.c:306: print_stackframe+21
ebp:0x00007b18  eip:0x00100c87 arg:0x00000000 0x00000000 0x00000000 0x00007b88 
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b38  eip:0x00100092 arg:0x00000000 0x00007b60 0xffff0000 0x00007b64 
    kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b58  eip:0x001000bb arg:0x00000000 0xffff0000 0x00007b84 0x00000029 
    kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b78  eip:0x001000d9 arg:0x00000000 0x00100000 0xffff0000 0x0000001d 
    kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007b98  eip:0x001000fe arg:0x001032dc 0x001032c0 0x0000130a 0x00000000 
    kern/init/init.c:63: grade_backtrace+34
ebp:0x00007bc8  eip:0x00100055 arg:0x00000000 0x00000000 0x00000000 0x00010094 
    kern/init/init.c:28: kern_init+84
ebp:0x00007bf8  eip:0x00007d68 arg:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d67 --
...

ebp存放为7c00-2，即转入7c00，可以看到调用完成函数时，eip和ebp会更新。
<unknown>是由于不是函数而是汇编段，所以没有函数名称所致。

```

#### 练习6：完善中断初始化和处理 （需要编程）

请完成编码工作和回答如下问题：

1. 中断向量表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？
```
8字节；
段选择子：2-3
offset：0-1和6-7
一起构成中断处理代码的入口
```
2. 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。在idt_init函数中，依次对所有中断入口进行初始化。使用mmu.h中的SETGATE宏，填充idt数组内容。注意除了系统调用中断(T_SYSCALL)以外，其它中断均使用中断门描述符，权限为内核态权限；而系统调用中断使用异常，权限为陷阱门描述符。每个中断的入口由tools/vectors.c生成，使用trap.c中声明的vectors数组即可。
```
按代码所示，先将idt权限都设为内核态，然后单独该T_SYSCALL，最后调用lidt

```

3. 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”。
```
print_ticks();即可
```

要求完成问题2和问题3 提出的相关函数实现，提交改进后的源代码包（可以编译执行），并在实验报告中简要说明实现过程，并写出对问题1的回答。完成这问题2和3要求的部分代码后，运行整个系统，可以看到大约每1秒会输出一次”100 ticks”，而按下的键也会在屏幕上显示。

提示：可阅读小节“中断与异常”。



#### 扩展练习 Challenge 1（需要编程）

扩展proj4,增加syscall功能，即增加一用户态函数（可执行一特定系统调用：获得时钟计数值），当内核初始完毕后，可从内核态返回到用户态的函数，而用户态的函数又通过系统调用得到内核态的服务（通过网络查询所需信息，可找老师咨询。如果完成，且有兴趣做代替考试的实验，可找老师商量）。需写出详细的设计和分析报告。完成出色的可获得适当加分。

提示：
规范一下 challenge 的流程。

kern_init 调用 switch_test，该函数如下：

```
	static void
	switch_test(void) {
		print_cur_status();          // print 当前 cs/ss/ds 等寄存器状态
		cprintf("+++ switch to  user  mode +++\n");
		switch_to_user();            // switch to user mode
		print_cur_status();
		cprintf("+++ switch to kernel mode +++\n");
		switch_to_kernel();         // switch to kernel mode
		print_cur_status();
	}
```

switch_to_\* 函数建议通过 中断处理的方式实现。主要要完成的代码是在 trap 里面处理 T_SWITCH_TO\* 中断，并设置好返回的状态。

在 lab1 里面完成代码以后，执行 make grade 应该能够评测结果是否正确。

#### 扩展练习 Challenge 2（需要编程）
用键盘实现用户模式内核模式切换。具体目标是：“键盘输入3时切换到用户模式，键盘输入0时切换到内核模式”。
基本思路是借鉴软中断(syscall功能)的代码，并且把trap.c中软中断处理的设置语句拿过来。

注意：

　1.关于调试工具，不建议用lab1_print_cur_status()来显示，要注意到寄存器的值要在中断完成后tranentry.S里面iret结束的时候才写回，所以再trap.c里面不好观察，建议用print_trapframe(tf)

　2.关于内联汇编，最开始调试的时候，参数容易出现错误，可能的错误代码如下
   ```
   asm volatile ( "sub $0x8, %%esp \n"
     "int %0 \n"
     "movl %%ebp, %%esp"
     : )
  ```
  要去掉参数int %0 \n这一行

3.软中断是利用了临时栈来处理的，所以有压栈和出栈的汇编语句。硬件中断本身就在内核态了，直接处理就可以了。

4. 参考答案在mooc_os_lab中的mooc_os_2014 branch中的labcodes_answer/lab1_result目录下



