
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 80 11 40 	lgdtl  0x40118018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 04 00 00 00       	call   10002c <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>
  10002a:	66 90                	xchg   %ax,%ax

0010002c <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002c:	55                   	push   %ebp
  10002d:	89 e5                	mov    %esp,%ebp
  10002f:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100032:	ba 88 99 11 00       	mov    $0x119988,%edx
  100037:	b8 38 8a 11 00       	mov    $0x118a38,%eax
  10003c:	89 d1                	mov    %edx,%ecx
  10003e:	29 c1                	sub    %eax,%ecx
  100040:	89 c8                	mov    %ecx,%eax
  100042:	89 44 24 08          	mov    %eax,0x8(%esp)
  100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10004d:	00 
  10004e:	c7 04 24 38 8a 11 00 	movl   $0x118a38,(%esp)
  100055:	e8 29 60 00 00       	call   106083 <memset>

    cons_init();                // init the console
  10005a:	e8 15 16 00 00       	call   101674 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005f:	c7 45 f4 40 62 10 00 	movl   $0x106240,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100069:	89 44 24 04          	mov    %eax,0x4(%esp)
  10006d:	c7 04 24 5c 62 10 00 	movl   $0x10625c,(%esp)
  100074:	e8 ce 02 00 00       	call   100347 <cprintf>

    print_kerninfo();
  100079:	e8 02 08 00 00       	call   100880 <print_kerninfo>

    grade_backtrace();
  10007e:	e8 86 00 00 00       	call   100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100083:	e8 5d 44 00 00       	call   1044e5 <pmm_init>

    pic_init();                 // init interrupt controller
  100088:	e8 58 17 00 00       	call   1017e5 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10008d:	e8 aa 18 00 00       	call   10193c <idt_init>

    clock_init();               // init clock interrupt
  100092:	e8 ed 0c 00 00       	call   100d84 <clock_init>
    intr_enable();              // enable irq interrupt
  100097:	e8 b0 16 00 00       	call   10174c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10009c:	eb fe                	jmp    10009c <kern_init+0x70>

0010009e <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009e:	55                   	push   %ebp
  10009f:	89 e5                	mov    %esp,%ebp
  1000a1:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000ab:	00 
  1000ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b3:	00 
  1000b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bb:	e8 ee 0b 00 00       	call   100cae <mon_backtrace>
}
  1000c0:	c9                   	leave  
  1000c1:	c3                   	ret    

001000c2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c2:	55                   	push   %ebp
  1000c3:	89 e5                	mov    %esp,%ebp
  1000c5:	53                   	push   %ebx
  1000c6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c9:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cf:	8d 55 08             	lea    0x8(%ebp),%edx
  1000d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e1:	89 04 24             	mov    %eax,(%esp)
  1000e4:	e8 b5 ff ff ff       	call   10009e <grade_backtrace2>
}
  1000e9:	83 c4 14             	add    $0x14,%esp
  1000ec:	5b                   	pop    %ebx
  1000ed:	5d                   	pop    %ebp
  1000ee:	c3                   	ret    

001000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ef:	55                   	push   %ebp
  1000f0:	89 e5                	mov    %esp,%ebp
  1000f2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ff:	89 04 24             	mov    %eax,(%esp)
  100102:	e8 bb ff ff ff       	call   1000c2 <grade_backtrace1>
}
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <grade_backtrace>:

void
grade_backtrace(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010f:	b8 2c 00 10 00       	mov    $0x10002c,%eax
  100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10011b:	ff 
  10011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100127:	e8 c3 ff ff ff       	call   1000ef <grade_backtrace0>
}
  10012c:	c9                   	leave  
  10012d:	c3                   	ret    

0010012e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012e:	55                   	push   %ebp
  10012f:	89 e5                	mov    %esp,%ebp
  100131:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100134:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100137:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10013a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10013d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100140:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100144:	0f b7 c0             	movzwl %ax,%eax
  100147:	89 c2                	mov    %eax,%edx
  100149:	83 e2 03             	and    $0x3,%edx
  10014c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100151:	89 54 24 08          	mov    %edx,0x8(%esp)
  100155:	89 44 24 04          	mov    %eax,0x4(%esp)
  100159:	c7 04 24 61 62 10 00 	movl   $0x106261,(%esp)
  100160:	e8 e2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	0f b7 d0             	movzwl %ax,%edx
  10016c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100171:	89 54 24 08          	mov    %edx,0x8(%esp)
  100175:	89 44 24 04          	mov    %eax,0x4(%esp)
  100179:	c7 04 24 6f 62 10 00 	movl   $0x10626f,(%esp)
  100180:	e8 c2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100189:	0f b7 d0             	movzwl %ax,%edx
  10018c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100191:	89 54 24 08          	mov    %edx,0x8(%esp)
  100195:	89 44 24 04          	mov    %eax,0x4(%esp)
  100199:	c7 04 24 7d 62 10 00 	movl   $0x10627d,(%esp)
  1001a0:	e8 a2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a9:	0f b7 d0             	movzwl %ax,%edx
  1001ac:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b9:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1001c0:	e8 82 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c9:	0f b7 d0             	movzwl %ax,%edx
  1001cc:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d9:	c7 04 24 99 62 10 00 	movl   $0x106299,(%esp)
  1001e0:	e8 62 01 00 00       	call   100347 <cprintf>
    round ++;
  1001e5:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001ea:	83 c0 01             	add    $0x1,%eax
  1001ed:	a3 40 8a 11 00       	mov    %eax,0x118a40
}
  1001f2:	c9                   	leave  
  1001f3:	c3                   	ret    

001001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f4:	55                   	push   %ebp
  1001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001fc:	5d                   	pop    %ebp
  1001fd:	c3                   	ret    

001001fe <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 25 ff ff ff       	call   10012e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 a8 62 10 00 	movl   $0x1062a8,(%esp)
  100210:	e8 32 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_user();
  100215:	e8 da ff ff ff       	call   1001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 0f ff ff ff       	call   10012e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 c8 62 10 00 	movl   $0x1062c8,(%esp)
  100226:	e8 1c 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 c9 ff ff ff       	call   1001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 f9 fe ff ff       	call   10012e <lab1_print_cur_status>
}
  100235:	c9                   	leave  
  100236:	c3                   	ret    
  100237:	90                   	nop

00100238 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100238:	55                   	push   %ebp
  100239:	89 e5                	mov    %esp,%ebp
  10023b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100242:	74 13                	je     100257 <readline+0x1f>
        cprintf("%s", prompt);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 e7 62 10 00 	movl   $0x1062e7,(%esp)
  100252:	e8 f0 00 00 00       	call   100347 <cprintf>
    }
    int i = 0, c;
  100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10025e:	eb 01                	jmp    100261 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
  100260:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
  100261:	e8 6e 01 00 00       	call   1003d4 <getchar>
  100266:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10026d:	79 07                	jns    100276 <readline+0x3e>
            return NULL;
  10026f:	b8 00 00 00 00       	mov    $0x0,%eax
  100274:	eb 79                	jmp    1002ef <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100276:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027a:	7e 28                	jle    1002a4 <readline+0x6c>
  10027c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100283:	7f 1f                	jg     1002a4 <readline+0x6c>
            cputchar(c);
  100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100288:	89 04 24             	mov    %eax,(%esp)
  10028b:	e8 df 00 00 00       	call   10036f <cputchar>
            buf[i ++] = c;
  100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100296:	81 c2 60 8a 11 00    	add    $0x118a60,%edx
  10029c:	88 02                	mov    %al,(%edx)
  10029e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1002a2:	eb 46                	jmp    1002ea <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1002a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a8:	75 17                	jne    1002c1 <readline+0x89>
  1002aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ae:	7e 11                	jle    1002c1 <readline+0x89>
            cputchar(c);
  1002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b3:	89 04 24             	mov    %eax,(%esp)
  1002b6:	e8 b4 00 00 00       	call   10036f <cputchar>
            i --;
  1002bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002bf:	eb 29                	jmp    1002ea <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1002c1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c5:	74 06                	je     1002cd <readline+0x95>
  1002c7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cb:	75 93                	jne    100260 <readline+0x28>
            cputchar(c);
  1002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d0:	89 04 24             	mov    %eax,(%esp)
  1002d3:	e8 97 00 00 00       	call   10036f <cputchar>
            buf[i] = '\0';
  1002d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002db:	05 60 8a 11 00       	add    $0x118a60,%eax
  1002e0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e3:	b8 60 8a 11 00       	mov    $0x118a60,%eax
  1002e8:	eb 05                	jmp    1002ef <readline+0xb7>
        }
    }
  1002ea:	e9 71 ff ff ff       	jmp    100260 <readline+0x28>
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    
  1002f1:	66 90                	xchg   %ax,%ax
  1002f3:	90                   	nop

001002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fd:	89 04 24             	mov    %eax,(%esp)
  100300:	e8 9b 13 00 00       	call   1016a0 <cons_putc>
    (*cnt) ++;
  100305:	8b 45 0c             	mov    0xc(%ebp),%eax
  100308:	8b 00                	mov    (%eax),%eax
  10030a:	8d 50 01             	lea    0x1(%eax),%edx
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	89 10                	mov    %edx,(%eax)
}
  100312:	c9                   	leave  
  100313:	c3                   	ret    

00100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100321:	8b 45 0c             	mov    0xc(%ebp),%eax
  100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100332:	89 44 24 04          	mov    %eax,0x4(%esp)
  100336:	c7 04 24 f4 02 10 00 	movl   $0x1002f4,(%esp)
  10033d:	e8 44 55 00 00       	call   105886 <vprintfmt>
    return cnt;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100347:	55                   	push   %ebp
  100348:	89 e5                	mov    %esp,%ebp
  10034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034d:	8d 55 0c             	lea    0xc(%ebp),%edx
  100350:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100353:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
  100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100358:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035c:	8b 45 08             	mov    0x8(%ebp),%eax
  10035f:	89 04 24             	mov    %eax,(%esp)
  100362:	e8 ad ff ff ff       	call   100314 <vcprintf>
  100367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036d:	c9                   	leave  
  10036e:	c3                   	ret    

0010036f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036f:	55                   	push   %ebp
  100370:	89 e5                	mov    %esp,%ebp
  100372:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100375:	8b 45 08             	mov    0x8(%ebp),%eax
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 20 13 00 00       	call   1016a0 <cons_putc>
}
  100380:	c9                   	leave  
  100381:	c3                   	ret    

00100382 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100382:	55                   	push   %ebp
  100383:	89 e5                	mov    %esp,%ebp
  100385:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038f:	eb 13                	jmp    1003a4 <cputs+0x22>
        cputch(c, &cnt);
  100391:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100395:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100398:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039c:	89 04 24             	mov    %eax,(%esp)
  10039f:	e8 50 ff ff ff       	call   1002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a7:	0f b6 00             	movzbl (%eax),%eax
  1003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b1:	0f 95 c0             	setne  %al
  1003b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1003b8:	84 c0                	test   %al,%al
  1003ba:	75 d5                	jne    100391 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ca:	e8 25 ff ff ff       	call   1002f4 <cputch>
    return cnt;
  1003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003d2:	c9                   	leave  
  1003d3:	c3                   	ret    

001003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d4:	55                   	push   %ebp
  1003d5:	89 e5                	mov    %esp,%ebp
  1003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003da:	e8 fd 12 00 00       	call   1016dc <cons_getc>
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e6:	74 f2                	je     1003da <getchar+0x6>
        /* do nothing */;
    return c;
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003eb:	c9                   	leave  
  1003ec:	c3                   	ret    

001003ed <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003ed:	55                   	push   %ebp
  1003ee:	89 e5                	mov    %esp,%ebp
  1003f0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f6:	8b 00                	mov    (%eax),%eax
  1003f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fe:	8b 00                	mov    (%eax),%eax
  100400:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10040a:	e9 d2 00 00 00       	jmp    1004e1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100412:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100415:	01 d0                	add    %edx,%eax
  100417:	89 c2                	mov    %eax,%edx
  100419:	c1 ea 1f             	shr    $0x1f,%edx
  10041c:	01 d0                	add    %edx,%eax
  10041e:	d1 f8                	sar    %eax
  100420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100426:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100429:	eb 04                	jmp    10042f <stab_binsearch+0x42>
            m --;
  10042b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100432:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100435:	7c 1f                	jl     100456 <stab_binsearch+0x69>
  100437:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043a:	89 d0                	mov    %edx,%eax
  10043c:	01 c0                	add    %eax,%eax
  10043e:	01 d0                	add    %edx,%eax
  100440:	c1 e0 02             	shl    $0x2,%eax
  100443:	89 c2                	mov    %eax,%edx
  100445:	8b 45 08             	mov    0x8(%ebp),%eax
  100448:	01 d0                	add    %edx,%eax
  10044a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044e:	0f b6 c0             	movzbl %al,%eax
  100451:	3b 45 14             	cmp    0x14(%ebp),%eax
  100454:	75 d5                	jne    10042b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100459:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10045c:	7d 0b                	jge    100469 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100461:	83 c0 01             	add    $0x1,%eax
  100464:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100467:	eb 78                	jmp    1004e1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100470:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100473:	89 d0                	mov    %edx,%eax
  100475:	01 c0                	add    %eax,%eax
  100477:	01 d0                	add    %edx,%eax
  100479:	c1 e0 02             	shl    $0x2,%eax
  10047c:	89 c2                	mov    %eax,%edx
  10047e:	8b 45 08             	mov    0x8(%ebp),%eax
  100481:	01 d0                	add    %edx,%eax
  100483:	8b 40 08             	mov    0x8(%eax),%eax
  100486:	3b 45 18             	cmp    0x18(%ebp),%eax
  100489:	73 13                	jae    10049e <stab_binsearch+0xb1>
            *region_left = m;
  10048b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100493:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100496:	83 c0 01             	add    $0x1,%eax
  100499:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049c:	eb 43                	jmp    1004e1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a1:	89 d0                	mov    %edx,%eax
  1004a3:	01 c0                	add    %eax,%eax
  1004a5:	01 d0                	add    %edx,%eax
  1004a7:	c1 e0 02             	shl    $0x2,%eax
  1004aa:	89 c2                	mov    %eax,%edx
  1004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1004af:	01 d0                	add    %edx,%eax
  1004b1:	8b 40 08             	mov    0x8(%eax),%eax
  1004b4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b7:	76 16                	jbe    1004cf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c7:	83 e8 01             	sub    $0x1,%eax
  1004ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004cd:	eb 12                	jmp    1004e1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004dd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e7:	0f 8e 22 ff ff ff    	jle    10040f <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004f1:	75 0f                	jne    100502 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f6:	8b 00                	mov    (%eax),%eax
  1004f8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004fb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fe:	89 10                	mov    %edx,(%eax)
  100500:	eb 3f                	jmp    100541 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100502:	8b 45 10             	mov    0x10(%ebp),%eax
  100505:	8b 00                	mov    (%eax),%eax
  100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10050a:	eb 04                	jmp    100510 <stab_binsearch+0x123>
  10050c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100510:	8b 45 0c             	mov    0xc(%ebp),%eax
  100513:	8b 00                	mov    (%eax),%eax
  100515:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100518:	7d 1f                	jge    100539 <stab_binsearch+0x14c>
  10051a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10051d:	89 d0                	mov    %edx,%eax
  10051f:	01 c0                	add    %eax,%eax
  100521:	01 d0                	add    %edx,%eax
  100523:	c1 e0 02             	shl    $0x2,%eax
  100526:	89 c2                	mov    %eax,%edx
  100528:	8b 45 08             	mov    0x8(%ebp),%eax
  10052b:	01 d0                	add    %edx,%eax
  10052d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100531:	0f b6 c0             	movzbl %al,%eax
  100534:	3b 45 14             	cmp    0x14(%ebp),%eax
  100537:	75 d3                	jne    10050c <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053f:	89 10                	mov    %edx,(%eax)
    }
}
  100541:	c9                   	leave  
  100542:	c3                   	ret    

00100543 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100543:	55                   	push   %ebp
  100544:	89 e5                	mov    %esp,%ebp
  100546:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100549:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054c:	c7 00 ec 62 10 00    	movl   $0x1062ec,(%eax)
    info->eip_line = 0;
  100552:	8b 45 0c             	mov    0xc(%ebp),%eax
  100555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10055c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055f:	c7 40 08 ec 62 10 00 	movl   $0x1062ec,0x8(%eax)
    info->eip_fn_namelen = 9;
  100566:	8b 45 0c             	mov    0xc(%ebp),%eax
  100569:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100570:	8b 45 0c             	mov    0xc(%ebp),%eax
  100573:	8b 55 08             	mov    0x8(%ebp),%edx
  100576:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100583:	c7 45 f4 3c 75 10 00 	movl   $0x10753c,-0xc(%ebp)
    stab_end = __STAB_END__;
  10058a:	c7 45 f0 e0 24 11 00 	movl   $0x1124e0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100591:	c7 45 ec e1 24 11 00 	movl   $0x1124e1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100598:	c7 45 e8 7a 50 11 00 	movl   $0x11507a,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a5:	76 0d                	jbe    1005b4 <debuginfo_eip+0x71>
  1005a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005aa:	83 e8 01             	sub    $0x1,%eax
  1005ad:	0f b6 00             	movzbl (%eax),%eax
  1005b0:	84 c0                	test   %al,%al
  1005b2:	74 0a                	je     1005be <debuginfo_eip+0x7b>
        return -1;
  1005b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b9:	e9 c0 02 00 00       	jmp    10087e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005cb:	29 c2                	sub    %eax,%edx
  1005cd:	89 d0                	mov    %edx,%eax
  1005cf:	c1 f8 02             	sar    $0x2,%eax
  1005d2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d8:	83 e8 01             	sub    $0x1,%eax
  1005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005de:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005ec:	00 
  1005ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fe:	89 04 24             	mov    %eax,(%esp)
  100601:	e8 e7 fd ff ff       	call   1003ed <stab_binsearch>
    if (lfile == 0)
  100606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100609:	85 c0                	test   %eax,%eax
  10060b:	75 0a                	jne    100617 <debuginfo_eip+0xd4>
        return -1;
  10060d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100612:	e9 67 02 00 00       	jmp    10087e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10061a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100620:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100623:	8b 45 08             	mov    0x8(%ebp),%eax
  100626:	89 44 24 10          	mov    %eax,0x10(%esp)
  10062a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100631:	00 
  100632:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100635:	89 44 24 08          	mov    %eax,0x8(%esp)
  100639:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10063c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100643:	89 04 24             	mov    %eax,(%esp)
  100646:	e8 a2 fd ff ff       	call   1003ed <stab_binsearch>

    if (lfun <= rfun) {
  10064b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100651:	39 c2                	cmp    %eax,%edx
  100653:	7f 7c                	jg     1006d1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100655:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100658:	89 c2                	mov    %eax,%edx
  10065a:	89 d0                	mov    %edx,%eax
  10065c:	01 c0                	add    %eax,%eax
  10065e:	01 d0                	add    %edx,%eax
  100660:	c1 e0 02             	shl    $0x2,%eax
  100663:	89 c2                	mov    %eax,%edx
  100665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100668:	01 d0                	add    %edx,%eax
  10066a:	8b 10                	mov    (%eax),%edx
  10066c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100672:	29 c1                	sub    %eax,%ecx
  100674:	89 c8                	mov    %ecx,%eax
  100676:	39 c2                	cmp    %eax,%edx
  100678:	73 22                	jae    10069c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067d:	89 c2                	mov    %eax,%edx
  10067f:	89 d0                	mov    %edx,%eax
  100681:	01 c0                	add    %eax,%eax
  100683:	01 d0                	add    %edx,%eax
  100685:	c1 e0 02             	shl    $0x2,%eax
  100688:	89 c2                	mov    %eax,%edx
  10068a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068d:	01 d0                	add    %edx,%eax
  10068f:	8b 10                	mov    (%eax),%edx
  100691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100694:	01 c2                	add    %eax,%edx
  100696:	8b 45 0c             	mov    0xc(%ebp),%eax
  100699:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10069c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069f:	89 c2                	mov    %eax,%edx
  1006a1:	89 d0                	mov    %edx,%eax
  1006a3:	01 c0                	add    %eax,%eax
  1006a5:	01 d0                	add    %edx,%eax
  1006a7:	c1 e0 02             	shl    $0x2,%eax
  1006aa:	89 c2                	mov    %eax,%edx
  1006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006af:	01 d0                	add    %edx,%eax
  1006b1:	8b 50 08             	mov    0x8(%eax),%edx
  1006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bd:	8b 40 10             	mov    0x10(%eax),%eax
  1006c0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cf:	eb 15                	jmp    1006e6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e9:	8b 40 08             	mov    0x8(%eax),%eax
  1006ec:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006f3:	00 
  1006f4:	89 04 24             	mov    %eax,(%esp)
  1006f7:	e8 ff 57 00 00       	call   105efb <strfind>
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  100701:	8b 40 08             	mov    0x8(%eax),%eax
  100704:	29 c2                	sub    %eax,%edx
  100706:	8b 45 0c             	mov    0xc(%ebp),%eax
  100709:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10070c:	8b 45 08             	mov    0x8(%ebp),%eax
  10070f:	89 44 24 10          	mov    %eax,0x10(%esp)
  100713:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10071a:	00 
  10071b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100722:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100725:	89 44 24 04          	mov    %eax,0x4(%esp)
  100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072c:	89 04 24             	mov    %eax,(%esp)
  10072f:	e8 b9 fc ff ff       	call   1003ed <stab_binsearch>
    if (lline <= rline) {
  100734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100737:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073a:	39 c2                	cmp    %eax,%edx
  10073c:	7f 24                	jg     100762 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100741:	89 c2                	mov    %eax,%edx
  100743:	89 d0                	mov    %edx,%eax
  100745:	01 c0                	add    %eax,%eax
  100747:	01 d0                	add    %edx,%eax
  100749:	c1 e0 02             	shl    $0x2,%eax
  10074c:	89 c2                	mov    %eax,%edx
  10074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100757:	0f b7 d0             	movzwl %ax,%edx
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100760:	eb 13                	jmp    100775 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100767:	e9 12 01 00 00       	jmp    10087e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076f:	83 e8 01             	sub    $0x1,%eax
  100772:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10077b:	39 c2                	cmp    %eax,%edx
  10077d:	7c 56                	jl     1007d5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100798:	3c 84                	cmp    $0x84,%al
  10079a:	74 39                	je     1007d5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10079c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079f:	89 c2                	mov    %eax,%edx
  1007a1:	89 d0                	mov    %edx,%eax
  1007a3:	01 c0                	add    %eax,%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	c1 e0 02             	shl    $0x2,%eax
  1007aa:	89 c2                	mov    %eax,%edx
  1007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007af:	01 d0                	add    %edx,%eax
  1007b1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b5:	3c 64                	cmp    $0x64,%al
  1007b7:	75 b3                	jne    10076c <debuginfo_eip+0x229>
  1007b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bc:	89 c2                	mov    %eax,%edx
  1007be:	89 d0                	mov    %edx,%eax
  1007c0:	01 c0                	add    %eax,%eax
  1007c2:	01 d0                	add    %edx,%eax
  1007c4:	c1 e0 02             	shl    $0x2,%eax
  1007c7:	89 c2                	mov    %eax,%edx
  1007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cc:	01 d0                	add    %edx,%eax
  1007ce:	8b 40 08             	mov    0x8(%eax),%eax
  1007d1:	85 c0                	test   %eax,%eax
  1007d3:	74 97                	je     10076c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007db:	39 c2                	cmp    %eax,%edx
  1007dd:	7c 46                	jl     100825 <debuginfo_eip+0x2e2>
  1007df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e2:	89 c2                	mov    %eax,%edx
  1007e4:	89 d0                	mov    %edx,%eax
  1007e6:	01 c0                	add    %eax,%eax
  1007e8:	01 d0                	add    %edx,%eax
  1007ea:	c1 e0 02             	shl    $0x2,%eax
  1007ed:	89 c2                	mov    %eax,%edx
  1007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f2:	01 d0                	add    %edx,%eax
  1007f4:	8b 10                	mov    (%eax),%edx
  1007f6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007fc:	29 c1                	sub    %eax,%ecx
  1007fe:	89 c8                	mov    %ecx,%eax
  100800:	39 c2                	cmp    %eax,%edx
  100802:	73 21                	jae    100825 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	89 c2                	mov    %eax,%edx
  100809:	89 d0                	mov    %edx,%eax
  10080b:	01 c0                	add    %eax,%eax
  10080d:	01 d0                	add    %edx,%eax
  10080f:	c1 e0 02             	shl    $0x2,%eax
  100812:	89 c2                	mov    %eax,%edx
  100814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100817:	01 d0                	add    %edx,%eax
  100819:	8b 10                	mov    (%eax),%edx
  10081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081e:	01 c2                	add    %eax,%edx
  100820:	8b 45 0c             	mov    0xc(%ebp),%eax
  100823:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100825:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100828:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10082b:	39 c2                	cmp    %eax,%edx
  10082d:	7d 4a                	jge    100879 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100832:	83 c0 01             	add    $0x1,%eax
  100835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100838:	eb 18                	jmp    100852 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10083a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083d:	8b 40 14             	mov    0x14(%eax),%eax
  100840:	8d 50 01             	lea    0x1(%eax),%edx
  100843:	8b 45 0c             	mov    0xc(%ebp),%eax
  100846:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084c:	83 c0 01             	add    $0x1,%eax
  10084f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100852:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100855:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100858:	39 c2                	cmp    %eax,%edx
  10085a:	7d 1d                	jge    100879 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10085c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	89 d0                	mov    %edx,%eax
  100863:	01 c0                	add    %eax,%eax
  100865:	01 d0                	add    %edx,%eax
  100867:	c1 e0 02             	shl    $0x2,%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086f:	01 d0                	add    %edx,%eax
  100871:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100875:	3c a0                	cmp    $0xa0,%al
  100877:	74 c1                	je     10083a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087e:	c9                   	leave  
  10087f:	c3                   	ret    

00100880 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100880:	55                   	push   %ebp
  100881:	89 e5                	mov    %esp,%ebp
  100883:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100886:	c7 04 24 f6 62 10 00 	movl   $0x1062f6,(%esp)
  10088d:	e8 b5 fa ff ff       	call   100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100892:	c7 44 24 04 2c 00 10 	movl   $0x10002c,0x4(%esp)
  100899:	00 
  10089a:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  1008a1:	e8 a1 fa ff ff       	call   100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a6:	c7 44 24 04 3b 62 10 	movl   $0x10623b,0x4(%esp)
  1008ad:	00 
  1008ae:	c7 04 24 27 63 10 00 	movl   $0x106327,(%esp)
  1008b5:	e8 8d fa ff ff       	call   100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008ba:	c7 44 24 04 38 8a 11 	movl   $0x118a38,0x4(%esp)
  1008c1:	00 
  1008c2:	c7 04 24 3f 63 10 00 	movl   $0x10633f,(%esp)
  1008c9:	e8 79 fa ff ff       	call   100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ce:	c7 44 24 04 88 99 11 	movl   $0x119988,0x4(%esp)
  1008d5:	00 
  1008d6:	c7 04 24 57 63 10 00 	movl   $0x106357,(%esp)
  1008dd:	e8 65 fa ff ff       	call   100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008e2:	b8 88 99 11 00       	mov    $0x119988,%eax
  1008e7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ed:	b8 2c 00 10 00       	mov    $0x10002c,%eax
  1008f2:	29 c2                	sub    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008fc:	85 c0                	test   %eax,%eax
  1008fe:	0f 48 c2             	cmovs  %edx,%eax
  100901:	c1 f8 0a             	sar    $0xa,%eax
  100904:	89 44 24 04          	mov    %eax,0x4(%esp)
  100908:	c7 04 24 70 63 10 00 	movl   $0x106370,(%esp)
  10090f:	e8 33 fa ff ff       	call   100347 <cprintf>
}
  100914:	c9                   	leave  
  100915:	c3                   	ret    

00100916 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100916:	55                   	push   %ebp
  100917:	89 e5                	mov    %esp,%ebp
  100919:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100922:	89 44 24 04          	mov    %eax,0x4(%esp)
  100926:	8b 45 08             	mov    0x8(%ebp),%eax
  100929:	89 04 24             	mov    %eax,(%esp)
  10092c:	e8 12 fc ff ff       	call   100543 <debuginfo_eip>
  100931:	85 c0                	test   %eax,%eax
  100933:	74 15                	je     10094a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100935:	8b 45 08             	mov    0x8(%ebp),%eax
  100938:	89 44 24 04          	mov    %eax,0x4(%esp)
  10093c:	c7 04 24 9a 63 10 00 	movl   $0x10639a,(%esp)
  100943:	e8 ff f9 ff ff       	call   100347 <cprintf>
  100948:	eb 6d                	jmp    1009b7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10094a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100951:	eb 1c                	jmp    10096f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100959:	01 d0                	add    %edx,%eax
  10095b:	0f b6 00             	movzbl (%eax),%eax
  10095e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100967:	01 ca                	add    %ecx,%edx
  100969:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10096b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100972:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100975:	7f dc                	jg     100953 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100977:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100980:	01 d0                	add    %edx,%eax
  100982:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100985:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100988:	8b 55 08             	mov    0x8(%ebp),%edx
  10098b:	89 d1                	mov    %edx,%ecx
  10098d:	29 c1                	sub    %eax,%ecx
  10098f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100992:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100995:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100999:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ab:	c7 04 24 b6 63 10 00 	movl   $0x1063b6,(%esp)
  1009b2:	e8 90 f9 ff ff       	call   100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b7:	c9                   	leave  
  1009b8:	c3                   	ret    

001009b9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b9:	55                   	push   %ebp
  1009ba:	89 e5                	mov    %esp,%ebp
  1009bc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bf:	8b 45 04             	mov    0x4(%ebp),%eax
  1009c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c8:	c9                   	leave  
  1009c9:	c3                   	ret    

001009ca <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ca:	55                   	push   %ebp
  1009cb:	89 e5                	mov    %esp,%ebp
  1009cd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009d0:	89 e8                	mov    %ebp,%eax
  1009d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
  1009d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
  1009db:	e8 d9 ff ff ff       	call   1009b9 <read_eip>
  1009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
  1009e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009ea:	e9 80 00 00 00       	jmp    100a6f <print_stackframe+0xa5>
		cprintf("ebp:0x%08x  eip:0x%08x arg:", ebp, eip);
  1009ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fd:	c7 04 24 c8 63 10 00 	movl   $0x1063c8,(%esp)
  100a04:	e8 3e f9 ff ff       	call   100347 <cprintf>

		int j;
		for (j=0;j<4;j++)
  100a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a10:	eb 26                	jmp    100a38 <print_stackframe+0x6e>
			cprintf("0x%08x ",*(uint32_t*)(ebp+4*j+8));
  100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a15:	c1 e0 02             	shl    $0x2,%eax
  100a18:	89 c2                	mov    %eax,%edx
  100a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1d:	01 d0                	add    %edx,%eax
  100a1f:	83 c0 08             	add    $0x8,%eax
  100a22:	8b 00                	mov    (%eax),%eax
  100a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a28:	c7 04 24 e4 63 10 00 	movl   $0x1063e4,(%esp)
  100a2f:	e8 13 f9 ff ff       	call   100347 <cprintf>
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
		cprintf("ebp:0x%08x  eip:0x%08x arg:", ebp, eip);

		int j;
		for (j=0;j<4;j++)
  100a34:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a38:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3c:	7e d4                	jle    100a12 <print_stackframe+0x48>
			cprintf("0x%08x ",*(uint32_t*)(ebp+4*j+8));
		cprintf("\n");
  100a3e:	c7 04 24 ec 63 10 00 	movl   $0x1063ec,(%esp)
  100a45:	e8 fd f8 ff ff       	call   100347 <cprintf>
		print_debuginfo(eip-1);
  100a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4d:	83 e8 01             	sub    $0x1,%eax
  100a50:	89 04 24             	mov    %eax,(%esp)
  100a53:	e8 be fe ff ff       	call   100916 <print_debuginfo>
		eip=*(uint32_t*)(ebp+4);
  100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5b:	83 c0 04             	add    $0x4,%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=*(uint32_t*)(ebp);
  100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a66:	8b 00                	mov    (%eax),%eax
  100a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
  100a6b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a73:	0f 8e 76 ff ff ff    	jle    1009ef <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip=*(uint32_t*)(ebp+4);
		ebp=*(uint32_t*)(ebp);
	}
}
  100a79:	c9                   	leave  
  100a7a:	c3                   	ret    
  100a7b:	90                   	nop

00100a7c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a7c:	55                   	push   %ebp
  100a7d:	89 e5                	mov    %esp,%ebp
  100a7f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a89:	eb 0d                	jmp    100a98 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
  100a8b:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8c:	eb 0a                	jmp    100a98 <parse+0x1c>
            *buf ++ = '\0';
  100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a91:	c6 00 00             	movb   $0x0,(%eax)
  100a94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a98:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9b:	0f b6 00             	movzbl (%eax),%eax
  100a9e:	84 c0                	test   %al,%al
  100aa0:	74 1d                	je     100abf <parse+0x43>
  100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa5:	0f b6 00             	movzbl (%eax),%eax
  100aa8:	0f be c0             	movsbl %al,%eax
  100aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aaf:	c7 04 24 70 64 10 00 	movl   $0x106470,(%esp)
  100ab6:	e8 0d 54 00 00       	call   105ec8 <strchr>
  100abb:	85 c0                	test   %eax,%eax
  100abd:	75 cf                	jne    100a8e <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abf:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac2:	0f b6 00             	movzbl (%eax),%eax
  100ac5:	84 c0                	test   %al,%al
  100ac7:	74 5e                	je     100b27 <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acd:	75 14                	jne    100ae3 <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad6:	00 
  100ad7:	c7 04 24 75 64 10 00 	movl   $0x106475,(%esp)
  100ade:	e8 64 f8 ff ff       	call   100347 <cprintf>
        }
        argv[argc ++] = buf;
  100ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae6:	c1 e0 02             	shl    $0x2,%eax
  100ae9:	03 45 0c             	add    0xc(%ebp),%eax
  100aec:	8b 55 08             	mov    0x8(%ebp),%edx
  100aef:	89 10                	mov    %edx,(%eax)
  100af1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af5:	eb 04                	jmp    100afb <parse+0x7f>
            buf ++;
  100af7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	8b 45 08             	mov    0x8(%ebp),%eax
  100afe:	0f b6 00             	movzbl (%eax),%eax
  100b01:	84 c0                	test   %al,%al
  100b03:	74 86                	je     100a8b <parse+0xf>
  100b05:	8b 45 08             	mov    0x8(%ebp),%eax
  100b08:	0f b6 00             	movzbl (%eax),%eax
  100b0b:	0f be c0             	movsbl %al,%eax
  100b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b12:	c7 04 24 70 64 10 00 	movl   $0x106470,(%esp)
  100b19:	e8 aa 53 00 00       	call   105ec8 <strchr>
  100b1e:	85 c0                	test   %eax,%eax
  100b20:	74 d5                	je     100af7 <parse+0x7b>
            buf ++;
        }
    }
  100b22:	e9 64 ff ff ff       	jmp    100a8b <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b27:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b2b:	c9                   	leave  
  100b2c:	c3                   	ret    

00100b2d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b2d:	55                   	push   %ebp
  100b2e:	89 e5                	mov    %esp,%ebp
  100b30:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b33:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3d:	89 04 24             	mov    %eax,(%esp)
  100b40:	e8 37 ff ff ff       	call   100a7c <parse>
  100b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b4c:	75 0a                	jne    100b58 <runcmd+0x2b>
        return 0;
  100b4e:	b8 00 00 00 00       	mov    $0x0,%eax
  100b53:	e9 85 00 00 00       	jmp    100bdd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b5f:	eb 5c                	jmp    100bbd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b61:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b67:	89 d0                	mov    %edx,%eax
  100b69:	01 c0                	add    %eax,%eax
  100b6b:	01 d0                	add    %edx,%eax
  100b6d:	c1 e0 02             	shl    $0x2,%eax
  100b70:	05 20 80 11 00       	add    $0x118020,%eax
  100b75:	8b 00                	mov    (%eax),%eax
  100b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b7b:	89 04 24             	mov    %eax,(%esp)
  100b7e:	e8 a0 52 00 00       	call   105e23 <strcmp>
  100b83:	85 c0                	test   %eax,%eax
  100b85:	75 32                	jne    100bb9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b8a:	89 d0                	mov    %edx,%eax
  100b8c:	01 c0                	add    %eax,%eax
  100b8e:	01 d0                	add    %edx,%eax
  100b90:	c1 e0 02             	shl    $0x2,%eax
  100b93:	05 20 80 11 00       	add    $0x118020,%eax
  100b98:	8b 50 08             	mov    0x8(%eax),%edx
  100b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b9e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  100ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ba4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ba8:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bab:	83 c0 04             	add    $0x4,%eax
  100bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb2:	89 0c 24             	mov    %ecx,(%esp)
  100bb5:	ff d2                	call   *%edx
  100bb7:	eb 24                	jmp    100bdd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc0:	83 f8 02             	cmp    $0x2,%eax
  100bc3:	76 9c                	jbe    100b61 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcc:	c7 04 24 93 64 10 00 	movl   $0x106493,(%esp)
  100bd3:	e8 6f f7 ff ff       	call   100347 <cprintf>
    return 0;
  100bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bdd:	c9                   	leave  
  100bde:	c3                   	ret    

00100bdf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bdf:	55                   	push   %ebp
  100be0:	89 e5                	mov    %esp,%ebp
  100be2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be5:	c7 04 24 ac 64 10 00 	movl   $0x1064ac,(%esp)
  100bec:	e8 56 f7 ff ff       	call   100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf1:	c7 04 24 d4 64 10 00 	movl   $0x1064d4,(%esp)
  100bf8:	e8 4a f7 ff ff       	call   100347 <cprintf>

    if (tf != NULL) {
  100bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c01:	74 0e                	je     100c11 <kmonitor+0x32>
        print_trapframe(tf);
  100c03:	8b 45 08             	mov    0x8(%ebp),%eax
  100c06:	89 04 24             	mov    %eax,(%esp)
  100c09:	e8 e2 0e 00 00       	call   101af0 <print_trapframe>
  100c0e:	eb 01                	jmp    100c11 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
  100c10:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c11:	c7 04 24 f9 64 10 00 	movl   $0x1064f9,(%esp)
  100c18:	e8 1b f6 ff ff       	call   100238 <readline>
  100c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c24:	74 ea                	je     100c10 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
  100c26:	8b 45 08             	mov    0x8(%ebp),%eax
  100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c30:	89 04 24             	mov    %eax,(%esp)
  100c33:	e8 f5 fe ff ff       	call   100b2d <runcmd>
  100c38:	85 c0                	test   %eax,%eax
  100c3a:	79 d4                	jns    100c10 <kmonitor+0x31>
                break;
  100c3c:	90                   	nop
            }
        }
    }
}
  100c3d:	c9                   	leave  
  100c3e:	c3                   	ret    

00100c3f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c3f:	55                   	push   %ebp
  100c40:	89 e5                	mov    %esp,%ebp
  100c42:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c4c:	eb 3f                	jmp    100c8d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c51:	89 d0                	mov    %edx,%eax
  100c53:	01 c0                	add    %eax,%eax
  100c55:	01 d0                	add    %edx,%eax
  100c57:	c1 e0 02             	shl    $0x2,%eax
  100c5a:	05 20 80 11 00       	add    $0x118020,%eax
  100c5f:	8b 48 04             	mov    0x4(%eax),%ecx
  100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c65:	89 d0                	mov    %edx,%eax
  100c67:	01 c0                	add    %eax,%eax
  100c69:	01 d0                	add    %edx,%eax
  100c6b:	c1 e0 02             	shl    $0x2,%eax
  100c6e:	05 20 80 11 00       	add    $0x118020,%eax
  100c73:	8b 00                	mov    (%eax),%eax
  100c75:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7d:	c7 04 24 fd 64 10 00 	movl   $0x1064fd,(%esp)
  100c84:	e8 be f6 ff ff       	call   100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c90:	83 f8 02             	cmp    $0x2,%eax
  100c93:	76 b9                	jbe    100c4e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca2:	e8 d9 fb ff ff       	call   100880 <print_kerninfo>
    return 0;
  100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cac:	c9                   	leave  
  100cad:	c3                   	ret    

00100cae <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cae:	55                   	push   %ebp
  100caf:	89 e5                	mov    %esp,%ebp
  100cb1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb4:	e8 11 fd ff ff       	call   1009ca <print_stackframe>
    return 0;
  100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbe:	c9                   	leave  
  100cbf:	c3                   	ret    

00100cc0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc0:	55                   	push   %ebp
  100cc1:	89 e5                	mov    %esp,%ebp
  100cc3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cc6:	a1 60 8e 11 00       	mov    0x118e60,%eax
  100ccb:	85 c0                	test   %eax,%eax
  100ccd:	75 4c                	jne    100d1b <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
  100ccf:	c7 05 60 8e 11 00 01 	movl   $0x1,0x118e60
  100cd6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cd9:	8d 55 14             	lea    0x14(%ebp),%edx
  100cdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100cdf:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cef:	c7 04 24 06 65 10 00 	movl   $0x106506,(%esp)
  100cf6:	e8 4c f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d02:	8b 45 10             	mov    0x10(%ebp),%eax
  100d05:	89 04 24             	mov    %eax,(%esp)
  100d08:	e8 07 f6 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d0d:	c7 04 24 22 65 10 00 	movl   $0x106522,(%esp)
  100d14:	e8 2e f6 ff ff       	call   100347 <cprintf>
  100d19:	eb 01                	jmp    100d1c <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100d1b:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100d1c:	e8 31 0a 00 00       	call   101752 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d28:	e8 b2 fe ff ff       	call   100bdf <kmonitor>
    }
  100d2d:	eb f2                	jmp    100d21 <__panic+0x61>

00100d2f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d2f:	55                   	push   %ebp
  100d30:	89 e5                	mov    %esp,%ebp
  100d32:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d35:	8d 55 14             	lea    0x14(%ebp),%edx
  100d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100d3b:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d44:	8b 45 08             	mov    0x8(%ebp),%eax
  100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4b:	c7 04 24 24 65 10 00 	movl   $0x106524,(%esp)
  100d52:	e8 f0 f5 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5e:	8b 45 10             	mov    0x10(%ebp),%eax
  100d61:	89 04 24             	mov    %eax,(%esp)
  100d64:	e8 ab f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d69:	c7 04 24 22 65 10 00 	movl   $0x106522,(%esp)
  100d70:	e8 d2 f5 ff ff       	call   100347 <cprintf>
    va_end(ap);
}
  100d75:	c9                   	leave  
  100d76:	c3                   	ret    

00100d77 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d77:	55                   	push   %ebp
  100d78:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7a:	a1 60 8e 11 00       	mov    0x118e60,%eax
}
  100d7f:	5d                   	pop    %ebp
  100d80:	c3                   	ret    
  100d81:	66 90                	xchg   %ax,%ax
  100d83:	90                   	nop

00100d84 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d84:	55                   	push   %ebp
  100d85:	89 e5                	mov    %esp,%ebp
  100d87:	83 ec 28             	sub    $0x28,%esp
  100d8a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d90:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d94:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d98:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9c:	ee                   	out    %al,(%dx)
  100d9d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100daf:	ee                   	out    %al,(%dx)
  100db0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dba:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc3:	c7 05 6c 99 11 00 00 	movl   $0x0,0x11996c
  100dca:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcd:	c7 04 24 42 65 10 00 	movl   $0x106542,(%esp)
  100dd4:	e8 6e f5 ff ff       	call   100347 <cprintf>
    pic_enable(IRQ_TIMER);
  100dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de0:	e8 cb 09 00 00       	call   1017b0 <pic_enable>
}
  100de5:	c9                   	leave  
  100de6:	c3                   	ret    
  100de7:	90                   	nop

00100de8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de8:	55                   	push   %ebp
  100de9:	89 e5                	mov    %esp,%ebp
  100deb:	53                   	push   %ebx
  100dec:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100def:	9c                   	pushf  
  100df0:	5b                   	pop    %ebx
  100df1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
  100df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df7:	25 00 02 00 00       	and    $0x200,%eax
  100dfc:	85 c0                	test   %eax,%eax
  100dfe:	74 0c                	je     100e0c <__intr_save+0x24>
        intr_disable();
  100e00:	e8 4d 09 00 00       	call   101752 <intr_disable>
        return 1;
  100e05:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0a:	eb 05                	jmp    100e11 <__intr_save+0x29>
    }
    return 0;
  100e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e11:	83 c4 14             	add    $0x14,%esp
  100e14:	5b                   	pop    %ebx
  100e15:	5d                   	pop    %ebp
  100e16:	c3                   	ret    

00100e17 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e17:	55                   	push   %ebp
  100e18:	89 e5                	mov    %esp,%ebp
  100e1a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e21:	74 05                	je     100e28 <__intr_restore+0x11>
        intr_enable();
  100e23:	e8 24 09 00 00       	call   10174c <intr_enable>
    }
}
  100e28:	c9                   	leave  
  100e29:	c3                   	ret    

00100e2a <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e2a:	55                   	push   %ebp
  100e2b:	89 e5                	mov    %esp,%ebp
  100e2d:	53                   	push   %ebx
  100e2e:	83 ec 14             	sub    $0x14,%esp
  100e31:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e3b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e43:	ec                   	in     (%dx),%al
  100e44:	89 c3                	mov    %eax,%ebx
  100e46:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
  100e49:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e4f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e53:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	89 c3                	mov    %eax,%ebx
  100e5e:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e67:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e6b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e6f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e73:	ec                   	in     (%dx),%al
  100e74:	89 c3                	mov    %eax,%ebx
  100e76:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  100e79:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e7f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e83:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e87:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e8b:	ec                   	in     (%dx),%al
  100e8c:	89 c3                	mov    %eax,%ebx
  100e8e:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e91:	83 c4 14             	add    $0x14,%esp
  100e94:	5b                   	pop    %ebx
  100e95:	5d                   	pop    %ebp
  100e96:	c3                   	ret    

00100e97 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e97:	55                   	push   %ebp
  100e98:	89 e5                	mov    %esp,%ebp
  100e9a:	53                   	push   %ebx
  100e9b:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e9e:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
  100ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100ea8:	0f b7 00             	movzwl (%eax),%eax
  100eab:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
  100eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100eb2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100eba:	0f b7 00             	movzwl (%eax),%eax
  100ebd:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ec1:	74 12                	je     100ed5 <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ec3:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
  100eca:	66 c7 05 86 8e 11 00 	movw   $0x3b4,0x118e86
  100ed1:	b4 03 
  100ed3:	eb 13                	jmp    100ee8 <cga_init+0x51>
    } else {
        *cp = was;
  100ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100ed8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100edc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100edf:	66 c7 05 86 8e 11 00 	movw   $0x3d4,0x118e86
  100ee6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ee8:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100eef:	0f b7 c0             	movzwl %ax,%eax
  100ef2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ef6:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100efa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f02:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100f03:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100f0a:	83 c0 01             	add    $0x1,%eax
  100f0d:	0f b7 c0             	movzwl %ax,%eax
  100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f14:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f18:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100f1c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f20:	ec                   	in     (%dx),%al
  100f21:	89 c3                	mov    %eax,%ebx
  100f23:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
  100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f2a:	0f b6 c0             	movzbl %al,%eax
  100f2d:	c1 e0 08             	shl    $0x8,%eax
  100f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
  100f33:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100f3a:	0f b7 c0             	movzwl %ax,%eax
  100f3d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f41:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f4e:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100f55:	83 c0 01             	add    $0x1,%eax
  100f58:	0f b7 c0             	movzwl %ax,%eax
  100f5b:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f5f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f63:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100f67:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f6b:	ec                   	in     (%dx),%al
  100f6c:	89 c3                	mov    %eax,%ebx
  100f6e:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
  100f71:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f75:	0f b6 c0             	movzbl %al,%eax
  100f78:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
  100f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f7e:	a3 80 8e 11 00       	mov    %eax,0x118e80
    crt_pos = pos;
  100f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100f86:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
}
  100f8c:	83 c4 24             	add    $0x24,%esp
  100f8f:	5b                   	pop    %ebx
  100f90:	5d                   	pop    %ebp
  100f91:	c3                   	ret    

00100f92 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f92:	55                   	push   %ebp
  100f93:	89 e5                	mov    %esp,%ebp
  100f95:	53                   	push   %ebx
  100f96:	83 ec 54             	sub    $0x54,%esp
  100f99:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f9f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fa3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fa7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fab:	ee                   	out    %al,(%dx)
  100fac:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100fb2:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100fb6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fbe:	ee                   	out    %al,(%dx)
  100fbf:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100fc5:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fd1:	ee                   	out    %al,(%dx)
  100fd2:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fd8:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fdc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fe0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fe4:	ee                   	out    %al,(%dx)
  100fe5:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100feb:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fef:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ff3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ff7:	ee                   	out    %al,(%dx)
  100ff8:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100ffe:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  101002:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101006:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10100a:	ee                   	out    %al,(%dx)
  10100b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101011:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  101015:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101019:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10101d:	ee                   	out    %al,(%dx)
  10101e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101024:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101028:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  10102c:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101030:	ec                   	in     (%dx),%al
  101031:	89 c3                	mov    %eax,%ebx
  101033:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
  101036:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10103a:	3c ff                	cmp    $0xff,%al
  10103c:	0f 95 c0             	setne  %al
  10103f:	0f b6 c0             	movzbl %al,%eax
  101042:	a3 88 8e 11 00       	mov    %eax,0x118e88
  101047:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10104d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101051:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101055:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101059:	ec                   	in     (%dx),%al
  10105a:	89 c3                	mov    %eax,%ebx
  10105c:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
  10105f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101065:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101069:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  10106d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101071:	ec                   	in     (%dx),%al
  101072:	89 c3                	mov    %eax,%ebx
  101074:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101077:	a1 88 8e 11 00       	mov    0x118e88,%eax
  10107c:	85 c0                	test   %eax,%eax
  10107e:	74 0c                	je     10108c <serial_init+0xfa>
        pic_enable(IRQ_COM1);
  101080:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101087:	e8 24 07 00 00       	call   1017b0 <pic_enable>
    }
}
  10108c:	83 c4 54             	add    $0x54,%esp
  10108f:	5b                   	pop    %ebx
  101090:	5d                   	pop    %ebp
  101091:	c3                   	ret    

00101092 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101092:	55                   	push   %ebp
  101093:	89 e5                	mov    %esp,%ebp
  101095:	53                   	push   %ebx
  101096:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101099:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  1010a0:	eb 09                	jmp    1010ab <lpt_putc_sub+0x19>
        delay();
  1010a2:	e8 83 fd ff ff       	call   100e2a <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010a7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  1010ab:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
  1010b1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010b5:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  1010b9:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1010bd:	ec                   	in     (%dx),%al
  1010be:	89 c3                	mov    %eax,%ebx
  1010c0:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  1010c3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010c7:	84 c0                	test   %al,%al
  1010c9:	78 09                	js     1010d4 <lpt_putc_sub+0x42>
  1010cb:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  1010d2:	7e ce                	jle    1010a2 <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
  1010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d7:	0f b6 c0             	movzbl %al,%eax
  1010da:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
  1010e0:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010e3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010e7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010eb:	ee                   	out    %al,(%dx)
  1010ec:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010f2:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
  1010f6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010fa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010fe:	ee                   	out    %al,(%dx)
  1010ff:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
  101105:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
  101109:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10110d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101111:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101112:	83 c4 24             	add    $0x24,%esp
  101115:	5b                   	pop    %ebx
  101116:	5d                   	pop    %ebp
  101117:	c3                   	ret    

00101118 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101118:	55                   	push   %ebp
  101119:	89 e5                	mov    %esp,%ebp
  10111b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10111e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101122:	74 0d                	je     101131 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101124:	8b 45 08             	mov    0x8(%ebp),%eax
  101127:	89 04 24             	mov    %eax,(%esp)
  10112a:	e8 63 ff ff ff       	call   101092 <lpt_putc_sub>
  10112f:	eb 24                	jmp    101155 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101131:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101138:	e8 55 ff ff ff       	call   101092 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10113d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101144:	e8 49 ff ff ff       	call   101092 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101149:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101150:	e8 3d ff ff ff       	call   101092 <lpt_putc_sub>
    }
}
  101155:	c9                   	leave  
  101156:	c3                   	ret    

00101157 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101157:	55                   	push   %ebp
  101158:	89 e5                	mov    %esp,%ebp
  10115a:	53                   	push   %ebx
  10115b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10115e:	8b 45 08             	mov    0x8(%ebp),%eax
  101161:	b0 00                	mov    $0x0,%al
  101163:	85 c0                	test   %eax,%eax
  101165:	75 07                	jne    10116e <cga_putc+0x17>
        c |= 0x0700;
  101167:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10116e:	8b 45 08             	mov    0x8(%ebp),%eax
  101171:	25 ff 00 00 00       	and    $0xff,%eax
  101176:	83 f8 0a             	cmp    $0xa,%eax
  101179:	74 4e                	je     1011c9 <cga_putc+0x72>
  10117b:	83 f8 0d             	cmp    $0xd,%eax
  10117e:	74 59                	je     1011d9 <cga_putc+0x82>
  101180:	83 f8 08             	cmp    $0x8,%eax
  101183:	0f 85 8c 00 00 00    	jne    101215 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  101189:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101190:	66 85 c0             	test   %ax,%ax
  101193:	0f 84 a1 00 00 00    	je     10123a <cga_putc+0xe3>
            crt_pos --;
  101199:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1011a0:	83 e8 01             	sub    $0x1,%eax
  1011a3:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011a9:	a1 80 8e 11 00       	mov    0x118e80,%eax
  1011ae:	0f b7 15 84 8e 11 00 	movzwl 0x118e84,%edx
  1011b5:	0f b7 d2             	movzwl %dx,%edx
  1011b8:	01 d2                	add    %edx,%edx
  1011ba:	01 c2                	add    %eax,%edx
  1011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1011bf:	b0 00                	mov    $0x0,%al
  1011c1:	83 c8 20             	or     $0x20,%eax
  1011c4:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011c7:	eb 71                	jmp    10123a <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
  1011c9:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1011d0:	83 c0 50             	add    $0x50,%eax
  1011d3:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011d9:	0f b7 1d 84 8e 11 00 	movzwl 0x118e84,%ebx
  1011e0:	0f b7 0d 84 8e 11 00 	movzwl 0x118e84,%ecx
  1011e7:	0f b7 c1             	movzwl %cx,%eax
  1011ea:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011f0:	c1 e8 10             	shr    $0x10,%eax
  1011f3:	89 c2                	mov    %eax,%edx
  1011f5:	66 c1 ea 06          	shr    $0x6,%dx
  1011f9:	89 d0                	mov    %edx,%eax
  1011fb:	c1 e0 02             	shl    $0x2,%eax
  1011fe:	01 d0                	add    %edx,%eax
  101200:	c1 e0 04             	shl    $0x4,%eax
  101203:	89 ca                	mov    %ecx,%edx
  101205:	66 29 c2             	sub    %ax,%dx
  101208:	89 d8                	mov    %ebx,%eax
  10120a:	66 29 d0             	sub    %dx,%ax
  10120d:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
        break;
  101213:	eb 26                	jmp    10123b <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101215:	8b 15 80 8e 11 00    	mov    0x118e80,%edx
  10121b:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101222:	0f b7 c8             	movzwl %ax,%ecx
  101225:	01 c9                	add    %ecx,%ecx
  101227:	01 d1                	add    %edx,%ecx
  101229:	8b 55 08             	mov    0x8(%ebp),%edx
  10122c:	66 89 11             	mov    %dx,(%ecx)
  10122f:	83 c0 01             	add    $0x1,%eax
  101232:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
        break;
  101238:	eb 01                	jmp    10123b <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  10123a:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10123b:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101242:	66 3d cf 07          	cmp    $0x7cf,%ax
  101246:	76 5b                	jbe    1012a3 <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101248:	a1 80 8e 11 00       	mov    0x118e80,%eax
  10124d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101253:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101258:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10125f:	00 
  101260:	89 54 24 04          	mov    %edx,0x4(%esp)
  101264:	89 04 24             	mov    %eax,(%esp)
  101267:	e8 62 4e 00 00       	call   1060ce <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10126c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101273:	eb 15                	jmp    10128a <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
  101275:	a1 80 8e 11 00       	mov    0x118e80,%eax
  10127a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10127d:	01 d2                	add    %edx,%edx
  10127f:	01 d0                	add    %edx,%eax
  101281:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101286:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10128a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101291:	7e e2                	jle    101275 <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101293:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  10129a:	83 e8 50             	sub    $0x50,%eax
  10129d:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012a3:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  1012aa:	0f b7 c0             	movzwl %ax,%eax
  1012ad:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1012b1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1012b5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012b9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1012be:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1012c5:	66 c1 e8 08          	shr    $0x8,%ax
  1012c9:	0f b6 c0             	movzbl %al,%eax
  1012cc:	0f b7 15 86 8e 11 00 	movzwl 0x118e86,%edx
  1012d3:	83 c2 01             	add    $0x1,%edx
  1012d6:	0f b7 d2             	movzwl %dx,%edx
  1012d9:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012dd:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012e0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012e8:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012e9:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  1012f0:	0f b7 c0             	movzwl %ax,%eax
  1012f3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012f7:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012fb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101303:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101304:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  10130b:	0f b6 c0             	movzbl %al,%eax
  10130e:	0f b7 15 86 8e 11 00 	movzwl 0x118e86,%edx
  101315:	83 c2 01             	add    $0x1,%edx
  101318:	0f b7 d2             	movzwl %dx,%edx
  10131b:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10131f:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101322:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101326:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10132a:	ee                   	out    %al,(%dx)
}
  10132b:	83 c4 34             	add    $0x34,%esp
  10132e:	5b                   	pop    %ebx
  10132f:	5d                   	pop    %ebp
  101330:	c3                   	ret    

00101331 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101331:	55                   	push   %ebp
  101332:	89 e5                	mov    %esp,%ebp
  101334:	53                   	push   %ebx
  101335:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  10133f:	eb 09                	jmp    10134a <serial_putc_sub+0x19>
        delay();
  101341:	e8 e4 fa ff ff       	call   100e2a <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101346:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  10134a:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101350:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101354:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101358:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10135c:	ec                   	in     (%dx),%al
  10135d:	89 c3                	mov    %eax,%ebx
  10135f:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  101362:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101366:	0f b6 c0             	movzbl %al,%eax
  101369:	83 e0 20             	and    $0x20,%eax
  10136c:	85 c0                	test   %eax,%eax
  10136e:	75 09                	jne    101379 <serial_putc_sub+0x48>
  101370:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  101377:	7e c8                	jle    101341 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101379:	8b 45 08             	mov    0x8(%ebp),%eax
  10137c:	0f b6 c0             	movzbl %al,%eax
  10137f:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  101385:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101388:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10138c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101390:	ee                   	out    %al,(%dx)
}
  101391:	83 c4 14             	add    $0x14,%esp
  101394:	5b                   	pop    %ebx
  101395:	5d                   	pop    %ebp
  101396:	c3                   	ret    

00101397 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101397:	55                   	push   %ebp
  101398:	89 e5                	mov    %esp,%ebp
  10139a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10139d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013a1:	74 0d                	je     1013b0 <serial_putc+0x19>
        serial_putc_sub(c);
  1013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1013a6:	89 04 24             	mov    %eax,(%esp)
  1013a9:	e8 83 ff ff ff       	call   101331 <serial_putc_sub>
  1013ae:	eb 24                	jmp    1013d4 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1013b0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b7:	e8 75 ff ff ff       	call   101331 <serial_putc_sub>
        serial_putc_sub(' ');
  1013bc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013c3:	e8 69 ff ff ff       	call   101331 <serial_putc_sub>
        serial_putc_sub('\b');
  1013c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013cf:	e8 5d ff ff ff       	call   101331 <serial_putc_sub>
    }
}
  1013d4:	c9                   	leave  
  1013d5:	c3                   	ret    

001013d6 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013d6:	55                   	push   %ebp
  1013d7:	89 e5                	mov    %esp,%ebp
  1013d9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013dc:	eb 32                	jmp    101410 <cons_intr+0x3a>
        if (c != 0) {
  1013de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013e2:	74 2c                	je     101410 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
  1013e4:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  1013e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013ec:	88 90 a0 8e 11 00    	mov    %dl,0x118ea0(%eax)
  1013f2:	83 c0 01             	add    $0x1,%eax
  1013f5:	a3 a4 90 11 00       	mov    %eax,0x1190a4
            if (cons.wpos == CONSBUFSIZE) {
  1013fa:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  1013ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  101404:	75 0a                	jne    101410 <cons_intr+0x3a>
                cons.wpos = 0;
  101406:	c7 05 a4 90 11 00 00 	movl   $0x0,0x1190a4
  10140d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101410:	8b 45 08             	mov    0x8(%ebp),%eax
  101413:	ff d0                	call   *%eax
  101415:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101418:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10141c:	75 c0                	jne    1013de <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10141e:	c9                   	leave  
  10141f:	c3                   	ret    

00101420 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101420:	55                   	push   %ebp
  101421:	89 e5                	mov    %esp,%ebp
  101423:	53                   	push   %ebx
  101424:	83 ec 14             	sub    $0x14,%esp
  101427:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101431:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101435:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101439:	ec                   	in     (%dx),%al
  10143a:	89 c3                	mov    %eax,%ebx
  10143c:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10143f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101443:	0f b6 c0             	movzbl %al,%eax
  101446:	83 e0 01             	and    $0x1,%eax
  101449:	85 c0                	test   %eax,%eax
  10144b:	75 07                	jne    101454 <serial_proc_data+0x34>
        return -1;
  10144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101452:	eb 32                	jmp    101486 <serial_proc_data+0x66>
  101454:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10145a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10145e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101462:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101466:	ec                   	in     (%dx),%al
  101467:	89 c3                	mov    %eax,%ebx
  101469:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  10146c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101470:	0f b6 c0             	movzbl %al,%eax
  101473:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
  101476:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
  10147a:	75 07                	jne    101483 <serial_proc_data+0x63>
        c = '\b';
  10147c:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
  101483:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  101486:	83 c4 14             	add    $0x14,%esp
  101489:	5b                   	pop    %ebx
  10148a:	5d                   	pop    %ebp
  10148b:	c3                   	ret    

0010148c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10148c:	55                   	push   %ebp
  10148d:	89 e5                	mov    %esp,%ebp
  10148f:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101492:	a1 88 8e 11 00       	mov    0x118e88,%eax
  101497:	85 c0                	test   %eax,%eax
  101499:	74 0c                	je     1014a7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10149b:	c7 04 24 20 14 10 00 	movl   $0x101420,(%esp)
  1014a2:	e8 2f ff ff ff       	call   1013d6 <cons_intr>
    }
}
  1014a7:	c9                   	leave  
  1014a8:	c3                   	ret    

001014a9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014a9:	55                   	push   %ebp
  1014aa:	89 e5                	mov    %esp,%ebp
  1014ac:	53                   	push   %ebx
  1014ad:	83 ec 44             	sub    $0x44,%esp
  1014b0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014b6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1014ba:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  1014be:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1014c2:	ec                   	in     (%dx),%al
  1014c3:	89 c3                	mov    %eax,%ebx
  1014c5:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
  1014c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014cc:	0f b6 c0             	movzbl %al,%eax
  1014cf:	83 e0 01             	and    $0x1,%eax
  1014d2:	85 c0                	test   %eax,%eax
  1014d4:	75 0a                	jne    1014e0 <kbd_proc_data+0x37>
        return -1;
  1014d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014db:	e9 61 01 00 00       	jmp    101641 <kbd_proc_data+0x198>
  1014e0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014e6:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1014ea:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  1014ee:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1014f2:	ec                   	in     (%dx),%al
  1014f3:	89 c3                	mov    %eax,%ebx
  1014f5:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
  1014f8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014fc:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014ff:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101503:	75 17                	jne    10151c <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
  101505:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10150a:	83 c8 40             	or     $0x40,%eax
  10150d:	a3 a8 90 11 00       	mov    %eax,0x1190a8
        return 0;
  101512:	b8 00 00 00 00       	mov    $0x0,%eax
  101517:	e9 25 01 00 00       	jmp    101641 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
  10151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101520:	84 c0                	test   %al,%al
  101522:	79 47                	jns    10156b <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101524:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101529:	83 e0 40             	and    $0x40,%eax
  10152c:	85 c0                	test   %eax,%eax
  10152e:	75 09                	jne    101539 <kbd_proc_data+0x90>
  101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101534:	83 e0 7f             	and    $0x7f,%eax
  101537:	eb 04                	jmp    10153d <kbd_proc_data+0x94>
  101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10153d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101540:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101544:	0f b6 80 60 80 11 00 	movzbl 0x118060(%eax),%eax
  10154b:	83 c8 40             	or     $0x40,%eax
  10154e:	0f b6 c0             	movzbl %al,%eax
  101551:	f7 d0                	not    %eax
  101553:	89 c2                	mov    %eax,%edx
  101555:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10155a:	21 d0                	and    %edx,%eax
  10155c:	a3 a8 90 11 00       	mov    %eax,0x1190a8
        return 0;
  101561:	b8 00 00 00 00       	mov    $0x0,%eax
  101566:	e9 d6 00 00 00       	jmp    101641 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
  10156b:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101570:	83 e0 40             	and    $0x40,%eax
  101573:	85 c0                	test   %eax,%eax
  101575:	74 11                	je     101588 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101577:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10157b:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101580:	83 e0 bf             	and    $0xffffffbf,%eax
  101583:	a3 a8 90 11 00       	mov    %eax,0x1190a8
    }

    shift |= shiftcode[data];
  101588:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158c:	0f b6 80 60 80 11 00 	movzbl 0x118060(%eax),%eax
  101593:	0f b6 d0             	movzbl %al,%edx
  101596:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10159b:	09 d0                	or     %edx,%eax
  10159d:	a3 a8 90 11 00       	mov    %eax,0x1190a8
    shift ^= togglecode[data];
  1015a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a6:	0f b6 80 60 81 11 00 	movzbl 0x118160(%eax),%eax
  1015ad:	0f b6 d0             	movzbl %al,%edx
  1015b0:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1015b5:	31 d0                	xor    %edx,%eax
  1015b7:	a3 a8 90 11 00       	mov    %eax,0x1190a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1015bc:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1015c1:	83 e0 03             	and    $0x3,%eax
  1015c4:	8b 14 85 60 85 11 00 	mov    0x118560(,%eax,4),%edx
  1015cb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015cf:	01 d0                	add    %edx,%eax
  1015d1:	0f b6 00             	movzbl (%eax),%eax
  1015d4:	0f b6 c0             	movzbl %al,%eax
  1015d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015da:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1015df:	83 e0 08             	and    $0x8,%eax
  1015e2:	85 c0                	test   %eax,%eax
  1015e4:	74 22                	je     101608 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
  1015e6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015ea:	7e 0c                	jle    1015f8 <kbd_proc_data+0x14f>
  1015ec:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015f0:	7f 06                	jg     1015f8 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
  1015f2:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015f6:	eb 10                	jmp    101608 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
  1015f8:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015fc:	7e 0a                	jle    101608 <kbd_proc_data+0x15f>
  1015fe:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101602:	7f 04                	jg     101608 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
  101604:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101608:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10160d:	f7 d0                	not    %eax
  10160f:	83 e0 06             	and    $0x6,%eax
  101612:	85 c0                	test   %eax,%eax
  101614:	75 28                	jne    10163e <kbd_proc_data+0x195>
  101616:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10161d:	75 1f                	jne    10163e <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
  10161f:	c7 04 24 5d 65 10 00 	movl   $0x10655d,(%esp)
  101626:	e8 1c ed ff ff       	call   100347 <cprintf>
  10162b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101631:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101635:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101639:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10163d:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101641:	83 c4 44             	add    $0x44,%esp
  101644:	5b                   	pop    %ebx
  101645:	5d                   	pop    %ebp
  101646:	c3                   	ret    

00101647 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101647:	55                   	push   %ebp
  101648:	89 e5                	mov    %esp,%ebp
  10164a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10164d:	c7 04 24 a9 14 10 00 	movl   $0x1014a9,(%esp)
  101654:	e8 7d fd ff ff       	call   1013d6 <cons_intr>
}
  101659:	c9                   	leave  
  10165a:	c3                   	ret    

0010165b <kbd_init>:

static void
kbd_init(void) {
  10165b:	55                   	push   %ebp
  10165c:	89 e5                	mov    %esp,%ebp
  10165e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101661:	e8 e1 ff ff ff       	call   101647 <kbd_intr>
    pic_enable(IRQ_KBD);
  101666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10166d:	e8 3e 01 00 00       	call   1017b0 <pic_enable>
}
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
  101677:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10167a:	e8 18 f8 ff ff       	call   100e97 <cga_init>
    serial_init();
  10167f:	e8 0e f9 ff ff       	call   100f92 <serial_init>
    kbd_init();
  101684:	e8 d2 ff ff ff       	call   10165b <kbd_init>
    if (!serial_exists) {
  101689:	a1 88 8e 11 00       	mov    0x118e88,%eax
  10168e:	85 c0                	test   %eax,%eax
  101690:	75 0c                	jne    10169e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101692:	c7 04 24 69 65 10 00 	movl   $0x106569,(%esp)
  101699:	e8 a9 ec ff ff       	call   100347 <cprintf>
    }
}
  10169e:	c9                   	leave  
  10169f:	c3                   	ret    

001016a0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016a0:	55                   	push   %ebp
  1016a1:	89 e5                	mov    %esp,%ebp
  1016a3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016a6:	e8 3d f7 ff ff       	call   100de8 <__intr_save>
  1016ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b1:	89 04 24             	mov    %eax,(%esp)
  1016b4:	e8 5f fa ff ff       	call   101118 <lpt_putc>
        cga_putc(c);
  1016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bc:	89 04 24             	mov    %eax,(%esp)
  1016bf:	e8 93 fa ff ff       	call   101157 <cga_putc>
        serial_putc(c);
  1016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c7:	89 04 24             	mov    %eax,(%esp)
  1016ca:	e8 c8 fc ff ff       	call   101397 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016d2:	89 04 24             	mov    %eax,(%esp)
  1016d5:	e8 3d f7 ff ff       	call   100e17 <__intr_restore>
}
  1016da:	c9                   	leave  
  1016db:	c3                   	ret    

001016dc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016dc:	55                   	push   %ebp
  1016dd:	89 e5                	mov    %esp,%ebp
  1016df:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016e9:	e8 fa f6 ff ff       	call   100de8 <__intr_save>
  1016ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016f1:	e8 96 fd ff ff       	call   10148c <serial_intr>
        kbd_intr();
  1016f6:	e8 4c ff ff ff       	call   101647 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016fb:	8b 15 a0 90 11 00    	mov    0x1190a0,%edx
  101701:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  101706:	39 c2                	cmp    %eax,%edx
  101708:	74 30                	je     10173a <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
  10170a:	a1 a0 90 11 00       	mov    0x1190a0,%eax
  10170f:	0f b6 90 a0 8e 11 00 	movzbl 0x118ea0(%eax),%edx
  101716:	0f b6 d2             	movzbl %dl,%edx
  101719:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10171c:	83 c0 01             	add    $0x1,%eax
  10171f:	a3 a0 90 11 00       	mov    %eax,0x1190a0
            if (cons.rpos == CONSBUFSIZE) {
  101724:	a1 a0 90 11 00       	mov    0x1190a0,%eax
  101729:	3d 00 02 00 00       	cmp    $0x200,%eax
  10172e:	75 0a                	jne    10173a <cons_getc+0x5e>
                cons.rpos = 0;
  101730:	c7 05 a0 90 11 00 00 	movl   $0x0,0x1190a0
  101737:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10173d:	89 04 24             	mov    %eax,(%esp)
  101740:	e8 d2 f6 ff ff       	call   100e17 <__intr_restore>
    return c;
  101745:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101748:	c9                   	leave  
  101749:	c3                   	ret    
  10174a:	66 90                	xchg   %ax,%ax

0010174c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10174c:	55                   	push   %ebp
  10174d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  10174f:	fb                   	sti    
    sti();
}
  101750:	5d                   	pop    %ebp
  101751:	c3                   	ret    

00101752 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101752:	55                   	push   %ebp
  101753:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101755:	fa                   	cli    
    cli();
}
  101756:	5d                   	pop    %ebp
  101757:	c3                   	ret    

00101758 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101758:	55                   	push   %ebp
  101759:	89 e5                	mov    %esp,%ebp
  10175b:	83 ec 14             	sub    $0x14,%esp
  10175e:	8b 45 08             	mov    0x8(%ebp),%eax
  101761:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101765:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101769:	66 a3 70 85 11 00    	mov    %ax,0x118570
    if (did_init) {
  10176f:	a1 ac 90 11 00       	mov    0x1190ac,%eax
  101774:	85 c0                	test   %eax,%eax
  101776:	74 36                	je     1017ae <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101778:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10177c:	0f b6 c0             	movzbl %al,%eax
  10177f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101785:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101788:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10178c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101791:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101795:	66 c1 e8 08          	shr    $0x8,%ax
  101799:	0f b6 c0             	movzbl %al,%eax
  10179c:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1017a2:	88 45 f9             	mov    %al,-0x7(%ebp)
  1017a5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017a9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017ad:	ee                   	out    %al,(%dx)
    }
}
  1017ae:	c9                   	leave  
  1017af:	c3                   	ret    

001017b0 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017b0:	55                   	push   %ebp
  1017b1:	89 e5                	mov    %esp,%ebp
  1017b3:	53                   	push   %ebx
  1017b4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1017ba:	ba 01 00 00 00       	mov    $0x1,%edx
  1017bf:	89 d3                	mov    %edx,%ebx
  1017c1:	89 c1                	mov    %eax,%ecx
  1017c3:	d3 e3                	shl    %cl,%ebx
  1017c5:	89 d8                	mov    %ebx,%eax
  1017c7:	89 c2                	mov    %eax,%edx
  1017c9:	f7 d2                	not    %edx
  1017cb:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  1017d2:	21 d0                	and    %edx,%eax
  1017d4:	0f b7 c0             	movzwl %ax,%eax
  1017d7:	89 04 24             	mov    %eax,(%esp)
  1017da:	e8 79 ff ff ff       	call   101758 <pic_setmask>
}
  1017df:	83 c4 04             	add    $0x4,%esp
  1017e2:	5b                   	pop    %ebx
  1017e3:	5d                   	pop    %ebp
  1017e4:	c3                   	ret    

001017e5 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017e5:	55                   	push   %ebp
  1017e6:	89 e5                	mov    %esp,%ebp
  1017e8:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017eb:	c7 05 ac 90 11 00 01 	movl   $0x1,0x1190ac
  1017f2:	00 00 00 
  1017f5:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1017fb:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1017ff:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101803:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101807:	ee                   	out    %al,(%dx)
  101808:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10180e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101812:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101816:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10181a:	ee                   	out    %al,(%dx)
  10181b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101821:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101825:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101829:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
  10182e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101834:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101838:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10183c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
  101841:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101847:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10184b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10184f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
  101854:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10185a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10185e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101862:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101866:	ee                   	out    %al,(%dx)
  101867:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10186d:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101871:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101875:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101879:	ee                   	out    %al,(%dx)
  10187a:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101880:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101884:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101888:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10188c:	ee                   	out    %al,(%dx)
  10188d:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101893:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101897:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10189b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10189f:	ee                   	out    %al,(%dx)
  1018a0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1018a6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1018aa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1018ae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1018b2:	ee                   	out    %al,(%dx)
  1018b3:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1018b9:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1018bd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1018c1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1018c5:	ee                   	out    %al,(%dx)
  1018c6:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1018cc:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1018d0:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1018d4:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1018d8:	ee                   	out    %al,(%dx)
  1018d9:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1018df:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1018e3:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1018e7:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1018eb:	ee                   	out    %al,(%dx)
  1018ec:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1018f2:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1018f6:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1018fa:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1018fe:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018ff:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  101906:	66 83 f8 ff          	cmp    $0xffff,%ax
  10190a:	74 12                	je     10191e <pic_init+0x139>
        pic_setmask(irq_mask);
  10190c:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  101913:	0f b7 c0             	movzwl %ax,%eax
  101916:	89 04 24             	mov    %eax,(%esp)
  101919:	e8 3a fe ff ff       	call   101758 <pic_setmask>
    }
}
  10191e:	c9                   	leave  
  10191f:	c3                   	ret    

00101920 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101920:	55                   	push   %ebp
  101921:	89 e5                	mov    %esp,%ebp
  101923:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101926:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10192d:	00 
  10192e:	c7 04 24 a0 65 10 00 	movl   $0x1065a0,(%esp)
  101935:	e8 0d ea ff ff       	call   100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10193a:	c9                   	leave  
  10193b:	c3                   	ret    

0010193c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10193c:	55                   	push   %ebp
  10193d:	89 e5                	mov    %esp,%ebp
  10193f:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];

	int i;
	for (i=0;i<256;i++)
  101942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101949:	e9 c3 00 00 00       	jmp    101a11 <idt_init+0xd5>
		SETGATE(idt[i], 0, 8, __vectors[i], 0);
  10194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101951:	8b 04 85 00 86 11 00 	mov    0x118600(,%eax,4),%eax
  101958:	89 c2                	mov    %eax,%edx
  10195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195d:	66 89 14 c5 c0 90 11 	mov    %dx,0x1190c0(,%eax,8)
  101964:	00 
  101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101968:	66 c7 04 c5 c2 90 11 	movw   $0x8,0x1190c2(,%eax,8)
  10196f:	00 08 00 
  101972:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101975:	0f b6 14 c5 c4 90 11 	movzbl 0x1190c4(,%eax,8),%edx
  10197c:	00 
  10197d:	83 e2 e0             	and    $0xffffffe0,%edx
  101980:	88 14 c5 c4 90 11 00 	mov    %dl,0x1190c4(,%eax,8)
  101987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198a:	0f b6 14 c5 c4 90 11 	movzbl 0x1190c4(,%eax,8),%edx
  101991:	00 
  101992:	83 e2 1f             	and    $0x1f,%edx
  101995:	88 14 c5 c4 90 11 00 	mov    %dl,0x1190c4(,%eax,8)
  10199c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199f:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019a6:	00 
  1019a7:	83 e2 f0             	and    $0xfffffff0,%edx
  1019aa:	83 ca 0e             	or     $0xe,%edx
  1019ad:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b7:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019be:	00 
  1019bf:	83 e2 ef             	and    $0xffffffef,%edx
  1019c2:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019cc:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019d3:	00 
  1019d4:	83 e2 9f             	and    $0xffffff9f,%edx
  1019d7:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e1:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019e8:	00 
  1019e9:	83 ca 80             	or     $0xffffff80,%edx
  1019ec:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f6:	8b 04 85 00 86 11 00 	mov    0x118600(,%eax,4),%eax
  1019fd:	c1 e8 10             	shr    $0x10,%eax
  101a00:	89 c2                	mov    %eax,%edx
  101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a05:	66 89 14 c5 c6 90 11 	mov    %dx,0x1190c6(,%eax,8)
  101a0c:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];

	int i;
	for (i=0;i<256;i++)
  101a0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101a11:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a18:	0f 8e 30 ff ff ff    	jle    10194e <idt_init+0x12>
		SETGATE(idt[i], 0, 8, __vectors[i], 0);
	SETGATE(idt[T_SYSCALL], 1, 8, __vectors[T_SYSCALL], 3);
  101a1e:	a1 00 88 11 00       	mov    0x118800,%eax
  101a23:	66 a3 c0 94 11 00    	mov    %ax,0x1194c0
  101a29:	66 c7 05 c2 94 11 00 	movw   $0x8,0x1194c2
  101a30:	08 00 
  101a32:	0f b6 05 c4 94 11 00 	movzbl 0x1194c4,%eax
  101a39:	83 e0 e0             	and    $0xffffffe0,%eax
  101a3c:	a2 c4 94 11 00       	mov    %al,0x1194c4
  101a41:	0f b6 05 c4 94 11 00 	movzbl 0x1194c4,%eax
  101a48:	83 e0 1f             	and    $0x1f,%eax
  101a4b:	a2 c4 94 11 00       	mov    %al,0x1194c4
  101a50:	0f b6 05 c5 94 11 00 	movzbl 0x1194c5,%eax
  101a57:	83 c8 0f             	or     $0xf,%eax
  101a5a:	a2 c5 94 11 00       	mov    %al,0x1194c5
  101a5f:	0f b6 05 c5 94 11 00 	movzbl 0x1194c5,%eax
  101a66:	83 e0 ef             	and    $0xffffffef,%eax
  101a69:	a2 c5 94 11 00       	mov    %al,0x1194c5
  101a6e:	0f b6 05 c5 94 11 00 	movzbl 0x1194c5,%eax
  101a75:	83 c8 60             	or     $0x60,%eax
  101a78:	a2 c5 94 11 00       	mov    %al,0x1194c5
  101a7d:	0f b6 05 c5 94 11 00 	movzbl 0x1194c5,%eax
  101a84:	83 c8 80             	or     $0xffffff80,%eax
  101a87:	a2 c5 94 11 00       	mov    %al,0x1194c5
  101a8c:	a1 00 88 11 00       	mov    0x118800,%eax
  101a91:	c1 e8 10             	shr    $0x10,%eax
  101a94:	66 a3 c6 94 11 00    	mov    %ax,0x1194c6
  101a9a:	c7 45 f8 80 85 11 00 	movl   $0x118580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101aa4:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101aa7:	c9                   	leave  
  101aa8:	c3                   	ret    

00101aa9 <trapname>:

static const char *
trapname(int trapno) {
  101aa9:	55                   	push   %ebp
  101aaa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101aac:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaf:	83 f8 13             	cmp    $0x13,%eax
  101ab2:	77 0c                	ja     101ac0 <trapname+0x17>
        return excnames[trapno];
  101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab7:	8b 04 85 00 69 10 00 	mov    0x106900(,%eax,4),%eax
  101abe:	eb 18                	jmp    101ad8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ac0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ac4:	7e 0d                	jle    101ad3 <trapname+0x2a>
  101ac6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101aca:	7f 07                	jg     101ad3 <trapname+0x2a>
        return "Hardware Interrupt";
  101acc:	b8 aa 65 10 00       	mov    $0x1065aa,%eax
  101ad1:	eb 05                	jmp    101ad8 <trapname+0x2f>
    }
    return "(unknown trap)";
  101ad3:	b8 bd 65 10 00       	mov    $0x1065bd,%eax
}
  101ad8:	5d                   	pop    %ebp
  101ad9:	c3                   	ret    

00101ada <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ada:	55                   	push   %ebp
  101adb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101add:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae4:	66 83 f8 08          	cmp    $0x8,%ax
  101ae8:	0f 94 c0             	sete   %al
  101aeb:	0f b6 c0             	movzbl %al,%eax
}
  101aee:	5d                   	pop    %ebp
  101aef:	c3                   	ret    

00101af0 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101af0:	55                   	push   %ebp
  101af1:	89 e5                	mov    %esp,%ebp
  101af3:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101af6:	8b 45 08             	mov    0x8(%ebp),%eax
  101af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afd:	c7 04 24 fe 65 10 00 	movl   $0x1065fe,(%esp)
  101b04:	e8 3e e8 ff ff       	call   100347 <cprintf>
    print_regs(&tf->tf_regs);
  101b09:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0c:	89 04 24             	mov    %eax,(%esp)
  101b0f:	e8 a1 01 00 00       	call   101cb5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b14:	8b 45 08             	mov    0x8(%ebp),%eax
  101b17:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b1b:	0f b7 c0             	movzwl %ax,%eax
  101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b22:	c7 04 24 0f 66 10 00 	movl   $0x10660f,(%esp)
  101b29:	e8 19 e8 ff ff       	call   100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b35:	0f b7 c0             	movzwl %ax,%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 22 66 10 00 	movl   $0x106622,(%esp)
  101b43:	e8 ff e7 ff ff       	call   100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b4f:	0f b7 c0             	movzwl %ax,%eax
  101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b56:	c7 04 24 35 66 10 00 	movl   $0x106635,(%esp)
  101b5d:	e8 e5 e7 ff ff       	call   100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b62:	8b 45 08             	mov    0x8(%ebp),%eax
  101b65:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b69:	0f b7 c0             	movzwl %ax,%eax
  101b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b70:	c7 04 24 48 66 10 00 	movl   $0x106648,(%esp)
  101b77:	e8 cb e7 ff ff       	call   100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7f:	8b 40 30             	mov    0x30(%eax),%eax
  101b82:	89 04 24             	mov    %eax,(%esp)
  101b85:	e8 1f ff ff ff       	call   101aa9 <trapname>
  101b8a:	8b 55 08             	mov    0x8(%ebp),%edx
  101b8d:	8b 52 30             	mov    0x30(%edx),%edx
  101b90:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b94:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b98:	c7 04 24 5b 66 10 00 	movl   $0x10665b,(%esp)
  101b9f:	e8 a3 e7 ff ff       	call   100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba7:	8b 40 34             	mov    0x34(%eax),%eax
  101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bae:	c7 04 24 6d 66 10 00 	movl   $0x10666d,(%esp)
  101bb5:	e8 8d e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bba:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbd:	8b 40 38             	mov    0x38(%eax),%eax
  101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc4:	c7 04 24 7c 66 10 00 	movl   $0x10667c,(%esp)
  101bcb:	e8 77 e7 ff ff       	call   100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd7:	0f b7 c0             	movzwl %ax,%eax
  101bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bde:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  101be5:	e8 5d e7 ff ff       	call   100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bea:	8b 45 08             	mov    0x8(%ebp),%eax
  101bed:	8b 40 40             	mov    0x40(%eax),%eax
  101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf4:	c7 04 24 9e 66 10 00 	movl   $0x10669e,(%esp)
  101bfb:	e8 47 e7 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c07:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c0e:	eb 3e                	jmp    101c4e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	8b 50 40             	mov    0x40(%eax),%edx
  101c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c19:	21 d0                	and    %edx,%eax
  101c1b:	85 c0                	test   %eax,%eax
  101c1d:	74 28                	je     101c47 <print_trapframe+0x157>
  101c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c22:	8b 04 85 a0 85 11 00 	mov    0x1185a0(,%eax,4),%eax
  101c29:	85 c0                	test   %eax,%eax
  101c2b:	74 1a                	je     101c47 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c30:	8b 04 85 a0 85 11 00 	mov    0x1185a0(,%eax,4),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 ad 66 10 00 	movl   $0x1066ad,(%esp)
  101c42:	e8 00 e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c4b:	d1 65 f0             	shll   -0x10(%ebp)
  101c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c51:	83 f8 17             	cmp    $0x17,%eax
  101c54:	76 ba                	jbe    101c10 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c56:	8b 45 08             	mov    0x8(%ebp),%eax
  101c59:	8b 40 40             	mov    0x40(%eax),%eax
  101c5c:	25 00 30 00 00       	and    $0x3000,%eax
  101c61:	c1 e8 0c             	shr    $0xc,%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 b1 66 10 00 	movl   $0x1066b1,(%esp)
  101c6f:	e8 d3 e6 ff ff       	call   100347 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c74:	8b 45 08             	mov    0x8(%ebp),%eax
  101c77:	89 04 24             	mov    %eax,(%esp)
  101c7a:	e8 5b fe ff ff       	call   101ada <trap_in_kernel>
  101c7f:	85 c0                	test   %eax,%eax
  101c81:	75 30                	jne    101cb3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	8b 40 44             	mov    0x44(%eax),%eax
  101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8d:	c7 04 24 ba 66 10 00 	movl   $0x1066ba,(%esp)
  101c94:	e8 ae e6 ff ff       	call   100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c99:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ca0:	0f b7 c0             	movzwl %ax,%eax
  101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca7:	c7 04 24 c9 66 10 00 	movl   $0x1066c9,(%esp)
  101cae:	e8 94 e6 ff ff       	call   100347 <cprintf>
    }
}
  101cb3:	c9                   	leave  
  101cb4:	c3                   	ret    

00101cb5 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cb5:	55                   	push   %ebp
  101cb6:	89 e5                	mov    %esp,%ebp
  101cb8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbe:	8b 00                	mov    (%eax),%eax
  101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc4:	c7 04 24 dc 66 10 00 	movl   $0x1066dc,(%esp)
  101ccb:	e8 77 e6 ff ff       	call   100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 04             	mov    0x4(%eax),%eax
  101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cda:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  101ce1:	e8 61 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce9:	8b 40 08             	mov    0x8(%eax),%eax
  101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf0:	c7 04 24 fa 66 10 00 	movl   $0x1066fa,(%esp)
  101cf7:	e8 4b e6 ff ff       	call   100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cff:	8b 40 0c             	mov    0xc(%eax),%eax
  101d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d06:	c7 04 24 09 67 10 00 	movl   $0x106709,(%esp)
  101d0d:	e8 35 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d12:	8b 45 08             	mov    0x8(%ebp),%eax
  101d15:	8b 40 10             	mov    0x10(%eax),%eax
  101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1c:	c7 04 24 18 67 10 00 	movl   $0x106718,(%esp)
  101d23:	e8 1f e6 ff ff       	call   100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d28:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2b:	8b 40 14             	mov    0x14(%eax),%eax
  101d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d32:	c7 04 24 27 67 10 00 	movl   $0x106727,(%esp)
  101d39:	e8 09 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d41:	8b 40 18             	mov    0x18(%eax),%eax
  101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d48:	c7 04 24 36 67 10 00 	movl   $0x106736,(%esp)
  101d4f:	e8 f3 e5 ff ff       	call   100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d54:	8b 45 08             	mov    0x8(%ebp),%eax
  101d57:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5e:	c7 04 24 45 67 10 00 	movl   $0x106745,(%esp)
  101d65:	e8 dd e5 ff ff       	call   100347 <cprintf>
}
  101d6a:	c9                   	leave  
  101d6b:	c3                   	ret    

00101d6c <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d6c:	55                   	push   %ebp
  101d6d:	89 e5                	mov    %esp,%ebp
  101d6f:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int ticks;
    switch (tf->tf_trapno) {
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	8b 40 30             	mov    0x30(%eax),%eax
  101d78:	83 f8 2f             	cmp    $0x2f,%eax
  101d7b:	77 1d                	ja     101d9a <trap_dispatch+0x2e>
  101d7d:	83 f8 2e             	cmp    $0x2e,%eax
  101d80:	0f 83 f2 00 00 00    	jae    101e78 <trap_dispatch+0x10c>
  101d86:	83 f8 21             	cmp    $0x21,%eax
  101d89:	74 73                	je     101dfe <trap_dispatch+0x92>
  101d8b:	83 f8 24             	cmp    $0x24,%eax
  101d8e:	74 48                	je     101dd8 <trap_dispatch+0x6c>
  101d90:	83 f8 20             	cmp    $0x20,%eax
  101d93:	74 13                	je     101da8 <trap_dispatch+0x3c>
  101d95:	e9 a6 00 00 00       	jmp    101e40 <trap_dispatch+0xd4>
  101d9a:	83 e8 78             	sub    $0x78,%eax
  101d9d:	83 f8 01             	cmp    $0x1,%eax
  101da0:	0f 87 9a 00 00 00    	ja     101e40 <trap_dispatch+0xd4>
  101da6:	eb 7c                	jmp    101e24 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
  101da8:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  101dad:	83 c0 01             	add    $0x1,%eax
  101db0:	a3 c0 98 11 00       	mov    %eax,0x1198c0
		if (ticks==TICK_NUM)
  101db5:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  101dba:	83 f8 64             	cmp    $0x64,%eax
  101dbd:	75 14                	jne    101dd3 <trap_dispatch+0x67>
		{
			ticks=0;
  101dbf:	c7 05 c0 98 11 00 00 	movl   $0x0,0x1198c0
  101dc6:	00 00 00 
			print_ticks();
  101dc9:	e8 52 fb ff ff       	call   101920 <print_ticks>
		}
        break;
  101dce:	e9 a6 00 00 00       	jmp    101e79 <trap_dispatch+0x10d>
  101dd3:	e9 a1 00 00 00       	jmp    101e79 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dd8:	e8 ff f8 ff ff       	call   1016dc <cons_getc>
  101ddd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101de0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101de4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101de8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101df0:	c7 04 24 54 67 10 00 	movl   $0x106754,(%esp)
  101df7:	e8 4b e5 ff ff       	call   100347 <cprintf>
        break;
  101dfc:	eb 7b                	jmp    101e79 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dfe:	e8 d9 f8 ff ff       	call   1016dc <cons_getc>
  101e03:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e06:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e0a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e12:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e16:	c7 04 24 66 67 10 00 	movl   $0x106766,(%esp)
  101e1d:	e8 25 e5 ff ff       	call   100347 <cprintf>
        break;
  101e22:	eb 55                	jmp    101e79 <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e24:	c7 44 24 08 75 67 10 	movl   $0x106775,0x8(%esp)
  101e2b:	00 
  101e2c:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  101e33:	00 
  101e34:	c7 04 24 85 67 10 00 	movl   $0x106785,(%esp)
  101e3b:	e8 80 ee ff ff       	call   100cc0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e47:	0f b7 c0             	movzwl %ax,%eax
  101e4a:	83 e0 03             	and    $0x3,%eax
  101e4d:	85 c0                	test   %eax,%eax
  101e4f:	75 28                	jne    101e79 <trap_dispatch+0x10d>
            print_trapframe(tf);
  101e51:	8b 45 08             	mov    0x8(%ebp),%eax
  101e54:	89 04 24             	mov    %eax,(%esp)
  101e57:	e8 94 fc ff ff       	call   101af0 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e5c:	c7 44 24 08 96 67 10 	movl   $0x106796,0x8(%esp)
  101e63:	00 
  101e64:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  101e6b:	00 
  101e6c:	c7 04 24 85 67 10 00 	movl   $0x106785,(%esp)
  101e73:	e8 48 ee ff ff       	call   100cc0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e78:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e79:	c9                   	leave  
  101e7a:	c3                   	ret    

00101e7b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e7b:	55                   	push   %ebp
  101e7c:	89 e5                	mov    %esp,%ebp
  101e7e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e81:	8b 45 08             	mov    0x8(%ebp),%eax
  101e84:	89 04 24             	mov    %eax,(%esp)
  101e87:	e8 e0 fe ff ff       	call   101d6c <trap_dispatch>
}
  101e8c:	c9                   	leave  
  101e8d:	c3                   	ret    
  101e8e:	66 90                	xchg   %ax,%ax

00101e90 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e90:	1e                   	push   %ds
    pushl %es
  101e91:	06                   	push   %es
    pushl %fs
  101e92:	0f a0                	push   %fs
    pushl %gs
  101e94:	0f a8                	push   %gs
    pushal
  101e96:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e97:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e9c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e9e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ea0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ea1:	e8 d5 ff ff ff       	call   101e7b <trap>

    # pop the pushed stack pointer
    popl %esp
  101ea6:	5c                   	pop    %esp

00101ea7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ea7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ea8:	0f a9                	pop    %gs
    popl %fs
  101eaa:	0f a1                	pop    %fs
    popl %es
  101eac:	07                   	pop    %es
    popl %ds
  101ead:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101eae:	83 c4 08             	add    $0x8,%esp
    iret
  101eb1:	cf                   	iret   
  101eb2:	66 90                	xchg   %ax,%ax

00101eb4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $0
  101eb6:	6a 00                	push   $0x0
  jmp __alltraps
  101eb8:	e9 d3 ff ff ff       	jmp    101e90 <__alltraps>

00101ebd <vector1>:
.globl vector1
vector1:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $1
  101ebf:	6a 01                	push   $0x1
  jmp __alltraps
  101ec1:	e9 ca ff ff ff       	jmp    101e90 <__alltraps>

00101ec6 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $2
  101ec8:	6a 02                	push   $0x2
  jmp __alltraps
  101eca:	e9 c1 ff ff ff       	jmp    101e90 <__alltraps>

00101ecf <vector3>:
.globl vector3
vector3:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $3
  101ed1:	6a 03                	push   $0x3
  jmp __alltraps
  101ed3:	e9 b8 ff ff ff       	jmp    101e90 <__alltraps>

00101ed8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $4
  101eda:	6a 04                	push   $0x4
  jmp __alltraps
  101edc:	e9 af ff ff ff       	jmp    101e90 <__alltraps>

00101ee1 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $5
  101ee3:	6a 05                	push   $0x5
  jmp __alltraps
  101ee5:	e9 a6 ff ff ff       	jmp    101e90 <__alltraps>

00101eea <vector6>:
.globl vector6
vector6:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $6
  101eec:	6a 06                	push   $0x6
  jmp __alltraps
  101eee:	e9 9d ff ff ff       	jmp    101e90 <__alltraps>

00101ef3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $7
  101ef5:	6a 07                	push   $0x7
  jmp __alltraps
  101ef7:	e9 94 ff ff ff       	jmp    101e90 <__alltraps>

00101efc <vector8>:
.globl vector8
vector8:
  pushl $8
  101efc:	6a 08                	push   $0x8
  jmp __alltraps
  101efe:	e9 8d ff ff ff       	jmp    101e90 <__alltraps>

00101f03 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f03:	6a 09                	push   $0x9
  jmp __alltraps
  101f05:	e9 86 ff ff ff       	jmp    101e90 <__alltraps>

00101f0a <vector10>:
.globl vector10
vector10:
  pushl $10
  101f0a:	6a 0a                	push   $0xa
  jmp __alltraps
  101f0c:	e9 7f ff ff ff       	jmp    101e90 <__alltraps>

00101f11 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f11:	6a 0b                	push   $0xb
  jmp __alltraps
  101f13:	e9 78 ff ff ff       	jmp    101e90 <__alltraps>

00101f18 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f18:	6a 0c                	push   $0xc
  jmp __alltraps
  101f1a:	e9 71 ff ff ff       	jmp    101e90 <__alltraps>

00101f1f <vector13>:
.globl vector13
vector13:
  pushl $13
  101f1f:	6a 0d                	push   $0xd
  jmp __alltraps
  101f21:	e9 6a ff ff ff       	jmp    101e90 <__alltraps>

00101f26 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f26:	6a 0e                	push   $0xe
  jmp __alltraps
  101f28:	e9 63 ff ff ff       	jmp    101e90 <__alltraps>

00101f2d <vector15>:
.globl vector15
vector15:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $15
  101f2f:	6a 0f                	push   $0xf
  jmp __alltraps
  101f31:	e9 5a ff ff ff       	jmp    101e90 <__alltraps>

00101f36 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $16
  101f38:	6a 10                	push   $0x10
  jmp __alltraps
  101f3a:	e9 51 ff ff ff       	jmp    101e90 <__alltraps>

00101f3f <vector17>:
.globl vector17
vector17:
  pushl $17
  101f3f:	6a 11                	push   $0x11
  jmp __alltraps
  101f41:	e9 4a ff ff ff       	jmp    101e90 <__alltraps>

00101f46 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $18
  101f48:	6a 12                	push   $0x12
  jmp __alltraps
  101f4a:	e9 41 ff ff ff       	jmp    101e90 <__alltraps>

00101f4f <vector19>:
.globl vector19
vector19:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $19
  101f51:	6a 13                	push   $0x13
  jmp __alltraps
  101f53:	e9 38 ff ff ff       	jmp    101e90 <__alltraps>

00101f58 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $20
  101f5a:	6a 14                	push   $0x14
  jmp __alltraps
  101f5c:	e9 2f ff ff ff       	jmp    101e90 <__alltraps>

00101f61 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $21
  101f63:	6a 15                	push   $0x15
  jmp __alltraps
  101f65:	e9 26 ff ff ff       	jmp    101e90 <__alltraps>

00101f6a <vector22>:
.globl vector22
vector22:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $22
  101f6c:	6a 16                	push   $0x16
  jmp __alltraps
  101f6e:	e9 1d ff ff ff       	jmp    101e90 <__alltraps>

00101f73 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $23
  101f75:	6a 17                	push   $0x17
  jmp __alltraps
  101f77:	e9 14 ff ff ff       	jmp    101e90 <__alltraps>

00101f7c <vector24>:
.globl vector24
vector24:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $24
  101f7e:	6a 18                	push   $0x18
  jmp __alltraps
  101f80:	e9 0b ff ff ff       	jmp    101e90 <__alltraps>

00101f85 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $25
  101f87:	6a 19                	push   $0x19
  jmp __alltraps
  101f89:	e9 02 ff ff ff       	jmp    101e90 <__alltraps>

00101f8e <vector26>:
.globl vector26
vector26:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $26
  101f90:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f92:	e9 f9 fe ff ff       	jmp    101e90 <__alltraps>

00101f97 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $27
  101f99:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f9b:	e9 f0 fe ff ff       	jmp    101e90 <__alltraps>

00101fa0 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $28
  101fa2:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fa4:	e9 e7 fe ff ff       	jmp    101e90 <__alltraps>

00101fa9 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $29
  101fab:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fad:	e9 de fe ff ff       	jmp    101e90 <__alltraps>

00101fb2 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $30
  101fb4:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fb6:	e9 d5 fe ff ff       	jmp    101e90 <__alltraps>

00101fbb <vector31>:
.globl vector31
vector31:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $31
  101fbd:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fbf:	e9 cc fe ff ff       	jmp    101e90 <__alltraps>

00101fc4 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $32
  101fc6:	6a 20                	push   $0x20
  jmp __alltraps
  101fc8:	e9 c3 fe ff ff       	jmp    101e90 <__alltraps>

00101fcd <vector33>:
.globl vector33
vector33:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $33
  101fcf:	6a 21                	push   $0x21
  jmp __alltraps
  101fd1:	e9 ba fe ff ff       	jmp    101e90 <__alltraps>

00101fd6 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $34
  101fd8:	6a 22                	push   $0x22
  jmp __alltraps
  101fda:	e9 b1 fe ff ff       	jmp    101e90 <__alltraps>

00101fdf <vector35>:
.globl vector35
vector35:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $35
  101fe1:	6a 23                	push   $0x23
  jmp __alltraps
  101fe3:	e9 a8 fe ff ff       	jmp    101e90 <__alltraps>

00101fe8 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $36
  101fea:	6a 24                	push   $0x24
  jmp __alltraps
  101fec:	e9 9f fe ff ff       	jmp    101e90 <__alltraps>

00101ff1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $37
  101ff3:	6a 25                	push   $0x25
  jmp __alltraps
  101ff5:	e9 96 fe ff ff       	jmp    101e90 <__alltraps>

00101ffa <vector38>:
.globl vector38
vector38:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $38
  101ffc:	6a 26                	push   $0x26
  jmp __alltraps
  101ffe:	e9 8d fe ff ff       	jmp    101e90 <__alltraps>

00102003 <vector39>:
.globl vector39
vector39:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $39
  102005:	6a 27                	push   $0x27
  jmp __alltraps
  102007:	e9 84 fe ff ff       	jmp    101e90 <__alltraps>

0010200c <vector40>:
.globl vector40
vector40:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $40
  10200e:	6a 28                	push   $0x28
  jmp __alltraps
  102010:	e9 7b fe ff ff       	jmp    101e90 <__alltraps>

00102015 <vector41>:
.globl vector41
vector41:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $41
  102017:	6a 29                	push   $0x29
  jmp __alltraps
  102019:	e9 72 fe ff ff       	jmp    101e90 <__alltraps>

0010201e <vector42>:
.globl vector42
vector42:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $42
  102020:	6a 2a                	push   $0x2a
  jmp __alltraps
  102022:	e9 69 fe ff ff       	jmp    101e90 <__alltraps>

00102027 <vector43>:
.globl vector43
vector43:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $43
  102029:	6a 2b                	push   $0x2b
  jmp __alltraps
  10202b:	e9 60 fe ff ff       	jmp    101e90 <__alltraps>

00102030 <vector44>:
.globl vector44
vector44:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $44
  102032:	6a 2c                	push   $0x2c
  jmp __alltraps
  102034:	e9 57 fe ff ff       	jmp    101e90 <__alltraps>

00102039 <vector45>:
.globl vector45
vector45:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $45
  10203b:	6a 2d                	push   $0x2d
  jmp __alltraps
  10203d:	e9 4e fe ff ff       	jmp    101e90 <__alltraps>

00102042 <vector46>:
.globl vector46
vector46:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $46
  102044:	6a 2e                	push   $0x2e
  jmp __alltraps
  102046:	e9 45 fe ff ff       	jmp    101e90 <__alltraps>

0010204b <vector47>:
.globl vector47
vector47:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $47
  10204d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10204f:	e9 3c fe ff ff       	jmp    101e90 <__alltraps>

00102054 <vector48>:
.globl vector48
vector48:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $48
  102056:	6a 30                	push   $0x30
  jmp __alltraps
  102058:	e9 33 fe ff ff       	jmp    101e90 <__alltraps>

0010205d <vector49>:
.globl vector49
vector49:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $49
  10205f:	6a 31                	push   $0x31
  jmp __alltraps
  102061:	e9 2a fe ff ff       	jmp    101e90 <__alltraps>

00102066 <vector50>:
.globl vector50
vector50:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $50
  102068:	6a 32                	push   $0x32
  jmp __alltraps
  10206a:	e9 21 fe ff ff       	jmp    101e90 <__alltraps>

0010206f <vector51>:
.globl vector51
vector51:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $51
  102071:	6a 33                	push   $0x33
  jmp __alltraps
  102073:	e9 18 fe ff ff       	jmp    101e90 <__alltraps>

00102078 <vector52>:
.globl vector52
vector52:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $52
  10207a:	6a 34                	push   $0x34
  jmp __alltraps
  10207c:	e9 0f fe ff ff       	jmp    101e90 <__alltraps>

00102081 <vector53>:
.globl vector53
vector53:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $53
  102083:	6a 35                	push   $0x35
  jmp __alltraps
  102085:	e9 06 fe ff ff       	jmp    101e90 <__alltraps>

0010208a <vector54>:
.globl vector54
vector54:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $54
  10208c:	6a 36                	push   $0x36
  jmp __alltraps
  10208e:	e9 fd fd ff ff       	jmp    101e90 <__alltraps>

00102093 <vector55>:
.globl vector55
vector55:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $55
  102095:	6a 37                	push   $0x37
  jmp __alltraps
  102097:	e9 f4 fd ff ff       	jmp    101e90 <__alltraps>

0010209c <vector56>:
.globl vector56
vector56:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $56
  10209e:	6a 38                	push   $0x38
  jmp __alltraps
  1020a0:	e9 eb fd ff ff       	jmp    101e90 <__alltraps>

001020a5 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $57
  1020a7:	6a 39                	push   $0x39
  jmp __alltraps
  1020a9:	e9 e2 fd ff ff       	jmp    101e90 <__alltraps>

001020ae <vector58>:
.globl vector58
vector58:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $58
  1020b0:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020b2:	e9 d9 fd ff ff       	jmp    101e90 <__alltraps>

001020b7 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $59
  1020b9:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020bb:	e9 d0 fd ff ff       	jmp    101e90 <__alltraps>

001020c0 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $60
  1020c2:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020c4:	e9 c7 fd ff ff       	jmp    101e90 <__alltraps>

001020c9 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $61
  1020cb:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020cd:	e9 be fd ff ff       	jmp    101e90 <__alltraps>

001020d2 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $62
  1020d4:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020d6:	e9 b5 fd ff ff       	jmp    101e90 <__alltraps>

001020db <vector63>:
.globl vector63
vector63:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $63
  1020dd:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020df:	e9 ac fd ff ff       	jmp    101e90 <__alltraps>

001020e4 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $64
  1020e6:	6a 40                	push   $0x40
  jmp __alltraps
  1020e8:	e9 a3 fd ff ff       	jmp    101e90 <__alltraps>

001020ed <vector65>:
.globl vector65
vector65:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $65
  1020ef:	6a 41                	push   $0x41
  jmp __alltraps
  1020f1:	e9 9a fd ff ff       	jmp    101e90 <__alltraps>

001020f6 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $66
  1020f8:	6a 42                	push   $0x42
  jmp __alltraps
  1020fa:	e9 91 fd ff ff       	jmp    101e90 <__alltraps>

001020ff <vector67>:
.globl vector67
vector67:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $67
  102101:	6a 43                	push   $0x43
  jmp __alltraps
  102103:	e9 88 fd ff ff       	jmp    101e90 <__alltraps>

00102108 <vector68>:
.globl vector68
vector68:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $68
  10210a:	6a 44                	push   $0x44
  jmp __alltraps
  10210c:	e9 7f fd ff ff       	jmp    101e90 <__alltraps>

00102111 <vector69>:
.globl vector69
vector69:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $69
  102113:	6a 45                	push   $0x45
  jmp __alltraps
  102115:	e9 76 fd ff ff       	jmp    101e90 <__alltraps>

0010211a <vector70>:
.globl vector70
vector70:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $70
  10211c:	6a 46                	push   $0x46
  jmp __alltraps
  10211e:	e9 6d fd ff ff       	jmp    101e90 <__alltraps>

00102123 <vector71>:
.globl vector71
vector71:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $71
  102125:	6a 47                	push   $0x47
  jmp __alltraps
  102127:	e9 64 fd ff ff       	jmp    101e90 <__alltraps>

0010212c <vector72>:
.globl vector72
vector72:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $72
  10212e:	6a 48                	push   $0x48
  jmp __alltraps
  102130:	e9 5b fd ff ff       	jmp    101e90 <__alltraps>

00102135 <vector73>:
.globl vector73
vector73:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $73
  102137:	6a 49                	push   $0x49
  jmp __alltraps
  102139:	e9 52 fd ff ff       	jmp    101e90 <__alltraps>

0010213e <vector74>:
.globl vector74
vector74:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $74
  102140:	6a 4a                	push   $0x4a
  jmp __alltraps
  102142:	e9 49 fd ff ff       	jmp    101e90 <__alltraps>

00102147 <vector75>:
.globl vector75
vector75:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $75
  102149:	6a 4b                	push   $0x4b
  jmp __alltraps
  10214b:	e9 40 fd ff ff       	jmp    101e90 <__alltraps>

00102150 <vector76>:
.globl vector76
vector76:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $76
  102152:	6a 4c                	push   $0x4c
  jmp __alltraps
  102154:	e9 37 fd ff ff       	jmp    101e90 <__alltraps>

00102159 <vector77>:
.globl vector77
vector77:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $77
  10215b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10215d:	e9 2e fd ff ff       	jmp    101e90 <__alltraps>

00102162 <vector78>:
.globl vector78
vector78:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $78
  102164:	6a 4e                	push   $0x4e
  jmp __alltraps
  102166:	e9 25 fd ff ff       	jmp    101e90 <__alltraps>

0010216b <vector79>:
.globl vector79
vector79:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $79
  10216d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10216f:	e9 1c fd ff ff       	jmp    101e90 <__alltraps>

00102174 <vector80>:
.globl vector80
vector80:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $80
  102176:	6a 50                	push   $0x50
  jmp __alltraps
  102178:	e9 13 fd ff ff       	jmp    101e90 <__alltraps>

0010217d <vector81>:
.globl vector81
vector81:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $81
  10217f:	6a 51                	push   $0x51
  jmp __alltraps
  102181:	e9 0a fd ff ff       	jmp    101e90 <__alltraps>

00102186 <vector82>:
.globl vector82
vector82:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $82
  102188:	6a 52                	push   $0x52
  jmp __alltraps
  10218a:	e9 01 fd ff ff       	jmp    101e90 <__alltraps>

0010218f <vector83>:
.globl vector83
vector83:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $83
  102191:	6a 53                	push   $0x53
  jmp __alltraps
  102193:	e9 f8 fc ff ff       	jmp    101e90 <__alltraps>

00102198 <vector84>:
.globl vector84
vector84:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $84
  10219a:	6a 54                	push   $0x54
  jmp __alltraps
  10219c:	e9 ef fc ff ff       	jmp    101e90 <__alltraps>

001021a1 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $85
  1021a3:	6a 55                	push   $0x55
  jmp __alltraps
  1021a5:	e9 e6 fc ff ff       	jmp    101e90 <__alltraps>

001021aa <vector86>:
.globl vector86
vector86:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $86
  1021ac:	6a 56                	push   $0x56
  jmp __alltraps
  1021ae:	e9 dd fc ff ff       	jmp    101e90 <__alltraps>

001021b3 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $87
  1021b5:	6a 57                	push   $0x57
  jmp __alltraps
  1021b7:	e9 d4 fc ff ff       	jmp    101e90 <__alltraps>

001021bc <vector88>:
.globl vector88
vector88:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $88
  1021be:	6a 58                	push   $0x58
  jmp __alltraps
  1021c0:	e9 cb fc ff ff       	jmp    101e90 <__alltraps>

001021c5 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $89
  1021c7:	6a 59                	push   $0x59
  jmp __alltraps
  1021c9:	e9 c2 fc ff ff       	jmp    101e90 <__alltraps>

001021ce <vector90>:
.globl vector90
vector90:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $90
  1021d0:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021d2:	e9 b9 fc ff ff       	jmp    101e90 <__alltraps>

001021d7 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $91
  1021d9:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021db:	e9 b0 fc ff ff       	jmp    101e90 <__alltraps>

001021e0 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $92
  1021e2:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021e4:	e9 a7 fc ff ff       	jmp    101e90 <__alltraps>

001021e9 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $93
  1021eb:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021ed:	e9 9e fc ff ff       	jmp    101e90 <__alltraps>

001021f2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $94
  1021f4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021f6:	e9 95 fc ff ff       	jmp    101e90 <__alltraps>

001021fb <vector95>:
.globl vector95
vector95:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $95
  1021fd:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021ff:	e9 8c fc ff ff       	jmp    101e90 <__alltraps>

00102204 <vector96>:
.globl vector96
vector96:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $96
  102206:	6a 60                	push   $0x60
  jmp __alltraps
  102208:	e9 83 fc ff ff       	jmp    101e90 <__alltraps>

0010220d <vector97>:
.globl vector97
vector97:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $97
  10220f:	6a 61                	push   $0x61
  jmp __alltraps
  102211:	e9 7a fc ff ff       	jmp    101e90 <__alltraps>

00102216 <vector98>:
.globl vector98
vector98:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $98
  102218:	6a 62                	push   $0x62
  jmp __alltraps
  10221a:	e9 71 fc ff ff       	jmp    101e90 <__alltraps>

0010221f <vector99>:
.globl vector99
vector99:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $99
  102221:	6a 63                	push   $0x63
  jmp __alltraps
  102223:	e9 68 fc ff ff       	jmp    101e90 <__alltraps>

00102228 <vector100>:
.globl vector100
vector100:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $100
  10222a:	6a 64                	push   $0x64
  jmp __alltraps
  10222c:	e9 5f fc ff ff       	jmp    101e90 <__alltraps>

00102231 <vector101>:
.globl vector101
vector101:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $101
  102233:	6a 65                	push   $0x65
  jmp __alltraps
  102235:	e9 56 fc ff ff       	jmp    101e90 <__alltraps>

0010223a <vector102>:
.globl vector102
vector102:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $102
  10223c:	6a 66                	push   $0x66
  jmp __alltraps
  10223e:	e9 4d fc ff ff       	jmp    101e90 <__alltraps>

00102243 <vector103>:
.globl vector103
vector103:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $103
  102245:	6a 67                	push   $0x67
  jmp __alltraps
  102247:	e9 44 fc ff ff       	jmp    101e90 <__alltraps>

0010224c <vector104>:
.globl vector104
vector104:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $104
  10224e:	6a 68                	push   $0x68
  jmp __alltraps
  102250:	e9 3b fc ff ff       	jmp    101e90 <__alltraps>

00102255 <vector105>:
.globl vector105
vector105:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $105
  102257:	6a 69                	push   $0x69
  jmp __alltraps
  102259:	e9 32 fc ff ff       	jmp    101e90 <__alltraps>

0010225e <vector106>:
.globl vector106
vector106:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $106
  102260:	6a 6a                	push   $0x6a
  jmp __alltraps
  102262:	e9 29 fc ff ff       	jmp    101e90 <__alltraps>

00102267 <vector107>:
.globl vector107
vector107:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $107
  102269:	6a 6b                	push   $0x6b
  jmp __alltraps
  10226b:	e9 20 fc ff ff       	jmp    101e90 <__alltraps>

00102270 <vector108>:
.globl vector108
vector108:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $108
  102272:	6a 6c                	push   $0x6c
  jmp __alltraps
  102274:	e9 17 fc ff ff       	jmp    101e90 <__alltraps>

00102279 <vector109>:
.globl vector109
vector109:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $109
  10227b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10227d:	e9 0e fc ff ff       	jmp    101e90 <__alltraps>

00102282 <vector110>:
.globl vector110
vector110:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $110
  102284:	6a 6e                	push   $0x6e
  jmp __alltraps
  102286:	e9 05 fc ff ff       	jmp    101e90 <__alltraps>

0010228b <vector111>:
.globl vector111
vector111:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $111
  10228d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10228f:	e9 fc fb ff ff       	jmp    101e90 <__alltraps>

00102294 <vector112>:
.globl vector112
vector112:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $112
  102296:	6a 70                	push   $0x70
  jmp __alltraps
  102298:	e9 f3 fb ff ff       	jmp    101e90 <__alltraps>

0010229d <vector113>:
.globl vector113
vector113:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $113
  10229f:	6a 71                	push   $0x71
  jmp __alltraps
  1022a1:	e9 ea fb ff ff       	jmp    101e90 <__alltraps>

001022a6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $114
  1022a8:	6a 72                	push   $0x72
  jmp __alltraps
  1022aa:	e9 e1 fb ff ff       	jmp    101e90 <__alltraps>

001022af <vector115>:
.globl vector115
vector115:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $115
  1022b1:	6a 73                	push   $0x73
  jmp __alltraps
  1022b3:	e9 d8 fb ff ff       	jmp    101e90 <__alltraps>

001022b8 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $116
  1022ba:	6a 74                	push   $0x74
  jmp __alltraps
  1022bc:	e9 cf fb ff ff       	jmp    101e90 <__alltraps>

001022c1 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $117
  1022c3:	6a 75                	push   $0x75
  jmp __alltraps
  1022c5:	e9 c6 fb ff ff       	jmp    101e90 <__alltraps>

001022ca <vector118>:
.globl vector118
vector118:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $118
  1022cc:	6a 76                	push   $0x76
  jmp __alltraps
  1022ce:	e9 bd fb ff ff       	jmp    101e90 <__alltraps>

001022d3 <vector119>:
.globl vector119
vector119:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $119
  1022d5:	6a 77                	push   $0x77
  jmp __alltraps
  1022d7:	e9 b4 fb ff ff       	jmp    101e90 <__alltraps>

001022dc <vector120>:
.globl vector120
vector120:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $120
  1022de:	6a 78                	push   $0x78
  jmp __alltraps
  1022e0:	e9 ab fb ff ff       	jmp    101e90 <__alltraps>

001022e5 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $121
  1022e7:	6a 79                	push   $0x79
  jmp __alltraps
  1022e9:	e9 a2 fb ff ff       	jmp    101e90 <__alltraps>

001022ee <vector122>:
.globl vector122
vector122:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $122
  1022f0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022f2:	e9 99 fb ff ff       	jmp    101e90 <__alltraps>

001022f7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $123
  1022f9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022fb:	e9 90 fb ff ff       	jmp    101e90 <__alltraps>

00102300 <vector124>:
.globl vector124
vector124:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $124
  102302:	6a 7c                	push   $0x7c
  jmp __alltraps
  102304:	e9 87 fb ff ff       	jmp    101e90 <__alltraps>

00102309 <vector125>:
.globl vector125
vector125:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $125
  10230b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10230d:	e9 7e fb ff ff       	jmp    101e90 <__alltraps>

00102312 <vector126>:
.globl vector126
vector126:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $126
  102314:	6a 7e                	push   $0x7e
  jmp __alltraps
  102316:	e9 75 fb ff ff       	jmp    101e90 <__alltraps>

0010231b <vector127>:
.globl vector127
vector127:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $127
  10231d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10231f:	e9 6c fb ff ff       	jmp    101e90 <__alltraps>

00102324 <vector128>:
.globl vector128
vector128:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $128
  102326:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10232b:	e9 60 fb ff ff       	jmp    101e90 <__alltraps>

00102330 <vector129>:
.globl vector129
vector129:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $129
  102332:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102337:	e9 54 fb ff ff       	jmp    101e90 <__alltraps>

0010233c <vector130>:
.globl vector130
vector130:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $130
  10233e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102343:	e9 48 fb ff ff       	jmp    101e90 <__alltraps>

00102348 <vector131>:
.globl vector131
vector131:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $131
  10234a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10234f:	e9 3c fb ff ff       	jmp    101e90 <__alltraps>

00102354 <vector132>:
.globl vector132
vector132:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $132
  102356:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10235b:	e9 30 fb ff ff       	jmp    101e90 <__alltraps>

00102360 <vector133>:
.globl vector133
vector133:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $133
  102362:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102367:	e9 24 fb ff ff       	jmp    101e90 <__alltraps>

0010236c <vector134>:
.globl vector134
vector134:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $134
  10236e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102373:	e9 18 fb ff ff       	jmp    101e90 <__alltraps>

00102378 <vector135>:
.globl vector135
vector135:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $135
  10237a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10237f:	e9 0c fb ff ff       	jmp    101e90 <__alltraps>

00102384 <vector136>:
.globl vector136
vector136:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $136
  102386:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10238b:	e9 00 fb ff ff       	jmp    101e90 <__alltraps>

00102390 <vector137>:
.globl vector137
vector137:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $137
  102392:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102397:	e9 f4 fa ff ff       	jmp    101e90 <__alltraps>

0010239c <vector138>:
.globl vector138
vector138:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $138
  10239e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023a3:	e9 e8 fa ff ff       	jmp    101e90 <__alltraps>

001023a8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $139
  1023aa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023af:	e9 dc fa ff ff       	jmp    101e90 <__alltraps>

001023b4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $140
  1023b6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023bb:	e9 d0 fa ff ff       	jmp    101e90 <__alltraps>

001023c0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $141
  1023c2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023c7:	e9 c4 fa ff ff       	jmp    101e90 <__alltraps>

001023cc <vector142>:
.globl vector142
vector142:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $142
  1023ce:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023d3:	e9 b8 fa ff ff       	jmp    101e90 <__alltraps>

001023d8 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $143
  1023da:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023df:	e9 ac fa ff ff       	jmp    101e90 <__alltraps>

001023e4 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $144
  1023e6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023eb:	e9 a0 fa ff ff       	jmp    101e90 <__alltraps>

001023f0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $145
  1023f2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023f7:	e9 94 fa ff ff       	jmp    101e90 <__alltraps>

001023fc <vector146>:
.globl vector146
vector146:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $146
  1023fe:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102403:	e9 88 fa ff ff       	jmp    101e90 <__alltraps>

00102408 <vector147>:
.globl vector147
vector147:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $147
  10240a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10240f:	e9 7c fa ff ff       	jmp    101e90 <__alltraps>

00102414 <vector148>:
.globl vector148
vector148:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $148
  102416:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10241b:	e9 70 fa ff ff       	jmp    101e90 <__alltraps>

00102420 <vector149>:
.globl vector149
vector149:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $149
  102422:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102427:	e9 64 fa ff ff       	jmp    101e90 <__alltraps>

0010242c <vector150>:
.globl vector150
vector150:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $150
  10242e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102433:	e9 58 fa ff ff       	jmp    101e90 <__alltraps>

00102438 <vector151>:
.globl vector151
vector151:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $151
  10243a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10243f:	e9 4c fa ff ff       	jmp    101e90 <__alltraps>

00102444 <vector152>:
.globl vector152
vector152:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $152
  102446:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10244b:	e9 40 fa ff ff       	jmp    101e90 <__alltraps>

00102450 <vector153>:
.globl vector153
vector153:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $153
  102452:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102457:	e9 34 fa ff ff       	jmp    101e90 <__alltraps>

0010245c <vector154>:
.globl vector154
vector154:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $154
  10245e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102463:	e9 28 fa ff ff       	jmp    101e90 <__alltraps>

00102468 <vector155>:
.globl vector155
vector155:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $155
  10246a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10246f:	e9 1c fa ff ff       	jmp    101e90 <__alltraps>

00102474 <vector156>:
.globl vector156
vector156:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $156
  102476:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10247b:	e9 10 fa ff ff       	jmp    101e90 <__alltraps>

00102480 <vector157>:
.globl vector157
vector157:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $157
  102482:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102487:	e9 04 fa ff ff       	jmp    101e90 <__alltraps>

0010248c <vector158>:
.globl vector158
vector158:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $158
  10248e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102493:	e9 f8 f9 ff ff       	jmp    101e90 <__alltraps>

00102498 <vector159>:
.globl vector159
vector159:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $159
  10249a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10249f:	e9 ec f9 ff ff       	jmp    101e90 <__alltraps>

001024a4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $160
  1024a6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024ab:	e9 e0 f9 ff ff       	jmp    101e90 <__alltraps>

001024b0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $161
  1024b2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024b7:	e9 d4 f9 ff ff       	jmp    101e90 <__alltraps>

001024bc <vector162>:
.globl vector162
vector162:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $162
  1024be:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024c3:	e9 c8 f9 ff ff       	jmp    101e90 <__alltraps>

001024c8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $163
  1024ca:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024cf:	e9 bc f9 ff ff       	jmp    101e90 <__alltraps>

001024d4 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $164
  1024d6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024db:	e9 b0 f9 ff ff       	jmp    101e90 <__alltraps>

001024e0 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $165
  1024e2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024e7:	e9 a4 f9 ff ff       	jmp    101e90 <__alltraps>

001024ec <vector166>:
.globl vector166
vector166:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $166
  1024ee:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024f3:	e9 98 f9 ff ff       	jmp    101e90 <__alltraps>

001024f8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $167
  1024fa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024ff:	e9 8c f9 ff ff       	jmp    101e90 <__alltraps>

00102504 <vector168>:
.globl vector168
vector168:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $168
  102506:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10250b:	e9 80 f9 ff ff       	jmp    101e90 <__alltraps>

00102510 <vector169>:
.globl vector169
vector169:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $169
  102512:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102517:	e9 74 f9 ff ff       	jmp    101e90 <__alltraps>

0010251c <vector170>:
.globl vector170
vector170:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $170
  10251e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102523:	e9 68 f9 ff ff       	jmp    101e90 <__alltraps>

00102528 <vector171>:
.globl vector171
vector171:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $171
  10252a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10252f:	e9 5c f9 ff ff       	jmp    101e90 <__alltraps>

00102534 <vector172>:
.globl vector172
vector172:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $172
  102536:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10253b:	e9 50 f9 ff ff       	jmp    101e90 <__alltraps>

00102540 <vector173>:
.globl vector173
vector173:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $173
  102542:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102547:	e9 44 f9 ff ff       	jmp    101e90 <__alltraps>

0010254c <vector174>:
.globl vector174
vector174:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $174
  10254e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102553:	e9 38 f9 ff ff       	jmp    101e90 <__alltraps>

00102558 <vector175>:
.globl vector175
vector175:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $175
  10255a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10255f:	e9 2c f9 ff ff       	jmp    101e90 <__alltraps>

00102564 <vector176>:
.globl vector176
vector176:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $176
  102566:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10256b:	e9 20 f9 ff ff       	jmp    101e90 <__alltraps>

00102570 <vector177>:
.globl vector177
vector177:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $177
  102572:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102577:	e9 14 f9 ff ff       	jmp    101e90 <__alltraps>

0010257c <vector178>:
.globl vector178
vector178:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $178
  10257e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102583:	e9 08 f9 ff ff       	jmp    101e90 <__alltraps>

00102588 <vector179>:
.globl vector179
vector179:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $179
  10258a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10258f:	e9 fc f8 ff ff       	jmp    101e90 <__alltraps>

00102594 <vector180>:
.globl vector180
vector180:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $180
  102596:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10259b:	e9 f0 f8 ff ff       	jmp    101e90 <__alltraps>

001025a0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $181
  1025a2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025a7:	e9 e4 f8 ff ff       	jmp    101e90 <__alltraps>

001025ac <vector182>:
.globl vector182
vector182:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $182
  1025ae:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025b3:	e9 d8 f8 ff ff       	jmp    101e90 <__alltraps>

001025b8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $183
  1025ba:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025bf:	e9 cc f8 ff ff       	jmp    101e90 <__alltraps>

001025c4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $184
  1025c6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025cb:	e9 c0 f8 ff ff       	jmp    101e90 <__alltraps>

001025d0 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $185
  1025d2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025d7:	e9 b4 f8 ff ff       	jmp    101e90 <__alltraps>

001025dc <vector186>:
.globl vector186
vector186:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $186
  1025de:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025e3:	e9 a8 f8 ff ff       	jmp    101e90 <__alltraps>

001025e8 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $187
  1025ea:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025ef:	e9 9c f8 ff ff       	jmp    101e90 <__alltraps>

001025f4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $188
  1025f6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025fb:	e9 90 f8 ff ff       	jmp    101e90 <__alltraps>

00102600 <vector189>:
.globl vector189
vector189:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $189
  102602:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102607:	e9 84 f8 ff ff       	jmp    101e90 <__alltraps>

0010260c <vector190>:
.globl vector190
vector190:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $190
  10260e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102613:	e9 78 f8 ff ff       	jmp    101e90 <__alltraps>

00102618 <vector191>:
.globl vector191
vector191:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $191
  10261a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10261f:	e9 6c f8 ff ff       	jmp    101e90 <__alltraps>

00102624 <vector192>:
.globl vector192
vector192:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $192
  102626:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10262b:	e9 60 f8 ff ff       	jmp    101e90 <__alltraps>

00102630 <vector193>:
.globl vector193
vector193:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $193
  102632:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102637:	e9 54 f8 ff ff       	jmp    101e90 <__alltraps>

0010263c <vector194>:
.globl vector194
vector194:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $194
  10263e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102643:	e9 48 f8 ff ff       	jmp    101e90 <__alltraps>

00102648 <vector195>:
.globl vector195
vector195:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $195
  10264a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10264f:	e9 3c f8 ff ff       	jmp    101e90 <__alltraps>

00102654 <vector196>:
.globl vector196
vector196:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $196
  102656:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10265b:	e9 30 f8 ff ff       	jmp    101e90 <__alltraps>

00102660 <vector197>:
.globl vector197
vector197:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $197
  102662:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102667:	e9 24 f8 ff ff       	jmp    101e90 <__alltraps>

0010266c <vector198>:
.globl vector198
vector198:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $198
  10266e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102673:	e9 18 f8 ff ff       	jmp    101e90 <__alltraps>

00102678 <vector199>:
.globl vector199
vector199:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $199
  10267a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10267f:	e9 0c f8 ff ff       	jmp    101e90 <__alltraps>

00102684 <vector200>:
.globl vector200
vector200:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $200
  102686:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10268b:	e9 00 f8 ff ff       	jmp    101e90 <__alltraps>

00102690 <vector201>:
.globl vector201
vector201:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $201
  102692:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102697:	e9 f4 f7 ff ff       	jmp    101e90 <__alltraps>

0010269c <vector202>:
.globl vector202
vector202:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $202
  10269e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026a3:	e9 e8 f7 ff ff       	jmp    101e90 <__alltraps>

001026a8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $203
  1026aa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026af:	e9 dc f7 ff ff       	jmp    101e90 <__alltraps>

001026b4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $204
  1026b6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026bb:	e9 d0 f7 ff ff       	jmp    101e90 <__alltraps>

001026c0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $205
  1026c2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026c7:	e9 c4 f7 ff ff       	jmp    101e90 <__alltraps>

001026cc <vector206>:
.globl vector206
vector206:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $206
  1026ce:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026d3:	e9 b8 f7 ff ff       	jmp    101e90 <__alltraps>

001026d8 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $207
  1026da:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026df:	e9 ac f7 ff ff       	jmp    101e90 <__alltraps>

001026e4 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $208
  1026e6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026eb:	e9 a0 f7 ff ff       	jmp    101e90 <__alltraps>

001026f0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $209
  1026f2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026f7:	e9 94 f7 ff ff       	jmp    101e90 <__alltraps>

001026fc <vector210>:
.globl vector210
vector210:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $210
  1026fe:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102703:	e9 88 f7 ff ff       	jmp    101e90 <__alltraps>

00102708 <vector211>:
.globl vector211
vector211:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $211
  10270a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10270f:	e9 7c f7 ff ff       	jmp    101e90 <__alltraps>

00102714 <vector212>:
.globl vector212
vector212:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $212
  102716:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10271b:	e9 70 f7 ff ff       	jmp    101e90 <__alltraps>

00102720 <vector213>:
.globl vector213
vector213:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $213
  102722:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102727:	e9 64 f7 ff ff       	jmp    101e90 <__alltraps>

0010272c <vector214>:
.globl vector214
vector214:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $214
  10272e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102733:	e9 58 f7 ff ff       	jmp    101e90 <__alltraps>

00102738 <vector215>:
.globl vector215
vector215:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $215
  10273a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10273f:	e9 4c f7 ff ff       	jmp    101e90 <__alltraps>

00102744 <vector216>:
.globl vector216
vector216:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $216
  102746:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10274b:	e9 40 f7 ff ff       	jmp    101e90 <__alltraps>

00102750 <vector217>:
.globl vector217
vector217:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $217
  102752:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102757:	e9 34 f7 ff ff       	jmp    101e90 <__alltraps>

0010275c <vector218>:
.globl vector218
vector218:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $218
  10275e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102763:	e9 28 f7 ff ff       	jmp    101e90 <__alltraps>

00102768 <vector219>:
.globl vector219
vector219:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $219
  10276a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10276f:	e9 1c f7 ff ff       	jmp    101e90 <__alltraps>

00102774 <vector220>:
.globl vector220
vector220:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $220
  102776:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10277b:	e9 10 f7 ff ff       	jmp    101e90 <__alltraps>

00102780 <vector221>:
.globl vector221
vector221:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $221
  102782:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102787:	e9 04 f7 ff ff       	jmp    101e90 <__alltraps>

0010278c <vector222>:
.globl vector222
vector222:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $222
  10278e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102793:	e9 f8 f6 ff ff       	jmp    101e90 <__alltraps>

00102798 <vector223>:
.globl vector223
vector223:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $223
  10279a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10279f:	e9 ec f6 ff ff       	jmp    101e90 <__alltraps>

001027a4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $224
  1027a6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027ab:	e9 e0 f6 ff ff       	jmp    101e90 <__alltraps>

001027b0 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $225
  1027b2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027b7:	e9 d4 f6 ff ff       	jmp    101e90 <__alltraps>

001027bc <vector226>:
.globl vector226
vector226:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $226
  1027be:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027c3:	e9 c8 f6 ff ff       	jmp    101e90 <__alltraps>

001027c8 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $227
  1027ca:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027cf:	e9 bc f6 ff ff       	jmp    101e90 <__alltraps>

001027d4 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $228
  1027d6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027db:	e9 b0 f6 ff ff       	jmp    101e90 <__alltraps>

001027e0 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $229
  1027e2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027e7:	e9 a4 f6 ff ff       	jmp    101e90 <__alltraps>

001027ec <vector230>:
.globl vector230
vector230:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $230
  1027ee:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027f3:	e9 98 f6 ff ff       	jmp    101e90 <__alltraps>

001027f8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $231
  1027fa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027ff:	e9 8c f6 ff ff       	jmp    101e90 <__alltraps>

00102804 <vector232>:
.globl vector232
vector232:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $232
  102806:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10280b:	e9 80 f6 ff ff       	jmp    101e90 <__alltraps>

00102810 <vector233>:
.globl vector233
vector233:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $233
  102812:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102817:	e9 74 f6 ff ff       	jmp    101e90 <__alltraps>

0010281c <vector234>:
.globl vector234
vector234:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $234
  10281e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102823:	e9 68 f6 ff ff       	jmp    101e90 <__alltraps>

00102828 <vector235>:
.globl vector235
vector235:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $235
  10282a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10282f:	e9 5c f6 ff ff       	jmp    101e90 <__alltraps>

00102834 <vector236>:
.globl vector236
vector236:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $236
  102836:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10283b:	e9 50 f6 ff ff       	jmp    101e90 <__alltraps>

00102840 <vector237>:
.globl vector237
vector237:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $237
  102842:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102847:	e9 44 f6 ff ff       	jmp    101e90 <__alltraps>

0010284c <vector238>:
.globl vector238
vector238:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $238
  10284e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102853:	e9 38 f6 ff ff       	jmp    101e90 <__alltraps>

00102858 <vector239>:
.globl vector239
vector239:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $239
  10285a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10285f:	e9 2c f6 ff ff       	jmp    101e90 <__alltraps>

00102864 <vector240>:
.globl vector240
vector240:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $240
  102866:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10286b:	e9 20 f6 ff ff       	jmp    101e90 <__alltraps>

00102870 <vector241>:
.globl vector241
vector241:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $241
  102872:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102877:	e9 14 f6 ff ff       	jmp    101e90 <__alltraps>

0010287c <vector242>:
.globl vector242
vector242:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $242
  10287e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102883:	e9 08 f6 ff ff       	jmp    101e90 <__alltraps>

00102888 <vector243>:
.globl vector243
vector243:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $243
  10288a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10288f:	e9 fc f5 ff ff       	jmp    101e90 <__alltraps>

00102894 <vector244>:
.globl vector244
vector244:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $244
  102896:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10289b:	e9 f0 f5 ff ff       	jmp    101e90 <__alltraps>

001028a0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $245
  1028a2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028a7:	e9 e4 f5 ff ff       	jmp    101e90 <__alltraps>

001028ac <vector246>:
.globl vector246
vector246:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $246
  1028ae:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028b3:	e9 d8 f5 ff ff       	jmp    101e90 <__alltraps>

001028b8 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $247
  1028ba:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028bf:	e9 cc f5 ff ff       	jmp    101e90 <__alltraps>

001028c4 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $248
  1028c6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028cb:	e9 c0 f5 ff ff       	jmp    101e90 <__alltraps>

001028d0 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $249
  1028d2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028d7:	e9 b4 f5 ff ff       	jmp    101e90 <__alltraps>

001028dc <vector250>:
.globl vector250
vector250:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $250
  1028de:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028e3:	e9 a8 f5 ff ff       	jmp    101e90 <__alltraps>

001028e8 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $251
  1028ea:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028ef:	e9 9c f5 ff ff       	jmp    101e90 <__alltraps>

001028f4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $252
  1028f6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028fb:	e9 90 f5 ff ff       	jmp    101e90 <__alltraps>

00102900 <vector253>:
.globl vector253
vector253:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $253
  102902:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102907:	e9 84 f5 ff ff       	jmp    101e90 <__alltraps>

0010290c <vector254>:
.globl vector254
vector254:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $254
  10290e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102913:	e9 78 f5 ff ff       	jmp    101e90 <__alltraps>

00102918 <vector255>:
.globl vector255
vector255:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $255
  10291a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10291f:	e9 6c f5 ff ff       	jmp    101e90 <__alltraps>

00102924 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102924:	55                   	push   %ebp
  102925:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102927:	8b 55 08             	mov    0x8(%ebp),%edx
  10292a:	a1 84 99 11 00       	mov    0x119984,%eax
  10292f:	29 c2                	sub    %eax,%edx
  102931:	89 d0                	mov    %edx,%eax
  102933:	c1 f8 02             	sar    $0x2,%eax
  102936:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10293c:	5d                   	pop    %ebp
  10293d:	c3                   	ret    

0010293e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  10293e:	55                   	push   %ebp
  10293f:	89 e5                	mov    %esp,%ebp
  102941:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102944:	8b 45 08             	mov    0x8(%ebp),%eax
  102947:	89 04 24             	mov    %eax,(%esp)
  10294a:	e8 d5 ff ff ff       	call   102924 <page2ppn>
  10294f:	c1 e0 0c             	shl    $0xc,%eax
}
  102952:	c9                   	leave  
  102953:	c3                   	ret    

00102954 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102954:	55                   	push   %ebp
  102955:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102957:	8b 45 08             	mov    0x8(%ebp),%eax
  10295a:	8b 00                	mov    (%eax),%eax
}
  10295c:	5d                   	pop    %ebp
  10295d:	c3                   	ret    

0010295e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  10295e:	55                   	push   %ebp
  10295f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102961:	8b 45 08             	mov    0x8(%ebp),%eax
  102964:	8b 55 0c             	mov    0xc(%ebp),%edx
  102967:	89 10                	mov    %edx,(%eax)
}
  102969:	5d                   	pop    %ebp
  10296a:	c3                   	ret    

0010296b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10296b:	55                   	push   %ebp
  10296c:	89 e5                	mov    %esp,%ebp
  10296e:	83 ec 10             	sub    $0x10,%esp
  102971:	c7 45 fc 70 99 11 00 	movl   $0x119970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10297b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10297e:	89 50 04             	mov    %edx,0x4(%eax)
  102981:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102984:	8b 50 04             	mov    0x4(%eax),%edx
  102987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10298a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10298c:	c7 05 78 99 11 00 00 	movl   $0x0,0x119978
  102993:	00 00 00 
}
  102996:	c9                   	leave  
  102997:	c3                   	ret    

00102998 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102998:	55                   	push   %ebp
  102999:	89 e5                	mov    %esp,%ebp
  10299b:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  10299e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029a2:	75 24                	jne    1029c8 <default_init_memmap+0x30>
  1029a4:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  1029ab:	00 
  1029ac:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1029b3:	00 
  1029b4:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1029bb:	00 
  1029bc:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1029c3:	e8 f8 e2 ff ff       	call   100cc0 <__panic>
    struct Page *p = base;
  1029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//cprintf("base=%x\n",base);
    for (; p != base + n; p ++) {
  1029ce:	eb 7d                	jmp    102a4d <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d3:	83 c0 04             	add    $0x4,%eax
  1029d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1029dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029e6:	0f a3 10             	bt     %edx,(%eax)
  1029e9:	19 c0                	sbb    %eax,%eax
  1029eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1029ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029f2:	0f 95 c0             	setne  %al
  1029f5:	0f b6 c0             	movzbl %al,%eax
  1029f8:	85 c0                	test   %eax,%eax
  1029fa:	75 24                	jne    102a20 <default_init_memmap+0x88>
  1029fc:	c7 44 24 0c 81 69 10 	movl   $0x106981,0xc(%esp)
  102a03:	00 
  102a04:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102a0b:	00 
  102a0c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  102a13:	00 
  102a14:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102a1b:	e8 a0 e2 ff ff       	call   100cc0 <__panic>
        p->flags = p->property = 0;
  102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2d:	8b 50 08             	mov    0x8(%eax),%edx
  102a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a33:	89 50 04             	mov    %edx,0x4(%eax)
	//ClearPageProperty(p);
	//ClearPageReserved(p);  
	set_page_ref(p, 0);
  102a36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a3d:	00 
  102a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a41:	89 04 24             	mov    %eax,(%esp)
  102a44:	e8 15 ff ff ff       	call   10295e <set_page_ref>
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
//cprintf("base=%x\n",base);
    for (; p != base + n; p ++) {
  102a49:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a50:	89 d0                	mov    %edx,%eax
  102a52:	c1 e0 02             	shl    $0x2,%eax
  102a55:	01 d0                	add    %edx,%eax
  102a57:	c1 e0 02             	shl    $0x2,%eax
  102a5a:	89 c2                	mov    %eax,%edx
  102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5f:	01 d0                	add    %edx,%eax
  102a61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a64:	0f 85 66 ff ff ff    	jne    1029d0 <default_init_memmap+0x38>
	//ClearPageProperty(p);
	//ClearPageReserved(p);  
	set_page_ref(p, 0);
	
    }
    base->property = n;
  102a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a70:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a73:	8b 45 08             	mov    0x8(%ebp),%eax
  102a76:	83 c0 04             	add    $0x4,%eax
  102a79:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a80:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a89:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102a8c:	8b 15 78 99 11 00    	mov    0x119978,%edx
  102a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a95:	01 d0                	add    %edx,%eax
  102a97:	a3 78 99 11 00       	mov    %eax,0x119978
    list_add_before(&free_list, &(base->page_link));
  102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9f:	83 c0 0c             	add    $0xc,%eax
  102aa2:	c7 45 dc 70 99 11 00 	movl   $0x119970,-0x24(%ebp)
  102aa9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102aaf:	8b 00                	mov    (%eax),%eax
  102ab1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102ab4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ab7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102aba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102abd:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ac0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ac3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ac6:	89 10                	mov    %edx,(%eax)
  102ac8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102acb:	8b 10                	mov    (%eax),%edx
  102acd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ad0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ad3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ad6:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ad9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102adf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102ae2:	89 10                	mov    %edx,(%eax)
}
  102ae4:	c9                   	leave  
  102ae5:	c3                   	ret    

00102ae6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102ae6:	55                   	push   %ebp
  102ae7:	89 e5                	mov    %esp,%ebp
  102ae9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102aec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102af0:	75 24                	jne    102b16 <default_alloc_pages+0x30>
  102af2:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  102af9:	00 
  102afa:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102b01:	00 
  102b02:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
  102b09:	00 
  102b0a:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102b11:	e8 aa e1 ff ff       	call   100cc0 <__panic>
    if (n > nr_free) {
  102b16:	a1 78 99 11 00       	mov    0x119978,%eax
  102b1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b1e:	73 0a                	jae    102b2a <default_alloc_pages+0x44>
        return NULL;
  102b20:	b8 00 00 00 00       	mov    $0x0,%eax
  102b25:	e9 78 01 00 00       	jmp    102ca2 <default_alloc_pages+0x1bc>
    }
    struct Page *page = NULL;
  102b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102b31:	c7 45 f0 70 99 11 00 	movl   $0x119970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102b38:	eb 1c                	jmp    102b56 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b3d:	83 e8 0c             	sub    $0xc,%eax
  102b40:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  102b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b46:	8b 40 08             	mov    0x8(%eax),%eax
  102b49:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b4c:	72 08                	jb     102b56 <default_alloc_pages+0x70>
            page = p;
  102b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102b54:	eb 18                	jmp    102b6e <default_alloc_pages+0x88>
  102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b5f:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b65:	81 7d f0 70 99 11 00 	cmpl   $0x119970,-0x10(%ebp)
  102b6c:	75 cc                	jne    102b3a <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102b72:	0f 84 27 01 00 00    	je     102c9f <default_alloc_pages+0x1b9>
	struct Page *p=page;
  102b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (;p!=page+n;p++)
  102b7e:	eb 0e                	jmp    102b8e <default_alloc_pages+0xa8>
		p->flags=1;	
  102b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b83:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
            break;
        }
    }
    if (page != NULL) {
	struct Page *p=page;
	for (;p!=page+n;p++)
  102b8a:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102b8e:	8b 55 08             	mov    0x8(%ebp),%edx
  102b91:	89 d0                	mov    %edx,%eax
  102b93:	c1 e0 02             	shl    $0x2,%eax
  102b96:	01 d0                	add    %edx,%eax
  102b98:	c1 e0 02             	shl    $0x2,%eax
  102b9b:	89 c2                	mov    %eax,%edx
  102b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba0:	01 d0                	add    %edx,%eax
  102ba2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102ba5:	75 d9                	jne    102b80 <default_alloc_pages+0x9a>
		p->flags=1;	
	
        if (page->property > n) {
  102ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102baa:	8b 40 08             	mov    0x8(%eax),%eax
  102bad:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bb0:	0f 86 98 00 00 00    	jbe    102c4e <default_alloc_pages+0x168>
            struct Page *p = page + n;
  102bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  102bb9:	89 d0                	mov    %edx,%eax
  102bbb:	c1 e0 02             	shl    $0x2,%eax
  102bbe:	01 d0                	add    %edx,%eax
  102bc0:	c1 e0 02             	shl    $0x2,%eax
  102bc3:	89 c2                	mov    %eax,%edx
  102bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc8:	01 d0                	add    %edx,%eax
  102bca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
  102bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bd0:	8b 40 08             	mov    0x8(%eax),%eax
  102bd3:	2b 45 08             	sub    0x8(%ebp),%eax
  102bd6:	89 c2                	mov    %eax,%edx
  102bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bdb:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(page->page_link), &(p->page_link));
  102bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102be1:	83 c0 0c             	add    $0xc,%eax
  102be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102be7:	83 c2 0c             	add    $0xc,%edx
  102bea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102bed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102bf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bf3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bf9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102bfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102bff:	8b 40 04             	mov    0x4(%eax),%eax
  102c02:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c05:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102c08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c0b:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102c0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c14:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102c17:	89 10                	mov    %edx,(%eax)
  102c19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c1c:	8b 10                	mov    (%eax),%edx
  102c1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c21:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c24:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c27:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102c2a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c30:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c33:	89 10                	mov    %edx,(%eax)
	    SetPageProperty(p);
  102c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c38:	83 c0 04             	add    $0x4,%eax
  102c3b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102c42:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102c45:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102c48:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102c4b:	0f ab 10             	bts    %edx,(%eax)
    	}
	list_del(&(page->page_link));
  102c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c51:	83 c0 0c             	add    $0xc,%eax
  102c54:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102c57:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102c5a:	8b 40 04             	mov    0x4(%eax),%eax
  102c5d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102c60:	8b 12                	mov    (%edx),%edx
  102c62:	89 55 b4             	mov    %edx,-0x4c(%ebp)
  102c65:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102c68:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102c6b:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c6e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c71:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c74:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102c77:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  102c79:	a1 78 99 11 00       	mov    0x119978,%eax
  102c7e:	2b 45 08             	sub    0x8(%ebp),%eax
  102c81:	a3 78 99 11 00       	mov    %eax,0x119978
        ClearPageProperty(page);
  102c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c89:	83 c0 04             	add    $0x4,%eax
  102c8c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  102c93:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c96:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c99:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102c9c:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ca2:	c9                   	leave  
  102ca3:	c3                   	ret    

00102ca4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102ca4:	55                   	push   %ebp
  102ca5:	89 e5                	mov    %esp,%ebp
  102ca7:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
  102cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cb1:	75 24                	jne    102cd7 <default_free_pages+0x33>
  102cb3:	c7 44 24 0c 50 69 10 	movl   $0x106950,0xc(%esp)
  102cba:	00 
  102cbb:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102cc2:	00 
  102cc3:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102cca:	00 
  102ccb:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102cd2:	e8 e9 df ff ff       	call   100cc0 <__panic>
    struct Page *p = base;
  102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102cdd:	e9 9d 00 00 00       	jmp    102d7f <default_free_pages+0xdb>
        assert(PageReserved(p) && !PageProperty(p));
  102ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce5:	83 c0 04             	add    $0x4,%eax
  102ce8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  102cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cf8:	0f a3 10             	bt     %edx,(%eax)
  102cfb:	19 c0                	sbb    %eax,%eax
  102cfd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
  102d00:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d04:	0f 95 c0             	setne  %al
  102d07:	0f b6 c0             	movzbl %al,%eax
  102d0a:	85 c0                	test   %eax,%eax
  102d0c:	74 2c                	je     102d3a <default_free_pages+0x96>
  102d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d11:	83 c0 04             	add    $0x4,%eax
  102d14:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
  102d1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102d1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d21:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102d24:	0f a3 10             	bt     %edx,(%eax)
  102d27:	19 c0                	sbb    %eax,%eax
  102d29:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
  102d2c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  102d30:	0f 95 c0             	setne  %al
  102d33:	0f b6 c0             	movzbl %al,%eax
  102d36:	85 c0                	test   %eax,%eax
  102d38:	74 24                	je     102d5e <default_free_pages+0xba>
  102d3a:	c7 44 24 0c 94 69 10 	movl   $0x106994,0xc(%esp)
  102d41:	00 
  102d42:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  102d49:	00 
  102d4a:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  102d51:	00 
  102d52:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  102d59:	e8 62 df ff ff       	call   100cc0 <__panic>
        p->flags = 0;
  102d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102d68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d6f:	00 
  102d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d73:	89 04 24             	mov    %eax,(%esp)
  102d76:	e8 e3 fb ff ff       	call   10295e <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102d7b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d82:	89 d0                	mov    %edx,%eax
  102d84:	c1 e0 02             	shl    $0x2,%eax
  102d87:	01 d0                	add    %edx,%eax
  102d89:	c1 e0 02             	shl    $0x2,%eax
  102d8c:	89 c2                	mov    %eax,%edx
  102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d91:	01 d0                	add    %edx,%eax
  102d93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d96:	0f 85 46 ff ff ff    	jne    102ce2 <default_free_pages+0x3e>
        assert(PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102da2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102da5:	8b 45 08             	mov    0x8(%ebp),%eax
  102da8:	83 c0 04             	add    $0x4,%eax
  102dab:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  102db2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102db5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102db8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102dbb:	0f ab 10             	bts    %edx,(%eax)
  102dbe:	c7 45 c4 70 99 11 00 	movl   $0x119970,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102dc5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102dc8:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102dce:	e9 08 01 00 00       	jmp    102edb <default_free_pages+0x237>
        p = le2page(le, page_link);
  102dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd6:	83 e8 0c             	sub    $0xc,%eax
  102dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ddf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  102de2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102de5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102deb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dee:	8b 50 08             	mov    0x8(%eax),%edx
  102df1:	89 d0                	mov    %edx,%eax
  102df3:	c1 e0 02             	shl    $0x2,%eax
  102df6:	01 d0                	add    %edx,%eax
  102df8:	c1 e0 02             	shl    $0x2,%eax
  102dfb:	89 c2                	mov    %eax,%edx
  102dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  102e00:	01 d0                	add    %edx,%eax
  102e02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e05:	75 5a                	jne    102e61 <default_free_pages+0x1bd>
            base->property += p->property;
  102e07:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0a:	8b 50 08             	mov    0x8(%eax),%edx
  102e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e10:	8b 40 08             	mov    0x8(%eax),%eax
  102e13:	01 c2                	add    %eax,%edx
  102e15:	8b 45 08             	mov    0x8(%ebp),%eax
  102e18:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e1e:	83 c0 04             	add    $0x4,%eax
  102e21:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  102e28:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e31:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e37:	83 c0 0c             	add    $0xc,%eax
  102e3a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e3d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e40:	8b 40 04             	mov    0x4(%eax),%eax
  102e43:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e46:	8b 12                	mov    (%edx),%edx
  102e48:	89 55 b0             	mov    %edx,-0x50(%ebp)
  102e4b:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e51:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102e54:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e57:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e5a:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e5d:	89 10                	mov    %edx,(%eax)
  102e5f:	eb 7a                	jmp    102edb <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e64:	8b 50 08             	mov    0x8(%eax),%edx
  102e67:	89 d0                	mov    %edx,%eax
  102e69:	c1 e0 02             	shl    $0x2,%eax
  102e6c:	01 d0                	add    %edx,%eax
  102e6e:	c1 e0 02             	shl    $0x2,%eax
  102e71:	89 c2                	mov    %eax,%edx
  102e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e76:	01 d0                	add    %edx,%eax
  102e78:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e7b:	75 5e                	jne    102edb <default_free_pages+0x237>
            p->property += base->property;
  102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e80:	8b 50 08             	mov    0x8(%eax),%edx
  102e83:	8b 45 08             	mov    0x8(%ebp),%eax
  102e86:	8b 40 08             	mov    0x8(%eax),%eax
  102e89:	01 c2                	add    %eax,%edx
  102e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e8e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102e91:	8b 45 08             	mov    0x8(%ebp),%eax
  102e94:	83 c0 04             	add    $0x4,%eax
  102e97:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
  102e9e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102ea1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102ea4:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102ea7:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ead:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb3:	83 c0 0c             	add    $0xc,%eax
  102eb6:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102eb9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102ebc:	8b 40 04             	mov    0x4(%eax),%eax
  102ebf:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102ec2:	8b 12                	mov    (%edx),%edx
  102ec4:	89 55 9c             	mov    %edx,-0x64(%ebp)
  102ec7:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102eca:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102ecd:	8b 55 98             	mov    -0x68(%ebp),%edx
  102ed0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102ed3:	8b 45 98             	mov    -0x68(%ebp),%eax
  102ed6:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102ed9:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102edb:	81 7d f0 70 99 11 00 	cmpl   $0x119970,-0x10(%ebp)
  102ee2:	0f 85 eb fe ff ff    	jne    102dd3 <default_free_pages+0x12f>
            base = p;
            list_del(&(p->page_link));
        }
    }

    nr_free += n;
  102ee8:	8b 15 78 99 11 00    	mov    0x119978,%edx
  102eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef1:	01 d0                	add    %edx,%eax
  102ef3:	a3 78 99 11 00       	mov    %eax,0x119978
    le = &free_list;
  102ef8:	c7 45 f0 70 99 11 00 	movl   $0x119970,-0x10(%ebp)
  102eff:	c7 45 94 70 99 11 00 	movl   $0x119970,-0x6c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102f06:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102f09:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  102f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int flag=0;
  102f0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102f16:	eb 67                	jmp    102f7f <default_free_pages+0x2db>
    	p = le2page(le, page_link);
  102f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f1b:	83 e8 0c             	sub    $0xc,%eax
  102f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	list_entry_t *before_le = le;
  102f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f24:	89 45 e8             	mov    %eax,-0x18(%ebp)
    	if (p > base) {
  102f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102f2d:	76 50                	jbe    102f7f <default_free_pages+0x2db>
    		list_add_before(before_le, &(base->page_link));
  102f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f32:	8d 50 0c             	lea    0xc(%eax),%edx
  102f35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f38:	89 45 90             	mov    %eax,-0x70(%ebp)
  102f3b:	89 55 8c             	mov    %edx,-0x74(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f41:	8b 00                	mov    (%eax),%eax
  102f43:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102f46:	89 55 88             	mov    %edx,-0x78(%ebp)
  102f49:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102f4c:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f4f:	89 45 80             	mov    %eax,-0x80(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102f52:	8b 45 80             	mov    -0x80(%ebp),%eax
  102f55:	8b 55 88             	mov    -0x78(%ebp),%edx
  102f58:	89 10                	mov    %edx,(%eax)
  102f5a:	8b 45 80             	mov    -0x80(%ebp),%eax
  102f5d:	8b 10                	mov    (%eax),%edx
  102f5f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102f62:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102f65:	8b 45 88             	mov    -0x78(%ebp),%eax
  102f68:	8b 55 80             	mov    -0x80(%ebp),%edx
  102f6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102f6e:	8b 45 88             	mov    -0x78(%ebp),%eax
  102f71:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102f74:	89 10                	mov    %edx,(%eax)
    		flag = 1;
  102f76:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    		break;
  102f7d:	eb 22                	jmp    102fa1 <default_free_pages+0x2fd>
  102f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f82:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102f88:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102f8e:	8b 40 04             	mov    0x4(%eax),%eax

    nr_free += n;
    le = &free_list;
    le = list_next(&free_list);
    int flag=0;
    while ((le = list_next(le)) != &free_list) {
  102f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f94:	81 7d f0 70 99 11 00 	cmpl   $0x119970,-0x10(%ebp)
  102f9b:	0f 85 77 ff ff ff    	jne    102f18 <default_free_pages+0x274>
    		list_add_before(before_le, &(base->page_link));
    		flag = 1;
    		break;
    	}
    }
    if (flag == 0)
  102fa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102fa5:	75 78                	jne    10301f <default_free_pages+0x37b>
    	list_add_before(&free_list, &(base->page_link));
  102fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  102faa:	83 c0 0c             	add    $0xc,%eax
  102fad:	c7 85 78 ff ff ff 70 	movl   $0x119970,-0x88(%ebp)
  102fb4:	99 11 00 
  102fb7:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102fbd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102fc3:	8b 00                	mov    (%eax),%eax
  102fc5:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
  102fcb:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
  102fd1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  102fd7:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102fdd:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102fe3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  102fe9:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
  102fef:	89 10                	mov    %edx,(%eax)
  102ff1:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  102ff7:	8b 10                	mov    (%eax),%edx
  102ff9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  102fff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103002:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  103008:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
  10300e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103011:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  103017:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  10301d:	89 10                	mov    %edx,(%eax)
}
  10301f:	c9                   	leave  
  103020:	c3                   	ret    

00103021 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  103021:	55                   	push   %ebp
  103022:	89 e5                	mov    %esp,%ebp
    return nr_free;
  103024:	a1 78 99 11 00       	mov    0x119978,%eax
}
  103029:	5d                   	pop    %ebp
  10302a:	c3                   	ret    

0010302b <basic_check>:

static void
basic_check(void) {
  10302b:	55                   	push   %ebp
  10302c:	89 e5                	mov    %esp,%ebp
  10302e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  103031:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10303e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103041:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  103044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10304b:	e8 85 0e 00 00       	call   103ed5 <alloc_pages>
  103050:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103053:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103057:	75 24                	jne    10307d <basic_check+0x52>
  103059:	c7 44 24 0c b8 69 10 	movl   $0x1069b8,0xc(%esp)
  103060:	00 
  103061:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103068:	00 
  103069:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  103070:	00 
  103071:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103078:	e8 43 dc ff ff       	call   100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10307d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103084:	e8 4c 0e 00 00       	call   103ed5 <alloc_pages>
  103089:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10308c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103090:	75 24                	jne    1030b6 <basic_check+0x8b>
  103092:	c7 44 24 0c d4 69 10 	movl   $0x1069d4,0xc(%esp)
  103099:	00 
  10309a:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1030a1:	00 
  1030a2:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  1030a9:	00 
  1030aa:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1030b1:	e8 0a dc ff ff       	call   100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1030b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030bd:	e8 13 0e 00 00       	call   103ed5 <alloc_pages>
  1030c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030c9:	75 24                	jne    1030ef <basic_check+0xc4>
  1030cb:	c7 44 24 0c f0 69 10 	movl   $0x1069f0,0xc(%esp)
  1030d2:	00 
  1030d3:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1030da:	00 
  1030db:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  1030e2:	00 
  1030e3:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1030ea:	e8 d1 db ff ff       	call   100cc0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1030ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1030f5:	74 10                	je     103107 <basic_check+0xdc>
  1030f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1030fd:	74 08                	je     103107 <basic_check+0xdc>
  1030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103102:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103105:	75 24                	jne    10312b <basic_check+0x100>
  103107:	c7 44 24 0c 0c 6a 10 	movl   $0x106a0c,0xc(%esp)
  10310e:	00 
  10310f:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103116:	00 
  103117:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  10311e:	00 
  10311f:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103126:	e8 95 db ff ff       	call   100cc0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  10312b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10312e:	89 04 24             	mov    %eax,(%esp)
  103131:	e8 1e f8 ff ff       	call   102954 <page_ref>
  103136:	85 c0                	test   %eax,%eax
  103138:	75 1e                	jne    103158 <basic_check+0x12d>
  10313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10313d:	89 04 24             	mov    %eax,(%esp)
  103140:	e8 0f f8 ff ff       	call   102954 <page_ref>
  103145:	85 c0                	test   %eax,%eax
  103147:	75 0f                	jne    103158 <basic_check+0x12d>
  103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10314c:	89 04 24             	mov    %eax,(%esp)
  10314f:	e8 00 f8 ff ff       	call   102954 <page_ref>
  103154:	85 c0                	test   %eax,%eax
  103156:	74 24                	je     10317c <basic_check+0x151>
  103158:	c7 44 24 0c 30 6a 10 	movl   $0x106a30,0xc(%esp)
  10315f:	00 
  103160:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103167:	00 
  103168:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  10316f:	00 
  103170:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103177:	e8 44 db ff ff       	call   100cc0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10317c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10317f:	89 04 24             	mov    %eax,(%esp)
  103182:	e8 b7 f7 ff ff       	call   10293e <page2pa>
  103187:	8b 15 e0 98 11 00    	mov    0x1198e0,%edx
  10318d:	c1 e2 0c             	shl    $0xc,%edx
  103190:	39 d0                	cmp    %edx,%eax
  103192:	72 24                	jb     1031b8 <basic_check+0x18d>
  103194:	c7 44 24 0c 6c 6a 10 	movl   $0x106a6c,0xc(%esp)
  10319b:	00 
  10319c:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1031a3:	00 
  1031a4:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  1031ab:	00 
  1031ac:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1031b3:	e8 08 db ff ff       	call   100cc0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031bb:	89 04 24             	mov    %eax,(%esp)
  1031be:	e8 7b f7 ff ff       	call   10293e <page2pa>
  1031c3:	8b 15 e0 98 11 00    	mov    0x1198e0,%edx
  1031c9:	c1 e2 0c             	shl    $0xc,%edx
  1031cc:	39 d0                	cmp    %edx,%eax
  1031ce:	72 24                	jb     1031f4 <basic_check+0x1c9>
  1031d0:	c7 44 24 0c 89 6a 10 	movl   $0x106a89,0xc(%esp)
  1031d7:	00 
  1031d8:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1031df:	00 
  1031e0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  1031e7:	00 
  1031e8:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1031ef:	e8 cc da ff ff       	call   100cc0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031f7:	89 04 24             	mov    %eax,(%esp)
  1031fa:	e8 3f f7 ff ff       	call   10293e <page2pa>
  1031ff:	8b 15 e0 98 11 00    	mov    0x1198e0,%edx
  103205:	c1 e2 0c             	shl    $0xc,%edx
  103208:	39 d0                	cmp    %edx,%eax
  10320a:	72 24                	jb     103230 <basic_check+0x205>
  10320c:	c7 44 24 0c a6 6a 10 	movl   $0x106aa6,0xc(%esp)
  103213:	00 
  103214:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10321b:	00 
  10321c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  103223:	00 
  103224:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10322b:	e8 90 da ff ff       	call   100cc0 <__panic>

    list_entry_t free_list_store = free_list;
  103230:	a1 70 99 11 00       	mov    0x119970,%eax
  103235:	8b 15 74 99 11 00    	mov    0x119974,%edx
  10323b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10323e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103241:	c7 45 e0 70 99 11 00 	movl   $0x119970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103248:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10324b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10324e:	89 50 04             	mov    %edx,0x4(%eax)
  103251:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103254:	8b 50 04             	mov    0x4(%eax),%edx
  103257:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10325a:	89 10                	mov    %edx,(%eax)
  10325c:	c7 45 dc 70 99 11 00 	movl   $0x119970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103263:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103266:	8b 40 04             	mov    0x4(%eax),%eax
  103269:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10326c:	0f 94 c0             	sete   %al
  10326f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103272:	85 c0                	test   %eax,%eax
  103274:	75 24                	jne    10329a <basic_check+0x26f>
  103276:	c7 44 24 0c c3 6a 10 	movl   $0x106ac3,0xc(%esp)
  10327d:	00 
  10327e:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103285:	00 
  103286:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10328d:	00 
  10328e:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103295:	e8 26 da ff ff       	call   100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
  10329a:	a1 78 99 11 00       	mov    0x119978,%eax
  10329f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1032a2:	c7 05 78 99 11 00 00 	movl   $0x0,0x119978
  1032a9:	00 00 00 

    assert(alloc_page() == NULL);
  1032ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032b3:	e8 1d 0c 00 00       	call   103ed5 <alloc_pages>
  1032b8:	85 c0                	test   %eax,%eax
  1032ba:	74 24                	je     1032e0 <basic_check+0x2b5>
  1032bc:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  1032c3:	00 
  1032c4:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1032cb:	00 
  1032cc:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  1032d3:	00 
  1032d4:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1032db:	e8 e0 d9 ff ff       	call   100cc0 <__panic>
    free_page(p0);
  1032e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032e7:	00 
  1032e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032eb:	89 04 24             	mov    %eax,(%esp)
  1032ee:	e8 1a 0c 00 00       	call   103f0d <free_pages>
    free_page(p1);
  1032f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032fa:	00 
  1032fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032fe:	89 04 24             	mov    %eax,(%esp)
  103301:	e8 07 0c 00 00       	call   103f0d <free_pages>
    free_page(p2);
  103306:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10330d:	00 
  10330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103311:	89 04 24             	mov    %eax,(%esp)
  103314:	e8 f4 0b 00 00       	call   103f0d <free_pages>
    assert(nr_free == 3);
  103319:	a1 78 99 11 00       	mov    0x119978,%eax
  10331e:	83 f8 03             	cmp    $0x3,%eax
  103321:	74 24                	je     103347 <basic_check+0x31c>
  103323:	c7 44 24 0c ef 6a 10 	movl   $0x106aef,0xc(%esp)
  10332a:	00 
  10332b:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103332:	00 
  103333:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  10333a:	00 
  10333b:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103342:	e8 79 d9 ff ff       	call   100cc0 <__panic>
    assert((p0 = alloc_page()) != NULL);
  103347:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10334e:	e8 82 0b 00 00       	call   103ed5 <alloc_pages>
  103353:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103356:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10335a:	75 24                	jne    103380 <basic_check+0x355>
  10335c:	c7 44 24 0c b8 69 10 	movl   $0x1069b8,0xc(%esp)
  103363:	00 
  103364:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10336b:	00 
  10336c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  103373:	00 
  103374:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10337b:	e8 40 d9 ff ff       	call   100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103380:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103387:	e8 49 0b 00 00       	call   103ed5 <alloc_pages>
  10338c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103393:	75 24                	jne    1033b9 <basic_check+0x38e>
  103395:	c7 44 24 0c d4 69 10 	movl   $0x1069d4,0xc(%esp)
  10339c:	00 
  10339d:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1033a4:	00 
  1033a5:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  1033ac:	00 
  1033ad:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1033b4:	e8 07 d9 ff ff       	call   100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1033b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033c0:	e8 10 0b 00 00       	call   103ed5 <alloc_pages>
  1033c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1033cc:	75 24                	jne    1033f2 <basic_check+0x3c7>
  1033ce:	c7 44 24 0c f0 69 10 	movl   $0x1069f0,0xc(%esp)
  1033d5:	00 
  1033d6:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1033dd:	00 
  1033de:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  1033e5:	00 
  1033e6:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1033ed:	e8 ce d8 ff ff       	call   100cc0 <__panic>

    assert(alloc_page() == NULL);
  1033f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033f9:	e8 d7 0a 00 00       	call   103ed5 <alloc_pages>
  1033fe:	85 c0                	test   %eax,%eax
  103400:	74 24                	je     103426 <basic_check+0x3fb>
  103402:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  103409:	00 
  10340a:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103411:	00 
  103412:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  103419:	00 
  10341a:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103421:	e8 9a d8 ff ff       	call   100cc0 <__panic>

    free_page(p0);
  103426:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10342d:	00 
  10342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103431:	89 04 24             	mov    %eax,(%esp)
  103434:	e8 d4 0a 00 00       	call   103f0d <free_pages>
  103439:	c7 45 d8 70 99 11 00 	movl   $0x119970,-0x28(%ebp)
  103440:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103443:	8b 40 04             	mov    0x4(%eax),%eax
  103446:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103449:	0f 94 c0             	sete   %al
  10344c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10344f:	85 c0                	test   %eax,%eax
  103451:	74 24                	je     103477 <basic_check+0x44c>
  103453:	c7 44 24 0c fc 6a 10 	movl   $0x106afc,0xc(%esp)
  10345a:	00 
  10345b:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103462:	00 
  103463:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  10346a:	00 
  10346b:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103472:	e8 49 d8 ff ff       	call   100cc0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10347e:	e8 52 0a 00 00       	call   103ed5 <alloc_pages>
  103483:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103489:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10348c:	74 24                	je     1034b2 <basic_check+0x487>
  10348e:	c7 44 24 0c 14 6b 10 	movl   $0x106b14,0xc(%esp)
  103495:	00 
  103496:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10349d:	00 
  10349e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  1034a5:	00 
  1034a6:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1034ad:	e8 0e d8 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  1034b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034b9:	e8 17 0a 00 00       	call   103ed5 <alloc_pages>
  1034be:	85 c0                	test   %eax,%eax
  1034c0:	74 24                	je     1034e6 <basic_check+0x4bb>
  1034c2:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  1034c9:	00 
  1034ca:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1034d1:	00 
  1034d2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  1034d9:	00 
  1034da:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1034e1:	e8 da d7 ff ff       	call   100cc0 <__panic>

    assert(nr_free == 0);
  1034e6:	a1 78 99 11 00       	mov    0x119978,%eax
  1034eb:	85 c0                	test   %eax,%eax
  1034ed:	74 24                	je     103513 <basic_check+0x4e8>
  1034ef:	c7 44 24 0c 2d 6b 10 	movl   $0x106b2d,0xc(%esp)
  1034f6:	00 
  1034f7:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1034fe:	00 
  1034ff:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  103506:	00 
  103507:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10350e:	e8 ad d7 ff ff       	call   100cc0 <__panic>
    free_list = free_list_store;
  103513:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103516:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103519:	a3 70 99 11 00       	mov    %eax,0x119970
  10351e:	89 15 74 99 11 00    	mov    %edx,0x119974
    nr_free = nr_free_store;
  103524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103527:	a3 78 99 11 00       	mov    %eax,0x119978

    free_page(p);
  10352c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103533:	00 
  103534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103537:	89 04 24             	mov    %eax,(%esp)
  10353a:	e8 ce 09 00 00       	call   103f0d <free_pages>
    free_page(p1);
  10353f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103546:	00 
  103547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354a:	89 04 24             	mov    %eax,(%esp)
  10354d:	e8 bb 09 00 00       	call   103f0d <free_pages>
    free_page(p2);
  103552:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103559:	00 
  10355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10355d:	89 04 24             	mov    %eax,(%esp)
  103560:	e8 a8 09 00 00       	call   103f0d <free_pages>
}
  103565:	c9                   	leave  
  103566:	c3                   	ret    

00103567 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103567:	55                   	push   %ebp
  103568:	89 e5                	mov    %esp,%ebp
  10356a:	53                   	push   %ebx
  10356b:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10357f:	c7 45 ec 70 99 11 00 	movl   $0x119970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103586:	eb 6b                	jmp    1035f3 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10358b:	83 e8 0c             	sub    $0xc,%eax
  10358e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103591:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103594:	83 c0 04             	add    $0x4,%eax
  103597:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10359e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1035a4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1035a7:	0f a3 10             	bt     %edx,(%eax)
  1035aa:	19 c0                	sbb    %eax,%eax
  1035ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1035af:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1035b3:	0f 95 c0             	setne  %al
  1035b6:	0f b6 c0             	movzbl %al,%eax
  1035b9:	85 c0                	test   %eax,%eax
  1035bb:	75 24                	jne    1035e1 <default_check+0x7a>
  1035bd:	c7 44 24 0c 3a 6b 10 	movl   $0x106b3a,0xc(%esp)
  1035c4:	00 
  1035c5:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1035cc:	00 
  1035cd:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  1035d4:	00 
  1035d5:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1035dc:	e8 df d6 ff ff       	call   100cc0 <__panic>
        count ++, total += p->property;
  1035e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035e8:	8b 50 08             	mov    0x8(%eax),%edx
  1035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ee:	01 d0                	add    %edx,%eax
  1035f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1035f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1035fc:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1035ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103602:	81 7d ec 70 99 11 00 	cmpl   $0x119970,-0x14(%ebp)
  103609:	0f 85 79 ff ff ff    	jne    103588 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10360f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103612:	e8 28 09 00 00       	call   103f3f <nr_free_pages>
  103617:	39 c3                	cmp    %eax,%ebx
  103619:	74 24                	je     10363f <default_check+0xd8>
  10361b:	c7 44 24 0c 4a 6b 10 	movl   $0x106b4a,0xc(%esp)
  103622:	00 
  103623:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10362a:	00 
  10362b:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  103632:	00 
  103633:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10363a:	e8 81 d6 ff ff       	call   100cc0 <__panic>
    basic_check();
  10363f:	e8 e7 f9 ff ff       	call   10302b <basic_check>
    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103644:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10364b:	e8 85 08 00 00       	call   103ed5 <alloc_pages>
  103650:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103653:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103657:	75 24                	jne    10367d <default_check+0x116>
  103659:	c7 44 24 0c 63 6b 10 	movl   $0x106b63,0xc(%esp)
  103660:	00 
  103661:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103668:	00 
  103669:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103670:	00 
  103671:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103678:	e8 43 d6 ff ff       	call   100cc0 <__panic>
    assert(!PageProperty(p0));
  10367d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103680:	83 c0 04             	add    $0x4,%eax
  103683:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10368a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10368d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103690:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103693:	0f a3 10             	bt     %edx,(%eax)
  103696:	19 c0                	sbb    %eax,%eax
  103698:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10369b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10369f:	0f 95 c0             	setne  %al
  1036a2:	0f b6 c0             	movzbl %al,%eax
  1036a5:	85 c0                	test   %eax,%eax
  1036a7:	74 24                	je     1036cd <default_check+0x166>
  1036a9:	c7 44 24 0c 6e 6b 10 	movl   $0x106b6e,0xc(%esp)
  1036b0:	00 
  1036b1:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1036b8:	00 
  1036b9:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
  1036c0:	00 
  1036c1:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1036c8:	e8 f3 d5 ff ff       	call   100cc0 <__panic>

    list_entry_t free_list_store = free_list;
  1036cd:	a1 70 99 11 00       	mov    0x119970,%eax
  1036d2:	8b 15 74 99 11 00    	mov    0x119974,%edx
  1036d8:	89 45 80             	mov    %eax,-0x80(%ebp)
  1036db:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1036de:	c7 45 b4 70 99 11 00 	movl   $0x119970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1036e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1036e8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1036eb:	89 50 04             	mov    %edx,0x4(%eax)
  1036ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1036f1:	8b 50 04             	mov    0x4(%eax),%edx
  1036f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1036f7:	89 10                	mov    %edx,(%eax)
  1036f9:	c7 45 b0 70 99 11 00 	movl   $0x119970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103700:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103703:	8b 40 04             	mov    0x4(%eax),%eax
  103706:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103709:	0f 94 c0             	sete   %al
  10370c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10370f:	85 c0                	test   %eax,%eax
  103711:	75 24                	jne    103737 <default_check+0x1d0>
  103713:	c7 44 24 0c c3 6a 10 	movl   $0x106ac3,0xc(%esp)
  10371a:	00 
  10371b:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103722:	00 
  103723:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10372a:	00 
  10372b:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103732:	e8 89 d5 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  103737:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10373e:	e8 92 07 00 00       	call   103ed5 <alloc_pages>
  103743:	85 c0                	test   %eax,%eax
  103745:	74 24                	je     10376b <default_check+0x204>
  103747:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  10374e:	00 
  10374f:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103756:	00 
  103757:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  10375e:	00 
  10375f:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103766:	e8 55 d5 ff ff       	call   100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
  10376b:	a1 78 99 11 00       	mov    0x119978,%eax
  103770:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103773:	c7 05 78 99 11 00 00 	movl   $0x0,0x119978
  10377a:	00 00 00 

    free_pages(p0 + 2, 3);
  10377d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103780:	83 c0 28             	add    $0x28,%eax
  103783:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10378a:	00 
  10378b:	89 04 24             	mov    %eax,(%esp)
  10378e:	e8 7a 07 00 00       	call   103f0d <free_pages>
    assert(alloc_pages(4) == NULL);
  103793:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10379a:	e8 36 07 00 00       	call   103ed5 <alloc_pages>
  10379f:	85 c0                	test   %eax,%eax
  1037a1:	74 24                	je     1037c7 <default_check+0x260>
  1037a3:	c7 44 24 0c 80 6b 10 	movl   $0x106b80,0xc(%esp)
  1037aa:	00 
  1037ab:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1037b2:	00 
  1037b3:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  1037ba:	00 
  1037bb:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1037c2:	e8 f9 d4 ff ff       	call   100cc0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1037c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037ca:	83 c0 28             	add    $0x28,%eax
  1037cd:	83 c0 04             	add    $0x4,%eax
  1037d0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1037d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037da:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1037dd:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1037e0:	0f a3 10             	bt     %edx,(%eax)
  1037e3:	19 c0                	sbb    %eax,%eax
  1037e5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1037e8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1037ec:	0f 95 c0             	setne  %al
  1037ef:	0f b6 c0             	movzbl %al,%eax
  1037f2:	85 c0                	test   %eax,%eax
  1037f4:	74 0e                	je     103804 <default_check+0x29d>
  1037f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037f9:	83 c0 28             	add    $0x28,%eax
  1037fc:	8b 40 08             	mov    0x8(%eax),%eax
  1037ff:	83 f8 03             	cmp    $0x3,%eax
  103802:	74 24                	je     103828 <default_check+0x2c1>
  103804:	c7 44 24 0c 98 6b 10 	movl   $0x106b98,0xc(%esp)
  10380b:	00 
  10380c:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103813:	00 
  103814:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  10381b:	00 
  10381c:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103823:	e8 98 d4 ff ff       	call   100cc0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103828:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10382f:	e8 a1 06 00 00       	call   103ed5 <alloc_pages>
  103834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103837:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10383b:	75 24                	jne    103861 <default_check+0x2fa>
  10383d:	c7 44 24 0c c4 6b 10 	movl   $0x106bc4,0xc(%esp)
  103844:	00 
  103845:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  10384c:	00 
  10384d:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  103854:	00 
  103855:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  10385c:	e8 5f d4 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  103861:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103868:	e8 68 06 00 00       	call   103ed5 <alloc_pages>
  10386d:	85 c0                	test   %eax,%eax
  10386f:	74 24                	je     103895 <default_check+0x32e>
  103871:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  103878:	00 
  103879:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103880:	00 
  103881:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  103888:	00 
  103889:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103890:	e8 2b d4 ff ff       	call   100cc0 <__panic>
    assert(p0 + 2 == p1);
  103895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103898:	83 c0 28             	add    $0x28,%eax
  10389b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10389e:	74 24                	je     1038c4 <default_check+0x35d>
  1038a0:	c7 44 24 0c e2 6b 10 	movl   $0x106be2,0xc(%esp)
  1038a7:	00 
  1038a8:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1038af:	00 
  1038b0:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1038b7:	00 
  1038b8:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1038bf:	e8 fc d3 ff ff       	call   100cc0 <__panic>

    p2 = p0 + 1;
  1038c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038c7:	83 c0 14             	add    $0x14,%eax
  1038ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1038cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038d4:	00 
  1038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038d8:	89 04 24             	mov    %eax,(%esp)
  1038db:	e8 2d 06 00 00       	call   103f0d <free_pages>
    free_pages(p1, 3);
  1038e0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1038e7:	00 
  1038e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1038eb:	89 04 24             	mov    %eax,(%esp)
  1038ee:	e8 1a 06 00 00       	call   103f0d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038f6:	83 c0 04             	add    $0x4,%eax
  1038f9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103900:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103903:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103906:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103909:	0f a3 10             	bt     %edx,(%eax)
  10390c:	19 c0                	sbb    %eax,%eax
  10390e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103911:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103915:	0f 95 c0             	setne  %al
  103918:	0f b6 c0             	movzbl %al,%eax
  10391b:	85 c0                	test   %eax,%eax
  10391d:	74 0b                	je     10392a <default_check+0x3c3>
  10391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103922:	8b 40 08             	mov    0x8(%eax),%eax
  103925:	83 f8 01             	cmp    $0x1,%eax
  103928:	74 24                	je     10394e <default_check+0x3e7>
  10392a:	c7 44 24 0c f0 6b 10 	movl   $0x106bf0,0xc(%esp)
  103931:	00 
  103932:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103939:	00 
  10393a:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103941:	00 
  103942:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103949:	e8 72 d3 ff ff       	call   100cc0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10394e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103951:	83 c0 04             	add    $0x4,%eax
  103954:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10395b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10395e:	8b 45 90             	mov    -0x70(%ebp),%eax
  103961:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103964:	0f a3 10             	bt     %edx,(%eax)
  103967:	19 c0                	sbb    %eax,%eax
  103969:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10396c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103970:	0f 95 c0             	setne  %al
  103973:	0f b6 c0             	movzbl %al,%eax
  103976:	85 c0                	test   %eax,%eax
  103978:	74 0b                	je     103985 <default_check+0x41e>
  10397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10397d:	8b 40 08             	mov    0x8(%eax),%eax
  103980:	83 f8 03             	cmp    $0x3,%eax
  103983:	74 24                	je     1039a9 <default_check+0x442>
  103985:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  10398c:	00 
  10398d:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103994:	00 
  103995:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  10399c:	00 
  10399d:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1039a4:	e8 17 d3 ff ff       	call   100cc0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1039a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039b0:	e8 20 05 00 00       	call   103ed5 <alloc_pages>
  1039b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1039b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1039bb:	83 e8 14             	sub    $0x14,%eax
  1039be:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1039c1:	74 24                	je     1039e7 <default_check+0x480>
  1039c3:	c7 44 24 0c 3e 6c 10 	movl   $0x106c3e,0xc(%esp)
  1039ca:	00 
  1039cb:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  1039d2:	00 
  1039d3:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1039da:	00 
  1039db:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  1039e2:	e8 d9 d2 ff ff       	call   100cc0 <__panic>
    free_page(p0);
  1039e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1039ee:	00 
  1039ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039f2:	89 04 24             	mov    %eax,(%esp)
  1039f5:	e8 13 05 00 00       	call   103f0d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1039fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a01:	e8 cf 04 00 00       	call   103ed5 <alloc_pages>
  103a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a0c:	83 c0 14             	add    $0x14,%eax
  103a0f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a12:	74 24                	je     103a38 <default_check+0x4d1>
  103a14:	c7 44 24 0c 5c 6c 10 	movl   $0x106c5c,0xc(%esp)
  103a1b:	00 
  103a1c:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103a23:	00 
  103a24:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103a2b:	00 
  103a2c:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103a33:	e8 88 d2 ff ff       	call   100cc0 <__panic>

    free_pages(p0, 2);
  103a38:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103a3f:	00 
  103a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a43:	89 04 24             	mov    %eax,(%esp)
  103a46:	e8 c2 04 00 00       	call   103f0d <free_pages>
    free_page(p2);
  103a4b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a52:	00 
  103a53:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a56:	89 04 24             	mov    %eax,(%esp)
  103a59:	e8 af 04 00 00       	call   103f0d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103a5e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103a65:	e8 6b 04 00 00       	call   103ed5 <alloc_pages>
  103a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103a71:	75 24                	jne    103a97 <default_check+0x530>
  103a73:	c7 44 24 0c 7c 6c 10 	movl   $0x106c7c,0xc(%esp)
  103a7a:	00 
  103a7b:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103a82:	00 
  103a83:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103a8a:	00 
  103a8b:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103a92:	e8 29 d2 ff ff       	call   100cc0 <__panic>
    assert(alloc_page() == NULL);
  103a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a9e:	e8 32 04 00 00       	call   103ed5 <alloc_pages>
  103aa3:	85 c0                	test   %eax,%eax
  103aa5:	74 24                	je     103acb <default_check+0x564>
  103aa7:	c7 44 24 0c da 6a 10 	movl   $0x106ada,0xc(%esp)
  103aae:	00 
  103aaf:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103ab6:	00 
  103ab7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  103abe:	00 
  103abf:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103ac6:	e8 f5 d1 ff ff       	call   100cc0 <__panic>

    assert(nr_free == 0);
  103acb:	a1 78 99 11 00       	mov    0x119978,%eax
  103ad0:	85 c0                	test   %eax,%eax
  103ad2:	74 24                	je     103af8 <default_check+0x591>
  103ad4:	c7 44 24 0c 2d 6b 10 	movl   $0x106b2d,0xc(%esp)
  103adb:	00 
  103adc:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103ae3:	00 
  103ae4:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103aeb:	00 
  103aec:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103af3:	e8 c8 d1 ff ff       	call   100cc0 <__panic>
    nr_free = nr_free_store;
  103af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103afb:	a3 78 99 11 00       	mov    %eax,0x119978

    free_list = free_list_store;
  103b00:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b03:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b06:	a3 70 99 11 00       	mov    %eax,0x119970
  103b0b:	89 15 74 99 11 00    	mov    %edx,0x119974
    free_pages(p0, 5);
  103b11:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b18:	00 
  103b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b1c:	89 04 24             	mov    %eax,(%esp)
  103b1f:	e8 e9 03 00 00       	call   103f0d <free_pages>

    le = &free_list;
  103b24:	c7 45 ec 70 99 11 00 	movl   $0x119970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103b2b:	eb 1d                	jmp    103b4a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b30:	83 e8 0c             	sub    $0xc,%eax
  103b33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103b36:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103b3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103b40:	8b 40 08             	mov    0x8(%eax),%eax
  103b43:	29 c2                	sub    %eax,%edx
  103b45:	89 d0                	mov    %edx,%eax
  103b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103b4d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103b50:	8b 45 88             	mov    -0x78(%ebp),%eax
  103b53:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103b59:	81 7d ec 70 99 11 00 	cmpl   $0x119970,-0x14(%ebp)
  103b60:	75 cb                	jne    103b2d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103b66:	74 24                	je     103b8c <default_check+0x625>
  103b68:	c7 44 24 0c 9a 6c 10 	movl   $0x106c9a,0xc(%esp)
  103b6f:	00 
  103b70:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103b77:	00 
  103b78:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103b7f:	00 
  103b80:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103b87:	e8 34 d1 ff ff       	call   100cc0 <__panic>
    assert(total == 0);
  103b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b90:	74 24                	je     103bb6 <default_check+0x64f>
  103b92:	c7 44 24 0c a5 6c 10 	movl   $0x106ca5,0xc(%esp)
  103b99:	00 
  103b9a:	c7 44 24 08 56 69 10 	movl   $0x106956,0x8(%esp)
  103ba1:	00 
  103ba2:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103ba9:	00 
  103baa:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103bb1:	e8 0a d1 ff ff       	call   100cc0 <__panic>
}
  103bb6:	81 c4 94 00 00 00    	add    $0x94,%esp
  103bbc:	5b                   	pop    %ebx
  103bbd:	5d                   	pop    %ebp
  103bbe:	c3                   	ret    

00103bbf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103bbf:	55                   	push   %ebp
  103bc0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  103bc5:	a1 84 99 11 00       	mov    0x119984,%eax
  103bca:	29 c2                	sub    %eax,%edx
  103bcc:	89 d0                	mov    %edx,%eax
  103bce:	c1 f8 02             	sar    $0x2,%eax
  103bd1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103bd7:	5d                   	pop    %ebp
  103bd8:	c3                   	ret    

00103bd9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103bd9:	55                   	push   %ebp
  103bda:	89 e5                	mov    %esp,%ebp
  103bdc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  103be2:	89 04 24             	mov    %eax,(%esp)
  103be5:	e8 d5 ff ff ff       	call   103bbf <page2ppn>
  103bea:	c1 e0 0c             	shl    $0xc,%eax
}
  103bed:	c9                   	leave  
  103bee:	c3                   	ret    

00103bef <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103bef:	55                   	push   %ebp
  103bf0:	89 e5                	mov    %esp,%ebp
  103bf2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  103bf8:	c1 e8 0c             	shr    $0xc,%eax
  103bfb:	89 c2                	mov    %eax,%edx
  103bfd:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  103c02:	39 c2                	cmp    %eax,%edx
  103c04:	72 1c                	jb     103c22 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c06:	c7 44 24 08 e0 6c 10 	movl   $0x106ce0,0x8(%esp)
  103c0d:	00 
  103c0e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c15:	00 
  103c16:	c7 04 24 ff 6c 10 00 	movl   $0x106cff,(%esp)
  103c1d:	e8 9e d0 ff ff       	call   100cc0 <__panic>
    }
    return &pages[PPN(pa)];
  103c22:	8b 0d 84 99 11 00    	mov    0x119984,%ecx
  103c28:	8b 45 08             	mov    0x8(%ebp),%eax
  103c2b:	c1 e8 0c             	shr    $0xc,%eax
  103c2e:	89 c2                	mov    %eax,%edx
  103c30:	89 d0                	mov    %edx,%eax
  103c32:	c1 e0 02             	shl    $0x2,%eax
  103c35:	01 d0                	add    %edx,%eax
  103c37:	c1 e0 02             	shl    $0x2,%eax
  103c3a:	01 c8                	add    %ecx,%eax
}
  103c3c:	c9                   	leave  
  103c3d:	c3                   	ret    

00103c3e <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103c3e:	55                   	push   %ebp
  103c3f:	89 e5                	mov    %esp,%ebp
  103c41:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103c44:	8b 45 08             	mov    0x8(%ebp),%eax
  103c47:	89 04 24             	mov    %eax,(%esp)
  103c4a:	e8 8a ff ff ff       	call   103bd9 <page2pa>
  103c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c55:	c1 e8 0c             	shr    $0xc,%eax
  103c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103c5b:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  103c60:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103c63:	72 23                	jb     103c88 <page2kva+0x4a>
  103c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c68:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c6c:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  103c73:	00 
  103c74:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103c7b:	00 
  103c7c:	c7 04 24 ff 6c 10 00 	movl   $0x106cff,(%esp)
  103c83:	e8 38 d0 ff ff       	call   100cc0 <__panic>
  103c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c8b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103c90:	c9                   	leave  
  103c91:	c3                   	ret    

00103c92 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103c92:	55                   	push   %ebp
  103c93:	89 e5                	mov    %esp,%ebp
  103c95:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103c98:	8b 45 08             	mov    0x8(%ebp),%eax
  103c9b:	83 e0 01             	and    $0x1,%eax
  103c9e:	85 c0                	test   %eax,%eax
  103ca0:	75 1c                	jne    103cbe <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103ca2:	c7 44 24 08 34 6d 10 	movl   $0x106d34,0x8(%esp)
  103ca9:	00 
  103caa:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103cb1:	00 
  103cb2:	c7 04 24 ff 6c 10 00 	movl   $0x106cff,(%esp)
  103cb9:	e8 02 d0 ff ff       	call   100cc0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  103cc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103cc6:	89 04 24             	mov    %eax,(%esp)
  103cc9:	e8 21 ff ff ff       	call   103bef <pa2page>
}
  103cce:	c9                   	leave  
  103ccf:	c3                   	ret    

00103cd0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103cd0:	55                   	push   %ebp
  103cd1:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  103cd6:	8b 00                	mov    (%eax),%eax
}
  103cd8:	5d                   	pop    %ebp
  103cd9:	c3                   	ret    

00103cda <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103cda:	55                   	push   %ebp
  103cdb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  103ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ce3:	89 10                	mov    %edx,(%eax)
}
  103ce5:	5d                   	pop    %ebp
  103ce6:	c3                   	ret    

00103ce7 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103ce7:	55                   	push   %ebp
  103ce8:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103cea:	8b 45 08             	mov    0x8(%ebp),%eax
  103ced:	8b 00                	mov    (%eax),%eax
  103cef:	8d 50 01             	lea    0x1(%eax),%edx
  103cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  103cf5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  103cfa:	8b 00                	mov    (%eax),%eax
}
  103cfc:	5d                   	pop    %ebp
  103cfd:	c3                   	ret    

00103cfe <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103cfe:	55                   	push   %ebp
  103cff:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d01:	8b 45 08             	mov    0x8(%ebp),%eax
  103d04:	8b 00                	mov    (%eax),%eax
  103d06:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d09:	8b 45 08             	mov    0x8(%ebp),%eax
  103d0c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  103d11:	8b 00                	mov    (%eax),%eax
}
  103d13:	5d                   	pop    %ebp
  103d14:	c3                   	ret    

00103d15 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103d15:	55                   	push   %ebp
  103d16:	89 e5                	mov    %esp,%ebp
  103d18:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103d1b:	9c                   	pushf  
  103d1c:	58                   	pop    %eax
  103d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103d23:	25 00 02 00 00       	and    $0x200,%eax
  103d28:	85 c0                	test   %eax,%eax
  103d2a:	74 0c                	je     103d38 <__intr_save+0x23>
        intr_disable();
  103d2c:	e8 21 da ff ff       	call   101752 <intr_disable>
        return 1;
  103d31:	b8 01 00 00 00       	mov    $0x1,%eax
  103d36:	eb 05                	jmp    103d3d <__intr_save+0x28>
    }
    return 0;
  103d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103d3d:	c9                   	leave  
  103d3e:	c3                   	ret    

00103d3f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103d3f:	55                   	push   %ebp
  103d40:	89 e5                	mov    %esp,%ebp
  103d42:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103d45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103d49:	74 05                	je     103d50 <__intr_restore+0x11>
        intr_enable();
  103d4b:	e8 fc d9 ff ff       	call   10174c <intr_enable>
    }
}
  103d50:	c9                   	leave  
  103d51:	c3                   	ret    

00103d52 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103d52:	55                   	push   %ebp
  103d53:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103d55:	8b 45 08             	mov    0x8(%ebp),%eax
  103d58:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103d5b:	b8 23 00 00 00       	mov    $0x23,%eax
  103d60:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103d62:	b8 23 00 00 00       	mov    $0x23,%eax
  103d67:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103d69:	b8 10 00 00 00       	mov    $0x10,%eax
  103d6e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103d70:	b8 10 00 00 00       	mov    $0x10,%eax
  103d75:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103d77:	b8 10 00 00 00       	mov    $0x10,%eax
  103d7c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103d7e:	ea 85 3d 10 00 08 00 	ljmp   $0x8,$0x103d85
}
  103d85:	5d                   	pop    %ebp
  103d86:	c3                   	ret    

00103d87 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103d87:	55                   	push   %ebp
  103d88:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d8d:	a3 04 99 11 00       	mov    %eax,0x119904
}
  103d92:	5d                   	pop    %ebp
  103d93:	c3                   	ret    

00103d94 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103d94:	55                   	push   %ebp
  103d95:	89 e5                	mov    %esp,%ebp
  103d97:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103d9a:	b8 00 80 11 00       	mov    $0x118000,%eax
  103d9f:	89 04 24             	mov    %eax,(%esp)
  103da2:	e8 e0 ff ff ff       	call   103d87 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103da7:	66 c7 05 08 99 11 00 	movw   $0x10,0x119908
  103dae:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103db0:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103db7:	68 00 
  103db9:	b8 00 99 11 00       	mov    $0x119900,%eax
  103dbe:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103dc4:	b8 00 99 11 00       	mov    $0x119900,%eax
  103dc9:	c1 e8 10             	shr    $0x10,%eax
  103dcc:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103dd1:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103dd8:	83 e0 f0             	and    $0xfffffff0,%eax
  103ddb:	83 c8 09             	or     $0x9,%eax
  103dde:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103de3:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103dea:	83 e0 ef             	and    $0xffffffef,%eax
  103ded:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103df2:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103df9:	83 e0 9f             	and    $0xffffff9f,%eax
  103dfc:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e01:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e08:	83 c8 80             	or     $0xffffff80,%eax
  103e0b:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e10:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e17:	83 e0 f0             	and    $0xfffffff0,%eax
  103e1a:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e1f:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e26:	83 e0 ef             	and    $0xffffffef,%eax
  103e29:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e2e:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e35:	83 e0 df             	and    $0xffffffdf,%eax
  103e38:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e3d:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e44:	83 c8 40             	or     $0x40,%eax
  103e47:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e4c:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103e53:	83 e0 7f             	and    $0x7f,%eax
  103e56:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103e5b:	b8 00 99 11 00       	mov    $0x119900,%eax
  103e60:	c1 e8 18             	shr    $0x18,%eax
  103e63:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103e68:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103e6f:	e8 de fe ff ff       	call   103d52 <lgdt>
  103e74:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103e7a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103e7e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103e81:	c9                   	leave  
  103e82:	c3                   	ret    

00103e83 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103e83:	55                   	push   %ebp
  103e84:	89 e5                	mov    %esp,%ebp
  103e86:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103e89:	c7 05 7c 99 11 00 c4 	movl   $0x106cc4,0x11997c
  103e90:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103e93:	a1 7c 99 11 00       	mov    0x11997c,%eax
  103e98:	8b 00                	mov    (%eax),%eax
  103e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  103e9e:	c7 04 24 60 6d 10 00 	movl   $0x106d60,(%esp)
  103ea5:	e8 9d c4 ff ff       	call   100347 <cprintf>
    pmm_manager->init();
  103eaa:	a1 7c 99 11 00       	mov    0x11997c,%eax
  103eaf:	8b 40 04             	mov    0x4(%eax),%eax
  103eb2:	ff d0                	call   *%eax
}
  103eb4:	c9                   	leave  
  103eb5:	c3                   	ret    

00103eb6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103eb6:	55                   	push   %ebp
  103eb7:	89 e5                	mov    %esp,%ebp
  103eb9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103ebc:	a1 7c 99 11 00       	mov    0x11997c,%eax
  103ec1:	8b 40 08             	mov    0x8(%eax),%eax
  103ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ec7:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  103ece:	89 14 24             	mov    %edx,(%esp)
  103ed1:	ff d0                	call   *%eax
}
  103ed3:	c9                   	leave  
  103ed4:	c3                   	ret    

00103ed5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103ed5:	55                   	push   %ebp
  103ed6:	89 e5                	mov    %esp,%ebp
  103ed8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103ee2:	e8 2e fe ff ff       	call   103d15 <__intr_save>
  103ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103eea:	a1 7c 99 11 00       	mov    0x11997c,%eax
  103eef:	8b 40 0c             	mov    0xc(%eax),%eax
  103ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  103ef5:	89 14 24             	mov    %edx,(%esp)
  103ef8:	ff d0                	call   *%eax
  103efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f00:	89 04 24             	mov    %eax,(%esp)
  103f03:	e8 37 fe ff ff       	call   103d3f <__intr_restore>
    return page;
  103f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103f0b:	c9                   	leave  
  103f0c:	c3                   	ret    

00103f0d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103f0d:	55                   	push   %ebp
  103f0e:	89 e5                	mov    %esp,%ebp
  103f10:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103f13:	e8 fd fd ff ff       	call   103d15 <__intr_save>
  103f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103f1b:	a1 7c 99 11 00       	mov    0x11997c,%eax
  103f20:	8b 40 10             	mov    0x10(%eax),%eax
  103f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f26:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  103f2d:	89 14 24             	mov    %edx,(%esp)
  103f30:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f35:	89 04 24             	mov    %eax,(%esp)
  103f38:	e8 02 fe ff ff       	call   103d3f <__intr_restore>
}
  103f3d:	c9                   	leave  
  103f3e:	c3                   	ret    

00103f3f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103f3f:	55                   	push   %ebp
  103f40:	89 e5                	mov    %esp,%ebp
  103f42:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103f45:	e8 cb fd ff ff       	call   103d15 <__intr_save>
  103f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103f4d:	a1 7c 99 11 00       	mov    0x11997c,%eax
  103f52:	8b 40 14             	mov    0x14(%eax),%eax
  103f55:	ff d0                	call   *%eax
  103f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103f5d:	89 04 24             	mov    %eax,(%esp)
  103f60:	e8 da fd ff ff       	call   103d3f <__intr_restore>
    return ret;
  103f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103f68:	c9                   	leave  
  103f69:	c3                   	ret    

00103f6a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103f6a:	55                   	push   %ebp
  103f6b:	89 e5                	mov    %esp,%ebp
  103f6d:	57                   	push   %edi
  103f6e:	56                   	push   %esi
  103f6f:	53                   	push   %ebx
  103f70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103f76:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103f7d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103f84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103f8b:	c7 04 24 77 6d 10 00 	movl   $0x106d77,(%esp)
  103f92:	e8 b0 c3 ff ff       	call   100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f9e:	e9 15 01 00 00       	jmp    1040b8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fa3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fa6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fa9:	89 d0                	mov    %edx,%eax
  103fab:	c1 e0 02             	shl    $0x2,%eax
  103fae:	01 d0                	add    %edx,%eax
  103fb0:	c1 e0 02             	shl    $0x2,%eax
  103fb3:	01 c8                	add    %ecx,%eax
  103fb5:	8b 50 08             	mov    0x8(%eax),%edx
  103fb8:	8b 40 04             	mov    0x4(%eax),%eax
  103fbb:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103fbe:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103fc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fc7:	89 d0                	mov    %edx,%eax
  103fc9:	c1 e0 02             	shl    $0x2,%eax
  103fcc:	01 d0                	add    %edx,%eax
  103fce:	c1 e0 02             	shl    $0x2,%eax
  103fd1:	01 c8                	add    %ecx,%eax
  103fd3:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fd6:	8b 58 10             	mov    0x10(%eax),%ebx
  103fd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103fdc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103fdf:	01 c8                	add    %ecx,%eax
  103fe1:	11 da                	adc    %ebx,%edx
  103fe3:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103fe6:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103fe9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fec:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fef:	89 d0                	mov    %edx,%eax
  103ff1:	c1 e0 02             	shl    $0x2,%eax
  103ff4:	01 d0                	add    %edx,%eax
  103ff6:	c1 e0 02             	shl    $0x2,%eax
  103ff9:	01 c8                	add    %ecx,%eax
  103ffb:	83 c0 14             	add    $0x14,%eax
  103ffe:	8b 00                	mov    (%eax),%eax
  104000:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  104006:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104009:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10400c:	83 c0 ff             	add    $0xffffffff,%eax
  10400f:	83 d2 ff             	adc    $0xffffffff,%edx
  104012:	89 c6                	mov    %eax,%esi
  104014:	89 d7                	mov    %edx,%edi
  104016:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104019:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10401c:	89 d0                	mov    %edx,%eax
  10401e:	c1 e0 02             	shl    $0x2,%eax
  104021:	01 d0                	add    %edx,%eax
  104023:	c1 e0 02             	shl    $0x2,%eax
  104026:	01 c8                	add    %ecx,%eax
  104028:	8b 48 0c             	mov    0xc(%eax),%ecx
  10402b:	8b 58 10             	mov    0x10(%eax),%ebx
  10402e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  104034:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104038:	89 74 24 14          	mov    %esi,0x14(%esp)
  10403c:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104040:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104043:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104046:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10404a:	89 54 24 10          	mov    %edx,0x10(%esp)
  10404e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  104052:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  104056:	c7 04 24 84 6d 10 00 	movl   $0x106d84,(%esp)
  10405d:	e8 e5 c2 ff ff       	call   100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  104062:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104065:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104068:	89 d0                	mov    %edx,%eax
  10406a:	c1 e0 02             	shl    $0x2,%eax
  10406d:	01 d0                	add    %edx,%eax
  10406f:	c1 e0 02             	shl    $0x2,%eax
  104072:	01 c8                	add    %ecx,%eax
  104074:	83 c0 14             	add    $0x14,%eax
  104077:	8b 00                	mov    (%eax),%eax
  104079:	83 f8 01             	cmp    $0x1,%eax
  10407c:	75 36                	jne    1040b4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  10407e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104081:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104084:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104087:	77 2b                	ja     1040b4 <page_init+0x14a>
  104089:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  10408c:	72 05                	jb     104093 <page_init+0x129>
  10408e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  104091:	73 21                	jae    1040b4 <page_init+0x14a>
  104093:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104097:	77 1b                	ja     1040b4 <page_init+0x14a>
  104099:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  10409d:	72 09                	jb     1040a8 <page_init+0x13e>
  10409f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  1040a6:	77 0c                	ja     1040b4 <page_init+0x14a>
                maxpa = end;
  1040a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1040ab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1040ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1040b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  1040b4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1040b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040bb:	8b 00                	mov    (%eax),%eax
  1040bd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1040c0:	0f 8f dd fe ff ff    	jg     103fa3 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  1040c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1040ca:	72 1d                	jb     1040e9 <page_init+0x17f>
  1040cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1040d0:	77 09                	ja     1040db <page_init+0x171>
  1040d2:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  1040d9:	76 0e                	jbe    1040e9 <page_init+0x17f>
        maxpa = KMEMSIZE;
  1040db:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  1040e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1040e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1040ef:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1040f3:	c1 ea 0c             	shr    $0xc,%edx
  1040f6:	a3 e0 98 11 00       	mov    %eax,0x1198e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1040fb:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  104102:	b8 88 99 11 00       	mov    $0x119988,%eax
  104107:	8d 50 ff             	lea    -0x1(%eax),%edx
  10410a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10410d:	01 d0                	add    %edx,%eax
  10410f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  104112:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104115:	ba 00 00 00 00       	mov    $0x0,%edx
  10411a:	f7 75 ac             	divl   -0x54(%ebp)
  10411d:	89 d0                	mov    %edx,%eax
  10411f:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104122:	29 c2                	sub    %eax,%edx
  104124:	89 d0                	mov    %edx,%eax
  104126:	a3 84 99 11 00       	mov    %eax,0x119984

    for (i = 0; i < npage; i ++) {
  10412b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104132:	eb 2f                	jmp    104163 <page_init+0x1f9>
        SetPageReserved(pages + i);
  104134:	8b 0d 84 99 11 00    	mov    0x119984,%ecx
  10413a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10413d:	89 d0                	mov    %edx,%eax
  10413f:	c1 e0 02             	shl    $0x2,%eax
  104142:	01 d0                	add    %edx,%eax
  104144:	c1 e0 02             	shl    $0x2,%eax
  104147:	01 c8                	add    %ecx,%eax
  104149:	83 c0 04             	add    $0x4,%eax
  10414c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104153:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104156:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104159:	8b 55 90             	mov    -0x70(%ebp),%edx
  10415c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  10415f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104163:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104166:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  10416b:	39 c2                	cmp    %eax,%edx
  10416d:	72 c5                	jb     104134 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  10416f:	8b 15 e0 98 11 00    	mov    0x1198e0,%edx
  104175:	89 d0                	mov    %edx,%eax
  104177:	c1 e0 02             	shl    $0x2,%eax
  10417a:	01 d0                	add    %edx,%eax
  10417c:	c1 e0 02             	shl    $0x2,%eax
  10417f:	89 c2                	mov    %eax,%edx
  104181:	a1 84 99 11 00       	mov    0x119984,%eax
  104186:	01 d0                	add    %edx,%eax
  104188:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10418b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  104192:	77 23                	ja     1041b7 <page_init+0x24d>
  104194:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104197:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10419b:	c7 44 24 08 b4 6d 10 	movl   $0x106db4,0x8(%esp)
  1041a2:	00 
  1041a3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1041aa:	00 
  1041ab:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1041b2:	e8 09 cb ff ff       	call   100cc0 <__panic>
  1041b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1041ba:	05 00 00 00 40       	add    $0x40000000,%eax
  1041bf:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  1041c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041c9:	e9 74 01 00 00       	jmp    104342 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1041ce:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041d4:	89 d0                	mov    %edx,%eax
  1041d6:	c1 e0 02             	shl    $0x2,%eax
  1041d9:	01 d0                	add    %edx,%eax
  1041db:	c1 e0 02             	shl    $0x2,%eax
  1041de:	01 c8                	add    %ecx,%eax
  1041e0:	8b 50 08             	mov    0x8(%eax),%edx
  1041e3:	8b 40 04             	mov    0x4(%eax),%eax
  1041e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1041e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1041ec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041f2:	89 d0                	mov    %edx,%eax
  1041f4:	c1 e0 02             	shl    $0x2,%eax
  1041f7:	01 d0                	add    %edx,%eax
  1041f9:	c1 e0 02             	shl    $0x2,%eax
  1041fc:	01 c8                	add    %ecx,%eax
  1041fe:	8b 48 0c             	mov    0xc(%eax),%ecx
  104201:	8b 58 10             	mov    0x10(%eax),%ebx
  104204:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104207:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10420a:	01 c8                	add    %ecx,%eax
  10420c:	11 da                	adc    %ebx,%edx
  10420e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104211:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104214:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104217:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10421a:	89 d0                	mov    %edx,%eax
  10421c:	c1 e0 02             	shl    $0x2,%eax
  10421f:	01 d0                	add    %edx,%eax
  104221:	c1 e0 02             	shl    $0x2,%eax
  104224:	01 c8                	add    %ecx,%eax
  104226:	83 c0 14             	add    $0x14,%eax
  104229:	8b 00                	mov    (%eax),%eax
  10422b:	83 f8 01             	cmp    $0x1,%eax
  10422e:	0f 85 0a 01 00 00    	jne    10433e <page_init+0x3d4>
            if (begin < freemem) {
  104234:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104237:	ba 00 00 00 00       	mov    $0x0,%edx
  10423c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10423f:	72 17                	jb     104258 <page_init+0x2ee>
  104241:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104244:	77 05                	ja     10424b <page_init+0x2e1>
  104246:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104249:	76 0d                	jbe    104258 <page_init+0x2ee>
                begin = freemem;
  10424b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10424e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104251:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104258:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10425c:	72 1d                	jb     10427b <page_init+0x311>
  10425e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104262:	77 09                	ja     10426d <page_init+0x303>
  104264:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10426b:	76 0e                	jbe    10427b <page_init+0x311>
                end = KMEMSIZE;
  10426d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104274:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10427b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10427e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104281:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104284:	0f 87 b4 00 00 00    	ja     10433e <page_init+0x3d4>
  10428a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10428d:	72 09                	jb     104298 <page_init+0x32e>
  10428f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104292:	0f 83 a6 00 00 00    	jae    10433e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104298:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  10429f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1042a2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1042a5:	01 d0                	add    %edx,%eax
  1042a7:	83 e8 01             	sub    $0x1,%eax
  1042aa:	89 45 98             	mov    %eax,-0x68(%ebp)
  1042ad:	8b 45 98             	mov    -0x68(%ebp),%eax
  1042b0:	ba 00 00 00 00       	mov    $0x0,%edx
  1042b5:	f7 75 9c             	divl   -0x64(%ebp)
  1042b8:	89 d0                	mov    %edx,%eax
  1042ba:	8b 55 98             	mov    -0x68(%ebp),%edx
  1042bd:	29 c2                	sub    %eax,%edx
  1042bf:	89 d0                	mov    %edx,%eax
  1042c1:	ba 00 00 00 00       	mov    $0x0,%edx
  1042c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042c9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1042cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1042cf:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1042d2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1042d5:	ba 00 00 00 00       	mov    $0x0,%edx
  1042da:	89 c7                	mov    %eax,%edi
  1042dc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1042e2:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1042e5:	89 d0                	mov    %edx,%eax
  1042e7:	83 e0 00             	and    $0x0,%eax
  1042ea:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1042ed:	8b 45 80             	mov    -0x80(%ebp),%eax
  1042f0:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1042f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1042f6:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1042f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1042fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042ff:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104302:	77 3a                	ja     10433e <page_init+0x3d4>
  104304:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104307:	72 05                	jb     10430e <page_init+0x3a4>
  104309:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10430c:	73 30                	jae    10433e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10430e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104311:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104314:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104317:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10431a:	29 c8                	sub    %ecx,%eax
  10431c:	19 da                	sbb    %ebx,%edx
  10431e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104322:	c1 ea 0c             	shr    $0xc,%edx
  104325:	89 c3                	mov    %eax,%ebx
  104327:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10432a:	89 04 24             	mov    %eax,(%esp)
  10432d:	e8 bd f8 ff ff       	call   103bef <pa2page>
  104332:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104336:	89 04 24             	mov    %eax,(%esp)
  104339:	e8 78 fb ff ff       	call   103eb6 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  10433e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104342:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104345:	8b 00                	mov    (%eax),%eax
  104347:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10434a:	0f 8f 7e fe ff ff    	jg     1041ce <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104350:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104356:	5b                   	pop    %ebx
  104357:	5e                   	pop    %esi
  104358:	5f                   	pop    %edi
  104359:	5d                   	pop    %ebp
  10435a:	c3                   	ret    

0010435b <enable_paging>:

static void
enable_paging(void) {
  10435b:	55                   	push   %ebp
  10435c:	89 e5                	mov    %esp,%ebp
  10435e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104361:	a1 80 99 11 00       	mov    0x119980,%eax
  104366:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104369:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10436c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  10436f:	0f 20 c0             	mov    %cr0,%eax
  104372:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104375:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104378:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10437b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104382:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104386:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104389:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10438c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10438f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104392:	c9                   	leave  
  104393:	c3                   	ret    

00104394 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104394:	55                   	push   %ebp
  104395:	89 e5                	mov    %esp,%ebp
  104397:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10439a:	8b 45 14             	mov    0x14(%ebp),%eax
  10439d:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043a0:	31 d0                	xor    %edx,%eax
  1043a2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043a7:	85 c0                	test   %eax,%eax
  1043a9:	74 24                	je     1043cf <boot_map_segment+0x3b>
  1043ab:	c7 44 24 0c e6 6d 10 	movl   $0x106de6,0xc(%esp)
  1043b2:	00 
  1043b3:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  1043ba:	00 
  1043bb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1043c2:	00 
  1043c3:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1043ca:	e8 f1 c8 ff ff       	call   100cc0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1043cf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1043d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043d9:	25 ff 0f 00 00       	and    $0xfff,%eax
  1043de:	89 c2                	mov    %eax,%edx
  1043e0:	8b 45 10             	mov    0x10(%ebp),%eax
  1043e3:	01 c2                	add    %eax,%edx
  1043e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043e8:	01 d0                	add    %edx,%eax
  1043ea:	83 e8 01             	sub    $0x1,%eax
  1043ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1043f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043f3:	ba 00 00 00 00       	mov    $0x0,%edx
  1043f8:	f7 75 f0             	divl   -0x10(%ebp)
  1043fb:	89 d0                	mov    %edx,%eax
  1043fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104400:	29 c2                	sub    %eax,%edx
  104402:	89 d0                	mov    %edx,%eax
  104404:	c1 e8 0c             	shr    $0xc,%eax
  104407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10440a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10440d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104413:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104418:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10441b:	8b 45 14             	mov    0x14(%ebp),%eax
  10441e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104424:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104429:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10442c:	eb 6b                	jmp    104499 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10442e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104435:	00 
  104436:	8b 45 0c             	mov    0xc(%ebp),%eax
  104439:	89 44 24 04          	mov    %eax,0x4(%esp)
  10443d:	8b 45 08             	mov    0x8(%ebp),%eax
  104440:	89 04 24             	mov    %eax,(%esp)
  104443:	e8 cc 01 00 00       	call   104614 <get_pte>
  104448:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10444b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10444f:	75 24                	jne    104475 <boot_map_segment+0xe1>
  104451:	c7 44 24 0c 12 6e 10 	movl   $0x106e12,0xc(%esp)
  104458:	00 
  104459:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104460:	00 
  104461:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104468:	00 
  104469:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104470:	e8 4b c8 ff ff       	call   100cc0 <__panic>
        *ptep = pa | PTE_P | perm;
  104475:	8b 45 18             	mov    0x18(%ebp),%eax
  104478:	8b 55 14             	mov    0x14(%ebp),%edx
  10447b:	09 d0                	or     %edx,%eax
  10447d:	83 c8 01             	or     $0x1,%eax
  104480:	89 c2                	mov    %eax,%edx
  104482:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104485:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104487:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10448b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104492:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10449d:	75 8f                	jne    10442e <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10449f:	c9                   	leave  
  1044a0:	c3                   	ret    

001044a1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1044a1:	55                   	push   %ebp
  1044a2:	89 e5                	mov    %esp,%ebp
  1044a4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1044a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1044ae:	e8 22 fa ff ff       	call   103ed5 <alloc_pages>
  1044b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1044b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044ba:	75 1c                	jne    1044d8 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1044bc:	c7 44 24 08 1f 6e 10 	movl   $0x106e1f,0x8(%esp)
  1044c3:	00 
  1044c4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1044cb:	00 
  1044cc:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1044d3:	e8 e8 c7 ff ff       	call   100cc0 <__panic>
    }
    return page2kva(p);
  1044d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044db:	89 04 24             	mov    %eax,(%esp)
  1044de:	e8 5b f7 ff ff       	call   103c3e <page2kva>
}
  1044e3:	c9                   	leave  
  1044e4:	c3                   	ret    

001044e5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1044e5:	55                   	push   %ebp
  1044e6:	89 e5                	mov    %esp,%ebp
  1044e8:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1044eb:	e8 93 f9 ff ff       	call   103e83 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1044f0:	e8 75 fa ff ff       	call   103f6a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1044f5:	e8 cd 04 00 00       	call   1049c7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1044fa:	e8 a2 ff ff ff       	call   1044a1 <boot_alloc_page>
  1044ff:	a3 e4 98 11 00       	mov    %eax,0x1198e4
    memset(boot_pgdir, 0, PGSIZE);
  104504:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104509:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104510:	00 
  104511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104518:	00 
  104519:	89 04 24             	mov    %eax,(%esp)
  10451c:	e8 62 1b 00 00       	call   106083 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104521:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104529:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104530:	77 23                	ja     104555 <pmm_init+0x70>
  104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104535:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104539:	c7 44 24 08 b4 6d 10 	movl   $0x106db4,0x8(%esp)
  104540:	00 
  104541:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104548:	00 
  104549:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104550:	e8 6b c7 ff ff       	call   100cc0 <__panic>
  104555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104558:	05 00 00 00 40       	add    $0x40000000,%eax
  10455d:	a3 80 99 11 00       	mov    %eax,0x119980

    check_pgdir();
  104562:	e8 7e 04 00 00       	call   1049e5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104567:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10456c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104572:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104577:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10457a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104581:	77 23                	ja     1045a6 <pmm_init+0xc1>
  104583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104586:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10458a:	c7 44 24 08 b4 6d 10 	movl   $0x106db4,0x8(%esp)
  104591:	00 
  104592:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104599:	00 
  10459a:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1045a1:	e8 1a c7 ff ff       	call   100cc0 <__panic>
  1045a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045a9:	05 00 00 00 40       	add    $0x40000000,%eax
  1045ae:	83 c8 03             	or     $0x3,%eax
  1045b1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1045b3:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1045b8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1045bf:	00 
  1045c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1045c7:	00 
  1045c8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1045cf:	38 
  1045d0:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1045d7:	c0 
  1045d8:	89 04 24             	mov    %eax,(%esp)
  1045db:	e8 b4 fd ff ff       	call   104394 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1045e0:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1045e5:	8b 15 e4 98 11 00    	mov    0x1198e4,%edx
  1045eb:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1045f1:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1045f3:	e8 63 fd ff ff       	call   10435b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1045f8:	e8 97 f7 ff ff       	call   103d94 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1045fd:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104608:	e8 73 0a 00 00       	call   105080 <check_boot_pgdir>
    print_pgdir();
  10460d:	e8 00 0f 00 00       	call   105512 <print_pgdir>

}
  104612:	c9                   	leave  
  104613:	c3                   	ret    

00104614 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104614:	55                   	push   %ebp
  104615:	89 e5                	mov    %esp,%ebp
  104617:	83 ec 48             	sub    $0x48,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission

            // (8) return page table entry

    pde_t *pdep = pgdir+PDX(la);
  10461a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10461d:	c1 e8 16             	shr    $0x16,%eax
  104620:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104627:	8b 45 08             	mov    0x8(%ebp),%eax
  10462a:	01 d0                	add    %edx,%eax
  10462c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep) & PTE_P)==0) {
  10462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104632:	8b 00                	mov    (%eax),%eax
  104634:	83 e0 01             	and    $0x1,%eax
  104637:	85 c0                	test   %eax,%eax
  104639:	0f 85 07 01 00 00    	jne    104746 <get_pte+0x132>
		if (create==0)
  10463f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104643:	75 0a                	jne    10464f <get_pte+0x3b>
			return NULL;
  104645:	b8 00 00 00 00       	mov    $0x0,%eax
  10464a:	e9 59 01 00 00       	jmp    1047a8 <get_pte+0x194>
		struct Page *p = alloc_page();
  10464f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104656:	e8 7a f8 ff ff       	call   103ed5 <alloc_pages>
  10465b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		set_page_ref(p,1);
  10465e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104665:	00 
  104666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104669:	89 04 24             	mov    %eax,(%esp)
  10466c:	e8 69 f6 ff ff       	call   103cda <set_page_ref>
		*pdep =(page2pa(p) | PTE_P | PTE_W | PTE_U);
  104671:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104674:	89 04 24             	mov    %eax,(%esp)
  104677:	e8 5d f5 ff ff       	call   103bd9 <page2pa>
  10467c:	83 c8 07             	or     $0x7,%eax
  10467f:	89 c2                	mov    %eax,%edx
  104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104684:	89 10                	mov    %edx,(%eax)
		memset(KADDR(page2pa(p)),0,PGSIZE);
  104686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104689:	89 04 24             	mov    %eax,(%esp)
  10468c:	e8 48 f5 ff ff       	call   103bd9 <page2pa>
  104691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104697:	c1 e8 0c             	shr    $0xc,%eax
  10469a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10469d:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  1046a2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1046a5:	72 23                	jb     1046ca <get_pte+0xb6>
  1046a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046ae:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  1046b5:	00 
  1046b6:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
  1046bd:	00 
  1046be:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1046c5:	e8 f6 c5 ff ff       	call   100cc0 <__panic>
  1046ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046cd:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1046d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1046d9:	00 
  1046da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046e1:	00 
  1046e2:	89 04 24             	mov    %eax,(%esp)
  1046e5:	e8 99 19 00 00       	call   106083 <memset>
		return KADDR(page2pa(p)) + PTX(la);
  1046ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ed:	89 04 24             	mov    %eax,(%esp)
  1046f0:	e8 e4 f4 ff ff       	call   103bd9 <page2pa>
  1046f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1046f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1046fb:	c1 e8 0c             	shr    $0xc,%eax
  1046fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104701:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  104706:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104709:	72 23                	jb     10472e <get_pte+0x11a>
  10470b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10470e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104712:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  104719:	00 
  10471a:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
  104721:	00 
  104722:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104729:	e8 92 c5 ff ff       	call   100cc0 <__panic>
  10472e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104731:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104736:	8b 55 0c             	mov    0xc(%ebp),%edx
  104739:	c1 ea 0c             	shr    $0xc,%edx
  10473c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104742:	01 d0                	add    %edx,%eax
  104744:	eb 62                	jmp    1047a8 <get_pte+0x194>
    } else {
        pde_t *p = KADDR(PTE_ADDR(*pdep));
  104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104749:	8b 00                	mov    (%eax),%eax
  10474b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104750:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104753:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104756:	c1 e8 0c             	shr    $0xc,%eax
  104759:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10475c:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  104761:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104764:	72 23                	jb     104789 <get_pte+0x175>
  104766:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104769:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10476d:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  104774:	00 
  104775:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
  10477c:	00 
  10477d:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104784:	e8 37 c5 ff ff       	call   100cc0 <__panic>
  104789:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10478c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104791:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		p = p+PTX(la);
  104794:	8b 45 0c             	mov    0xc(%ebp),%eax
  104797:	c1 e8 0c             	shr    $0xc,%eax
  10479a:	25 ff 03 00 00       	and    $0x3ff,%eax
  10479f:	c1 e0 02             	shl    $0x2,%eax
  1047a2:	01 45 d4             	add    %eax,-0x2c(%ebp)
		return p;
  1047a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    }
}
  1047a8:	c9                   	leave  
  1047a9:	c3                   	ret    

001047aa <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1047aa:	55                   	push   %ebp
  1047ab:	89 e5                	mov    %esp,%ebp
  1047ad:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1047b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047b7:	00 
  1047b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c2:	89 04 24             	mov    %eax,(%esp)
  1047c5:	e8 4a fe ff ff       	call   104614 <get_pte>
  1047ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1047cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1047d1:	74 08                	je     1047db <get_page+0x31>
        *ptep_store = ptep;
  1047d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1047d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047d9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1047db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047df:	74 1b                	je     1047fc <get_page+0x52>
  1047e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e4:	8b 00                	mov    (%eax),%eax
  1047e6:	83 e0 01             	and    $0x1,%eax
  1047e9:	85 c0                	test   %eax,%eax
  1047eb:	74 0f                	je     1047fc <get_page+0x52>
        return pa2page(*ptep);
  1047ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047f0:	8b 00                	mov    (%eax),%eax
  1047f2:	89 04 24             	mov    %eax,(%esp)
  1047f5:	e8 f5 f3 ff ff       	call   103bef <pa2page>
  1047fa:	eb 05                	jmp    104801 <get_page+0x57>
    }
    return NULL;
  1047fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104801:	c9                   	leave  
  104802:	c3                   	ret    

00104803 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104803:	55                   	push   %ebp
  104804:	89 e5                	mov    %esp,%ebp
  104806:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (ptep!=NULL) {
  104809:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10480d:	74 5c                	je     10486b <page_remove_pte+0x68>
		struct Page *page=pte2page(*ptep);
  10480f:	8b 45 10             	mov    0x10(%ebp),%eax
  104812:	8b 00                	mov    (%eax),%eax
  104814:	89 04 24             	mov    %eax,(%esp)
  104817:	e8 76 f4 ff ff       	call   103c92 <pte2page>
  10481c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		page_ref_dec(page);
  10481f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104822:	89 04 24             	mov    %eax,(%esp)
  104825:	e8 d4 f4 ff ff       	call   103cfe <page_ref_dec>
		if (page->ref == 0) {
  10482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10482d:	8b 00                	mov    (%eax),%eax
  10482f:	85 c0                	test   %eax,%eax
  104831:	75 26                	jne    104859 <page_remove_pte+0x56>
		   free_page(page);
  104833:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10483a:	00 
  10483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10483e:	89 04 24             	mov    %eax,(%esp)
  104841:	e8 c7 f6 ff ff       	call   103f0d <free_pages>
		   pte_t p = *ptep;
  104846:	8b 45 10             	mov    0x10(%ebp),%eax
  104849:	8b 00                	mov    (%eax),%eax
  10484b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		   *ptep  = p - PTE_P;
  10484e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104851:	8d 50 ff             	lea    -0x1(%eax),%edx
  104854:	8b 45 10             	mov    0x10(%ebp),%eax
  104857:	89 10                	mov    %edx,(%eax)
		}
		tlb_invalidate(pgdir, la);
  104859:	8b 45 0c             	mov    0xc(%ebp),%eax
  10485c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104860:	8b 45 08             	mov    0x8(%ebp),%eax
  104863:	89 04 24             	mov    %eax,(%esp)
  104866:	e8 ff 00 00 00       	call   10496a <tlb_invalidate>
    }
}
  10486b:	c9                   	leave  
  10486c:	c3                   	ret    

0010486d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10486d:	55                   	push   %ebp
  10486e:	89 e5                	mov    %esp,%ebp
  104870:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104873:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10487a:	00 
  10487b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10487e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104882:	8b 45 08             	mov    0x8(%ebp),%eax
  104885:	89 04 24             	mov    %eax,(%esp)
  104888:	e8 87 fd ff ff       	call   104614 <get_pte>
  10488d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104894:	74 19                	je     1048af <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104899:	89 44 24 08          	mov    %eax,0x8(%esp)
  10489d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a7:	89 04 24             	mov    %eax,(%esp)
  1048aa:	e8 54 ff ff ff       	call   104803 <page_remove_pte>
    }
}
  1048af:	c9                   	leave  
  1048b0:	c3                   	ret    

001048b1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1048b1:	55                   	push   %ebp
  1048b2:	89 e5                	mov    %esp,%ebp
  1048b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1048b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1048be:	00 
  1048bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1048c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c9:	89 04 24             	mov    %eax,(%esp)
  1048cc:	e8 43 fd ff ff       	call   104614 <get_pte>
  1048d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1048d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048d8:	75 0a                	jne    1048e4 <page_insert+0x33>
        return -E_NO_MEM;
  1048da:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1048df:	e9 84 00 00 00       	jmp    104968 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1048e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048e7:	89 04 24             	mov    %eax,(%esp)
  1048ea:	e8 f8 f3 ff ff       	call   103ce7 <page_ref_inc>
    if (*ptep & PTE_P) {
  1048ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048f2:	8b 00                	mov    (%eax),%eax
  1048f4:	83 e0 01             	and    $0x1,%eax
  1048f7:	85 c0                	test   %eax,%eax
  1048f9:	74 3e                	je     104939 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1048fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048fe:	8b 00                	mov    (%eax),%eax
  104900:	89 04 24             	mov    %eax,(%esp)
  104903:	e8 8a f3 ff ff       	call   103c92 <pte2page>
  104908:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10490e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104911:	75 0d                	jne    104920 <page_insert+0x6f>
            page_ref_dec(page);
  104913:	8b 45 0c             	mov    0xc(%ebp),%eax
  104916:	89 04 24             	mov    %eax,(%esp)
  104919:	e8 e0 f3 ff ff       	call   103cfe <page_ref_dec>
  10491e:	eb 19                	jmp    104939 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104923:	89 44 24 08          	mov    %eax,0x8(%esp)
  104927:	8b 45 10             	mov    0x10(%ebp),%eax
  10492a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10492e:	8b 45 08             	mov    0x8(%ebp),%eax
  104931:	89 04 24             	mov    %eax,(%esp)
  104934:	e8 ca fe ff ff       	call   104803 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104939:	8b 45 0c             	mov    0xc(%ebp),%eax
  10493c:	89 04 24             	mov    %eax,(%esp)
  10493f:	e8 95 f2 ff ff       	call   103bd9 <page2pa>
  104944:	0b 45 14             	or     0x14(%ebp),%eax
  104947:	83 c8 01             	or     $0x1,%eax
  10494a:	89 c2                	mov    %eax,%edx
  10494c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10494f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104951:	8b 45 10             	mov    0x10(%ebp),%eax
  104954:	89 44 24 04          	mov    %eax,0x4(%esp)
  104958:	8b 45 08             	mov    0x8(%ebp),%eax
  10495b:	89 04 24             	mov    %eax,(%esp)
  10495e:	e8 07 00 00 00       	call   10496a <tlb_invalidate>
    return 0;
  104963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104968:	c9                   	leave  
  104969:	c3                   	ret    

0010496a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10496a:	55                   	push   %ebp
  10496b:	89 e5                	mov    %esp,%ebp
  10496d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104970:	0f 20 d8             	mov    %cr3,%eax
  104973:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104976:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104979:	89 c2                	mov    %eax,%edx
  10497b:	8b 45 08             	mov    0x8(%ebp),%eax
  10497e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104981:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104988:	77 23                	ja     1049ad <tlb_invalidate+0x43>
  10498a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10498d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104991:	c7 44 24 08 b4 6d 10 	movl   $0x106db4,0x8(%esp)
  104998:	00 
  104999:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1049a0:	00 
  1049a1:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1049a8:	e8 13 c3 ff ff       	call   100cc0 <__panic>
  1049ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049b0:	05 00 00 00 40       	add    $0x40000000,%eax
  1049b5:	39 c2                	cmp    %eax,%edx
  1049b7:	75 0c                	jne    1049c5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1049b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1049bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049c2:	0f 01 38             	invlpg (%eax)
    }
}
  1049c5:	c9                   	leave  
  1049c6:	c3                   	ret    

001049c7 <check_alloc_page>:

static void
check_alloc_page(void) {
  1049c7:	55                   	push   %ebp
  1049c8:	89 e5                	mov    %esp,%ebp
  1049ca:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1049cd:	a1 7c 99 11 00       	mov    0x11997c,%eax
  1049d2:	8b 40 18             	mov    0x18(%eax),%eax
  1049d5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1049d7:	c7 04 24 38 6e 10 00 	movl   $0x106e38,(%esp)
  1049de:	e8 64 b9 ff ff       	call   100347 <cprintf>
}
  1049e3:	c9                   	leave  
  1049e4:	c3                   	ret    

001049e5 <check_pgdir>:

static void
check_pgdir(void) {
  1049e5:	55                   	push   %ebp
  1049e6:	89 e5                	mov    %esp,%ebp
  1049e8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1049eb:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  1049f0:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1049f5:	76 24                	jbe    104a1b <check_pgdir+0x36>
  1049f7:	c7 44 24 0c 57 6e 10 	movl   $0x106e57,0xc(%esp)
  1049fe:	00 
  1049ff:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104a06:	00 
  104a07:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104a0e:	00 
  104a0f:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104a16:	e8 a5 c2 ff ff       	call   100cc0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104a1b:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104a20:	85 c0                	test   %eax,%eax
  104a22:	74 0e                	je     104a32 <check_pgdir+0x4d>
  104a24:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104a29:	25 ff 0f 00 00       	and    $0xfff,%eax
  104a2e:	85 c0                	test   %eax,%eax
  104a30:	74 24                	je     104a56 <check_pgdir+0x71>
  104a32:	c7 44 24 0c 74 6e 10 	movl   $0x106e74,0xc(%esp)
  104a39:	00 
  104a3a:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104a41:	00 
  104a42:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104a49:	00 
  104a4a:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104a51:	e8 6a c2 ff ff       	call   100cc0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104a56:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a62:	00 
  104a63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a6a:	00 
  104a6b:	89 04 24             	mov    %eax,(%esp)
  104a6e:	e8 37 fd ff ff       	call   1047aa <get_page>
  104a73:	85 c0                	test   %eax,%eax
  104a75:	74 24                	je     104a9b <check_pgdir+0xb6>
  104a77:	c7 44 24 0c ac 6e 10 	movl   $0x106eac,0xc(%esp)
  104a7e:	00 
  104a7f:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104a86:	00 
  104a87:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104a8e:	00 
  104a8f:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104a96:	e8 25 c2 ff ff       	call   100cc0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104aa2:	e8 2e f4 ff ff       	call   103ed5 <alloc_pages>
  104aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104aaa:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104aaf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104ab6:	00 
  104ab7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104abe:	00 
  104abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ac2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ac6:	89 04 24             	mov    %eax,(%esp)
  104ac9:	e8 e3 fd ff ff       	call   1048b1 <page_insert>
  104ace:	85 c0                	test   %eax,%eax
  104ad0:	74 24                	je     104af6 <check_pgdir+0x111>
  104ad2:	c7 44 24 0c d4 6e 10 	movl   $0x106ed4,0xc(%esp)
  104ad9:	00 
  104ada:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104ae1:	00 
  104ae2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104ae9:	00 
  104aea:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104af1:	e8 ca c1 ff ff       	call   100cc0 <__panic>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104af6:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104afb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b02:	00 
  104b03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b0a:	00 
  104b0b:	89 04 24             	mov    %eax,(%esp)
  104b0e:	e8 01 fb ff ff       	call   104614 <get_pte>
  104b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b1a:	75 24                	jne    104b40 <check_pgdir+0x15b>
  104b1c:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104b23:	00 
  104b24:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104b2b:	00 
  104b2c:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104b33:	00 
  104b34:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104b3b:	e8 80 c1 ff ff       	call   100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
  104b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b43:	8b 00                	mov    (%eax),%eax
  104b45:	89 04 24             	mov    %eax,(%esp)
  104b48:	e8 a2 f0 ff ff       	call   103bef <pa2page>
  104b4d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b50:	74 24                	je     104b76 <check_pgdir+0x191>
  104b52:	c7 44 24 0c 2d 6f 10 	movl   $0x106f2d,0xc(%esp)
  104b59:	00 
  104b5a:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104b61:	00 
  104b62:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104b69:	00 
  104b6a:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104b71:	e8 4a c1 ff ff       	call   100cc0 <__panic>
    assert(page_ref(p1) == 1);
  104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b79:	89 04 24             	mov    %eax,(%esp)
  104b7c:	e8 4f f1 ff ff       	call   103cd0 <page_ref>
  104b81:	83 f8 01             	cmp    $0x1,%eax
  104b84:	74 24                	je     104baa <check_pgdir+0x1c5>
  104b86:	c7 44 24 0c 42 6f 10 	movl   $0x106f42,0xc(%esp)
  104b8d:	00 
  104b8e:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104b95:	00 
  104b96:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104b9d:	00 
  104b9e:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104ba5:	e8 16 c1 ff ff       	call   100cc0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104baa:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104baf:	8b 00                	mov    (%eax),%eax
  104bb1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104bb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bbc:	c1 e8 0c             	shr    $0xc,%eax
  104bbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104bc2:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  104bc7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104bca:	72 23                	jb     104bef <check_pgdir+0x20a>
  104bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104bd3:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  104bda:	00 
  104bdb:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104be2:	00 
  104be3:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104bea:	e8 d1 c0 ff ff       	call   100cc0 <__panic>
  104bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104bf2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104bf7:	83 c0 04             	add    $0x4,%eax
  104bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104bfd:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104c02:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c09:	00 
  104c0a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c11:	00 
  104c12:	89 04 24             	mov    %eax,(%esp)
  104c15:	e8 fa f9 ff ff       	call   104614 <get_pte>
  104c1a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104c1d:	74 24                	je     104c43 <check_pgdir+0x25e>
  104c1f:	c7 44 24 0c 54 6f 10 	movl   $0x106f54,0xc(%esp)
  104c26:	00 
  104c27:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104c2e:	00 
  104c2f:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104c36:	00 
  104c37:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104c3e:	e8 7d c0 ff ff       	call   100cc0 <__panic>

    p2 = alloc_page();
  104c43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c4a:	e8 86 f2 ff ff       	call   103ed5 <alloc_pages>
  104c4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104c52:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104c57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104c5e:	00 
  104c5f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104c66:	00 
  104c67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c6e:	89 04 24             	mov    %eax,(%esp)
  104c71:	e8 3b fc ff ff       	call   1048b1 <page_insert>
  104c76:	85 c0                	test   %eax,%eax
  104c78:	74 24                	je     104c9e <check_pgdir+0x2b9>
  104c7a:	c7 44 24 0c 7c 6f 10 	movl   $0x106f7c,0xc(%esp)
  104c81:	00 
  104c82:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104c89:	00 
  104c8a:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104c91:	00 
  104c92:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104c99:	e8 22 c0 ff ff       	call   100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c9e:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104ca3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104caa:	00 
  104cab:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cb2:	00 
  104cb3:	89 04 24             	mov    %eax,(%esp)
  104cb6:	e8 59 f9 ff ff       	call   104614 <get_pte>
  104cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104cc2:	75 24                	jne    104ce8 <check_pgdir+0x303>
  104cc4:	c7 44 24 0c b4 6f 10 	movl   $0x106fb4,0xc(%esp)
  104ccb:	00 
  104ccc:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104cd3:	00 
  104cd4:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104cdb:	00 
  104cdc:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104ce3:	e8 d8 bf ff ff       	call   100cc0 <__panic>
    assert(*ptep & PTE_U);
  104ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ceb:	8b 00                	mov    (%eax),%eax
  104ced:	83 e0 04             	and    $0x4,%eax
  104cf0:	85 c0                	test   %eax,%eax
  104cf2:	75 24                	jne    104d18 <check_pgdir+0x333>
  104cf4:	c7 44 24 0c e4 6f 10 	movl   $0x106fe4,0xc(%esp)
  104cfb:	00 
  104cfc:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104d03:	00 
  104d04:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104d0b:	00 
  104d0c:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104d13:	e8 a8 bf ff ff       	call   100cc0 <__panic>
    assert(*ptep & PTE_W);
  104d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d1b:	8b 00                	mov    (%eax),%eax
  104d1d:	83 e0 02             	and    $0x2,%eax
  104d20:	85 c0                	test   %eax,%eax
  104d22:	75 24                	jne    104d48 <check_pgdir+0x363>
  104d24:	c7 44 24 0c f2 6f 10 	movl   $0x106ff2,0xc(%esp)
  104d2b:	00 
  104d2c:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104d33:	00 
  104d34:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104d3b:	00 
  104d3c:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104d43:	e8 78 bf ff ff       	call   100cc0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104d48:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104d4d:	8b 00                	mov    (%eax),%eax
  104d4f:	83 e0 04             	and    $0x4,%eax
  104d52:	85 c0                	test   %eax,%eax
  104d54:	75 24                	jne    104d7a <check_pgdir+0x395>
  104d56:	c7 44 24 0c 00 70 10 	movl   $0x107000,0xc(%esp)
  104d5d:	00 
  104d5e:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104d65:	00 
  104d66:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104d6d:	00 
  104d6e:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104d75:	e8 46 bf ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 1);
  104d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d7d:	89 04 24             	mov    %eax,(%esp)
  104d80:	e8 4b ef ff ff       	call   103cd0 <page_ref>
  104d85:	83 f8 01             	cmp    $0x1,%eax
  104d88:	74 24                	je     104dae <check_pgdir+0x3c9>
  104d8a:	c7 44 24 0c 16 70 10 	movl   $0x107016,0xc(%esp)
  104d91:	00 
  104d92:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104d99:	00 
  104d9a:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104da1:	00 
  104da2:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104da9:	e8 12 bf ff ff       	call   100cc0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104dae:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104db3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104dba:	00 
  104dbb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104dc2:	00 
  104dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104dc6:	89 54 24 04          	mov    %edx,0x4(%esp)
  104dca:	89 04 24             	mov    %eax,(%esp)
  104dcd:	e8 df fa ff ff       	call   1048b1 <page_insert>
  104dd2:	85 c0                	test   %eax,%eax
  104dd4:	74 24                	je     104dfa <check_pgdir+0x415>
  104dd6:	c7 44 24 0c 28 70 10 	movl   $0x107028,0xc(%esp)
  104ddd:	00 
  104dde:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104de5:	00 
  104de6:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104ded:	00 
  104dee:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104df5:	e8 c6 be ff ff       	call   100cc0 <__panic>
    assert(page_ref(p1) == 2);
  104dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104dfd:	89 04 24             	mov    %eax,(%esp)
  104e00:	e8 cb ee ff ff       	call   103cd0 <page_ref>
  104e05:	83 f8 02             	cmp    $0x2,%eax
  104e08:	74 24                	je     104e2e <check_pgdir+0x449>
  104e0a:	c7 44 24 0c 54 70 10 	movl   $0x107054,0xc(%esp)
  104e11:	00 
  104e12:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104e19:	00 
  104e1a:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104e21:	00 
  104e22:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104e29:	e8 92 be ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 0);
  104e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e31:	89 04 24             	mov    %eax,(%esp)
  104e34:	e8 97 ee ff ff       	call   103cd0 <page_ref>
  104e39:	85 c0                	test   %eax,%eax
  104e3b:	74 24                	je     104e61 <check_pgdir+0x47c>
  104e3d:	c7 44 24 0c 66 70 10 	movl   $0x107066,0xc(%esp)
  104e44:	00 
  104e45:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104e4c:	00 
  104e4d:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104e54:	00 
  104e55:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104e5c:	e8 5f be ff ff       	call   100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104e61:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104e66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e6d:	00 
  104e6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104e75:	00 
  104e76:	89 04 24             	mov    %eax,(%esp)
  104e79:	e8 96 f7 ff ff       	call   104614 <get_pte>
  104e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104e85:	75 24                	jne    104eab <check_pgdir+0x4c6>
  104e87:	c7 44 24 0c b4 6f 10 	movl   $0x106fb4,0xc(%esp)
  104e8e:	00 
  104e8f:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104e96:	00 
  104e97:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104e9e:	00 
  104e9f:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104ea6:	e8 15 be ff ff       	call   100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
  104eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104eae:	8b 00                	mov    (%eax),%eax
  104eb0:	89 04 24             	mov    %eax,(%esp)
  104eb3:	e8 37 ed ff ff       	call   103bef <pa2page>
  104eb8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ebb:	74 24                	je     104ee1 <check_pgdir+0x4fc>
  104ebd:	c7 44 24 0c 2d 6f 10 	movl   $0x106f2d,0xc(%esp)
  104ec4:	00 
  104ec5:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104ecc:	00 
  104ecd:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104ed4:	00 
  104ed5:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104edc:	e8 df bd ff ff       	call   100cc0 <__panic>
    assert((*ptep & PTE_U) == 0);
  104ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ee4:	8b 00                	mov    (%eax),%eax
  104ee6:	83 e0 04             	and    $0x4,%eax
  104ee9:	85 c0                	test   %eax,%eax
  104eeb:	74 24                	je     104f11 <check_pgdir+0x52c>
  104eed:	c7 44 24 0c 78 70 10 	movl   $0x107078,0xc(%esp)
  104ef4:	00 
  104ef5:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104efc:	00 
  104efd:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104f04:	00 
  104f05:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104f0c:	e8 af bd ff ff       	call   100cc0 <__panic>

    page_remove(boot_pgdir, 0x0);
  104f11:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104f16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f1d:	00 
  104f1e:	89 04 24             	mov    %eax,(%esp)
  104f21:	e8 47 f9 ff ff       	call   10486d <page_remove>
    assert(page_ref(p1) == 1);
  104f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f29:	89 04 24             	mov    %eax,(%esp)
  104f2c:	e8 9f ed ff ff       	call   103cd0 <page_ref>
  104f31:	83 f8 01             	cmp    $0x1,%eax
  104f34:	74 24                	je     104f5a <check_pgdir+0x575>
  104f36:	c7 44 24 0c 42 6f 10 	movl   $0x106f42,0xc(%esp)
  104f3d:	00 
  104f3e:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104f45:	00 
  104f46:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104f4d:	00 
  104f4e:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104f55:	e8 66 bd ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 0);
  104f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f5d:	89 04 24             	mov    %eax,(%esp)
  104f60:	e8 6b ed ff ff       	call   103cd0 <page_ref>
  104f65:	85 c0                	test   %eax,%eax
  104f67:	74 24                	je     104f8d <check_pgdir+0x5a8>
  104f69:	c7 44 24 0c 66 70 10 	movl   $0x107066,0xc(%esp)
  104f70:	00 
  104f71:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104f78:	00 
  104f79:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104f80:	00 
  104f81:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104f88:	e8 33 bd ff ff       	call   100cc0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104f8d:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  104f92:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104f99:	00 
  104f9a:	89 04 24             	mov    %eax,(%esp)
  104f9d:	e8 cb f8 ff ff       	call   10486d <page_remove>
    assert(page_ref(p1) == 0);
  104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fa5:	89 04 24             	mov    %eax,(%esp)
  104fa8:	e8 23 ed ff ff       	call   103cd0 <page_ref>
  104fad:	85 c0                	test   %eax,%eax
  104faf:	74 24                	je     104fd5 <check_pgdir+0x5f0>
  104fb1:	c7 44 24 0c 8d 70 10 	movl   $0x10708d,0xc(%esp)
  104fb8:	00 
  104fb9:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104fc0:	00 
  104fc1:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104fc8:	00 
  104fc9:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  104fd0:	e8 eb bc ff ff       	call   100cc0 <__panic>
    assert(page_ref(p2) == 0);
  104fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fd8:	89 04 24             	mov    %eax,(%esp)
  104fdb:	e8 f0 ec ff ff       	call   103cd0 <page_ref>
  104fe0:	85 c0                	test   %eax,%eax
  104fe2:	74 24                	je     105008 <check_pgdir+0x623>
  104fe4:	c7 44 24 0c 66 70 10 	movl   $0x107066,0xc(%esp)
  104feb:	00 
  104fec:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  104ff3:	00 
  104ff4:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104ffb:	00 
  104ffc:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  105003:	e8 b8 bc ff ff       	call   100cc0 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  105008:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10500d:	8b 00                	mov    (%eax),%eax
  10500f:	89 04 24             	mov    %eax,(%esp)
  105012:	e8 d8 eb ff ff       	call   103bef <pa2page>
  105017:	89 04 24             	mov    %eax,(%esp)
  10501a:	e8 b1 ec ff ff       	call   103cd0 <page_ref>
  10501f:	83 f8 01             	cmp    $0x1,%eax
  105022:	74 24                	je     105048 <check_pgdir+0x663>
  105024:	c7 44 24 0c a0 70 10 	movl   $0x1070a0,0xc(%esp)
  10502b:	00 
  10502c:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  105033:	00 
  105034:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  10503b:	00 
  10503c:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  105043:	e8 78 bc ff ff       	call   100cc0 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  105048:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10504d:	8b 00                	mov    (%eax),%eax
  10504f:	89 04 24             	mov    %eax,(%esp)
  105052:	e8 98 eb ff ff       	call   103bef <pa2page>
  105057:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10505e:	00 
  10505f:	89 04 24             	mov    %eax,(%esp)
  105062:	e8 a6 ee ff ff       	call   103f0d <free_pages>
    boot_pgdir[0] = 0;
  105067:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  10506c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  105072:	c7 04 24 c6 70 10 00 	movl   $0x1070c6,(%esp)
  105079:	e8 c9 b2 ff ff       	call   100347 <cprintf>
}
  10507e:	c9                   	leave  
  10507f:	c3                   	ret    

00105080 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  105080:	55                   	push   %ebp
  105081:	89 e5                	mov    %esp,%ebp
  105083:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10508d:	e9 ca 00 00 00       	jmp    10515c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  105092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105095:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10509b:	c1 e8 0c             	shr    $0xc,%eax
  10509e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1050a1:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  1050a6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1050a9:	72 23                	jb     1050ce <check_boot_pgdir+0x4e>
  1050ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050b2:	c7 44 24 08 10 6d 10 	movl   $0x106d10,0x8(%esp)
  1050b9:	00 
  1050ba:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  1050c1:	00 
  1050c2:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1050c9:	e8 f2 bb ff ff       	call   100cc0 <__panic>
  1050ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050d1:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1050d6:	89 c2                	mov    %eax,%edx
  1050d8:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1050dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1050e4:	00 
  1050e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1050e9:	89 04 24             	mov    %eax,(%esp)
  1050ec:	e8 23 f5 ff ff       	call   104614 <get_pte>
  1050f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1050f8:	75 24                	jne    10511e <check_boot_pgdir+0x9e>
  1050fa:	c7 44 24 0c e0 70 10 	movl   $0x1070e0,0xc(%esp)
  105101:	00 
  105102:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  105109:	00 
  10510a:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  105111:	00 
  105112:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  105119:	e8 a2 bb ff ff       	call   100cc0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10511e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105121:	8b 00                	mov    (%eax),%eax
  105123:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105128:	89 c2                	mov    %eax,%edx
  10512a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10512d:	39 c2                	cmp    %eax,%edx
  10512f:	74 24                	je     105155 <check_boot_pgdir+0xd5>
  105131:	c7 44 24 0c 1d 71 10 	movl   $0x10711d,0xc(%esp)
  105138:	00 
  105139:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  105140:	00 
  105141:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
  105148:	00 
  105149:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  105150:	e8 6b bb ff ff       	call   100cc0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  105155:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  10515c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10515f:	a1 e0 98 11 00       	mov    0x1198e0,%eax
  105164:	39 c2                	cmp    %eax,%edx
  105166:	0f 82 26 ff ff ff    	jb     105092 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  10516c:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  105171:	05 ac 0f 00 00       	add    $0xfac,%eax
  105176:	8b 00                	mov    (%eax),%eax
  105178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10517d:	89 c2                	mov    %eax,%edx
  10517f:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  105184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105187:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  10518e:	77 23                	ja     1051b3 <check_boot_pgdir+0x133>
  105190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105193:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105197:	c7 44 24 08 b4 6d 10 	movl   $0x106db4,0x8(%esp)
  10519e:	00 
  10519f:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  1051a6:	00 
  1051a7:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1051ae:	e8 0d bb ff ff       	call   100cc0 <__panic>
  1051b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051b6:	05 00 00 00 40       	add    $0x40000000,%eax
  1051bb:	39 c2                	cmp    %eax,%edx
  1051bd:	74 24                	je     1051e3 <check_boot_pgdir+0x163>
  1051bf:	c7 44 24 0c 34 71 10 	movl   $0x107134,0xc(%esp)
  1051c6:	00 
  1051c7:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  1051ce:	00 
  1051cf:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  1051d6:	00 
  1051d7:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1051de:	e8 dd ba ff ff       	call   100cc0 <__panic>

    assert(boot_pgdir[0] == 0);
  1051e3:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1051e8:	8b 00                	mov    (%eax),%eax
  1051ea:	85 c0                	test   %eax,%eax
  1051ec:	74 24                	je     105212 <check_boot_pgdir+0x192>
  1051ee:	c7 44 24 0c 68 71 10 	movl   $0x107168,0xc(%esp)
  1051f5:	00 
  1051f6:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  1051fd:	00 
  1051fe:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
  105205:	00 
  105206:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  10520d:	e8 ae ba ff ff       	call   100cc0 <__panic>

    struct Page *p;
    p = alloc_page();
  105212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105219:	e8 b7 ec ff ff       	call   103ed5 <alloc_pages>
  10521e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105221:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  105226:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10522d:	00 
  10522e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105235:	00 
  105236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105239:	89 54 24 04          	mov    %edx,0x4(%esp)
  10523d:	89 04 24             	mov    %eax,(%esp)
  105240:	e8 6c f6 ff ff       	call   1048b1 <page_insert>
  105245:	85 c0                	test   %eax,%eax
  105247:	74 24                	je     10526d <check_boot_pgdir+0x1ed>
  105249:	c7 44 24 0c 7c 71 10 	movl   $0x10717c,0xc(%esp)
  105250:	00 
  105251:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  105258:	00 
  105259:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  105260:	00 
  105261:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  105268:	e8 53 ba ff ff       	call   100cc0 <__panic>
    assert(page_ref(p) == 1);
  10526d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105270:	89 04 24             	mov    %eax,(%esp)
  105273:	e8 58 ea ff ff       	call   103cd0 <page_ref>
  105278:	83 f8 01             	cmp    $0x1,%eax
  10527b:	74 24                	je     1052a1 <check_boot_pgdir+0x221>
  10527d:	c7 44 24 0c aa 71 10 	movl   $0x1071aa,0xc(%esp)
  105284:	00 
  105285:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  10528c:	00 
  10528d:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  105294:	00 
  105295:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  10529c:	e8 1f ba ff ff       	call   100cc0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1052a1:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1052a6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1052ad:	00 
  1052ae:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  1052b5:	00 
  1052b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052bd:	89 04 24             	mov    %eax,(%esp)
  1052c0:	e8 ec f5 ff ff       	call   1048b1 <page_insert>
  1052c5:	85 c0                	test   %eax,%eax
  1052c7:	74 24                	je     1052ed <check_boot_pgdir+0x26d>
  1052c9:	c7 44 24 0c bc 71 10 	movl   $0x1071bc,0xc(%esp)
  1052d0:	00 
  1052d1:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  1052d8:	00 
  1052d9:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
  1052e0:	00 
  1052e1:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1052e8:	e8 d3 b9 ff ff       	call   100cc0 <__panic>
    assert(page_ref(p) == 2);
  1052ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052f0:	89 04 24             	mov    %eax,(%esp)
  1052f3:	e8 d8 e9 ff ff       	call   103cd0 <page_ref>
  1052f8:	83 f8 02             	cmp    $0x2,%eax
  1052fb:	74 24                	je     105321 <check_boot_pgdir+0x2a1>
  1052fd:	c7 44 24 0c f3 71 10 	movl   $0x1071f3,0xc(%esp)
  105304:	00 
  105305:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  10530c:	00 
  10530d:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  105314:	00 
  105315:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  10531c:	e8 9f b9 ff ff       	call   100cc0 <__panic>

    const char *str = "ucore: Hello world!!";
  105321:	c7 45 dc 04 72 10 00 	movl   $0x107204,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105328:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10532b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10532f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105336:	e8 6b 0a 00 00       	call   105da6 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10533b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  105342:	00 
  105343:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10534a:	e8 d4 0a 00 00       	call   105e23 <strcmp>
  10534f:	85 c0                	test   %eax,%eax
  105351:	74 24                	je     105377 <check_boot_pgdir+0x2f7>
  105353:	c7 44 24 0c 1c 72 10 	movl   $0x10721c,0xc(%esp)
  10535a:	00 
  10535b:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  105362:	00 
  105363:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  10536a:	00 
  10536b:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  105372:	e8 49 b9 ff ff       	call   100cc0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105377:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10537a:	89 04 24             	mov    %eax,(%esp)
  10537d:	e8 bc e8 ff ff       	call   103c3e <page2kva>
  105382:	05 00 01 00 00       	add    $0x100,%eax
  105387:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10538a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105391:	e8 b2 09 00 00       	call   105d48 <strlen>
  105396:	85 c0                	test   %eax,%eax
  105398:	74 24                	je     1053be <check_boot_pgdir+0x33e>
  10539a:	c7 44 24 0c 54 72 10 	movl   $0x107254,0xc(%esp)
  1053a1:	00 
  1053a2:	c7 44 24 08 fd 6d 10 	movl   $0x106dfd,0x8(%esp)
  1053a9:	00 
  1053aa:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  1053b1:	00 
  1053b2:	c7 04 24 d8 6d 10 00 	movl   $0x106dd8,(%esp)
  1053b9:	e8 02 b9 ff ff       	call   100cc0 <__panic>

    free_page(p);
  1053be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053c5:	00 
  1053c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053c9:	89 04 24             	mov    %eax,(%esp)
  1053cc:	e8 3c eb ff ff       	call   103f0d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1053d1:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1053d6:	8b 00                	mov    (%eax),%eax
  1053d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1053dd:	89 04 24             	mov    %eax,(%esp)
  1053e0:	e8 0a e8 ff ff       	call   103bef <pa2page>
  1053e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053ec:	00 
  1053ed:	89 04 24             	mov    %eax,(%esp)
  1053f0:	e8 18 eb ff ff       	call   103f0d <free_pages>
    boot_pgdir[0] = 0;
  1053f5:	a1 e4 98 11 00       	mov    0x1198e4,%eax
  1053fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105400:	c7 04 24 78 72 10 00 	movl   $0x107278,(%esp)
  105407:	e8 3b af ff ff       	call   100347 <cprintf>
}
  10540c:	c9                   	leave  
  10540d:	c3                   	ret    

0010540e <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  10540e:	55                   	push   %ebp
  10540f:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105411:	8b 45 08             	mov    0x8(%ebp),%eax
  105414:	83 e0 04             	and    $0x4,%eax
  105417:	85 c0                	test   %eax,%eax
  105419:	74 07                	je     105422 <perm2str+0x14>
  10541b:	b8 75 00 00 00       	mov    $0x75,%eax
  105420:	eb 05                	jmp    105427 <perm2str+0x19>
  105422:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105427:	a2 68 99 11 00       	mov    %al,0x119968
    str[1] = 'r';
  10542c:	c6 05 69 99 11 00 72 	movb   $0x72,0x119969
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105433:	8b 45 08             	mov    0x8(%ebp),%eax
  105436:	83 e0 02             	and    $0x2,%eax
  105439:	85 c0                	test   %eax,%eax
  10543b:	74 07                	je     105444 <perm2str+0x36>
  10543d:	b8 77 00 00 00       	mov    $0x77,%eax
  105442:	eb 05                	jmp    105449 <perm2str+0x3b>
  105444:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105449:	a2 6a 99 11 00       	mov    %al,0x11996a
    str[3] = '\0';
  10544e:	c6 05 6b 99 11 00 00 	movb   $0x0,0x11996b
    return str;
  105455:	b8 68 99 11 00       	mov    $0x119968,%eax
}
  10545a:	5d                   	pop    %ebp
  10545b:	c3                   	ret    

0010545c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10545c:	55                   	push   %ebp
  10545d:	89 e5                	mov    %esp,%ebp
  10545f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105462:	8b 45 10             	mov    0x10(%ebp),%eax
  105465:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105468:	72 0a                	jb     105474 <get_pgtable_items+0x18>
        return 0;
  10546a:	b8 00 00 00 00       	mov    $0x0,%eax
  10546f:	e9 9c 00 00 00       	jmp    105510 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105474:	eb 04                	jmp    10547a <get_pgtable_items+0x1e>
        start ++;
  105476:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  10547a:	8b 45 10             	mov    0x10(%ebp),%eax
  10547d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105480:	73 18                	jae    10549a <get_pgtable_items+0x3e>
  105482:	8b 45 10             	mov    0x10(%ebp),%eax
  105485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10548c:	8b 45 14             	mov    0x14(%ebp),%eax
  10548f:	01 d0                	add    %edx,%eax
  105491:	8b 00                	mov    (%eax),%eax
  105493:	83 e0 01             	and    $0x1,%eax
  105496:	85 c0                	test   %eax,%eax
  105498:	74 dc                	je     105476 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10549a:	8b 45 10             	mov    0x10(%ebp),%eax
  10549d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054a0:	73 69                	jae    10550b <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1054a2:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1054a6:	74 08                	je     1054b0 <get_pgtable_items+0x54>
            *left_store = start;
  1054a8:	8b 45 18             	mov    0x18(%ebp),%eax
  1054ab:	8b 55 10             	mov    0x10(%ebp),%edx
  1054ae:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1054b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1054b3:	8d 50 01             	lea    0x1(%eax),%edx
  1054b6:	89 55 10             	mov    %edx,0x10(%ebp)
  1054b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1054c0:	8b 45 14             	mov    0x14(%ebp),%eax
  1054c3:	01 d0                	add    %edx,%eax
  1054c5:	8b 00                	mov    (%eax),%eax
  1054c7:	83 e0 07             	and    $0x7,%eax
  1054ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1054cd:	eb 04                	jmp    1054d3 <get_pgtable_items+0x77>
            start ++;
  1054cf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1054d3:	8b 45 10             	mov    0x10(%ebp),%eax
  1054d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054d9:	73 1d                	jae    1054f8 <get_pgtable_items+0x9c>
  1054db:	8b 45 10             	mov    0x10(%ebp),%eax
  1054de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1054e5:	8b 45 14             	mov    0x14(%ebp),%eax
  1054e8:	01 d0                	add    %edx,%eax
  1054ea:	8b 00                	mov    (%eax),%eax
  1054ec:	83 e0 07             	and    $0x7,%eax
  1054ef:	89 c2                	mov    %eax,%edx
  1054f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1054f4:	39 c2                	cmp    %eax,%edx
  1054f6:	74 d7                	je     1054cf <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1054f8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1054fc:	74 08                	je     105506 <get_pgtable_items+0xaa>
            *right_store = start;
  1054fe:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105501:	8b 55 10             	mov    0x10(%ebp),%edx
  105504:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105509:	eb 05                	jmp    105510 <get_pgtable_items+0xb4>
    }
    return 0;
  10550b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105510:	c9                   	leave  
  105511:	c3                   	ret    

00105512 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105512:	55                   	push   %ebp
  105513:	89 e5                	mov    %esp,%ebp
  105515:	57                   	push   %edi
  105516:	56                   	push   %esi
  105517:	53                   	push   %ebx
  105518:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10551b:	c7 04 24 98 72 10 00 	movl   $0x107298,(%esp)
  105522:	e8 20 ae ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
  105527:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10552e:	e9 fa 00 00 00       	jmp    10562d <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105536:	89 04 24             	mov    %eax,(%esp)
  105539:	e8 d0 fe ff ff       	call   10540e <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10553e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105541:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105544:	29 d1                	sub    %edx,%ecx
  105546:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105548:	89 d6                	mov    %edx,%esi
  10554a:	c1 e6 16             	shl    $0x16,%esi
  10554d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105550:	89 d3                	mov    %edx,%ebx
  105552:	c1 e3 16             	shl    $0x16,%ebx
  105555:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105558:	89 d1                	mov    %edx,%ecx
  10555a:	c1 e1 16             	shl    $0x16,%ecx
  10555d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105560:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105563:	29 d7                	sub    %edx,%edi
  105565:	89 fa                	mov    %edi,%edx
  105567:	89 44 24 14          	mov    %eax,0x14(%esp)
  10556b:	89 74 24 10          	mov    %esi,0x10(%esp)
  10556f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105577:	89 54 24 04          	mov    %edx,0x4(%esp)
  10557b:	c7 04 24 c9 72 10 00 	movl   $0x1072c9,(%esp)
  105582:	e8 c0 ad ff ff       	call   100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105587:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10558a:	c1 e0 0a             	shl    $0xa,%eax
  10558d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105590:	eb 54                	jmp    1055e6 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105595:	89 04 24             	mov    %eax,(%esp)
  105598:	e8 71 fe ff ff       	call   10540e <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10559d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1055a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1055a3:	29 d1                	sub    %edx,%ecx
  1055a5:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1055a7:	89 d6                	mov    %edx,%esi
  1055a9:	c1 e6 0c             	shl    $0xc,%esi
  1055ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055af:	89 d3                	mov    %edx,%ebx
  1055b1:	c1 e3 0c             	shl    $0xc,%ebx
  1055b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1055b7:	c1 e2 0c             	shl    $0xc,%edx
  1055ba:	89 d1                	mov    %edx,%ecx
  1055bc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1055bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1055c2:	29 d7                	sub    %edx,%edi
  1055c4:	89 fa                	mov    %edi,%edx
  1055c6:	89 44 24 14          	mov    %eax,0x14(%esp)
  1055ca:	89 74 24 10          	mov    %esi,0x10(%esp)
  1055ce:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1055d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055da:	c7 04 24 e8 72 10 00 	movl   $0x1072e8,(%esp)
  1055e1:	e8 61 ad ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1055e6:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1055eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1055ee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1055f1:	89 ce                	mov    %ecx,%esi
  1055f3:	c1 e6 0a             	shl    $0xa,%esi
  1055f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1055f9:	89 cb                	mov    %ecx,%ebx
  1055fb:	c1 e3 0a             	shl    $0xa,%ebx
  1055fe:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105601:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105605:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105608:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10560c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105610:	89 44 24 08          	mov    %eax,0x8(%esp)
  105614:	89 74 24 04          	mov    %esi,0x4(%esp)
  105618:	89 1c 24             	mov    %ebx,(%esp)
  10561b:	e8 3c fe ff ff       	call   10545c <get_pgtable_items>
  105620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105623:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105627:	0f 85 65 ff ff ff    	jne    105592 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10562d:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105632:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105635:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105638:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10563c:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10563f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105643:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105647:	89 44 24 08          	mov    %eax,0x8(%esp)
  10564b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105652:	00 
  105653:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10565a:	e8 fd fd ff ff       	call   10545c <get_pgtable_items>
  10565f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105666:	0f 85 c7 fe ff ff    	jne    105533 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10566c:	c7 04 24 0c 73 10 00 	movl   $0x10730c,(%esp)
  105673:	e8 cf ac ff ff       	call   100347 <cprintf>
}
  105678:	83 c4 4c             	add    $0x4c,%esp
  10567b:	5b                   	pop    %ebx
  10567c:	5e                   	pop    %esi
  10567d:	5f                   	pop    %edi
  10567e:	5d                   	pop    %ebp
  10567f:	c3                   	ret    

00105680 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105680:	55                   	push   %ebp
  105681:	89 e5                	mov    %esp,%ebp
  105683:	56                   	push   %esi
  105684:	53                   	push   %ebx
  105685:	83 ec 60             	sub    $0x60,%esp
  105688:	8b 45 10             	mov    0x10(%ebp),%eax
  10568b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10568e:	8b 45 14             	mov    0x14(%ebp),%eax
  105691:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105694:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105697:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10569a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10569d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1056a0:	8b 45 18             	mov    0x18(%ebp),%eax
  1056a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1056ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1056af:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1056b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1056b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1056b8:	89 d3                	mov    %edx,%ebx
  1056ba:	89 c6                	mov    %eax,%esi
  1056bc:	89 75 e0             	mov    %esi,-0x20(%ebp)
  1056bf:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  1056c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1056c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1056cc:	74 1c                	je     1056ea <printnum+0x6a>
  1056ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056d1:	ba 00 00 00 00       	mov    $0x0,%edx
  1056d6:	f7 75 e4             	divl   -0x1c(%ebp)
  1056d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1056dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056df:	ba 00 00 00 00       	mov    $0x0,%edx
  1056e4:	f7 75 e4             	divl   -0x1c(%ebp)
  1056e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1056ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056f0:	89 d6                	mov    %edx,%esi
  1056f2:	89 c3                	mov    %eax,%ebx
  1056f4:	89 f0                	mov    %esi,%eax
  1056f6:	89 da                	mov    %ebx,%edx
  1056f8:	f7 75 e4             	divl   -0x1c(%ebp)
  1056fb:	89 d3                	mov    %edx,%ebx
  1056fd:	89 c6                	mov    %eax,%esi
  1056ff:	89 75 e0             	mov    %esi,-0x20(%ebp)
  105702:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  105705:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105708:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10570b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10570e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  105711:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105714:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  105717:	89 c3                	mov    %eax,%ebx
  105719:	89 d6                	mov    %edx,%esi
  10571b:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  10571e:	89 75 ec             	mov    %esi,-0x14(%ebp)
  105721:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105724:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105727:	8b 45 18             	mov    0x18(%ebp),%eax
  10572a:	ba 00 00 00 00       	mov    $0x0,%edx
  10572f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105732:	77 56                	ja     10578a <printnum+0x10a>
  105734:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105737:	72 05                	jb     10573e <printnum+0xbe>
  105739:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10573c:	77 4c                	ja     10578a <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  10573e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105741:	8d 50 ff             	lea    -0x1(%eax),%edx
  105744:	8b 45 20             	mov    0x20(%ebp),%eax
  105747:	89 44 24 18          	mov    %eax,0x18(%esp)
  10574b:	89 54 24 14          	mov    %edx,0x14(%esp)
  10574f:	8b 45 18             	mov    0x18(%ebp),%eax
  105752:	89 44 24 10          	mov    %eax,0x10(%esp)
  105756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105759:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10575c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105760:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105764:	8b 45 0c             	mov    0xc(%ebp),%eax
  105767:	89 44 24 04          	mov    %eax,0x4(%esp)
  10576b:	8b 45 08             	mov    0x8(%ebp),%eax
  10576e:	89 04 24             	mov    %eax,(%esp)
  105771:	e8 0a ff ff ff       	call   105680 <printnum>
  105776:	eb 1c                	jmp    105794 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10577b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10577f:	8b 45 20             	mov    0x20(%ebp),%eax
  105782:	89 04 24             	mov    %eax,(%esp)
  105785:	8b 45 08             	mov    0x8(%ebp),%eax
  105788:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10578a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10578e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105792:	7f e4                	jg     105778 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105794:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105797:	05 c0 73 10 00       	add    $0x1073c0,%eax
  10579c:	0f b6 00             	movzbl (%eax),%eax
  10579f:	0f be c0             	movsbl %al,%eax
  1057a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057a9:	89 04 24             	mov    %eax,(%esp)
  1057ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1057af:	ff d0                	call   *%eax
}
  1057b1:	83 c4 60             	add    $0x60,%esp
  1057b4:	5b                   	pop    %ebx
  1057b5:	5e                   	pop    %esi
  1057b6:	5d                   	pop    %ebp
  1057b7:	c3                   	ret    

001057b8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1057b8:	55                   	push   %ebp
  1057b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1057bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1057bf:	7e 14                	jle    1057d5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1057c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c4:	8b 00                	mov    (%eax),%eax
  1057c6:	8d 48 08             	lea    0x8(%eax),%ecx
  1057c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1057cc:	89 0a                	mov    %ecx,(%edx)
  1057ce:	8b 50 04             	mov    0x4(%eax),%edx
  1057d1:	8b 00                	mov    (%eax),%eax
  1057d3:	eb 30                	jmp    105805 <getuint+0x4d>
    }
    else if (lflag) {
  1057d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1057d9:	74 16                	je     1057f1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1057db:	8b 45 08             	mov    0x8(%ebp),%eax
  1057de:	8b 00                	mov    (%eax),%eax
  1057e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1057e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1057e6:	89 0a                	mov    %ecx,(%edx)
  1057e8:	8b 00                	mov    (%eax),%eax
  1057ea:	ba 00 00 00 00       	mov    $0x0,%edx
  1057ef:	eb 14                	jmp    105805 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1057f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f4:	8b 00                	mov    (%eax),%eax
  1057f6:	8d 48 04             	lea    0x4(%eax),%ecx
  1057f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1057fc:	89 0a                	mov    %ecx,(%edx)
  1057fe:	8b 00                	mov    (%eax),%eax
  105800:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105805:	5d                   	pop    %ebp
  105806:	c3                   	ret    

00105807 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105807:	55                   	push   %ebp
  105808:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10580a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10580e:	7e 14                	jle    105824 <getint+0x1d>
        return va_arg(*ap, long long);
  105810:	8b 45 08             	mov    0x8(%ebp),%eax
  105813:	8b 00                	mov    (%eax),%eax
  105815:	8d 48 08             	lea    0x8(%eax),%ecx
  105818:	8b 55 08             	mov    0x8(%ebp),%edx
  10581b:	89 0a                	mov    %ecx,(%edx)
  10581d:	8b 50 04             	mov    0x4(%eax),%edx
  105820:	8b 00                	mov    (%eax),%eax
  105822:	eb 30                	jmp    105854 <getint+0x4d>
    }
    else if (lflag) {
  105824:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105828:	74 16                	je     105840 <getint+0x39>
        return va_arg(*ap, long);
  10582a:	8b 45 08             	mov    0x8(%ebp),%eax
  10582d:	8b 00                	mov    (%eax),%eax
  10582f:	8d 48 04             	lea    0x4(%eax),%ecx
  105832:	8b 55 08             	mov    0x8(%ebp),%edx
  105835:	89 0a                	mov    %ecx,(%edx)
  105837:	8b 00                	mov    (%eax),%eax
  105839:	89 c2                	mov    %eax,%edx
  10583b:	c1 fa 1f             	sar    $0x1f,%edx
  10583e:	eb 14                	jmp    105854 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  105840:	8b 45 08             	mov    0x8(%ebp),%eax
  105843:	8b 00                	mov    (%eax),%eax
  105845:	8d 48 04             	lea    0x4(%eax),%ecx
  105848:	8b 55 08             	mov    0x8(%ebp),%edx
  10584b:	89 0a                	mov    %ecx,(%edx)
  10584d:	8b 00                	mov    (%eax),%eax
  10584f:	89 c2                	mov    %eax,%edx
  105851:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  105854:	5d                   	pop    %ebp
  105855:	c3                   	ret    

00105856 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105856:	55                   	push   %ebp
  105857:	89 e5                	mov    %esp,%ebp
  105859:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10585c:	8d 55 14             	lea    0x14(%ebp),%edx
  10585f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  105862:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  105864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105867:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10586b:	8b 45 10             	mov    0x10(%ebp),%eax
  10586e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105872:	8b 45 0c             	mov    0xc(%ebp),%eax
  105875:	89 44 24 04          	mov    %eax,0x4(%esp)
  105879:	8b 45 08             	mov    0x8(%ebp),%eax
  10587c:	89 04 24             	mov    %eax,(%esp)
  10587f:	e8 02 00 00 00       	call   105886 <vprintfmt>
    va_end(ap);
}
  105884:	c9                   	leave  
  105885:	c3                   	ret    

00105886 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105886:	55                   	push   %ebp
  105887:	89 e5                	mov    %esp,%ebp
  105889:	56                   	push   %esi
  10588a:	53                   	push   %ebx
  10588b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10588e:	eb 17                	jmp    1058a7 <vprintfmt+0x21>
            if (ch == '\0') {
  105890:	85 db                	test   %ebx,%ebx
  105892:	0f 84 db 03 00 00    	je     105c73 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  105898:	8b 45 0c             	mov    0xc(%ebp),%eax
  10589b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10589f:	89 1c 24             	mov    %ebx,(%esp)
  1058a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058a5:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058a7:	8b 45 10             	mov    0x10(%ebp),%eax
  1058aa:	0f b6 00             	movzbl (%eax),%eax
  1058ad:	0f b6 d8             	movzbl %al,%ebx
  1058b0:	83 fb 25             	cmp    $0x25,%ebx
  1058b3:	0f 95 c0             	setne  %al
  1058b6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  1058ba:	84 c0                	test   %al,%al
  1058bc:	75 d2                	jne    105890 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1058be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1058c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1058c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1058cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1058cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1058d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1058d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058dc:	eb 04                	jmp    1058e2 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  1058de:	90                   	nop
  1058df:	eb 01                	jmp    1058e2 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  1058e1:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1058e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1058e5:	0f b6 00             	movzbl (%eax),%eax
  1058e8:	0f b6 d8             	movzbl %al,%ebx
  1058eb:	89 d8                	mov    %ebx,%eax
  1058ed:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  1058f1:	83 e8 23             	sub    $0x23,%eax
  1058f4:	83 f8 55             	cmp    $0x55,%eax
  1058f7:	0f 87 45 03 00 00    	ja     105c42 <vprintfmt+0x3bc>
  1058fd:	8b 04 85 e4 73 10 00 	mov    0x1073e4(,%eax,4),%eax
  105904:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105906:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10590a:	eb d6                	jmp    1058e2 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10590c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105910:	eb d0                	jmp    1058e2 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105912:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10591c:	89 d0                	mov    %edx,%eax
  10591e:	c1 e0 02             	shl    $0x2,%eax
  105921:	01 d0                	add    %edx,%eax
  105923:	01 c0                	add    %eax,%eax
  105925:	01 d8                	add    %ebx,%eax
  105927:	83 e8 30             	sub    $0x30,%eax
  10592a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10592d:	8b 45 10             	mov    0x10(%ebp),%eax
  105930:	0f b6 00             	movzbl (%eax),%eax
  105933:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105936:	83 fb 2f             	cmp    $0x2f,%ebx
  105939:	7e 39                	jle    105974 <vprintfmt+0xee>
  10593b:	83 fb 39             	cmp    $0x39,%ebx
  10593e:	7f 34                	jg     105974 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105940:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105944:	eb d3                	jmp    105919 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105946:	8b 45 14             	mov    0x14(%ebp),%eax
  105949:	8d 50 04             	lea    0x4(%eax),%edx
  10594c:	89 55 14             	mov    %edx,0x14(%ebp)
  10594f:	8b 00                	mov    (%eax),%eax
  105951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105954:	eb 1f                	jmp    105975 <vprintfmt+0xef>

        case '.':
            if (width < 0)
  105956:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10595a:	79 82                	jns    1058de <vprintfmt+0x58>
                width = 0;
  10595c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105963:	e9 76 ff ff ff       	jmp    1058de <vprintfmt+0x58>

        case '#':
            altflag = 1;
  105968:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10596f:	e9 6e ff ff ff       	jmp    1058e2 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  105974:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  105975:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105979:	0f 89 62 ff ff ff    	jns    1058e1 <vprintfmt+0x5b>
                width = precision, precision = -1;
  10597f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105982:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105985:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10598c:	e9 50 ff ff ff       	jmp    1058e1 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105991:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105995:	e9 48 ff ff ff       	jmp    1058e2 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10599a:	8b 45 14             	mov    0x14(%ebp),%eax
  10599d:	8d 50 04             	lea    0x4(%eax),%edx
  1059a0:	89 55 14             	mov    %edx,0x14(%ebp)
  1059a3:	8b 00                	mov    (%eax),%eax
  1059a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059ac:	89 04 24             	mov    %eax,(%esp)
  1059af:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b2:	ff d0                	call   *%eax
            break;
  1059b4:	e9 b4 02 00 00       	jmp    105c6d <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1059b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1059bc:	8d 50 04             	lea    0x4(%eax),%edx
  1059bf:	89 55 14             	mov    %edx,0x14(%ebp)
  1059c2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1059c4:	85 db                	test   %ebx,%ebx
  1059c6:	79 02                	jns    1059ca <vprintfmt+0x144>
                err = -err;
  1059c8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1059ca:	83 fb 06             	cmp    $0x6,%ebx
  1059cd:	7f 0b                	jg     1059da <vprintfmt+0x154>
  1059cf:	8b 34 9d a4 73 10 00 	mov    0x1073a4(,%ebx,4),%esi
  1059d6:	85 f6                	test   %esi,%esi
  1059d8:	75 23                	jne    1059fd <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  1059da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1059de:	c7 44 24 08 d1 73 10 	movl   $0x1073d1,0x8(%esp)
  1059e5:	00 
  1059e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f0:	89 04 24             	mov    %eax,(%esp)
  1059f3:	e8 5e fe ff ff       	call   105856 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1059f8:	e9 70 02 00 00       	jmp    105c6d <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1059fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105a01:	c7 44 24 08 da 73 10 	movl   $0x1073da,0x8(%esp)
  105a08:	00 
  105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a10:	8b 45 08             	mov    0x8(%ebp),%eax
  105a13:	89 04 24             	mov    %eax,(%esp)
  105a16:	e8 3b fe ff ff       	call   105856 <printfmt>
            }
            break;
  105a1b:	e9 4d 02 00 00       	jmp    105c6d <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105a20:	8b 45 14             	mov    0x14(%ebp),%eax
  105a23:	8d 50 04             	lea    0x4(%eax),%edx
  105a26:	89 55 14             	mov    %edx,0x14(%ebp)
  105a29:	8b 30                	mov    (%eax),%esi
  105a2b:	85 f6                	test   %esi,%esi
  105a2d:	75 05                	jne    105a34 <vprintfmt+0x1ae>
                p = "(null)";
  105a2f:	be dd 73 10 00       	mov    $0x1073dd,%esi
            }
            if (width > 0 && padc != '-') {
  105a34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a38:	7e 7c                	jle    105ab6 <vprintfmt+0x230>
  105a3a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105a3e:	74 76                	je     105ab6 <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a40:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a4a:	89 34 24             	mov    %esi,(%esp)
  105a4d:	e8 21 03 00 00       	call   105d73 <strnlen>
  105a52:	89 da                	mov    %ebx,%edx
  105a54:	29 c2                	sub    %eax,%edx
  105a56:	89 d0                	mov    %edx,%eax
  105a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a5b:	eb 17                	jmp    105a74 <vprintfmt+0x1ee>
                    putch(padc, putdat);
  105a5d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a64:	89 54 24 04          	mov    %edx,0x4(%esp)
  105a68:	89 04 24             	mov    %eax,(%esp)
  105a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a70:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a78:	7f e3                	jg     105a5d <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105a7a:	eb 3a                	jmp    105ab6 <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  105a7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105a80:	74 1f                	je     105aa1 <vprintfmt+0x21b>
  105a82:	83 fb 1f             	cmp    $0x1f,%ebx
  105a85:	7e 05                	jle    105a8c <vprintfmt+0x206>
  105a87:	83 fb 7e             	cmp    $0x7e,%ebx
  105a8a:	7e 15                	jle    105aa1 <vprintfmt+0x21b>
                    putch('?', putdat);
  105a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a93:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9d:	ff d0                	call   *%eax
  105a9f:	eb 0f                	jmp    105ab0 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  105aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aa8:	89 1c 24             	mov    %ebx,(%esp)
  105aab:	8b 45 08             	mov    0x8(%ebp),%eax
  105aae:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105ab0:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105ab4:	eb 01                	jmp    105ab7 <vprintfmt+0x231>
  105ab6:	90                   	nop
  105ab7:	0f b6 06             	movzbl (%esi),%eax
  105aba:	0f be d8             	movsbl %al,%ebx
  105abd:	85 db                	test   %ebx,%ebx
  105abf:	0f 95 c0             	setne  %al
  105ac2:	83 c6 01             	add    $0x1,%esi
  105ac5:	84 c0                	test   %al,%al
  105ac7:	74 29                	je     105af2 <vprintfmt+0x26c>
  105ac9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105acd:	78 ad                	js     105a7c <vprintfmt+0x1f6>
  105acf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105ad7:	79 a3                	jns    105a7c <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105ad9:	eb 17                	jmp    105af2 <vprintfmt+0x26c>
                putch(' ', putdat);
  105adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ae2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  105aec:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105aee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105af2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105af6:	7f e3                	jg     105adb <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  105af8:	e9 70 01 00 00       	jmp    105c6d <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b04:	8d 45 14             	lea    0x14(%ebp),%eax
  105b07:	89 04 24             	mov    %eax,(%esp)
  105b0a:	e8 f8 fc ff ff       	call   105807 <getint>
  105b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b12:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b1b:	85 d2                	test   %edx,%edx
  105b1d:	79 26                	jns    105b45 <vprintfmt+0x2bf>
                putch('-', putdat);
  105b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b30:	ff d0                	call   *%eax
                num = -(long long)num;
  105b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b38:	f7 d8                	neg    %eax
  105b3a:	83 d2 00             	adc    $0x0,%edx
  105b3d:	f7 da                	neg    %edx
  105b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b42:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105b45:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b4c:	e9 a8 00 00 00       	jmp    105bf9 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b58:	8d 45 14             	lea    0x14(%ebp),%eax
  105b5b:	89 04 24             	mov    %eax,(%esp)
  105b5e:	e8 55 fc ff ff       	call   1057b8 <getuint>
  105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b66:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105b69:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b70:	e9 84 00 00 00       	jmp    105bf9 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b7c:	8d 45 14             	lea    0x14(%ebp),%eax
  105b7f:	89 04 24             	mov    %eax,(%esp)
  105b82:	e8 31 fc ff ff       	call   1057b8 <getuint>
  105b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105b8d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105b94:	eb 63                	jmp    105bf9 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  105b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b9d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba7:	ff d0                	call   *%eax
            putch('x', putdat);
  105ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bb0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  105bba:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105bbc:	8b 45 14             	mov    0x14(%ebp),%eax
  105bbf:	8d 50 04             	lea    0x4(%eax),%edx
  105bc2:	89 55 14             	mov    %edx,0x14(%ebp)
  105bc5:	8b 00                	mov    (%eax),%eax
  105bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105bd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105bd8:	eb 1f                	jmp    105bf9 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be1:	8d 45 14             	lea    0x14(%ebp),%eax
  105be4:	89 04 24             	mov    %eax,(%esp)
  105be7:	e8 cc fb ff ff       	call   1057b8 <getuint>
  105bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105bf9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c00:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c04:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c07:	89 54 24 14          	mov    %edx,0x14(%esp)
  105c0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  105c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c15:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c19:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c24:	8b 45 08             	mov    0x8(%ebp),%eax
  105c27:	89 04 24             	mov    %eax,(%esp)
  105c2a:	e8 51 fa ff ff       	call   105680 <printnum>
            break;
  105c2f:	eb 3c                	jmp    105c6d <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c38:	89 1c 24             	mov    %ebx,(%esp)
  105c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3e:	ff d0                	call   *%eax
            break;
  105c40:	eb 2b                	jmp    105c6d <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c45:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c49:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105c50:	8b 45 08             	mov    0x8(%ebp),%eax
  105c53:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105c55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c59:	eb 04                	jmp    105c5f <vprintfmt+0x3d9>
  105c5b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  105c62:	83 e8 01             	sub    $0x1,%eax
  105c65:	0f b6 00             	movzbl (%eax),%eax
  105c68:	3c 25                	cmp    $0x25,%al
  105c6a:	75 ef                	jne    105c5b <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  105c6c:	90                   	nop
        }
    }
  105c6d:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c6e:	e9 34 fc ff ff       	jmp    1058a7 <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  105c73:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105c74:	83 c4 40             	add    $0x40,%esp
  105c77:	5b                   	pop    %ebx
  105c78:	5e                   	pop    %esi
  105c79:	5d                   	pop    %ebp
  105c7a:	c3                   	ret    

00105c7b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105c7b:	55                   	push   %ebp
  105c7c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c81:	8b 40 08             	mov    0x8(%eax),%eax
  105c84:	8d 50 01             	lea    0x1(%eax),%edx
  105c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c8a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c90:	8b 10                	mov    (%eax),%edx
  105c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c95:	8b 40 04             	mov    0x4(%eax),%eax
  105c98:	39 c2                	cmp    %eax,%edx
  105c9a:	73 12                	jae    105cae <sprintputch+0x33>
        *b->buf ++ = ch;
  105c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c9f:	8b 00                	mov    (%eax),%eax
  105ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  105ca4:	88 10                	mov    %dl,(%eax)
  105ca6:	8d 50 01             	lea    0x1(%eax),%edx
  105ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cac:	89 10                	mov    %edx,(%eax)
    }
}
  105cae:	5d                   	pop    %ebp
  105caf:	c3                   	ret    

00105cb0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105cb0:	55                   	push   %ebp
  105cb1:	89 e5                	mov    %esp,%ebp
  105cb3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105cb6:	8d 55 14             	lea    0x14(%ebp),%edx
  105cb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105cbc:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  105cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105cc5:	8b 45 10             	mov    0x10(%ebp),%eax
  105cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd6:	89 04 24             	mov    %eax,(%esp)
  105cd9:	e8 08 00 00 00       	call   105ce6 <vsnprintf>
  105cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105ce4:	c9                   	leave  
  105ce5:	c3                   	ret    

00105ce6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105ce6:	55                   	push   %ebp
  105ce7:	89 e5                	mov    %esp,%ebp
  105ce9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105cec:	8b 45 08             	mov    0x8(%ebp),%eax
  105cef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf5:	83 e8 01             	sub    $0x1,%eax
  105cf8:	03 45 08             	add    0x8(%ebp),%eax
  105cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105d09:	74 0a                	je     105d15 <vsnprintf+0x2f>
  105d0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d11:	39 c2                	cmp    %eax,%edx
  105d13:	76 07                	jbe    105d1c <vsnprintf+0x36>
        return -E_INVAL;
  105d15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105d1a:	eb 2a                	jmp    105d46 <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  105d1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d23:	8b 45 10             	mov    0x10(%ebp),%eax
  105d26:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d31:	c7 04 24 7b 5c 10 00 	movl   $0x105c7b,(%esp)
  105d38:	e8 49 fb ff ff       	call   105886 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d40:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d46:	c9                   	leave  
  105d47:	c3                   	ret    

00105d48 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105d48:	55                   	push   %ebp
  105d49:	89 e5                	mov    %esp,%ebp
  105d4b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105d55:	eb 04                	jmp    105d5b <strlen+0x13>
        cnt ++;
  105d57:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5e:	0f b6 00             	movzbl (%eax),%eax
  105d61:	84 c0                	test   %al,%al
  105d63:	0f 95 c0             	setne  %al
  105d66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d6a:	84 c0                	test   %al,%al
  105d6c:	75 e9                	jne    105d57 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105d71:	c9                   	leave  
  105d72:	c3                   	ret    

00105d73 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105d73:	55                   	push   %ebp
  105d74:	89 e5                	mov    %esp,%ebp
  105d76:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105d80:	eb 04                	jmp    105d86 <strnlen+0x13>
        cnt ++;
  105d82:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d89:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105d8c:	73 13                	jae    105da1 <strnlen+0x2e>
  105d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d91:	0f b6 00             	movzbl (%eax),%eax
  105d94:	84 c0                	test   %al,%al
  105d96:	0f 95 c0             	setne  %al
  105d99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d9d:	84 c0                	test   %al,%al
  105d9f:	75 e1                	jne    105d82 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105da4:	c9                   	leave  
  105da5:	c3                   	ret    

00105da6 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105da6:	55                   	push   %ebp
  105da7:	89 e5                	mov    %esp,%ebp
  105da9:	57                   	push   %edi
  105daa:	56                   	push   %esi
  105dab:	53                   	push   %ebx
  105dac:	83 ec 24             	sub    $0x24,%esp
  105daf:	8b 45 08             	mov    0x8(%ebp),%eax
  105db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105db8:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dc1:	89 d6                	mov    %edx,%esi
  105dc3:	89 c3                	mov    %eax,%ebx
  105dc5:	89 df                	mov    %ebx,%edi
  105dc7:	ac                   	lods   %ds:(%esi),%al
  105dc8:	aa                   	stos   %al,%es:(%edi)
  105dc9:	84 c0                	test   %al,%al
  105dcb:	75 fa                	jne    105dc7 <strcpy+0x21>
  105dcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105dd0:	89 fb                	mov    %edi,%ebx
  105dd2:	89 75 e8             	mov    %esi,-0x18(%ebp)
  105dd5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  105dd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105de1:	83 c4 24             	add    $0x24,%esp
  105de4:	5b                   	pop    %ebx
  105de5:	5e                   	pop    %esi
  105de6:	5f                   	pop    %edi
  105de7:	5d                   	pop    %ebp
  105de8:	c3                   	ret    

00105de9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105de9:	55                   	push   %ebp
  105dea:	89 e5                	mov    %esp,%ebp
  105dec:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105def:	8b 45 08             	mov    0x8(%ebp),%eax
  105df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105df5:	eb 21                	jmp    105e18 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dfa:	0f b6 10             	movzbl (%eax),%edx
  105dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e00:	88 10                	mov    %dl,(%eax)
  105e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e05:	0f b6 00             	movzbl (%eax),%eax
  105e08:	84 c0                	test   %al,%al
  105e0a:	74 04                	je     105e10 <strncpy+0x27>
            src ++;
  105e0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105e10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e14:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e1c:	75 d9                	jne    105df7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105e1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e21:	c9                   	leave  
  105e22:	c3                   	ret    

00105e23 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105e23:	55                   	push   %ebp
  105e24:	89 e5                	mov    %esp,%ebp
  105e26:	57                   	push   %edi
  105e27:	56                   	push   %esi
  105e28:	53                   	push   %ebx
  105e29:	83 ec 24             	sub    $0x24,%esp
  105e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e35:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105e38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e3e:	89 d6                	mov    %edx,%esi
  105e40:	89 c3                	mov    %eax,%ebx
  105e42:	89 df                	mov    %ebx,%edi
  105e44:	ac                   	lods   %ds:(%esi),%al
  105e45:	ae                   	scas   %es:(%edi),%al
  105e46:	75 08                	jne    105e50 <strcmp+0x2d>
  105e48:	84 c0                	test   %al,%al
  105e4a:	75 f8                	jne    105e44 <strcmp+0x21>
  105e4c:	31 c0                	xor    %eax,%eax
  105e4e:	eb 04                	jmp    105e54 <strcmp+0x31>
  105e50:	19 c0                	sbb    %eax,%eax
  105e52:	0c 01                	or     $0x1,%al
  105e54:	89 fb                	mov    %edi,%ebx
  105e56:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105e59:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e5f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  105e62:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105e68:	83 c4 24             	add    $0x24,%esp
  105e6b:	5b                   	pop    %ebx
  105e6c:	5e                   	pop    %esi
  105e6d:	5f                   	pop    %edi
  105e6e:	5d                   	pop    %ebp
  105e6f:	c3                   	ret    

00105e70 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105e70:	55                   	push   %ebp
  105e71:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e73:	eb 0c                	jmp    105e81 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105e75:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105e79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e7d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e85:	74 1a                	je     105ea1 <strncmp+0x31>
  105e87:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8a:	0f b6 00             	movzbl (%eax),%eax
  105e8d:	84 c0                	test   %al,%al
  105e8f:	74 10                	je     105ea1 <strncmp+0x31>
  105e91:	8b 45 08             	mov    0x8(%ebp),%eax
  105e94:	0f b6 10             	movzbl (%eax),%edx
  105e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e9a:	0f b6 00             	movzbl (%eax),%eax
  105e9d:	38 c2                	cmp    %al,%dl
  105e9f:	74 d4                	je     105e75 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ea5:	74 1a                	je     105ec1 <strncmp+0x51>
  105ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  105eaa:	0f b6 00             	movzbl (%eax),%eax
  105ead:	0f b6 d0             	movzbl %al,%edx
  105eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb3:	0f b6 00             	movzbl (%eax),%eax
  105eb6:	0f b6 c0             	movzbl %al,%eax
  105eb9:	89 d1                	mov    %edx,%ecx
  105ebb:	29 c1                	sub    %eax,%ecx
  105ebd:	89 c8                	mov    %ecx,%eax
  105ebf:	eb 05                	jmp    105ec6 <strncmp+0x56>
  105ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ec6:	5d                   	pop    %ebp
  105ec7:	c3                   	ret    

00105ec8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105ec8:	55                   	push   %ebp
  105ec9:	89 e5                	mov    %esp,%ebp
  105ecb:	83 ec 04             	sub    $0x4,%esp
  105ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ed1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ed4:	eb 14                	jmp    105eea <strchr+0x22>
        if (*s == c) {
  105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed9:	0f b6 00             	movzbl (%eax),%eax
  105edc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105edf:	75 05                	jne    105ee6 <strchr+0x1e>
            return (char *)s;
  105ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee4:	eb 13                	jmp    105ef9 <strchr+0x31>
        }
        s ++;
  105ee6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105eea:	8b 45 08             	mov    0x8(%ebp),%eax
  105eed:	0f b6 00             	movzbl (%eax),%eax
  105ef0:	84 c0                	test   %al,%al
  105ef2:	75 e2                	jne    105ed6 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ef9:	c9                   	leave  
  105efa:	c3                   	ret    

00105efb <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105efb:	55                   	push   %ebp
  105efc:	89 e5                	mov    %esp,%ebp
  105efe:	83 ec 04             	sub    $0x4,%esp
  105f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f04:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f07:	eb 0f                	jmp    105f18 <strfind+0x1d>
        if (*s == c) {
  105f09:	8b 45 08             	mov    0x8(%ebp),%eax
  105f0c:	0f b6 00             	movzbl (%eax),%eax
  105f0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105f12:	74 10                	je     105f24 <strfind+0x29>
            break;
        }
        s ++;
  105f14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105f18:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1b:	0f b6 00             	movzbl (%eax),%eax
  105f1e:	84 c0                	test   %al,%al
  105f20:	75 e7                	jne    105f09 <strfind+0xe>
  105f22:	eb 01                	jmp    105f25 <strfind+0x2a>
        if (*s == c) {
            break;
  105f24:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105f25:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105f28:	c9                   	leave  
  105f29:	c3                   	ret    

00105f2a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105f2a:	55                   	push   %ebp
  105f2b:	89 e5                	mov    %esp,%ebp
  105f2d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105f30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105f37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f3e:	eb 04                	jmp    105f44 <strtol+0x1a>
        s ++;
  105f40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f44:	8b 45 08             	mov    0x8(%ebp),%eax
  105f47:	0f b6 00             	movzbl (%eax),%eax
  105f4a:	3c 20                	cmp    $0x20,%al
  105f4c:	74 f2                	je     105f40 <strtol+0x16>
  105f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f51:	0f b6 00             	movzbl (%eax),%eax
  105f54:	3c 09                	cmp    $0x9,%al
  105f56:	74 e8                	je     105f40 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105f58:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5b:	0f b6 00             	movzbl (%eax),%eax
  105f5e:	3c 2b                	cmp    $0x2b,%al
  105f60:	75 06                	jne    105f68 <strtol+0x3e>
        s ++;
  105f62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f66:	eb 15                	jmp    105f7d <strtol+0x53>
    }
    else if (*s == '-') {
  105f68:	8b 45 08             	mov    0x8(%ebp),%eax
  105f6b:	0f b6 00             	movzbl (%eax),%eax
  105f6e:	3c 2d                	cmp    $0x2d,%al
  105f70:	75 0b                	jne    105f7d <strtol+0x53>
        s ++, neg = 1;
  105f72:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f76:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105f81:	74 06                	je     105f89 <strtol+0x5f>
  105f83:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105f87:	75 24                	jne    105fad <strtol+0x83>
  105f89:	8b 45 08             	mov    0x8(%ebp),%eax
  105f8c:	0f b6 00             	movzbl (%eax),%eax
  105f8f:	3c 30                	cmp    $0x30,%al
  105f91:	75 1a                	jne    105fad <strtol+0x83>
  105f93:	8b 45 08             	mov    0x8(%ebp),%eax
  105f96:	83 c0 01             	add    $0x1,%eax
  105f99:	0f b6 00             	movzbl (%eax),%eax
  105f9c:	3c 78                	cmp    $0x78,%al
  105f9e:	75 0d                	jne    105fad <strtol+0x83>
        s += 2, base = 16;
  105fa0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105fa4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105fab:	eb 2a                	jmp    105fd7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105fad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105fb1:	75 17                	jne    105fca <strtol+0xa0>
  105fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  105fb6:	0f b6 00             	movzbl (%eax),%eax
  105fb9:	3c 30                	cmp    $0x30,%al
  105fbb:	75 0d                	jne    105fca <strtol+0xa0>
        s ++, base = 8;
  105fbd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105fc8:	eb 0d                	jmp    105fd7 <strtol+0xad>
    }
    else if (base == 0) {
  105fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105fce:	75 07                	jne    105fd7 <strtol+0xad>
        base = 10;
  105fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  105fda:	0f b6 00             	movzbl (%eax),%eax
  105fdd:	3c 2f                	cmp    $0x2f,%al
  105fdf:	7e 1b                	jle    105ffc <strtol+0xd2>
  105fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe4:	0f b6 00             	movzbl (%eax),%eax
  105fe7:	3c 39                	cmp    $0x39,%al
  105fe9:	7f 11                	jg     105ffc <strtol+0xd2>
            dig = *s - '0';
  105feb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fee:	0f b6 00             	movzbl (%eax),%eax
  105ff1:	0f be c0             	movsbl %al,%eax
  105ff4:	83 e8 30             	sub    $0x30,%eax
  105ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ffa:	eb 48                	jmp    106044 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  105fff:	0f b6 00             	movzbl (%eax),%eax
  106002:	3c 60                	cmp    $0x60,%al
  106004:	7e 1b                	jle    106021 <strtol+0xf7>
  106006:	8b 45 08             	mov    0x8(%ebp),%eax
  106009:	0f b6 00             	movzbl (%eax),%eax
  10600c:	3c 7a                	cmp    $0x7a,%al
  10600e:	7f 11                	jg     106021 <strtol+0xf7>
            dig = *s - 'a' + 10;
  106010:	8b 45 08             	mov    0x8(%ebp),%eax
  106013:	0f b6 00             	movzbl (%eax),%eax
  106016:	0f be c0             	movsbl %al,%eax
  106019:	83 e8 57             	sub    $0x57,%eax
  10601c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10601f:	eb 23                	jmp    106044 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106021:	8b 45 08             	mov    0x8(%ebp),%eax
  106024:	0f b6 00             	movzbl (%eax),%eax
  106027:	3c 40                	cmp    $0x40,%al
  106029:	7e 38                	jle    106063 <strtol+0x139>
  10602b:	8b 45 08             	mov    0x8(%ebp),%eax
  10602e:	0f b6 00             	movzbl (%eax),%eax
  106031:	3c 5a                	cmp    $0x5a,%al
  106033:	7f 2e                	jg     106063 <strtol+0x139>
            dig = *s - 'A' + 10;
  106035:	8b 45 08             	mov    0x8(%ebp),%eax
  106038:	0f b6 00             	movzbl (%eax),%eax
  10603b:	0f be c0             	movsbl %al,%eax
  10603e:	83 e8 37             	sub    $0x37,%eax
  106041:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  106047:	3b 45 10             	cmp    0x10(%ebp),%eax
  10604a:	7d 16                	jge    106062 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  10604c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106050:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106053:	0f af 45 10          	imul   0x10(%ebp),%eax
  106057:	03 45 f4             	add    -0xc(%ebp),%eax
  10605a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10605d:	e9 75 ff ff ff       	jmp    105fd7 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  106062:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  106063:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  106067:	74 08                	je     106071 <strtol+0x147>
        *endptr = (char *) s;
  106069:	8b 45 0c             	mov    0xc(%ebp),%eax
  10606c:	8b 55 08             	mov    0x8(%ebp),%edx
  10606f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  106071:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  106075:	74 07                	je     10607e <strtol+0x154>
  106077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10607a:	f7 d8                	neg    %eax
  10607c:	eb 03                	jmp    106081 <strtol+0x157>
  10607e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  106081:	c9                   	leave  
  106082:	c3                   	ret    

00106083 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  106083:	55                   	push   %ebp
  106084:	89 e5                	mov    %esp,%ebp
  106086:	57                   	push   %edi
  106087:	56                   	push   %esi
  106088:	53                   	push   %ebx
  106089:	83 ec 24             	sub    $0x24,%esp
  10608c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10608f:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  106092:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  106096:	8b 55 08             	mov    0x8(%ebp),%edx
  106099:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10609c:	88 45 ef             	mov    %al,-0x11(%ebp)
  10609f:	8b 45 10             	mov    0x10(%ebp),%eax
  1060a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1060a5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1060a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  1060ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1060af:	89 ce                	mov    %ecx,%esi
  1060b1:	89 d3                	mov    %edx,%ebx
  1060b3:	89 f1                	mov    %esi,%ecx
  1060b5:	89 df                	mov    %ebx,%edi
  1060b7:	f3 aa                	rep stos %al,%es:(%edi)
  1060b9:	89 fb                	mov    %edi,%ebx
  1060bb:	89 ce                	mov    %ecx,%esi
  1060bd:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  1060c0:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1060c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1060c6:	83 c4 24             	add    $0x24,%esp
  1060c9:	5b                   	pop    %ebx
  1060ca:	5e                   	pop    %esi
  1060cb:	5f                   	pop    %edi
  1060cc:	5d                   	pop    %ebp
  1060cd:	c3                   	ret    

001060ce <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1060ce:	55                   	push   %ebp
  1060cf:	89 e5                	mov    %esp,%ebp
  1060d1:	57                   	push   %edi
  1060d2:	56                   	push   %esi
  1060d3:	53                   	push   %ebx
  1060d4:	83 ec 38             	sub    $0x38,%esp
  1060d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1060da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1060e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1060e6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1060e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060ec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1060ef:	73 4e                	jae    10613f <memmove+0x71>
  1060f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1060f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1060fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106100:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106106:	89 c1                	mov    %eax,%ecx
  106108:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10610b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10610e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106111:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  106114:	89 d7                	mov    %edx,%edi
  106116:	89 c3                	mov    %eax,%ebx
  106118:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  10611b:	89 de                	mov    %ebx,%esi
  10611d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10611f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106122:	83 e1 03             	and    $0x3,%ecx
  106125:	74 02                	je     106129 <memmove+0x5b>
  106127:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106129:	89 f3                	mov    %esi,%ebx
  10612b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  10612e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  106131:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106134:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  106137:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10613a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10613d:	eb 3b                	jmp    10617a <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10613f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106142:	83 e8 01             	sub    $0x1,%eax
  106145:	89 c2                	mov    %eax,%edx
  106147:	03 55 ec             	add    -0x14(%ebp),%edx
  10614a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10614d:	83 e8 01             	sub    $0x1,%eax
  106150:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  106153:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  106156:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  106159:	89 d6                	mov    %edx,%esi
  10615b:	89 c3                	mov    %eax,%ebx
  10615d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  106160:	89 df                	mov    %ebx,%edi
  106162:	fd                   	std    
  106163:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106165:	fc                   	cld    
  106166:	89 fb                	mov    %edi,%ebx
  106168:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  10616b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  10616e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  106171:	89 75 c8             	mov    %esi,-0x38(%ebp)
  106174:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  106177:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10617a:	83 c4 38             	add    $0x38,%esp
  10617d:	5b                   	pop    %ebx
  10617e:	5e                   	pop    %esi
  10617f:	5f                   	pop    %edi
  106180:	5d                   	pop    %ebp
  106181:	c3                   	ret    

00106182 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  106182:	55                   	push   %ebp
  106183:	89 e5                	mov    %esp,%ebp
  106185:	57                   	push   %edi
  106186:	56                   	push   %esi
  106187:	53                   	push   %ebx
  106188:	83 ec 24             	sub    $0x24,%esp
  10618b:	8b 45 08             	mov    0x8(%ebp),%eax
  10618e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106191:	8b 45 0c             	mov    0xc(%ebp),%eax
  106194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106197:	8b 45 10             	mov    0x10(%ebp),%eax
  10619a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10619d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061a0:	89 c1                	mov    %eax,%ecx
  1061a2:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1061a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1061a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1061ab:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  1061ae:	89 d7                	mov    %edx,%edi
  1061b0:	89 c3                	mov    %eax,%ebx
  1061b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1061b5:	89 de                	mov    %ebx,%esi
  1061b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1061b9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1061bc:	83 e1 03             	and    $0x3,%ecx
  1061bf:	74 02                	je     1061c3 <memcpy+0x41>
  1061c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1061c3:	89 f3                	mov    %esi,%ebx
  1061c5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  1061c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1061cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  1061ce:	89 7d e0             	mov    %edi,-0x20(%ebp)
  1061d1:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1061d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1061d7:	83 c4 24             	add    $0x24,%esp
  1061da:	5b                   	pop    %ebx
  1061db:	5e                   	pop    %esi
  1061dc:	5f                   	pop    %edi
  1061dd:	5d                   	pop    %ebp
  1061de:	c3                   	ret    

001061df <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1061df:	55                   	push   %ebp
  1061e0:	89 e5                	mov    %esp,%ebp
  1061e2:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1061e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1061e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1061eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1061f1:	eb 32                	jmp    106225 <memcmp+0x46>
        if (*s1 != *s2) {
  1061f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1061f6:	0f b6 10             	movzbl (%eax),%edx
  1061f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1061fc:	0f b6 00             	movzbl (%eax),%eax
  1061ff:	38 c2                	cmp    %al,%dl
  106201:	74 1a                	je     10621d <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  106206:	0f b6 00             	movzbl (%eax),%eax
  106209:	0f b6 d0             	movzbl %al,%edx
  10620c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10620f:	0f b6 00             	movzbl (%eax),%eax
  106212:	0f b6 c0             	movzbl %al,%eax
  106215:	89 d1                	mov    %edx,%ecx
  106217:	29 c1                	sub    %eax,%ecx
  106219:	89 c8                	mov    %ecx,%eax
  10621b:	eb 1c                	jmp    106239 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  10621d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106221:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106229:	0f 95 c0             	setne  %al
  10622c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106230:	84 c0                	test   %al,%al
  106232:	75 bf                	jne    1061f3 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106234:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106239:	c9                   	leave  
  10623a:	c3                   	ret    
