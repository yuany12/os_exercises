lab2 report
2012011294 Yuan Yuan
thuyuany12@163.com

**练习0：填写已有实验**

本实验依赖实验1。请把你做的实验1的代码填入本实验中代码中有“LAB1”的注释相应部分。提示：可采用diff和patch工具进行半自动的合并（merge），也可用一些图形化的比较/merge工具来手动合并，比如meld，eclipse中的diff/merge工具，understand中的diff/merge工具等。

 列出本实验对应的OS原理的知识点，并说明本实验中的实现部分如何对应和体现了原理中的基本概念和关键知识点。
```
我们知道本次lab的目标是
* 理解基于段页式内存地址的转换机制
* 理解页表的建立和使用方法
* 理解物理内存的管理方法

对应了原理课中物理内存管理的两章。如段页表，地址转换，内存管理等。主要在kern/mm部分实现

```

**练习1：实现 first-fit 连续物理内存分配算法（需要编程）**

在实现first fit
内存分配算法的回收函数时，要考虑地址连续的空闲块之间的合并操作。提示:在建立空闲页块链表时，需要按照空闲页块起始地址来排序，形成一个有序的链表。可能会修改default\_pmm.c中的default\_init，default\_init\_memmap，default\_alloc\_pages，
default\_free\_pages等相关函数。请仔细查看和理解default\_pmm.c中的注释。

请在实验报告中简要说明你的设计实现过程。请回答如下问题：
 - 你的first fit算法是否有进一步的改进空间

```
修改部分主要是default.c

default_init 用来初始化free_list
default_init_memmap 用来初始化一个free block，本人修改了list_add为list_add_before,把新free出的往前插
default_alloc_pages 用来分配一个block size >=n，可以看到代码本身就是找到第一个大于等于n的block占用之的。
default_free_pages 用来free，我们可以看到最后一句 list_add(&free_list, &(base->page_link)); 显然他是把每个free出来的block放在free_list的后面，这与first fit不太符合。所以需要重新遍历一遍free block的地址，将其插在合适的地方（即地址序正确）

改进的空间：
采用链表结构，alloc一个block是个比较小的常数 free一个block是O(n)，效率不够高，可以按地址维护一个小根堆，这样可以降低时间复杂度（O(logn)）
```

**练习2：实现寻找虚拟地址对应的页表项（需要编程）**

通过设置页表和对应的页表项，可建立虚拟内存地址和物理内存地址的对应关系。其中的get\_pte函数是设置页表项环节中的一个重要步骤。此函数找到一个虚地址对应的二级页表项的内核虚地址，如果此二级页表项不存在，则分配一个包含此项的二级页表。本练习需要补全get\_pte函数
in
kern/mm/pmm.c，实现其功能。请仔细查看和理解get\_pte函数中的注释。get\_pte函数的调用关系图如下所示：

![](../lab2_figs/image001.png)
图1 get\_pte函数的调用关系图

请在实验报告中简要说明你的设计实现过程。请回答如下问题：

 ```
 实现过程：
 1.先用pgdir+PDX(la)判断是否存在
 2.再&PTE_P来判断这个entry是否存在。否转3，是转6
 3.判断是否允许创新的，若是并创建（创不成直接return NULL），若否return NULL
 4.设page ref，memset page的内容
 5.返回
 6.pte2page找到并返回
 ```

 - 如何ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
 ```
 *(int *)(var)即可访问var对应的内存地址
 若出现了页访问异常，硬件要做的事情有，
即CPU在当前内核栈保存当前被打断的程序现场，即依次压入当前被打断程序使用的EFLAGS，CS，EIP，errorCode；
由于页访问异常的中断号是0xE，CPU把异常中断号0xE对应的中断服务例程的地址（vectors.S中的标号vector14处）加载到CS和EIP寄存器中，开始执行中断服务例程。
 ```
 
 - 如何ucore的缺页服务例程在执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？
 ```
 异常的嵌套ucore是不支持的，硬件会触发reboot。
 ```
 
**练习3：释放某虚地址所在的页并取消对应二级页表项的映射（需要编程）**

当释放一个包含某虚地址的物理内存页时，需要让对应此物理内存页的管理数据结构Page做相关的清除处理，使得此物理内存页成为空闲；另外还需把表示虚地址与物理地址对应关系的二级页表项清除。请仔细查看和理解page\_remove\_pte函数中的注释。为此，需要补全在
kern/mm/pmm.c中的page\_remove\_pte函数。page\_remove\_pte函数的调用关系图如下所示：

![](../lab2_figs/image002.png)

图2 page\_remove\_pte函数的调用关系图

请在实验报告中简要说明你的设计实现过程。请回答如下问题：
```
实现过程：
先判断pte是否为NULL
转为page
用page_ref_dec decrease
free掉该page，最后用lib_invalidate处理tlb相关事宜
```

 - 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
```
有 就是页表项的前20位是page的index
```

 - 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ **鼓励通过编程来具体完成这个问题** 
```
在lab2中，启动好分页管理机制后，形成的是段页式映射机制，从而使得虚拟地址空间和物理地址空间之间存在如下的映射关系：
Virtual Address=LinearAddress=0xC0000000+Physical Address
可以考虑tools/kernel.ld中的0xC0100000改为0x00100000
```