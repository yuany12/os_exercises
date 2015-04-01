#lec9 虚存置换算法spoc练习

## 个人思考题
1. 置换算法的功能？

2. 全局和局部置换算法的不同？
全局：每个进程的页面数可以调整
局部：每个进程的页面数固定

3. 最优算法、先进先出算法和LRU算法的思路？

4. 时钟置换算法的思路？

5. LFU算法的思路？

6. 什么是Belady现象？

7. 几种局部置换算法的相关性：什么地方是相似的？什么地方是不同的？为什么有这种相似或不同？

8. 什么是工作集？

9. 什么是常驻集？

10. 工作集算法的思路？

11. 缺页率算法的思路？

12. 什么是虚拟内存管理的抖动现象？

13. 操作系统负载控制的最佳状态是什么状态？

## 小组思考题目

----
(1)（spoc）请证明为何LRU算法不会出现belady现象     
>设S为物理页面数量为n的LRU算法维护的栈，S1是物理页面数量为n+k的LRU算法维护的栈
证明在任意时刻，S属于S1，且任意S中元素a，对应到S1中元素a1，满足a的位置小于等于a1的栈位置,即可证明物理页面数量增加的缺页率不会降低。
数学归纳法：
在初始情况下，S与S1都为空，满足任意S中元素a，对应到S1中元素a1    
在t-1时刻满足S属于S1，且任意S中元素a，对应到S1中元素a1，满足a的位置小于等于a1的栈位置
在T时刻，对于对x页的页面访问请求，可能出现三种情况   
情况1：x属于S，且x属于S1,则经过这一步，需要将S与S1中的x页都置于栈顶部，因为S1的栈大小大于S，所以对于x元素，还是满足x在S中的位置，小于x在S1中的位置。对于原有在S与S1中的元素，在x元素前的元素位置不变，在x后的元素位置整体前移，大小关系保持不变。所以这种情况下依旧满足条件。   
情况2：x不属于S，且x属于S1，x不属于S，就在栈顶压入元素，x位置为n；在s1中找到x，将x元素移至栈定于，依旧满足S中x位置小于等于S1中位置。对于原有在S中的元素，整体前移了一位，S1中元素x前的不变，x后的整体前移1位，所以整体大小关系依旧满足。   
情况3：x不属于S，且x不属于S1，则都在栈尾部加入x，S中位置为n，S1中位置为n+k。同时对于被弹出栈的元素，如果弹出元素相同，则依旧满足。如果弹出元素不同，因为S中的对应元素位置小于等于S1的，所以S1中弹出的元素必然已经不属于S了。所以弹出后依旧满足S属于S1.即在这种情况下依旧满足假设。    
由于假设的存在，s属于S1，即不会出现x属于s，x不属于s1的情况。      
综上所述，由数学归纳法得，对任意时刻，任意时刻，S属于S1，且任意S中元素a，对应到S1中元素a1，满足a的位置小于等于a1的栈位置。      
即对任意时刻，对S1的缺页数量不会大于S。即物理页数量增加，缺页率不会上升。     
即证明了，LRU算法，不会出现belady现象。    

(2)（spoc）根据你的`学号 mod 4`的结果值，确定选择四种替换算法（0：LRU置换算法，1:改进的clock 页置换算法，2：工作集页置换算法，3：缺页率置换算法）中的一种来设计一个应用程序（可基于python, ruby, C, C++，LISP等）模拟实现，并给出测试。请参考如python代码或独自实现。
 - [页置换算法实现的参考实例](https://github.com/chyyuu/ucore_lab/blob/master/related_info/lab3/page-replacement-policy.py)
与袁源、杜鹃、王妍四个人一组。

改进的clock页面置换算法:
```
mem = [1,2,3,4]
bit0 = [0,0,0,0]
bit_write= [0,0,0,0]
ask = [3,1,4,2,5,2,1,2,3,4]
ask_write = [0,1,0,1,0,0,1,0,0,0]
pointer = 0
get = False
mmax = 3
for i in ask:
	get = False
	for j in range(0,mmax):
		if(mem[j]==ask[i]):
			print "the ref is in mem!"
			get = True
			break 
	
	while get==False:
		if bit0[pointer]==0 and bit_write[pointer]==0:
			mem[pointer] = ask[i]
			bit_write[pointer] = ask_write[i]
			bit0[pointer] = 1
			get = True
			print "found ! the mem now is :"
			print mem
			print "the reference bit :"
			print bit0
			print "the write bit :"
			print bit_write
			pointer += 1
			if pointer==mmax :
				pointer = 0
			break
		if bit0[pointer]==1:
			bit0[pointer]=0
			pointer+=1
			if pointer==mmax :
				pointer = 0
			break
		if bit_0[pointer]==0 and bit_write[pointer] ==1:
			bit_write[pointer]=0
			pointer += 1
			if pointer==mmax :
				pointer = 0
			break

```
工作集置换算法：
```
addrlist = [0,1,2,3,0,2,3,6,2,1,4,2,3,1,2]
t = 4

window = []
workset = set([])

print "visit sequence :   "
print addrlist
print "window size :"
print t
print "Memory resident: "
for i in addrlist:
    if i in workset:
        print "HIT"
    else:
        print "MISS"
    if ( len(window) < t  ):
        window.append(i)
        workset.add(i)
        print workset

    else:
        del window[0]
        window.append(i)
        workset = set([])
        for k in range(0, t):
            workset.add(window[k])
        print workset
 
测试结果：
visit sequence :   
[0, 1, 2, 3, 0, 2, 3, 6, 2, 1, 4, 2, 3, 1, 2]
window size :
4
Memory resident: 
MISS
set([0])
MISS
set([0, 1])
MISS
set([0, 1, 2])
MISS
set([0, 1, 2, 3])
HIT
set([0, 1, 2, 3])
HIT
set([0, 2, 3])
HIT
set([0, 2, 3])
MISS
set([0, 2, 3, 6])
HIT
set([2, 3, 6])
MISS
set([1, 2, 3, 6])
MISS
set([1, 2, 4, 6])
HIT
set([1, 2, 4])
MISS
set([1, 2, 3, 4])
HIT
set([1, 2, 3, 4])
HIT
set([1, 2, 3])
```
缺页率置换算法：
```
package testjava;

import java.lang.String;
import java.util.ArrayList;
import java.util.HashSet;

class Pair {
    String name;
    int time;
    boolean cited;
    Pair(String name, int time) {
        this.name = name;
        this.time = time;
        cited = false;
    }
}

class Replace {

	HashSet<Pair> set = null;
    int time_cur, time_last;
    int window_size;
    
    Replace(int W) {
        set = new HashSet<Pair>();
        window_size = W;
    }

    int now_time = 0;
    
    Pair add(String name) {
    	time_cur ++;
        // exist
        for (Pair p : set) {
            if (p.name.equals(name)) {
                p.cited = true;
                System.out.println("exist: " + p.name);
                return p;
            }
        }
        
        // not
        if (time_last!=0 && time_cur - time_last > window_size) {
            ArrayList<Pair> list = new ArrayList<Pair>();
        	System.out.print("out: ");
            for (Pair p : set) {
                if (! p.cited) {
                	System.out.print(" "+ p.name);
                	list.add(p);
                } else {
                    p.cited = false;
                }
            }
            System.out.println("\n");
            for (Pair p : list) {
            	set.remove(p);
            }
        }
        Pair p = new Pair(name, time_cur);
        System.out.println("add: " + p.name);
        set.add(p);
        time_last = time_cur;
        return p;
    }
    
    static public void main(String args[]) {
    
    	Replace work = new Replace(2);
    	work.add("a");
    	work.add("e");
    	work.add("d");
    	work.add("c");
    	work.add("c");
    	work.add("d");
    	work.add("d");
    	work.add("b");
    	work.add("c");
    	work.add("e");
    	work.add("c");
    	work.add("e");
    	work.add("a");
    	work.add("d");
    }
}

测试为课件所示例子
add: a
add: e
add: d
add: c
exist: c
exist: d
exist: d
out:  a e
add: b
exist: c
add: e
exist: c
exist: e
out:  d b
add: a
add: d
```

## 扩展思考题
（1）了解LIRS页置换算法的设计思路，尝试用高级语言实现其基本思路。此算法是江松博士（导师：张晓东博士）设计完成的，非常不错！

参考信息：

 - [LIRS conf paper](http://www.ece.eng.wayne.edu/~sjiang/pubs/papers/jiang02_LIRS.pdf)
 - [LIRS journal paper](http://www.ece.eng.wayne.edu/~sjiang/pubs/papers/jiang05_LIRS.pdf)
 - [LIRS-replacement ppt1](http://dragonstar.ict.ac.cn/course_09/XD_Zhang/(6)-LIRS-replacement.pdf)
 - [LIRS-replacement ppt2](http://www.ece.eng.wayne.edu/~sjiang/Projects/LIRS/sig02.ppt)
