# lab3 SPOC思考题

NOTICE
- 有"w5l2"标记的题是助教要提交到学堂在线上的。
- 有"w5l2"和"spoc"标记的题是要求拿清华学分的同学要在实体课上完成，并按时提交到学生对应的git repo上。
- 有"hard"标记的题有一定难度，鼓励实现。
- 有"easy"标记的题很容易实现，鼓励实现。
- 有"midd"标记的题是一般水平，鼓励实现。

## 个人思考题
---

### 10.1 实验目标：虚存管理
---

(1)缺页异常的处理流程？

(2)从外存的页面的存储和访问代码？

(3)缺页和页访问非法的返回地址有什么不同？

> 硬件设置、软件可修改； 中断号是

(4)虚拟内存管理中是否用到了段机制

(5)ucore如何知道页访问异常的地址？

### 10.2 回顾历史和了解当下
---

(6)中断处理例程的段表在GDT还是LDT？

(7)物理内存管理的数据结构在哪？

(8)页表项的结构？

(9)页表项的修改代码？

(10)如何设置一个虚拟地址到物理地址的映射关系？

(11)为了建立虚拟内存管理，需要在哪个数据结构中表示“合法”虚拟内存

### 10.3 处理流程、关键数据结构和功能
---

(12)swap_init()做了些什么？

(13)vmm_init()做了些什么？

(14)vma_struct数据结构的功能？

(15)mmap_list是什么列表？

(16)外存中的页面后备如何找到？

(17)vma_struct和mm_struct的关系是什么？

> 合法的连续虚拟地址区域、整个进程的地址空间

(18)画数据结构图，描述进程的虚拟地址空间、页表项、物理页面和后备页面的关系；

### 10.4 页访问异常
---

(19)页面不在内存和页面访问非法的处理中有什么区别？对应的代码区别在哪？

(20)find_vma()做了些什么？

(21)swapfs_read()做了些什么？

(22)缺页时的页面创建代码在哪？

(23)struct rb_tree数据结构的原理是什么？在虚拟管理中如何用它的？


(24)页目录项和页表项的dirty bit是何时，由谁置1的？


(25)页目录项和页表项的access bit是何时，由谁置1的？


### 10.5 页换入换出机制
---

(26)虚拟页与磁盘后备页面的对应有关系？

(27)如果在开始加载可执行文件时，如何改？

(28)check_swap()做了些什么检查？

(29)swap_entry_t数据结构做什么用的？放在什么地方？

(30)空闲物理页面的组织数据结构是什么？

(21)置换算法的接口数据结构？

> swap_manager

================


## 小组思考题
---
(1)(spoc) 请参考lab3_result的代码，思考如何在lab3_results中实现clock算法，并给出你的概要设计方案，可4人一个小组，说明你的方案中clock算法与LRU算法上相比，潜在的性能差异性。并进一说明LRU算法在lab3实现的可能性评价（给出理由）。

>概要设计：  
>在page结构中，设定一个空闲位，作为访问位。1表示已经访问过，0表示还未访问过。再构建一个循环列表指向各个页面。每次替换页面的时候，指针循环访问每一个页面，如果页面访问位为0，则替换该页面终止寻找过程。如果访问位为1，则改写访问为0。新建swap_clock,重写swap中的swappable、init等函数。在swap中实例化这个类然后调用其中的函数即可。  
>算法比较：  
LRU依据页面的最近访问时间顺序，性能较好，但是系统开销大  ；Clock页面访问时，不动态调整页面在链表中的顺序，仅做标记，开销比较小  
实现可能性：   
LRU的实现比较复杂，需要维护一个栈，或者维护一个首节点为最远时间的链表，要实现是可行的，但是需要较大的系统开销。


(2)(spoc) 理解内存访问的异常。在x86中内存访问会受到段机制和页机制的两层保护，请基于lab3_results的代码（包括lab1的challenge练习实现），请实践并分析出段机制和页机制各种内存非法访问的后果。，可4人一个小组，，找出尽可能多的各种内存访问异常，并在代码中给出实现和测试用例，在执行了测试用例后，ucore能够显示出是出现了哪种异常和尽量详细的错误信息。请在说明文档中指出：某种内存访问异常的原因，硬件的处理过程，以及OS如何处理，是否可以利用做其他有用的事情（比如提供比物理空间更大的虚拟空间）？哪些段异常是否可取消，并用页异常取代？
  
>缺页：访问地址0，  addr=0 *(int *a)=0;    
没有设置idt ： 删去idt的初始化操作，产生错误。因为没有设置idt，所以无法进入异常抓取与处理。最后ucore一直处于reboot的状态。  
访问没对齐 ：访问0x00050001这一没有对齐的地址。为了开启对齐检测，还需要修改CR0中am字段，同时设置eflags中ac字段（对应在 libs/x86.h）。  
越段内偏移访问：在entry.c中设置段SEC.ASH长度，造成段内偏移的异常 。  