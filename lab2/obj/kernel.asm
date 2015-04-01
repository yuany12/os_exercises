
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 80 11 00 	lgdtl  0x118018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 04 00 00 00       	call   c010002c <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>
c010002a:	66 90                	xchg   %ax,%ax

c010002c <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002c:	55                   	push   %ebp
c010002d:	89 e5                	mov    %esp,%ebp
c010002f:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100032:	ba 88 99 11 c0       	mov    $0xc0119988,%edx
c0100037:	b8 38 8a 11 c0       	mov    $0xc0118a38,%eax
c010003c:	89 d1                	mov    %edx,%ecx
c010003e:	29 c1                	sub    %eax,%ecx
c0100040:	89 c8                	mov    %ecx,%eax
c0100042:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010004d:	00 
c010004e:	c7 04 24 38 8a 11 c0 	movl   $0xc0118a38,(%esp)
c0100055:	e8 29 60 00 00       	call   c0106083 <memset>

    cons_init();                // init the console
c010005a:	e8 15 16 00 00       	call   c0101674 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005f:	c7 45 f4 40 62 10 c0 	movl   $0xc0106240,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010006d:	c7 04 24 5c 62 10 c0 	movl   $0xc010625c,(%esp)
c0100074:	e8 ce 02 00 00       	call   c0100347 <cprintf>

    print_kerninfo();
c0100079:	e8 02 08 00 00       	call   c0100880 <print_kerninfo>

    grade_backtrace();
c010007e:	e8 86 00 00 00       	call   c0100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100083:	e8 5d 44 00 00       	call   c01044e5 <pmm_init>

    pic_init();                 // init interrupt controller
c0100088:	e8 58 17 00 00       	call   c01017e5 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008d:	e8 aa 18 00 00       	call   c010193c <idt_init>

    clock_init();               // init clock interrupt
c0100092:	e8 ed 0c 00 00       	call   c0100d84 <clock_init>
    intr_enable();              // enable irq interrupt
c0100097:	e8 b0 16 00 00       	call   c010174c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009c:	eb fe                	jmp    c010009c <kern_init+0x70>

c010009e <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009e:	55                   	push   %ebp
c010009f:	89 e5                	mov    %esp,%ebp
c01000a1:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ab:	00 
c01000ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b3:	00 
c01000b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bb:	e8 ee 0b 00 00       	call   c0100cae <mon_backtrace>
}
c01000c0:	c9                   	leave  
c01000c1:	c3                   	ret    

c01000c2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c2:	55                   	push   %ebp
c01000c3:	89 e5                	mov    %esp,%ebp
c01000c5:	53                   	push   %ebx
c01000c6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c9:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cf:	8d 55 08             	lea    0x8(%ebp),%edx
c01000d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000dd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e1:	89 04 24             	mov    %eax,(%esp)
c01000e4:	e8 b5 ff ff ff       	call   c010009e <grade_backtrace2>
}
c01000e9:	83 c4 14             	add    $0x14,%esp
c01000ec:	5b                   	pop    %ebx
c01000ed:	5d                   	pop    %ebp
c01000ee:	c3                   	ret    

c01000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000ef:	55                   	push   %ebp
c01000f0:	89 e5                	mov    %esp,%ebp
c01000f2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ff:	89 04 24             	mov    %eax,(%esp)
c0100102:	e8 bb ff ff ff       	call   c01000c2 <grade_backtrace1>
}
c0100107:	c9                   	leave  
c0100108:	c3                   	ret    

c0100109 <grade_backtrace>:

void
grade_backtrace(void) {
c0100109:	55                   	push   %ebp
c010010a:	89 e5                	mov    %esp,%ebp
c010010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010f:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c0100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010011b:	ff 
c010011c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100127:	e8 c3 ff ff ff       	call   c01000ef <grade_backtrace0>
}
c010012c:	c9                   	leave  
c010012d:	c3                   	ret    

c010012e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012e:	55                   	push   %ebp
c010012f:	89 e5                	mov    %esp,%ebp
c0100131:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100134:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100137:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100140:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100144:	0f b7 c0             	movzwl %ax,%eax
c0100147:	89 c2                	mov    %eax,%edx
c0100149:	83 e2 03             	and    $0x3,%edx
c010014c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100151:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100155:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100159:	c7 04 24 61 62 10 c0 	movl   $0xc0106261,(%esp)
c0100160:	e8 e2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100169:	0f b7 d0             	movzwl %ax,%edx
c010016c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100171:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100175:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100179:	c7 04 24 6f 62 10 c0 	movl   $0xc010626f,(%esp)
c0100180:	e8 c2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100191:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100195:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100199:	c7 04 24 7d 62 10 c0 	movl   $0xc010627d,(%esp)
c01001a0:	e8 a2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a9:	0f b7 d0             	movzwl %ax,%edx
c01001ac:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b9:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01001c0:	e8 82 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c9:	0f b7 d0             	movzwl %ax,%edx
c01001cc:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d9:	c7 04 24 99 62 10 c0 	movl   $0xc0106299,(%esp)
c01001e0:	e8 62 01 00 00       	call   c0100347 <cprintf>
    round ++;
c01001e5:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001ea:	83 c0 01             	add    $0x1,%eax
c01001ed:	a3 40 8a 11 c0       	mov    %eax,0xc0118a40
}
c01001f2:	c9                   	leave  
c01001f3:	c3                   	ret    

c01001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f4:	55                   	push   %ebp
c01001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f7:	5d                   	pop    %ebp
c01001f8:	c3                   	ret    

c01001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f9:	55                   	push   %ebp
c01001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fc:	5d                   	pop    %ebp
c01001fd:	c3                   	ret    

c01001fe <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fe:	55                   	push   %ebp
c01001ff:	89 e5                	mov    %esp,%ebp
c0100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100204:	e8 25 ff ff ff       	call   c010012e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100209:	c7 04 24 a8 62 10 c0 	movl   $0xc01062a8,(%esp)
c0100210:	e8 32 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_user();
c0100215:	e8 da ff ff ff       	call   c01001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021a:	e8 0f ff ff ff       	call   c010012e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021f:	c7 04 24 c8 62 10 c0 	movl   $0xc01062c8,(%esp)
c0100226:	e8 1c 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_kernel();
c010022b:	e8 c9 ff ff ff       	call   c01001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100230:	e8 f9 fe ff ff       	call   c010012e <lab1_print_cur_status>
}
c0100235:	c9                   	leave  
c0100236:	c3                   	ret    
c0100237:	90                   	nop

c0100238 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100238:	55                   	push   %ebp
c0100239:	89 e5                	mov    %esp,%ebp
c010023b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100242:	74 13                	je     c0100257 <readline+0x1f>
        cprintf("%s", prompt);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 44 24 04          	mov    %eax,0x4(%esp)
c010024b:	c7 04 24 e7 62 10 c0 	movl   $0xc01062e7,(%esp)
c0100252:	e8 f0 00 00 00       	call   c0100347 <cprintf>
    }
    int i = 0, c;
c0100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010025e:	eb 01                	jmp    c0100261 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
c0100260:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
c0100261:	e8 6e 01 00 00       	call   c01003d4 <getchar>
c0100266:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010026d:	79 07                	jns    c0100276 <readline+0x3e>
            return NULL;
c010026f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100274:	eb 79                	jmp    c01002ef <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100276:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027a:	7e 28                	jle    c01002a4 <readline+0x6c>
c010027c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100283:	7f 1f                	jg     c01002a4 <readline+0x6c>
            cputchar(c);
c0100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100288:	89 04 24             	mov    %eax,(%esp)
c010028b:	e8 df 00 00 00       	call   c010036f <cputchar>
            buf[i ++] = c;
c0100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100293:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100296:	81 c2 60 8a 11 c0    	add    $0xc0118a60,%edx
c010029c:	88 02                	mov    %al,(%edx)
c010029e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01002a2:	eb 46                	jmp    c01002ea <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01002a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a8:	75 17                	jne    c01002c1 <readline+0x89>
c01002aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ae:	7e 11                	jle    c01002c1 <readline+0x89>
            cputchar(c);
c01002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b3:	89 04 24             	mov    %eax,(%esp)
c01002b6:	e8 b4 00 00 00       	call   c010036f <cputchar>
            i --;
c01002bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002bf:	eb 29                	jmp    c01002ea <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01002c1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c5:	74 06                	je     c01002cd <readline+0x95>
c01002c7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cb:	75 93                	jne    c0100260 <readline+0x28>
            cputchar(c);
c01002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d0:	89 04 24             	mov    %eax,(%esp)
c01002d3:	e8 97 00 00 00       	call   c010036f <cputchar>
            buf[i] = '\0';
c01002d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002db:	05 60 8a 11 c0       	add    $0xc0118a60,%eax
c01002e0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e3:	b8 60 8a 11 c0       	mov    $0xc0118a60,%eax
c01002e8:	eb 05                	jmp    c01002ef <readline+0xb7>
        }
    }
c01002ea:	e9 71 ff ff ff       	jmp    c0100260 <readline+0x28>
}
c01002ef:	c9                   	leave  
c01002f0:	c3                   	ret    
c01002f1:	66 90                	xchg   %ax,%ax
c01002f3:	90                   	nop

c01002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f4:	55                   	push   %ebp
c01002f5:	89 e5                	mov    %esp,%ebp
c01002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 9b 13 00 00       	call   c01016a0 <cons_putc>
    (*cnt) ++;
c0100305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100308:	8b 00                	mov    (%eax),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100310:	89 10                	mov    %edx,(%eax)
}
c0100312:	c9                   	leave  
c0100313:	c3                   	ret    

c0100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100314:	55                   	push   %ebp
c0100315:	89 e5                	mov    %esp,%ebp
c0100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100328:	8b 45 08             	mov    0x8(%ebp),%eax
c010032b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100336:	c7 04 24 f4 02 10 c0 	movl   $0xc01002f4,(%esp)
c010033d:	e8 44 55 00 00       	call   c0105886 <vprintfmt>
    return cnt;
c0100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100345:	c9                   	leave  
c0100346:	c3                   	ret    

c0100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100347:	55                   	push   %ebp
c0100348:	89 e5                	mov    %esp,%ebp
c010034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034d:	8d 55 0c             	lea    0xc(%ebp),%edx
c0100350:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100353:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
c0100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100358:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035c:	8b 45 08             	mov    0x8(%ebp),%eax
c010035f:	89 04 24             	mov    %eax,(%esp)
c0100362:	e8 ad ff ff ff       	call   c0100314 <vcprintf>
c0100367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036d:	c9                   	leave  
c010036e:	c3                   	ret    

c010036f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036f:	55                   	push   %ebp
c0100370:	89 e5                	mov    %esp,%ebp
c0100372:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100375:	8b 45 08             	mov    0x8(%ebp),%eax
c0100378:	89 04 24             	mov    %eax,(%esp)
c010037b:	e8 20 13 00 00       	call   c01016a0 <cons_putc>
}
c0100380:	c9                   	leave  
c0100381:	c3                   	ret    

c0100382 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100382:	55                   	push   %ebp
c0100383:	89 e5                	mov    %esp,%ebp
c0100385:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038f:	eb 13                	jmp    c01003a4 <cputs+0x22>
        cputch(c, &cnt);
c0100391:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100395:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100398:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039c:	89 04 24             	mov    %eax,(%esp)
c010039f:	e8 50 ff ff ff       	call   c01002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a7:	0f b6 00             	movzbl (%eax),%eax
c01003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b1:	0f 95 c0             	setne  %al
c01003b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01003b8:	84 c0                	test   %al,%al
c01003ba:	75 d5                	jne    c0100391 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ca:	e8 25 ff ff ff       	call   c01002f4 <cputch>
    return cnt;
c01003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d2:	c9                   	leave  
c01003d3:	c3                   	ret    

c01003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d4:	55                   	push   %ebp
c01003d5:	89 e5                	mov    %esp,%ebp
c01003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003da:	e8 fd 12 00 00       	call   c01016dc <cons_getc>
c01003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e6:	74 f2                	je     c01003da <getchar+0x6>
        /* do nothing */;
    return c;
c01003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003eb:	c9                   	leave  
c01003ec:	c3                   	ret    

c01003ed <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ed:	55                   	push   %ebp
c01003ee:	89 e5                	mov    %esp,%ebp
c01003f0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f6:	8b 00                	mov    (%eax),%eax
c01003f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fe:	8b 00                	mov    (%eax),%eax
c0100400:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100403:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010040a:	e9 d2 00 00 00       	jmp    c01004e1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100412:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100415:	01 d0                	add    %edx,%eax
c0100417:	89 c2                	mov    %eax,%edx
c0100419:	c1 ea 1f             	shr    $0x1f,%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	d1 f8                	sar    %eax
c0100420:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100423:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100426:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100429:	eb 04                	jmp    c010042f <stab_binsearch+0x42>
            m --;
c010042b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100432:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100435:	7c 1f                	jl     c0100456 <stab_binsearch+0x69>
c0100437:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010043a:	89 d0                	mov    %edx,%eax
c010043c:	01 c0                	add    %eax,%eax
c010043e:	01 d0                	add    %edx,%eax
c0100440:	c1 e0 02             	shl    $0x2,%eax
c0100443:	89 c2                	mov    %eax,%edx
c0100445:	8b 45 08             	mov    0x8(%ebp),%eax
c0100448:	01 d0                	add    %edx,%eax
c010044a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044e:	0f b6 c0             	movzbl %al,%eax
c0100451:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100454:	75 d5                	jne    c010042b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100456:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100459:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045c:	7d 0b                	jge    c0100469 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100461:	83 c0 01             	add    $0x1,%eax
c0100464:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100467:	eb 78                	jmp    c01004e1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100469:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100470:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100473:	89 d0                	mov    %edx,%eax
c0100475:	01 c0                	add    %eax,%eax
c0100477:	01 d0                	add    %edx,%eax
c0100479:	c1 e0 02             	shl    $0x2,%eax
c010047c:	89 c2                	mov    %eax,%edx
c010047e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100481:	01 d0                	add    %edx,%eax
c0100483:	8b 40 08             	mov    0x8(%eax),%eax
c0100486:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100489:	73 13                	jae    c010049e <stab_binsearch+0xb1>
            *region_left = m;
c010048b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100493:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100496:	83 c0 01             	add    $0x1,%eax
c0100499:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049c:	eb 43                	jmp    c01004e1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a1:	89 d0                	mov    %edx,%eax
c01004a3:	01 c0                	add    %eax,%eax
c01004a5:	01 d0                	add    %edx,%eax
c01004a7:	c1 e0 02             	shl    $0x2,%eax
c01004aa:	89 c2                	mov    %eax,%edx
c01004ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01004af:	01 d0                	add    %edx,%eax
c01004b1:	8b 40 08             	mov    0x8(%eax),%eax
c01004b4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b7:	76 16                	jbe    c01004cf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c7:	83 e8 01             	sub    $0x1,%eax
c01004ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cd:	eb 12                	jmp    c01004e1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004da:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e7:	0f 8e 22 ff ff ff    	jle    c010040f <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f1:	75 0f                	jne    c0100502 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f6:	8b 00                	mov    (%eax),%eax
c01004f8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fe:	89 10                	mov    %edx,(%eax)
c0100500:	eb 3f                	jmp    c0100541 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	8b 00                	mov    (%eax),%eax
c0100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c010050a:	eb 04                	jmp    c0100510 <stab_binsearch+0x123>
c010050c:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100510:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100513:	8b 00                	mov    (%eax),%eax
c0100515:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100518:	7d 1f                	jge    c0100539 <stab_binsearch+0x14c>
c010051a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051d:	89 d0                	mov    %edx,%eax
c010051f:	01 c0                	add    %eax,%eax
c0100521:	01 d0                	add    %edx,%eax
c0100523:	c1 e0 02             	shl    $0x2,%eax
c0100526:	89 c2                	mov    %eax,%edx
c0100528:	8b 45 08             	mov    0x8(%ebp),%eax
c010052b:	01 d0                	add    %edx,%eax
c010052d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100531:	0f b6 c0             	movzbl %al,%eax
c0100534:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100537:	75 d3                	jne    c010050c <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053f:	89 10                	mov    %edx,(%eax)
    }
}
c0100541:	c9                   	leave  
c0100542:	c3                   	ret    

c0100543 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100543:	55                   	push   %ebp
c0100544:	89 e5                	mov    %esp,%ebp
c0100546:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100549:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054c:	c7 00 ec 62 10 c0    	movl   $0xc01062ec,(%eax)
    info->eip_line = 0;
c0100552:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100555:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055f:	c7 40 08 ec 62 10 c0 	movl   $0xc01062ec,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100566:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100569:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100570:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100573:	8b 55 08             	mov    0x8(%ebp),%edx
c0100576:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100579:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100583:	c7 45 f4 3c 75 10 c0 	movl   $0xc010753c,-0xc(%ebp)
    stab_end = __STAB_END__;
c010058a:	c7 45 f0 e0 24 11 c0 	movl   $0xc01124e0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100591:	c7 45 ec e1 24 11 c0 	movl   $0xc01124e1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100598:	c7 45 e8 7a 50 11 c0 	movl   $0xc011507a,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a5:	76 0d                	jbe    c01005b4 <debuginfo_eip+0x71>
c01005a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005aa:	83 e8 01             	sub    $0x1,%eax
c01005ad:	0f b6 00             	movzbl (%eax),%eax
c01005b0:	84 c0                	test   %al,%al
c01005b2:	74 0a                	je     c01005be <debuginfo_eip+0x7b>
        return -1;
c01005b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b9:	e9 c0 02 00 00       	jmp    c010087e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005cb:	29 c2                	sub    %eax,%edx
c01005cd:	89 d0                	mov    %edx,%eax
c01005cf:	c1 f8 02             	sar    $0x2,%eax
c01005d2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d8:	83 e8 01             	sub    $0x1,%eax
c01005db:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005de:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005ec:	00 
c01005ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fe:	89 04 24             	mov    %eax,(%esp)
c0100601:	e8 e7 fd ff ff       	call   c01003ed <stab_binsearch>
    if (lfile == 0)
c0100606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100609:	85 c0                	test   %eax,%eax
c010060b:	75 0a                	jne    c0100617 <debuginfo_eip+0xd4>
        return -1;
c010060d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100612:	e9 67 02 00 00       	jmp    c010087e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100620:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100623:	8b 45 08             	mov    0x8(%ebp),%eax
c0100626:	89 44 24 10          	mov    %eax,0x10(%esp)
c010062a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100631:	00 
c0100632:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100635:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100639:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100640:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100643:	89 04 24             	mov    %eax,(%esp)
c0100646:	e8 a2 fd ff ff       	call   c01003ed <stab_binsearch>

    if (lfun <= rfun) {
c010064b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100651:	39 c2                	cmp    %eax,%edx
c0100653:	7f 7c                	jg     c01006d1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100655:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100658:	89 c2                	mov    %eax,%edx
c010065a:	89 d0                	mov    %edx,%eax
c010065c:	01 c0                	add    %eax,%eax
c010065e:	01 d0                	add    %edx,%eax
c0100660:	c1 e0 02             	shl    $0x2,%eax
c0100663:	89 c2                	mov    %eax,%edx
c0100665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100668:	01 d0                	add    %edx,%eax
c010066a:	8b 10                	mov    (%eax),%edx
c010066c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100672:	29 c1                	sub    %eax,%ecx
c0100674:	89 c8                	mov    %ecx,%eax
c0100676:	39 c2                	cmp    %eax,%edx
c0100678:	73 22                	jae    c010069c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067d:	89 c2                	mov    %eax,%edx
c010067f:	89 d0                	mov    %edx,%eax
c0100681:	01 c0                	add    %eax,%eax
c0100683:	01 d0                	add    %edx,%eax
c0100685:	c1 e0 02             	shl    $0x2,%eax
c0100688:	89 c2                	mov    %eax,%edx
c010068a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068d:	01 d0                	add    %edx,%eax
c010068f:	8b 10                	mov    (%eax),%edx
c0100691:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100694:	01 c2                	add    %eax,%edx
c0100696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100699:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069f:	89 c2                	mov    %eax,%edx
c01006a1:	89 d0                	mov    %edx,%eax
c01006a3:	01 c0                	add    %eax,%eax
c01006a5:	01 d0                	add    %edx,%eax
c01006a7:	c1 e0 02             	shl    $0x2,%eax
c01006aa:	89 c2                	mov    %eax,%edx
c01006ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006af:	01 d0                	add    %edx,%eax
c01006b1:	8b 50 08             	mov    0x8(%eax),%edx
c01006b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bd:	8b 40 10             	mov    0x10(%eax),%eax
c01006c0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cf:	eb 15                	jmp    c01006e6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e9:	8b 40 08             	mov    0x8(%eax),%eax
c01006ec:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f3:	00 
c01006f4:	89 04 24             	mov    %eax,(%esp)
c01006f7:	e8 ff 57 00 00       	call   c0105efb <strfind>
c01006fc:	89 c2                	mov    %eax,%edx
c01006fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100701:	8b 40 08             	mov    0x8(%eax),%eax
c0100704:	29 c2                	sub    %eax,%edx
c0100706:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100709:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070c:	8b 45 08             	mov    0x8(%ebp),%eax
c010070f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100713:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071a:	00 
c010071b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100722:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100725:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100729:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072c:	89 04 24             	mov    %eax,(%esp)
c010072f:	e8 b9 fc ff ff       	call   c01003ed <stab_binsearch>
    if (lline <= rline) {
c0100734:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100737:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073a:	39 c2                	cmp    %eax,%edx
c010073c:	7f 24                	jg     c0100762 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	89 c2                	mov    %eax,%edx
c0100743:	89 d0                	mov    %edx,%eax
c0100745:	01 c0                	add    %eax,%eax
c0100747:	01 d0                	add    %edx,%eax
c0100749:	c1 e0 02             	shl    $0x2,%eax
c010074c:	89 c2                	mov    %eax,%edx
c010074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100751:	01 d0                	add    %edx,%eax
c0100753:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100757:	0f b7 d0             	movzwl %ax,%edx
c010075a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100760:	eb 13                	jmp    c0100775 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100767:	e9 12 01 00 00       	jmp    c010087e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076f:	83 e8 01             	sub    $0x1,%eax
c0100772:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077b:	39 c2                	cmp    %eax,%edx
c010077d:	7c 56                	jl     c01007d5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	89 d0                	mov    %edx,%eax
c0100786:	01 c0                	add    %eax,%eax
c0100788:	01 d0                	add    %edx,%eax
c010078a:	c1 e0 02             	shl    $0x2,%eax
c010078d:	89 c2                	mov    %eax,%edx
c010078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100792:	01 d0                	add    %edx,%eax
c0100794:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100798:	3c 84                	cmp    $0x84,%al
c010079a:	74 39                	je     c01007d5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079f:	89 c2                	mov    %eax,%edx
c01007a1:	89 d0                	mov    %edx,%eax
c01007a3:	01 c0                	add    %eax,%eax
c01007a5:	01 d0                	add    %edx,%eax
c01007a7:	c1 e0 02             	shl    $0x2,%eax
c01007aa:	89 c2                	mov    %eax,%edx
c01007ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007af:	01 d0                	add    %edx,%eax
c01007b1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b5:	3c 64                	cmp    $0x64,%al
c01007b7:	75 b3                	jne    c010076c <debuginfo_eip+0x229>
c01007b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bc:	89 c2                	mov    %eax,%edx
c01007be:	89 d0                	mov    %edx,%eax
c01007c0:	01 c0                	add    %eax,%eax
c01007c2:	01 d0                	add    %edx,%eax
c01007c4:	c1 e0 02             	shl    $0x2,%eax
c01007c7:	89 c2                	mov    %eax,%edx
c01007c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cc:	01 d0                	add    %edx,%eax
c01007ce:	8b 40 08             	mov    0x8(%eax),%eax
c01007d1:	85 c0                	test   %eax,%eax
c01007d3:	74 97                	je     c010076c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007db:	39 c2                	cmp    %eax,%edx
c01007dd:	7c 46                	jl     c0100825 <debuginfo_eip+0x2e2>
c01007df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e2:	89 c2                	mov    %eax,%edx
c01007e4:	89 d0                	mov    %edx,%eax
c01007e6:	01 c0                	add    %eax,%eax
c01007e8:	01 d0                	add    %edx,%eax
c01007ea:	c1 e0 02             	shl    $0x2,%eax
c01007ed:	89 c2                	mov    %eax,%edx
c01007ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f2:	01 d0                	add    %edx,%eax
c01007f4:	8b 10                	mov    (%eax),%edx
c01007f6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fc:	29 c1                	sub    %eax,%ecx
c01007fe:	89 c8                	mov    %ecx,%eax
c0100800:	39 c2                	cmp    %eax,%edx
c0100802:	73 21                	jae    c0100825 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100807:	89 c2                	mov    %eax,%edx
c0100809:	89 d0                	mov    %edx,%eax
c010080b:	01 c0                	add    %eax,%eax
c010080d:	01 d0                	add    %edx,%eax
c010080f:	c1 e0 02             	shl    $0x2,%eax
c0100812:	89 c2                	mov    %eax,%edx
c0100814:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100817:	01 d0                	add    %edx,%eax
c0100819:	8b 10                	mov    (%eax),%edx
c010081b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081e:	01 c2                	add    %eax,%edx
c0100820:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100823:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100825:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100828:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082b:	39 c2                	cmp    %eax,%edx
c010082d:	7d 4a                	jge    c0100879 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100832:	83 c0 01             	add    $0x1,%eax
c0100835:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100838:	eb 18                	jmp    c0100852 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010083a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083d:	8b 40 14             	mov    0x14(%eax),%eax
c0100840:	8d 50 01             	lea    0x1(%eax),%edx
c0100843:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100846:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100849:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084c:	83 c0 01             	add    $0x1,%eax
c010084f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100852:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100855:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100858:	39 c2                	cmp    %eax,%edx
c010085a:	7d 1d                	jge    c0100879 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085f:	89 c2                	mov    %eax,%edx
c0100861:	89 d0                	mov    %edx,%eax
c0100863:	01 c0                	add    %eax,%eax
c0100865:	01 d0                	add    %edx,%eax
c0100867:	c1 e0 02             	shl    $0x2,%eax
c010086a:	89 c2                	mov    %eax,%edx
c010086c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086f:	01 d0                	add    %edx,%eax
c0100871:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100875:	3c a0                	cmp    $0xa0,%al
c0100877:	74 c1                	je     c010083a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100879:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087e:	c9                   	leave  
c010087f:	c3                   	ret    

c0100880 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100880:	55                   	push   %ebp
c0100881:	89 e5                	mov    %esp,%ebp
c0100883:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100886:	c7 04 24 f6 62 10 c0 	movl   $0xc01062f6,(%esp)
c010088d:	e8 b5 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100892:	c7 44 24 04 2c 00 10 	movl   $0xc010002c,0x4(%esp)
c0100899:	c0 
c010089a:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c01008a1:	e8 a1 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a6:	c7 44 24 04 3b 62 10 	movl   $0xc010623b,0x4(%esp)
c01008ad:	c0 
c01008ae:	c7 04 24 27 63 10 c0 	movl   $0xc0106327,(%esp)
c01008b5:	e8 8d fa ff ff       	call   c0100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008ba:	c7 44 24 04 38 8a 11 	movl   $0xc0118a38,0x4(%esp)
c01008c1:	c0 
c01008c2:	c7 04 24 3f 63 10 c0 	movl   $0xc010633f,(%esp)
c01008c9:	e8 79 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ce:	c7 44 24 04 88 99 11 	movl   $0xc0119988,0x4(%esp)
c01008d5:	c0 
c01008d6:	c7 04 24 57 63 10 c0 	movl   $0xc0106357,(%esp)
c01008dd:	e8 65 fa ff ff       	call   c0100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e2:	b8 88 99 11 c0       	mov    $0xc0119988,%eax
c01008e7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ed:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c01008f2:	29 c2                	sub    %eax,%edx
c01008f4:	89 d0                	mov    %edx,%eax
c01008f6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fc:	85 c0                	test   %eax,%eax
c01008fe:	0f 48 c2             	cmovs  %edx,%eax
c0100901:	c1 f8 0a             	sar    $0xa,%eax
c0100904:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100908:	c7 04 24 70 63 10 c0 	movl   $0xc0106370,(%esp)
c010090f:	e8 33 fa ff ff       	call   c0100347 <cprintf>
}
c0100914:	c9                   	leave  
c0100915:	c3                   	ret    

c0100916 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100916:	55                   	push   %ebp
c0100917:	89 e5                	mov    %esp,%ebp
c0100919:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100922:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100926:	8b 45 08             	mov    0x8(%ebp),%eax
c0100929:	89 04 24             	mov    %eax,(%esp)
c010092c:	e8 12 fc ff ff       	call   c0100543 <debuginfo_eip>
c0100931:	85 c0                	test   %eax,%eax
c0100933:	74 15                	je     c010094a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100935:	8b 45 08             	mov    0x8(%ebp),%eax
c0100938:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093c:	c7 04 24 9a 63 10 c0 	movl   $0xc010639a,(%esp)
c0100943:	e8 ff f9 ff ff       	call   c0100347 <cprintf>
c0100948:	eb 6d                	jmp    c01009b7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010094a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100951:	eb 1c                	jmp    c010096f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100953:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100956:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100959:	01 d0                	add    %edx,%eax
c010095b:	0f b6 00             	movzbl (%eax),%eax
c010095e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100964:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100967:	01 ca                	add    %ecx,%edx
c0100969:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100972:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100975:	7f dc                	jg     c0100953 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100977:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100980:	01 d0                	add    %edx,%eax
c0100982:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100985:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100988:	8b 55 08             	mov    0x8(%ebp),%edx
c010098b:	89 d1                	mov    %edx,%ecx
c010098d:	29 c1                	sub    %eax,%ecx
c010098f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100992:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100995:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100999:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ab:	c7 04 24 b6 63 10 c0 	movl   $0xc01063b6,(%esp)
c01009b2:	e8 90 f9 ff ff       	call   c0100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b7:	c9                   	leave  
c01009b8:	c3                   	ret    

c01009b9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b9:	55                   	push   %ebp
c01009ba:	89 e5                	mov    %esp,%ebp
c01009bc:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bf:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c8:	c9                   	leave  
c01009c9:	c3                   	ret    

c01009ca <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ca:	55                   	push   %ebp
c01009cb:	89 e5                	mov    %esp,%ebp
c01009cd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d0:	89 e8                	mov    %ebp,%eax
c01009d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
c01009d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
c01009db:	e8 d9 ff ff ff       	call   c01009b9 <read_eip>
c01009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
c01009e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009ea:	e9 80 00 00 00       	jmp    c0100a6f <print_stackframe+0xa5>
		cprintf("ebp:0x%08x  eip:0x%08x arg:", ebp, eip);
c01009ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fd:	c7 04 24 c8 63 10 c0 	movl   $0xc01063c8,(%esp)
c0100a04:	e8 3e f9 ff ff       	call   c0100347 <cprintf>

		int j;
		for (j=0;j<4;j++)
c0100a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a10:	eb 26                	jmp    c0100a38 <print_stackframe+0x6e>
			cprintf("0x%08x ",*(uint32_t*)(ebp+4*j+8));
c0100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a15:	c1 e0 02             	shl    $0x2,%eax
c0100a18:	89 c2                	mov    %eax,%edx
c0100a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1d:	01 d0                	add    %edx,%eax
c0100a1f:	83 c0 08             	add    $0x8,%eax
c0100a22:	8b 00                	mov    (%eax),%eax
c0100a24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a28:	c7 04 24 e4 63 10 c0 	movl   $0xc01063e4,(%esp)
c0100a2f:	e8 13 f9 ff ff       	call   c0100347 <cprintf>
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
		cprintf("ebp:0x%08x  eip:0x%08x arg:", ebp, eip);

		int j;
		for (j=0;j<4;j++)
c0100a34:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a38:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3c:	7e d4                	jle    c0100a12 <print_stackframe+0x48>
			cprintf("0x%08x ",*(uint32_t*)(ebp+4*j+8));
		cprintf("\n");
c0100a3e:	c7 04 24 ec 63 10 c0 	movl   $0xc01063ec,(%esp)
c0100a45:	e8 fd f8 ff ff       	call   c0100347 <cprintf>
		print_debuginfo(eip-1);
c0100a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4d:	83 e8 01             	sub    $0x1,%eax
c0100a50:	89 04 24             	mov    %eax,(%esp)
c0100a53:	e8 be fe ff ff       	call   c0100916 <print_debuginfo>
		eip=*(uint32_t*)(ebp+4);
c0100a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5b:	83 c0 04             	add    $0x4,%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=*(uint32_t*)(ebp);
c0100a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a66:	8b 00                	mov    (%eax),%eax
c0100a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
c0100a6b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a6f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a73:	0f 8e 76 ff ff ff    	jle    c01009ef <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip-1);
		eip=*(uint32_t*)(ebp+4);
		ebp=*(uint32_t*)(ebp);
	}
}
c0100a79:	c9                   	leave  
c0100a7a:	c3                   	ret    
c0100a7b:	90                   	nop

c0100a7c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7c:	55                   	push   %ebp
c0100a7d:	89 e5                	mov    %esp,%ebp
c0100a7f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a89:	eb 0d                	jmp    c0100a98 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
c0100a8b:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8c:	eb 0a                	jmp    c0100a98 <parse+0x1c>
            *buf ++ = '\0';
c0100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
c0100a94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9b:	0f b6 00             	movzbl (%eax),%eax
c0100a9e:	84 c0                	test   %al,%al
c0100aa0:	74 1d                	je     c0100abf <parse+0x43>
c0100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa5:	0f b6 00             	movzbl (%eax),%eax
c0100aa8:	0f be c0             	movsbl %al,%eax
c0100aab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaf:	c7 04 24 70 64 10 c0 	movl   $0xc0106470,(%esp)
c0100ab6:	e8 0d 54 00 00       	call   c0105ec8 <strchr>
c0100abb:	85 c0                	test   %eax,%eax
c0100abd:	75 cf                	jne    c0100a8e <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac2:	0f b6 00             	movzbl (%eax),%eax
c0100ac5:	84 c0                	test   %al,%al
c0100ac7:	74 5e                	je     c0100b27 <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acd:	75 14                	jne    c0100ae3 <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad6:	00 
c0100ad7:	c7 04 24 75 64 10 c0 	movl   $0xc0106475,(%esp)
c0100ade:	e8 64 f8 ff ff       	call   c0100347 <cprintf>
        }
        argv[argc ++] = buf;
c0100ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae6:	c1 e0 02             	shl    $0x2,%eax
c0100ae9:	03 45 0c             	add    0xc(%ebp),%eax
c0100aec:	8b 55 08             	mov    0x8(%ebp),%edx
c0100aef:	89 10                	mov    %edx,(%eax)
c0100af1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100af5:	eb 04                	jmp    c0100afb <parse+0x7f>
            buf ++;
c0100af7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afe:	0f b6 00             	movzbl (%eax),%eax
c0100b01:	84 c0                	test   %al,%al
c0100b03:	74 86                	je     c0100a8b <parse+0xf>
c0100b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b08:	0f b6 00             	movzbl (%eax),%eax
c0100b0b:	0f be c0             	movsbl %al,%eax
c0100b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b12:	c7 04 24 70 64 10 c0 	movl   $0xc0106470,(%esp)
c0100b19:	e8 aa 53 00 00       	call   c0105ec8 <strchr>
c0100b1e:	85 c0                	test   %eax,%eax
c0100b20:	74 d5                	je     c0100af7 <parse+0x7b>
            buf ++;
        }
    }
c0100b22:	e9 64 ff ff ff       	jmp    c0100a8b <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100b27:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b2b:	c9                   	leave  
c0100b2c:	c3                   	ret    

c0100b2d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b2d:	55                   	push   %ebp
c0100b2e:	89 e5                	mov    %esp,%ebp
c0100b30:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b33:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3d:	89 04 24             	mov    %eax,(%esp)
c0100b40:	e8 37 ff ff ff       	call   c0100a7c <parse>
c0100b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b4c:	75 0a                	jne    c0100b58 <runcmd+0x2b>
        return 0;
c0100b4e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b53:	e9 85 00 00 00       	jmp    c0100bdd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b5f:	eb 5c                	jmp    c0100bbd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b61:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b67:	89 d0                	mov    %edx,%eax
c0100b69:	01 c0                	add    %eax,%eax
c0100b6b:	01 d0                	add    %edx,%eax
c0100b6d:	c1 e0 02             	shl    $0x2,%eax
c0100b70:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100b75:	8b 00                	mov    (%eax),%eax
c0100b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b7b:	89 04 24             	mov    %eax,(%esp)
c0100b7e:	e8 a0 52 00 00       	call   c0105e23 <strcmp>
c0100b83:	85 c0                	test   %eax,%eax
c0100b85:	75 32                	jne    c0100bb9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b8a:	89 d0                	mov    %edx,%eax
c0100b8c:	01 c0                	add    %eax,%eax
c0100b8e:	01 d0                	add    %edx,%eax
c0100b90:	c1 e0 02             	shl    $0x2,%eax
c0100b93:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100b98:	8b 50 08             	mov    0x8(%eax),%edx
c0100b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b9e:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0100ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ba4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ba8:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bab:	83 c0 04             	add    $0x4,%eax
c0100bae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb2:	89 0c 24             	mov    %ecx,(%esp)
c0100bb5:	ff d2                	call   *%edx
c0100bb7:	eb 24                	jmp    c0100bdd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc0:	83 f8 02             	cmp    $0x2,%eax
c0100bc3:	76 9c                	jbe    c0100b61 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bcc:	c7 04 24 93 64 10 c0 	movl   $0xc0106493,(%esp)
c0100bd3:	e8 6f f7 ff ff       	call   c0100347 <cprintf>
    return 0;
c0100bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bdd:	c9                   	leave  
c0100bde:	c3                   	ret    

c0100bdf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bdf:	55                   	push   %ebp
c0100be0:	89 e5                	mov    %esp,%ebp
c0100be2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100be5:	c7 04 24 ac 64 10 c0 	movl   $0xc01064ac,(%esp)
c0100bec:	e8 56 f7 ff ff       	call   c0100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf1:	c7 04 24 d4 64 10 c0 	movl   $0xc01064d4,(%esp)
c0100bf8:	e8 4a f7 ff ff       	call   c0100347 <cprintf>

    if (tf != NULL) {
c0100bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c01:	74 0e                	je     c0100c11 <kmonitor+0x32>
        print_trapframe(tf);
c0100c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c06:	89 04 24             	mov    %eax,(%esp)
c0100c09:	e8 e2 0e 00 00       	call   c0101af0 <print_trapframe>
c0100c0e:	eb 01                	jmp    c0100c11 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
c0100c10:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c11:	c7 04 24 f9 64 10 c0 	movl   $0xc01064f9,(%esp)
c0100c18:	e8 1b f6 ff ff       	call   c0100238 <readline>
c0100c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c24:	74 ea                	je     c0100c10 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
c0100c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c30:	89 04 24             	mov    %eax,(%esp)
c0100c33:	e8 f5 fe ff ff       	call   c0100b2d <runcmd>
c0100c38:	85 c0                	test   %eax,%eax
c0100c3a:	79 d4                	jns    c0100c10 <kmonitor+0x31>
                break;
c0100c3c:	90                   	nop
            }
        }
    }
}
c0100c3d:	c9                   	leave  
c0100c3e:	c3                   	ret    

c0100c3f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c3f:	55                   	push   %ebp
c0100c40:	89 e5                	mov    %esp,%ebp
c0100c42:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c4c:	eb 3f                	jmp    c0100c8d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c51:	89 d0                	mov    %edx,%eax
c0100c53:	01 c0                	add    %eax,%eax
c0100c55:	01 d0                	add    %edx,%eax
c0100c57:	c1 e0 02             	shl    $0x2,%eax
c0100c5a:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100c5f:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c65:	89 d0                	mov    %edx,%eax
c0100c67:	01 c0                	add    %eax,%eax
c0100c69:	01 d0                	add    %edx,%eax
c0100c6b:	c1 e0 02             	shl    $0x2,%eax
c0100c6e:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100c73:	8b 00                	mov    (%eax),%eax
c0100c75:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c7d:	c7 04 24 fd 64 10 c0 	movl   $0xc01064fd,(%esp)
c0100c84:	e8 be f6 ff ff       	call   c0100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c90:	83 f8 02             	cmp    $0x2,%eax
c0100c93:	76 b9                	jbe    c0100c4e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9a:	c9                   	leave  
c0100c9b:	c3                   	ret    

c0100c9c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c9c:	55                   	push   %ebp
c0100c9d:	89 e5                	mov    %esp,%ebp
c0100c9f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca2:	e8 d9 fb ff ff       	call   c0100880 <print_kerninfo>
    return 0;
c0100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cac:	c9                   	leave  
c0100cad:	c3                   	ret    

c0100cae <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cae:	55                   	push   %ebp
c0100caf:	89 e5                	mov    %esp,%ebp
c0100cb1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cb4:	e8 11 fd ff ff       	call   c01009ca <print_stackframe>
    return 0;
c0100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbe:	c9                   	leave  
c0100cbf:	c3                   	ret    

c0100cc0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc0:	55                   	push   %ebp
c0100cc1:	89 e5                	mov    %esp,%ebp
c0100cc3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cc6:	a1 60 8e 11 c0       	mov    0xc0118e60,%eax
c0100ccb:	85 c0                	test   %eax,%eax
c0100ccd:	75 4c                	jne    c0100d1b <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
c0100ccf:	c7 05 60 8e 11 c0 01 	movl   $0x1,0xc0118e60
c0100cd6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cd9:	8d 55 14             	lea    0x14(%ebp),%edx
c0100cdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100cdf:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cef:	c7 04 24 06 65 10 c0 	movl   $0xc0106506,(%esp)
c0100cf6:	e8 4c f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d02:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d05:	89 04 24             	mov    %eax,(%esp)
c0100d08:	e8 07 f6 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d0d:	c7 04 24 22 65 10 c0 	movl   $0xc0106522,(%esp)
c0100d14:	e8 2e f6 ff ff       	call   c0100347 <cprintf>
c0100d19:	eb 01                	jmp    c0100d1c <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100d1b:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1c:	e8 31 0a 00 00       	call   c0101752 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d28:	e8 b2 fe ff ff       	call   c0100bdf <kmonitor>
    }
c0100d2d:	eb f2                	jmp    c0100d21 <__panic+0x61>

c0100d2f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d2f:	55                   	push   %ebp
c0100d30:	89 e5                	mov    %esp,%ebp
c0100d32:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d35:	8d 55 14             	lea    0x14(%ebp),%edx
c0100d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100d3b:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4b:	c7 04 24 24 65 10 c0 	movl   $0xc0106524,(%esp)
c0100d52:	e8 f0 f5 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d61:	89 04 24             	mov    %eax,(%esp)
c0100d64:	e8 ab f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d69:	c7 04 24 22 65 10 c0 	movl   $0xc0106522,(%esp)
c0100d70:	e8 d2 f5 ff ff       	call   c0100347 <cprintf>
    va_end(ap);
}
c0100d75:	c9                   	leave  
c0100d76:	c3                   	ret    

c0100d77 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d77:	55                   	push   %ebp
c0100d78:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7a:	a1 60 8e 11 c0       	mov    0xc0118e60,%eax
}
c0100d7f:	5d                   	pop    %ebp
c0100d80:	c3                   	ret    
c0100d81:	66 90                	xchg   %ax,%ax
c0100d83:	90                   	nop

c0100d84 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d84:	55                   	push   %ebp
c0100d85:	89 e5                	mov    %esp,%ebp
c0100d87:	83 ec 28             	sub    $0x28,%esp
c0100d8a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d90:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d94:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d98:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9c:	ee                   	out    %al,(%dx)
c0100d9d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100daf:	ee                   	out    %al,(%dx)
c0100db0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dba:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc3:	c7 05 6c 99 11 c0 00 	movl   $0x0,0xc011996c
c0100dca:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcd:	c7 04 24 42 65 10 c0 	movl   $0xc0106542,(%esp)
c0100dd4:	e8 6e f5 ff ff       	call   c0100347 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de0:	e8 cb 09 00 00       	call   c01017b0 <pic_enable>
}
c0100de5:	c9                   	leave  
c0100de6:	c3                   	ret    
c0100de7:	90                   	nop

c0100de8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de8:	55                   	push   %ebp
c0100de9:	89 e5                	mov    %esp,%ebp
c0100deb:	53                   	push   %ebx
c0100dec:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100def:	9c                   	pushf  
c0100df0:	5b                   	pop    %ebx
c0100df1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0100df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df7:	25 00 02 00 00       	and    $0x200,%eax
c0100dfc:	85 c0                	test   %eax,%eax
c0100dfe:	74 0c                	je     c0100e0c <__intr_save+0x24>
        intr_disable();
c0100e00:	e8 4d 09 00 00       	call   c0101752 <intr_disable>
        return 1;
c0100e05:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0a:	eb 05                	jmp    c0100e11 <__intr_save+0x29>
    }
    return 0;
c0100e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e11:	83 c4 14             	add    $0x14,%esp
c0100e14:	5b                   	pop    %ebx
c0100e15:	5d                   	pop    %ebp
c0100e16:	c3                   	ret    

c0100e17 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e17:	55                   	push   %ebp
c0100e18:	89 e5                	mov    %esp,%ebp
c0100e1a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e21:	74 05                	je     c0100e28 <__intr_restore+0x11>
        intr_enable();
c0100e23:	e8 24 09 00 00       	call   c010174c <intr_enable>
    }
}
c0100e28:	c9                   	leave  
c0100e29:	c3                   	ret    

c0100e2a <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2a:	55                   	push   %ebp
c0100e2b:	89 e5                	mov    %esp,%ebp
c0100e2d:	53                   	push   %ebx
c0100e2e:	83 ec 14             	sub    $0x14,%esp
c0100e31:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e3b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	89 c3                	mov    %eax,%ebx
c0100e46:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
c0100e49:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e4f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e53:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	89 c3                	mov    %eax,%ebx
c0100e5e:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e67:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e6b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e6f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e73:	ec                   	in     (%dx),%al
c0100e74:	89 c3                	mov    %eax,%ebx
c0100e76:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0100e79:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e7f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e83:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e87:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e8b:	ec                   	in     (%dx),%al
c0100e8c:	89 c3                	mov    %eax,%ebx
c0100e8e:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e91:	83 c4 14             	add    $0x14,%esp
c0100e94:	5b                   	pop    %ebx
c0100e95:	5d                   	pop    %ebp
c0100e96:	c3                   	ret    

c0100e97 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e97:	55                   	push   %ebp
c0100e98:	89 e5                	mov    %esp,%ebp
c0100e9a:	53                   	push   %ebx
c0100e9b:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e9e:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
c0100ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ea8:	0f b7 00             	movzwl (%eax),%eax
c0100eab:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eb2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eba:	0f b7 00             	movzwl (%eax),%eax
c0100ebd:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ec1:	74 12                	je     c0100ed5 <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec3:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
c0100eca:	66 c7 05 86 8e 11 c0 	movw   $0x3b4,0xc0118e86
c0100ed1:	b4 03 
c0100ed3:	eb 13                	jmp    c0100ee8 <cga_init+0x51>
    } else {
        *cp = was;
c0100ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ed8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100edc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edf:	66 c7 05 86 8e 11 c0 	movw   $0x3d4,0xc0118e86
c0100ee6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee8:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100eef:	0f b7 c0             	movzwl %ax,%eax
c0100ef2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ef6:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f02:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f03:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100f0a:	83 c0 01             	add    $0x1,%eax
c0100f0d:	0f b7 c0             	movzwl %ax,%eax
c0100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f14:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f18:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f1c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f20:	ec                   	in     (%dx),%al
c0100f21:	89 c3                	mov    %eax,%ebx
c0100f23:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b6 c0             	movzbl %al,%eax
c0100f2d:	c1 e0 08             	shl    $0x8,%eax
c0100f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
c0100f33:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100f3a:	0f b7 c0             	movzwl %ax,%eax
c0100f3d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f41:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f4d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f4e:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100f55:	83 c0 01             	add    $0x1,%eax
c0100f58:	0f b7 c0             	movzwl %ax,%eax
c0100f5b:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f63:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f67:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f6b:	ec                   	in     (%dx),%al
c0100f6c:	89 c3                	mov    %eax,%ebx
c0100f6e:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
c0100f71:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f75:	0f b6 c0             	movzbl %al,%eax
c0100f78:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100f7e:	a3 80 8e 11 c0       	mov    %eax,0xc0118e80
    crt_pos = pos;
c0100f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f86:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
}
c0100f8c:	83 c4 24             	add    $0x24,%esp
c0100f8f:	5b                   	pop    %ebx
c0100f90:	5d                   	pop    %ebp
c0100f91:	c3                   	ret    

c0100f92 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f92:	55                   	push   %ebp
c0100f93:	89 e5                	mov    %esp,%ebp
c0100f95:	53                   	push   %ebx
c0100f96:	83 ec 54             	sub    $0x54,%esp
c0100f99:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f9f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fa3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fa7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fab:	ee                   	out    %al,(%dx)
c0100fac:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100fb2:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100fb6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fbe:	ee                   	out    %al,(%dx)
c0100fbf:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fc5:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fd1:	ee                   	out    %al,(%dx)
c0100fd2:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fd8:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fdc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fe0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fe4:	ee                   	out    %al,(%dx)
c0100fe5:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100feb:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fef:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ff3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ff7:	ee                   	out    %al,(%dx)
c0100ff8:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100ffe:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0101002:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101006:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010100a:	ee                   	out    %al,(%dx)
c010100b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101011:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0101015:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101019:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010101d:	ee                   	out    %al,(%dx)
c010101e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101024:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101028:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010102c:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101030:	ec                   	in     (%dx),%al
c0101031:	89 c3                	mov    %eax,%ebx
c0101033:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
c0101036:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010103a:	3c ff                	cmp    $0xff,%al
c010103c:	0f 95 c0             	setne  %al
c010103f:	0f b6 c0             	movzbl %al,%eax
c0101042:	a3 88 8e 11 c0       	mov    %eax,0xc0118e88
c0101047:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010104d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101051:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101055:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101059:	ec                   	in     (%dx),%al
c010105a:	89 c3                	mov    %eax,%ebx
c010105c:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
c010105f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101065:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101069:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010106d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101071:	ec                   	in     (%dx),%al
c0101072:	89 c3                	mov    %eax,%ebx
c0101074:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101077:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c010107c:	85 c0                	test   %eax,%eax
c010107e:	74 0c                	je     c010108c <serial_init+0xfa>
        pic_enable(IRQ_COM1);
c0101080:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101087:	e8 24 07 00 00       	call   c01017b0 <pic_enable>
    }
}
c010108c:	83 c4 54             	add    $0x54,%esp
c010108f:	5b                   	pop    %ebx
c0101090:	5d                   	pop    %ebp
c0101091:	c3                   	ret    

c0101092 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101092:	55                   	push   %ebp
c0101093:	89 e5                	mov    %esp,%ebp
c0101095:	53                   	push   %ebx
c0101096:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101099:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01010a0:	eb 09                	jmp    c01010ab <lpt_putc_sub+0x19>
        delay();
c01010a2:	e8 83 fd ff ff       	call   c0100e2a <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010a7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01010ab:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
c01010b1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010b5:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01010b9:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01010bd:	ec                   	in     (%dx),%al
c01010be:	89 c3                	mov    %eax,%ebx
c01010c0:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c01010c3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010c7:	84 c0                	test   %al,%al
c01010c9:	78 09                	js     c01010d4 <lpt_putc_sub+0x42>
c01010cb:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c01010d2:	7e ce                	jle    c01010a2 <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
c01010d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d7:	0f b6 c0             	movzbl %al,%eax
c01010da:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
c01010e0:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010e7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010eb:	ee                   	out    %al,(%dx)
c01010ec:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010f2:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
c01010f6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010fa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010fe:	ee                   	out    %al,(%dx)
c01010ff:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
c0101105:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
c0101109:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010110d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101111:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101112:	83 c4 24             	add    $0x24,%esp
c0101115:	5b                   	pop    %ebx
c0101116:	5d                   	pop    %ebp
c0101117:	c3                   	ret    

c0101118 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101118:	55                   	push   %ebp
c0101119:	89 e5                	mov    %esp,%ebp
c010111b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010111e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101122:	74 0d                	je     c0101131 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101124:	8b 45 08             	mov    0x8(%ebp),%eax
c0101127:	89 04 24             	mov    %eax,(%esp)
c010112a:	e8 63 ff ff ff       	call   c0101092 <lpt_putc_sub>
c010112f:	eb 24                	jmp    c0101155 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101131:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101138:	e8 55 ff ff ff       	call   c0101092 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010113d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101144:	e8 49 ff ff ff       	call   c0101092 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101149:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101150:	e8 3d ff ff ff       	call   c0101092 <lpt_putc_sub>
    }
}
c0101155:	c9                   	leave  
c0101156:	c3                   	ret    

c0101157 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101157:	55                   	push   %ebp
c0101158:	89 e5                	mov    %esp,%ebp
c010115a:	53                   	push   %ebx
c010115b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010115e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101161:	b0 00                	mov    $0x0,%al
c0101163:	85 c0                	test   %eax,%eax
c0101165:	75 07                	jne    c010116e <cga_putc+0x17>
        c |= 0x0700;
c0101167:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010116e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101171:	25 ff 00 00 00       	and    $0xff,%eax
c0101176:	83 f8 0a             	cmp    $0xa,%eax
c0101179:	74 4e                	je     c01011c9 <cga_putc+0x72>
c010117b:	83 f8 0d             	cmp    $0xd,%eax
c010117e:	74 59                	je     c01011d9 <cga_putc+0x82>
c0101180:	83 f8 08             	cmp    $0x8,%eax
c0101183:	0f 85 8c 00 00 00    	jne    c0101215 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101189:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101190:	66 85 c0             	test   %ax,%ax
c0101193:	0f 84 a1 00 00 00    	je     c010123a <cga_putc+0xe3>
            crt_pos --;
c0101199:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01011a0:	83 e8 01             	sub    $0x1,%eax
c01011a3:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a9:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c01011ae:	0f b7 15 84 8e 11 c0 	movzwl 0xc0118e84,%edx
c01011b5:	0f b7 d2             	movzwl %dx,%edx
c01011b8:	01 d2                	add    %edx,%edx
c01011ba:	01 c2                	add    %eax,%edx
c01011bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011bf:	b0 00                	mov    $0x0,%al
c01011c1:	83 c8 20             	or     $0x20,%eax
c01011c4:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011c7:	eb 71                	jmp    c010123a <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
c01011c9:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01011d0:	83 c0 50             	add    $0x50,%eax
c01011d3:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011d9:	0f b7 1d 84 8e 11 c0 	movzwl 0xc0118e84,%ebx
c01011e0:	0f b7 0d 84 8e 11 c0 	movzwl 0xc0118e84,%ecx
c01011e7:	0f b7 c1             	movzwl %cx,%eax
c01011ea:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011f0:	c1 e8 10             	shr    $0x10,%eax
c01011f3:	89 c2                	mov    %eax,%edx
c01011f5:	66 c1 ea 06          	shr    $0x6,%dx
c01011f9:	89 d0                	mov    %edx,%eax
c01011fb:	c1 e0 02             	shl    $0x2,%eax
c01011fe:	01 d0                	add    %edx,%eax
c0101200:	c1 e0 04             	shl    $0x4,%eax
c0101203:	89 ca                	mov    %ecx,%edx
c0101205:	66 29 c2             	sub    %ax,%dx
c0101208:	89 d8                	mov    %ebx,%eax
c010120a:	66 29 d0             	sub    %dx,%ax
c010120d:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
        break;
c0101213:	eb 26                	jmp    c010123b <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101215:	8b 15 80 8e 11 c0    	mov    0xc0118e80,%edx
c010121b:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101222:	0f b7 c8             	movzwl %ax,%ecx
c0101225:	01 c9                	add    %ecx,%ecx
c0101227:	01 d1                	add    %edx,%ecx
c0101229:	8b 55 08             	mov    0x8(%ebp),%edx
c010122c:	66 89 11             	mov    %dx,(%ecx)
c010122f:	83 c0 01             	add    $0x1,%eax
c0101232:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
        break;
c0101238:	eb 01                	jmp    c010123b <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c010123a:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010123b:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101242:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101246:	76 5b                	jbe    c01012a3 <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101248:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c010124d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101253:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101258:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010125f:	00 
c0101260:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101264:	89 04 24             	mov    %eax,(%esp)
c0101267:	e8 62 4e 00 00       	call   c01060ce <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010126c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101273:	eb 15                	jmp    c010128a <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
c0101275:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c010127a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010127d:	01 d2                	add    %edx,%edx
c010127f:	01 d0                	add    %edx,%eax
c0101281:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101286:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010128a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101291:	7e e2                	jle    c0101275 <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101293:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c010129a:	83 e8 50             	sub    $0x50,%eax
c010129d:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012a3:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c01012aa:	0f b7 c0             	movzwl %ax,%eax
c01012ad:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01012b1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c01012b5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012b9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01012be:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01012c5:	66 c1 e8 08          	shr    $0x8,%ax
c01012c9:	0f b6 c0             	movzbl %al,%eax
c01012cc:	0f b7 15 86 8e 11 c0 	movzwl 0xc0118e86,%edx
c01012d3:	83 c2 01             	add    $0x1,%edx
c01012d6:	0f b7 d2             	movzwl %dx,%edx
c01012d9:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01012dd:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012e0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012e8:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012e9:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c01012f0:	0f b7 c0             	movzwl %ax,%eax
c01012f3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012f7:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012fb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101303:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101304:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c010130b:	0f b6 c0             	movzbl %al,%eax
c010130e:	0f b7 15 86 8e 11 c0 	movzwl 0xc0118e86,%edx
c0101315:	83 c2 01             	add    $0x1,%edx
c0101318:	0f b7 d2             	movzwl %dx,%edx
c010131b:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c010131f:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101322:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101326:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010132a:	ee                   	out    %al,(%dx)
}
c010132b:	83 c4 34             	add    $0x34,%esp
c010132e:	5b                   	pop    %ebx
c010132f:	5d                   	pop    %ebp
c0101330:	c3                   	ret    

c0101331 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101331:	55                   	push   %ebp
c0101332:	89 e5                	mov    %esp,%ebp
c0101334:	53                   	push   %ebx
c0101335:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010133f:	eb 09                	jmp    c010134a <serial_putc_sub+0x19>
        delay();
c0101341:	e8 e4 fa ff ff       	call   c0100e2a <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101346:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c010134a:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101350:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101354:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101358:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010135c:	ec                   	in     (%dx),%al
c010135d:	89 c3                	mov    %eax,%ebx
c010135f:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101362:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101366:	0f b6 c0             	movzbl %al,%eax
c0101369:	83 e0 20             	and    $0x20,%eax
c010136c:	85 c0                	test   %eax,%eax
c010136e:	75 09                	jne    c0101379 <serial_putc_sub+0x48>
c0101370:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c0101377:	7e c8                	jle    c0101341 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101379:	8b 45 08             	mov    0x8(%ebp),%eax
c010137c:	0f b6 c0             	movzbl %al,%eax
c010137f:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0101385:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101388:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010138c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101390:	ee                   	out    %al,(%dx)
}
c0101391:	83 c4 14             	add    $0x14,%esp
c0101394:	5b                   	pop    %ebx
c0101395:	5d                   	pop    %ebp
c0101396:	c3                   	ret    

c0101397 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101397:	55                   	push   %ebp
c0101398:	89 e5                	mov    %esp,%ebp
c010139a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010139d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a1:	74 0d                	je     c01013b0 <serial_putc+0x19>
        serial_putc_sub(c);
c01013a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a6:	89 04 24             	mov    %eax,(%esp)
c01013a9:	e8 83 ff ff ff       	call   c0101331 <serial_putc_sub>
c01013ae:	eb 24                	jmp    c01013d4 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c01013b0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013b7:	e8 75 ff ff ff       	call   c0101331 <serial_putc_sub>
        serial_putc_sub(' ');
c01013bc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013c3:	e8 69 ff ff ff       	call   c0101331 <serial_putc_sub>
        serial_putc_sub('\b');
c01013c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013cf:	e8 5d ff ff ff       	call   c0101331 <serial_putc_sub>
    }
}
c01013d4:	c9                   	leave  
c01013d5:	c3                   	ret    

c01013d6 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013d6:	55                   	push   %ebp
c01013d7:	89 e5                	mov    %esp,%ebp
c01013d9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013dc:	eb 32                	jmp    c0101410 <cons_intr+0x3a>
        if (c != 0) {
c01013de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013e2:	74 2c                	je     c0101410 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
c01013e4:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c01013e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013ec:	88 90 a0 8e 11 c0    	mov    %dl,-0x3fee7160(%eax)
c01013f2:	83 c0 01             	add    $0x1,%eax
c01013f5:	a3 a4 90 11 c0       	mov    %eax,0xc01190a4
            if (cons.wpos == CONSBUFSIZE) {
c01013fa:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c01013ff:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101404:	75 0a                	jne    c0101410 <cons_intr+0x3a>
                cons.wpos = 0;
c0101406:	c7 05 a4 90 11 c0 00 	movl   $0x0,0xc01190a4
c010140d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101410:	8b 45 08             	mov    0x8(%ebp),%eax
c0101413:	ff d0                	call   *%eax
c0101415:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101418:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010141c:	75 c0                	jne    c01013de <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010141e:	c9                   	leave  
c010141f:	c3                   	ret    

c0101420 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101420:	55                   	push   %ebp
c0101421:	89 e5                	mov    %esp,%ebp
c0101423:	53                   	push   %ebx
c0101424:	83 ec 14             	sub    $0x14,%esp
c0101427:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101431:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101435:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	89 c3                	mov    %eax,%ebx
c010143c:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010143f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101443:	0f b6 c0             	movzbl %al,%eax
c0101446:	83 e0 01             	and    $0x1,%eax
c0101449:	85 c0                	test   %eax,%eax
c010144b:	75 07                	jne    c0101454 <serial_proc_data+0x34>
        return -1;
c010144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101452:	eb 32                	jmp    c0101486 <serial_proc_data+0x66>
c0101454:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010145e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101462:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101466:	ec                   	in     (%dx),%al
c0101467:	89 c3                	mov    %eax,%ebx
c0101469:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c010146c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101470:	0f b6 c0             	movzbl %al,%eax
c0101473:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
c0101476:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
c010147a:	75 07                	jne    c0101483 <serial_proc_data+0x63>
        c = '\b';
c010147c:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
c0101483:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0101486:	83 c4 14             	add    $0x14,%esp
c0101489:	5b                   	pop    %ebx
c010148a:	5d                   	pop    %ebp
c010148b:	c3                   	ret    

c010148c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010148c:	55                   	push   %ebp
c010148d:	89 e5                	mov    %esp,%ebp
c010148f:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101492:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c0101497:	85 c0                	test   %eax,%eax
c0101499:	74 0c                	je     c01014a7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010149b:	c7 04 24 20 14 10 c0 	movl   $0xc0101420,(%esp)
c01014a2:	e8 2f ff ff ff       	call   c01013d6 <cons_intr>
    }
}
c01014a7:	c9                   	leave  
c01014a8:	c3                   	ret    

c01014a9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a9:	55                   	push   %ebp
c01014aa:	89 e5                	mov    %esp,%ebp
c01014ac:	53                   	push   %ebx
c01014ad:	83 ec 44             	sub    $0x44,%esp
c01014b0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014b6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01014ba:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014be:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014c2:	ec                   	in     (%dx),%al
c01014c3:	89 c3                	mov    %eax,%ebx
c01014c5:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
c01014c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014cc:	0f b6 c0             	movzbl %al,%eax
c01014cf:	83 e0 01             	and    $0x1,%eax
c01014d2:	85 c0                	test   %eax,%eax
c01014d4:	75 0a                	jne    c01014e0 <kbd_proc_data+0x37>
        return -1;
c01014d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014db:	e9 61 01 00 00       	jmp    c0101641 <kbd_proc_data+0x198>
c01014e0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e6:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01014ea:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014ee:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014f2:	ec                   	in     (%dx),%al
c01014f3:	89 c3                	mov    %eax,%ebx
c01014f5:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
c01014f8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014fc:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014ff:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101503:	75 17                	jne    c010151c <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
c0101505:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010150a:	83 c8 40             	or     $0x40,%eax
c010150d:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
        return 0;
c0101512:	b8 00 00 00 00       	mov    $0x0,%eax
c0101517:	e9 25 01 00 00       	jmp    c0101641 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
c010151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101520:	84 c0                	test   %al,%al
c0101522:	79 47                	jns    c010156b <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101524:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101529:	83 e0 40             	and    $0x40,%eax
c010152c:	85 c0                	test   %eax,%eax
c010152e:	75 09                	jne    c0101539 <kbd_proc_data+0x90>
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	83 e0 7f             	and    $0x7f,%eax
c0101537:	eb 04                	jmp    c010153d <kbd_proc_data+0x94>
c0101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101540:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101544:	0f b6 80 60 80 11 c0 	movzbl -0x3fee7fa0(%eax),%eax
c010154b:	83 c8 40             	or     $0x40,%eax
c010154e:	0f b6 c0             	movzbl %al,%eax
c0101551:	f7 d0                	not    %eax
c0101553:	89 c2                	mov    %eax,%edx
c0101555:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010155a:	21 d0                	and    %edx,%eax
c010155c:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
        return 0;
c0101561:	b8 00 00 00 00       	mov    $0x0,%eax
c0101566:	e9 d6 00 00 00       	jmp    c0101641 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
c010156b:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101570:	83 e0 40             	and    $0x40,%eax
c0101573:	85 c0                	test   %eax,%eax
c0101575:	74 11                	je     c0101588 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101577:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010157b:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101580:	83 e0 bf             	and    $0xffffffbf,%eax
c0101583:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
    }

    shift |= shiftcode[data];
c0101588:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158c:	0f b6 80 60 80 11 c0 	movzbl -0x3fee7fa0(%eax),%eax
c0101593:	0f b6 d0             	movzbl %al,%edx
c0101596:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010159b:	09 d0                	or     %edx,%eax
c010159d:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
    shift ^= togglecode[data];
c01015a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a6:	0f b6 80 60 81 11 c0 	movzbl -0x3fee7ea0(%eax),%eax
c01015ad:	0f b6 d0             	movzbl %al,%edx
c01015b0:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01015b5:	31 d0                	xor    %edx,%eax
c01015b7:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01015bc:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01015c1:	83 e0 03             	and    $0x3,%eax
c01015c4:	8b 14 85 60 85 11 c0 	mov    -0x3fee7aa0(,%eax,4),%edx
c01015cb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015cf:	01 d0                	add    %edx,%eax
c01015d1:	0f b6 00             	movzbl (%eax),%eax
c01015d4:	0f b6 c0             	movzbl %al,%eax
c01015d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015da:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01015df:	83 e0 08             	and    $0x8,%eax
c01015e2:	85 c0                	test   %eax,%eax
c01015e4:	74 22                	je     c0101608 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
c01015e6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015ea:	7e 0c                	jle    c01015f8 <kbd_proc_data+0x14f>
c01015ec:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015f0:	7f 06                	jg     c01015f8 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
c01015f2:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015f6:	eb 10                	jmp    c0101608 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
c01015f8:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015fc:	7e 0a                	jle    c0101608 <kbd_proc_data+0x15f>
c01015fe:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101602:	7f 04                	jg     c0101608 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
c0101604:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101608:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010160d:	f7 d0                	not    %eax
c010160f:	83 e0 06             	and    $0x6,%eax
c0101612:	85 c0                	test   %eax,%eax
c0101614:	75 28                	jne    c010163e <kbd_proc_data+0x195>
c0101616:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010161d:	75 1f                	jne    c010163e <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
c010161f:	c7 04 24 5d 65 10 c0 	movl   $0xc010655d,(%esp)
c0101626:	e8 1c ed ff ff       	call   c0100347 <cprintf>
c010162b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101631:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101635:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101639:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010163d:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101641:	83 c4 44             	add    $0x44,%esp
c0101644:	5b                   	pop    %ebx
c0101645:	5d                   	pop    %ebp
c0101646:	c3                   	ret    

c0101647 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101647:	55                   	push   %ebp
c0101648:	89 e5                	mov    %esp,%ebp
c010164a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010164d:	c7 04 24 a9 14 10 c0 	movl   $0xc01014a9,(%esp)
c0101654:	e8 7d fd ff ff       	call   c01013d6 <cons_intr>
}
c0101659:	c9                   	leave  
c010165a:	c3                   	ret    

c010165b <kbd_init>:

static void
kbd_init(void) {
c010165b:	55                   	push   %ebp
c010165c:	89 e5                	mov    %esp,%ebp
c010165e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101661:	e8 e1 ff ff ff       	call   c0101647 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010166d:	e8 3e 01 00 00       	call   c01017b0 <pic_enable>
}
c0101672:	c9                   	leave  
c0101673:	c3                   	ret    

c0101674 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101674:	55                   	push   %ebp
c0101675:	89 e5                	mov    %esp,%ebp
c0101677:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c010167a:	e8 18 f8 ff ff       	call   c0100e97 <cga_init>
    serial_init();
c010167f:	e8 0e f9 ff ff       	call   c0100f92 <serial_init>
    kbd_init();
c0101684:	e8 d2 ff ff ff       	call   c010165b <kbd_init>
    if (!serial_exists) {
c0101689:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c010168e:	85 c0                	test   %eax,%eax
c0101690:	75 0c                	jne    c010169e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101692:	c7 04 24 69 65 10 c0 	movl   $0xc0106569,(%esp)
c0101699:	e8 a9 ec ff ff       	call   c0100347 <cprintf>
    }
}
c010169e:	c9                   	leave  
c010169f:	c3                   	ret    

c01016a0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016a0:	55                   	push   %ebp
c01016a1:	89 e5                	mov    %esp,%ebp
c01016a3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016a6:	e8 3d f7 ff ff       	call   c0100de8 <__intr_save>
c01016ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b1:	89 04 24             	mov    %eax,(%esp)
c01016b4:	e8 5f fa ff ff       	call   c0101118 <lpt_putc>
        cga_putc(c);
c01016b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bc:	89 04 24             	mov    %eax,(%esp)
c01016bf:	e8 93 fa ff ff       	call   c0101157 <cga_putc>
        serial_putc(c);
c01016c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c7:	89 04 24             	mov    %eax,(%esp)
c01016ca:	e8 c8 fc ff ff       	call   c0101397 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016d2:	89 04 24             	mov    %eax,(%esp)
c01016d5:	e8 3d f7 ff ff       	call   c0100e17 <__intr_restore>
}
c01016da:	c9                   	leave  
c01016db:	c3                   	ret    

c01016dc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016dc:	55                   	push   %ebp
c01016dd:	89 e5                	mov    %esp,%ebp
c01016df:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016e9:	e8 fa f6 ff ff       	call   c0100de8 <__intr_save>
c01016ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016f1:	e8 96 fd ff ff       	call   c010148c <serial_intr>
        kbd_intr();
c01016f6:	e8 4c ff ff ff       	call   c0101647 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016fb:	8b 15 a0 90 11 c0    	mov    0xc01190a0,%edx
c0101701:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c0101706:	39 c2                	cmp    %eax,%edx
c0101708:	74 30                	je     c010173a <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c010170a:	a1 a0 90 11 c0       	mov    0xc01190a0,%eax
c010170f:	0f b6 90 a0 8e 11 c0 	movzbl -0x3fee7160(%eax),%edx
c0101716:	0f b6 d2             	movzbl %dl,%edx
c0101719:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010171c:	83 c0 01             	add    $0x1,%eax
c010171f:	a3 a0 90 11 c0       	mov    %eax,0xc01190a0
            if (cons.rpos == CONSBUFSIZE) {
c0101724:	a1 a0 90 11 c0       	mov    0xc01190a0,%eax
c0101729:	3d 00 02 00 00       	cmp    $0x200,%eax
c010172e:	75 0a                	jne    c010173a <cons_getc+0x5e>
                cons.rpos = 0;
c0101730:	c7 05 a0 90 11 c0 00 	movl   $0x0,0xc01190a0
c0101737:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010173d:	89 04 24             	mov    %eax,(%esp)
c0101740:	e8 d2 f6 ff ff       	call   c0100e17 <__intr_restore>
    return c;
c0101745:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101748:	c9                   	leave  
c0101749:	c3                   	ret    
c010174a:	66 90                	xchg   %ax,%ax

c010174c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010174c:	55                   	push   %ebp
c010174d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010174f:	fb                   	sti    
    sti();
}
c0101750:	5d                   	pop    %ebp
c0101751:	c3                   	ret    

c0101752 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101752:	55                   	push   %ebp
c0101753:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101755:	fa                   	cli    
    cli();
}
c0101756:	5d                   	pop    %ebp
c0101757:	c3                   	ret    

c0101758 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101758:	55                   	push   %ebp
c0101759:	89 e5                	mov    %esp,%ebp
c010175b:	83 ec 14             	sub    $0x14,%esp
c010175e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101761:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101765:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101769:	66 a3 70 85 11 c0    	mov    %ax,0xc0118570
    if (did_init) {
c010176f:	a1 ac 90 11 c0       	mov    0xc01190ac,%eax
c0101774:	85 c0                	test   %eax,%eax
c0101776:	74 36                	je     c01017ae <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101778:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010177c:	0f b6 c0             	movzbl %al,%eax
c010177f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101785:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101788:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010178c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101791:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101795:	66 c1 e8 08          	shr    $0x8,%ax
c0101799:	0f b6 c0             	movzbl %al,%eax
c010179c:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01017a2:	88 45 f9             	mov    %al,-0x7(%ebp)
c01017a5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017a9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017ad:	ee                   	out    %al,(%dx)
    }
}
c01017ae:	c9                   	leave  
c01017af:	c3                   	ret    

c01017b0 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01017b0:	55                   	push   %ebp
c01017b1:	89 e5                	mov    %esp,%ebp
c01017b3:	53                   	push   %ebx
c01017b4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01017b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01017ba:	ba 01 00 00 00       	mov    $0x1,%edx
c01017bf:	89 d3                	mov    %edx,%ebx
c01017c1:	89 c1                	mov    %eax,%ecx
c01017c3:	d3 e3                	shl    %cl,%ebx
c01017c5:	89 d8                	mov    %ebx,%eax
c01017c7:	89 c2                	mov    %eax,%edx
c01017c9:	f7 d2                	not    %edx
c01017cb:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c01017d2:	21 d0                	and    %edx,%eax
c01017d4:	0f b7 c0             	movzwl %ax,%eax
c01017d7:	89 04 24             	mov    %eax,(%esp)
c01017da:	e8 79 ff ff ff       	call   c0101758 <pic_setmask>
}
c01017df:	83 c4 04             	add    $0x4,%esp
c01017e2:	5b                   	pop    %ebx
c01017e3:	5d                   	pop    %ebp
c01017e4:	c3                   	ret    

c01017e5 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017e5:	55                   	push   %ebp
c01017e6:	89 e5                	mov    %esp,%ebp
c01017e8:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017eb:	c7 05 ac 90 11 c0 01 	movl   $0x1,0xc01190ac
c01017f2:	00 00 00 
c01017f5:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01017fb:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01017ff:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101803:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101807:	ee                   	out    %al,(%dx)
c0101808:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010180e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101812:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101816:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010181a:	ee                   	out    %al,(%dx)
c010181b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101821:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101825:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101829:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010182d:	ee                   	out    %al,(%dx)
c010182e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101834:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101838:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010183c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
c0101841:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101847:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010184b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010184f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
c0101854:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010185a:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010185e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101862:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101866:	ee                   	out    %al,(%dx)
c0101867:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c010186d:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101871:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101875:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101879:	ee                   	out    %al,(%dx)
c010187a:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0101880:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0101884:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101888:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010188c:	ee                   	out    %al,(%dx)
c010188d:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101893:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101897:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010189b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010189f:	ee                   	out    %al,(%dx)
c01018a0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01018a6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01018aa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01018ae:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01018b2:	ee                   	out    %al,(%dx)
c01018b3:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01018b9:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01018bd:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01018c1:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01018c5:	ee                   	out    %al,(%dx)
c01018c6:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01018cc:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01018d0:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01018d4:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01018d8:	ee                   	out    %al,(%dx)
c01018d9:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01018df:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01018e3:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018e7:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018eb:	ee                   	out    %al,(%dx)
c01018ec:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01018f2:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01018f6:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018fa:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01018fe:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01018ff:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c0101906:	66 83 f8 ff          	cmp    $0xffff,%ax
c010190a:	74 12                	je     c010191e <pic_init+0x139>
        pic_setmask(irq_mask);
c010190c:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c0101913:	0f b7 c0             	movzwl %ax,%eax
c0101916:	89 04 24             	mov    %eax,(%esp)
c0101919:	e8 3a fe ff ff       	call   c0101758 <pic_setmask>
    }
}
c010191e:	c9                   	leave  
c010191f:	c3                   	ret    

c0101920 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101920:	55                   	push   %ebp
c0101921:	89 e5                	mov    %esp,%ebp
c0101923:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101926:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010192d:	00 
c010192e:	c7 04 24 a0 65 10 c0 	movl   $0xc01065a0,(%esp)
c0101935:	e8 0d ea ff ff       	call   c0100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010193a:	c9                   	leave  
c010193b:	c3                   	ret    

c010193c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010193c:	55                   	push   %ebp
c010193d:	89 e5                	mov    %esp,%ebp
c010193f:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];

	int i;
	for (i=0;i<256;i++)
c0101942:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101949:	e9 c3 00 00 00       	jmp    c0101a11 <idt_init+0xd5>
		SETGATE(idt[i], 0, 8, __vectors[i], 0);
c010194e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101951:	8b 04 85 00 86 11 c0 	mov    -0x3fee7a00(,%eax,4),%eax
c0101958:	89 c2                	mov    %eax,%edx
c010195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195d:	66 89 14 c5 c0 90 11 	mov    %dx,-0x3fee6f40(,%eax,8)
c0101964:	c0 
c0101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101968:	66 c7 04 c5 c2 90 11 	movw   $0x8,-0x3fee6f3e(,%eax,8)
c010196f:	c0 08 00 
c0101972:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101975:	0f b6 14 c5 c4 90 11 	movzbl -0x3fee6f3c(,%eax,8),%edx
c010197c:	c0 
c010197d:	83 e2 e0             	and    $0xffffffe0,%edx
c0101980:	88 14 c5 c4 90 11 c0 	mov    %dl,-0x3fee6f3c(,%eax,8)
c0101987:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198a:	0f b6 14 c5 c4 90 11 	movzbl -0x3fee6f3c(,%eax,8),%edx
c0101991:	c0 
c0101992:	83 e2 1f             	and    $0x1f,%edx
c0101995:	88 14 c5 c4 90 11 c0 	mov    %dl,-0x3fee6f3c(,%eax,8)
c010199c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010199f:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019a6:	c0 
c01019a7:	83 e2 f0             	and    $0xfffffff0,%edx
c01019aa:	83 ca 0e             	or     $0xe,%edx
c01019ad:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b7:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019be:	c0 
c01019bf:	83 e2 ef             	and    $0xffffffef,%edx
c01019c2:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019cc:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019d3:	c0 
c01019d4:	83 e2 9f             	and    $0xffffff9f,%edx
c01019d7:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e1:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019e8:	c0 
c01019e9:	83 ca 80             	or     $0xffffff80,%edx
c01019ec:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f6:	8b 04 85 00 86 11 c0 	mov    -0x3fee7a00(,%eax,4),%eax
c01019fd:	c1 e8 10             	shr    $0x10,%eax
c0101a00:	89 c2                	mov    %eax,%edx
c0101a02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a05:	66 89 14 c5 c6 90 11 	mov    %dx,-0x3fee6f3a(,%eax,8)
c0101a0c:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];

	int i;
	for (i=0;i<256;i++)
c0101a0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a11:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a18:	0f 8e 30 ff ff ff    	jle    c010194e <idt_init+0x12>
		SETGATE(idt[i], 0, 8, __vectors[i], 0);
	SETGATE(idt[T_SYSCALL], 1, 8, __vectors[T_SYSCALL], 3);
c0101a1e:	a1 00 88 11 c0       	mov    0xc0118800,%eax
c0101a23:	66 a3 c0 94 11 c0    	mov    %ax,0xc01194c0
c0101a29:	66 c7 05 c2 94 11 c0 	movw   $0x8,0xc01194c2
c0101a30:	08 00 
c0101a32:	0f b6 05 c4 94 11 c0 	movzbl 0xc01194c4,%eax
c0101a39:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a3c:	a2 c4 94 11 c0       	mov    %al,0xc01194c4
c0101a41:	0f b6 05 c4 94 11 c0 	movzbl 0xc01194c4,%eax
c0101a48:	83 e0 1f             	and    $0x1f,%eax
c0101a4b:	a2 c4 94 11 c0       	mov    %al,0xc01194c4
c0101a50:	0f b6 05 c5 94 11 c0 	movzbl 0xc01194c5,%eax
c0101a57:	83 c8 0f             	or     $0xf,%eax
c0101a5a:	a2 c5 94 11 c0       	mov    %al,0xc01194c5
c0101a5f:	0f b6 05 c5 94 11 c0 	movzbl 0xc01194c5,%eax
c0101a66:	83 e0 ef             	and    $0xffffffef,%eax
c0101a69:	a2 c5 94 11 c0       	mov    %al,0xc01194c5
c0101a6e:	0f b6 05 c5 94 11 c0 	movzbl 0xc01194c5,%eax
c0101a75:	83 c8 60             	or     $0x60,%eax
c0101a78:	a2 c5 94 11 c0       	mov    %al,0xc01194c5
c0101a7d:	0f b6 05 c5 94 11 c0 	movzbl 0xc01194c5,%eax
c0101a84:	83 c8 80             	or     $0xffffff80,%eax
c0101a87:	a2 c5 94 11 c0       	mov    %al,0xc01194c5
c0101a8c:	a1 00 88 11 c0       	mov    0xc0118800,%eax
c0101a91:	c1 e8 10             	shr    $0x10,%eax
c0101a94:	66 a3 c6 94 11 c0    	mov    %ax,0xc01194c6
c0101a9a:	c7 45 f8 80 85 11 c0 	movl   $0xc0118580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101aa4:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101aa7:	c9                   	leave  
c0101aa8:	c3                   	ret    

c0101aa9 <trapname>:

static const char *
trapname(int trapno) {
c0101aa9:	55                   	push   %ebp
c0101aaa:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aaf:	83 f8 13             	cmp    $0x13,%eax
c0101ab2:	77 0c                	ja     c0101ac0 <trapname+0x17>
        return excnames[trapno];
c0101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab7:	8b 04 85 00 69 10 c0 	mov    -0x3fef9700(,%eax,4),%eax
c0101abe:	eb 18                	jmp    c0101ad8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ac0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ac4:	7e 0d                	jle    c0101ad3 <trapname+0x2a>
c0101ac6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101aca:	7f 07                	jg     c0101ad3 <trapname+0x2a>
        return "Hardware Interrupt";
c0101acc:	b8 aa 65 10 c0       	mov    $0xc01065aa,%eax
c0101ad1:	eb 05                	jmp    c0101ad8 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101ad3:	b8 bd 65 10 c0       	mov    $0xc01065bd,%eax
}
c0101ad8:	5d                   	pop    %ebp
c0101ad9:	c3                   	ret    

c0101ada <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ada:	55                   	push   %ebp
c0101adb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101add:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ae4:	66 83 f8 08          	cmp    $0x8,%ax
c0101ae8:	0f 94 c0             	sete   %al
c0101aeb:	0f b6 c0             	movzbl %al,%eax
}
c0101aee:	5d                   	pop    %ebp
c0101aef:	c3                   	ret    

c0101af0 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101af0:	55                   	push   %ebp
c0101af1:	89 e5                	mov    %esp,%ebp
c0101af3:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101afd:	c7 04 24 fe 65 10 c0 	movl   $0xc01065fe,(%esp)
c0101b04:	e8 3e e8 ff ff       	call   c0100347 <cprintf>
    print_regs(&tf->tf_regs);
c0101b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0c:	89 04 24             	mov    %eax,(%esp)
c0101b0f:	e8 a1 01 00 00       	call   c0101cb5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b17:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b1b:	0f b7 c0             	movzwl %ax,%eax
c0101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b22:	c7 04 24 0f 66 10 c0 	movl   $0xc010660f,(%esp)
c0101b29:	e8 19 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b35:	0f b7 c0             	movzwl %ax,%eax
c0101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b3c:	c7 04 24 22 66 10 c0 	movl   $0xc0106622,(%esp)
c0101b43:	e8 ff e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b4f:	0f b7 c0             	movzwl %ax,%eax
c0101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b56:	c7 04 24 35 66 10 c0 	movl   $0xc0106635,(%esp)
c0101b5d:	e8 e5 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b65:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b69:	0f b7 c0             	movzwl %ax,%eax
c0101b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b70:	c7 04 24 48 66 10 c0 	movl   $0xc0106648,(%esp)
c0101b77:	e8 cb e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7f:	8b 40 30             	mov    0x30(%eax),%eax
c0101b82:	89 04 24             	mov    %eax,(%esp)
c0101b85:	e8 1f ff ff ff       	call   c0101aa9 <trapname>
c0101b8a:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b8d:	8b 52 30             	mov    0x30(%edx),%edx
c0101b90:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b94:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b98:	c7 04 24 5b 66 10 c0 	movl   $0xc010665b,(%esp)
c0101b9f:	e8 a3 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba7:	8b 40 34             	mov    0x34(%eax),%eax
c0101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bae:	c7 04 24 6d 66 10 c0 	movl   $0xc010666d,(%esp)
c0101bb5:	e8 8d e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbd:	8b 40 38             	mov    0x38(%eax),%eax
c0101bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc4:	c7 04 24 7c 66 10 c0 	movl   $0xc010667c,(%esp)
c0101bcb:	e8 77 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bd7:	0f b7 c0             	movzwl %ax,%eax
c0101bda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bde:	c7 04 24 8b 66 10 c0 	movl   $0xc010668b,(%esp)
c0101be5:	e8 5d e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bea:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bed:	8b 40 40             	mov    0x40(%eax),%eax
c0101bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf4:	c7 04 24 9e 66 10 c0 	movl   $0xc010669e,(%esp)
c0101bfb:	e8 47 e7 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c07:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c0e:	eb 3e                	jmp    c0101c4e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c13:	8b 50 40             	mov    0x40(%eax),%edx
c0101c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c19:	21 d0                	and    %edx,%eax
c0101c1b:	85 c0                	test   %eax,%eax
c0101c1d:	74 28                	je     c0101c47 <print_trapframe+0x157>
c0101c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c22:	8b 04 85 a0 85 11 c0 	mov    -0x3fee7a60(,%eax,4),%eax
c0101c29:	85 c0                	test   %eax,%eax
c0101c2b:	74 1a                	je     c0101c47 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c30:	8b 04 85 a0 85 11 c0 	mov    -0x3fee7a60(,%eax,4),%eax
c0101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3b:	c7 04 24 ad 66 10 c0 	movl   $0xc01066ad,(%esp)
c0101c42:	e8 00 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c47:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c4b:	d1 65 f0             	shll   -0x10(%ebp)
c0101c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c51:	83 f8 17             	cmp    $0x17,%eax
c0101c54:	76 ba                	jbe    c0101c10 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c59:	8b 40 40             	mov    0x40(%eax),%eax
c0101c5c:	25 00 30 00 00       	and    $0x3000,%eax
c0101c61:	c1 e8 0c             	shr    $0xc,%eax
c0101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c68:	c7 04 24 b1 66 10 c0 	movl   $0xc01066b1,(%esp)
c0101c6f:	e8 d3 e6 ff ff       	call   c0100347 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c77:	89 04 24             	mov    %eax,(%esp)
c0101c7a:	e8 5b fe ff ff       	call   c0101ada <trap_in_kernel>
c0101c7f:	85 c0                	test   %eax,%eax
c0101c81:	75 30                	jne    c0101cb3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c86:	8b 40 44             	mov    0x44(%eax),%eax
c0101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8d:	c7 04 24 ba 66 10 c0 	movl   $0xc01066ba,(%esp)
c0101c94:	e8 ae e6 ff ff       	call   c0100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9c:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101ca0:	0f b7 c0             	movzwl %ax,%eax
c0101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca7:	c7 04 24 c9 66 10 c0 	movl   $0xc01066c9,(%esp)
c0101cae:	e8 94 e6 ff ff       	call   c0100347 <cprintf>
    }
}
c0101cb3:	c9                   	leave  
c0101cb4:	c3                   	ret    

c0101cb5 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101cb5:	55                   	push   %ebp
c0101cb6:	89 e5                	mov    %esp,%ebp
c0101cb8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbe:	8b 00                	mov    (%eax),%eax
c0101cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc4:	c7 04 24 dc 66 10 c0 	movl   $0xc01066dc,(%esp)
c0101ccb:	e8 77 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd3:	8b 40 04             	mov    0x4(%eax),%eax
c0101cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cda:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0101ce1:	e8 61 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce9:	8b 40 08             	mov    0x8(%eax),%eax
c0101cec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf0:	c7 04 24 fa 66 10 c0 	movl   $0xc01066fa,(%esp)
c0101cf7:	e8 4b e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cff:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d06:	c7 04 24 09 67 10 c0 	movl   $0xc0106709,(%esp)
c0101d0d:	e8 35 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d12:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d15:	8b 40 10             	mov    0x10(%eax),%eax
c0101d18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1c:	c7 04 24 18 67 10 c0 	movl   $0xc0106718,(%esp)
c0101d23:	e8 1f e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2b:	8b 40 14             	mov    0x14(%eax),%eax
c0101d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d32:	c7 04 24 27 67 10 c0 	movl   $0xc0106727,(%esp)
c0101d39:	e8 09 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d41:	8b 40 18             	mov    0x18(%eax),%eax
c0101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d48:	c7 04 24 36 67 10 c0 	movl   $0xc0106736,(%esp)
c0101d4f:	e8 f3 e5 ff ff       	call   c0100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d57:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5e:	c7 04 24 45 67 10 c0 	movl   $0xc0106745,(%esp)
c0101d65:	e8 dd e5 ff ff       	call   c0100347 <cprintf>
}
c0101d6a:	c9                   	leave  
c0101d6b:	c3                   	ret    

c0101d6c <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d6c:	55                   	push   %ebp
c0101d6d:	89 e5                	mov    %esp,%ebp
c0101d6f:	83 ec 28             	sub    $0x28,%esp
    char c;
    static int ticks;
    switch (tf->tf_trapno) {
c0101d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d75:	8b 40 30             	mov    0x30(%eax),%eax
c0101d78:	83 f8 2f             	cmp    $0x2f,%eax
c0101d7b:	77 1d                	ja     c0101d9a <trap_dispatch+0x2e>
c0101d7d:	83 f8 2e             	cmp    $0x2e,%eax
c0101d80:	0f 83 f2 00 00 00    	jae    c0101e78 <trap_dispatch+0x10c>
c0101d86:	83 f8 21             	cmp    $0x21,%eax
c0101d89:	74 73                	je     c0101dfe <trap_dispatch+0x92>
c0101d8b:	83 f8 24             	cmp    $0x24,%eax
c0101d8e:	74 48                	je     c0101dd8 <trap_dispatch+0x6c>
c0101d90:	83 f8 20             	cmp    $0x20,%eax
c0101d93:	74 13                	je     c0101da8 <trap_dispatch+0x3c>
c0101d95:	e9 a6 00 00 00       	jmp    c0101e40 <trap_dispatch+0xd4>
c0101d9a:	83 e8 78             	sub    $0x78,%eax
c0101d9d:	83 f8 01             	cmp    $0x1,%eax
c0101da0:	0f 87 9a 00 00 00    	ja     c0101e40 <trap_dispatch+0xd4>
c0101da6:	eb 7c                	jmp    c0101e24 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
c0101da8:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0101dad:	83 c0 01             	add    $0x1,%eax
c0101db0:	a3 c0 98 11 c0       	mov    %eax,0xc01198c0
		if (ticks==TICK_NUM)
c0101db5:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0101dba:	83 f8 64             	cmp    $0x64,%eax
c0101dbd:	75 14                	jne    c0101dd3 <trap_dispatch+0x67>
		{
			ticks=0;
c0101dbf:	c7 05 c0 98 11 c0 00 	movl   $0x0,0xc01198c0
c0101dc6:	00 00 00 
			print_ticks();
c0101dc9:	e8 52 fb ff ff       	call   c0101920 <print_ticks>
		}
        break;
c0101dce:	e9 a6 00 00 00       	jmp    c0101e79 <trap_dispatch+0x10d>
c0101dd3:	e9 a1 00 00 00       	jmp    c0101e79 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101dd8:	e8 ff f8 ff ff       	call   c01016dc <cons_getc>
c0101ddd:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101de0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101de4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101de8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101df0:	c7 04 24 54 67 10 c0 	movl   $0xc0106754,(%esp)
c0101df7:	e8 4b e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101dfc:	eb 7b                	jmp    c0101e79 <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dfe:	e8 d9 f8 ff ff       	call   c01016dc <cons_getc>
c0101e03:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e06:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e0a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e0e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e16:	c7 04 24 66 67 10 c0 	movl   $0xc0106766,(%esp)
c0101e1d:	e8 25 e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101e22:	eb 55                	jmp    c0101e79 <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e24:	c7 44 24 08 75 67 10 	movl   $0xc0106775,0x8(%esp)
c0101e2b:	c0 
c0101e2c:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0101e33:	00 
c0101e34:	c7 04 24 85 67 10 c0 	movl   $0xc0106785,(%esp)
c0101e3b:	e8 80 ee ff ff       	call   c0100cc0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e47:	0f b7 c0             	movzwl %ax,%eax
c0101e4a:	83 e0 03             	and    $0x3,%eax
c0101e4d:	85 c0                	test   %eax,%eax
c0101e4f:	75 28                	jne    c0101e79 <trap_dispatch+0x10d>
            print_trapframe(tf);
c0101e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e54:	89 04 24             	mov    %eax,(%esp)
c0101e57:	e8 94 fc ff ff       	call   c0101af0 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e5c:	c7 44 24 08 96 67 10 	movl   $0xc0106796,0x8(%esp)
c0101e63:	c0 
c0101e64:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0101e6b:	00 
c0101e6c:	c7 04 24 85 67 10 c0 	movl   $0xc0106785,(%esp)
c0101e73:	e8 48 ee ff ff       	call   c0100cc0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e78:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e79:	c9                   	leave  
c0101e7a:	c3                   	ret    

c0101e7b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e7b:	55                   	push   %ebp
c0101e7c:	89 e5                	mov    %esp,%ebp
c0101e7e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e81:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e84:	89 04 24             	mov    %eax,(%esp)
c0101e87:	e8 e0 fe ff ff       	call   c0101d6c <trap_dispatch>
}
c0101e8c:	c9                   	leave  
c0101e8d:	c3                   	ret    
c0101e8e:	66 90                	xchg   %ax,%ax

c0101e90 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e90:	1e                   	push   %ds
    pushl %es
c0101e91:	06                   	push   %es
    pushl %fs
c0101e92:	0f a0                	push   %fs
    pushl %gs
c0101e94:	0f a8                	push   %gs
    pushal
c0101e96:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e97:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e9c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e9e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101ea0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101ea1:	e8 d5 ff ff ff       	call   c0101e7b <trap>

    # pop the pushed stack pointer
    popl %esp
c0101ea6:	5c                   	pop    %esp

c0101ea7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101ea7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101ea8:	0f a9                	pop    %gs
    popl %fs
c0101eaa:	0f a1                	pop    %fs
    popl %es
c0101eac:	07                   	pop    %es
    popl %ds
c0101ead:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101eae:	83 c4 08             	add    $0x8,%esp
    iret
c0101eb1:	cf                   	iret   
c0101eb2:	66 90                	xchg   %ax,%ax

c0101eb4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101eb4:	6a 00                	push   $0x0
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  jmp __alltraps
c0101eb8:	e9 d3 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ebd <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ebd:	6a 00                	push   $0x0
  pushl $1
c0101ebf:	6a 01                	push   $0x1
  jmp __alltraps
c0101ec1:	e9 ca ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ec6 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ec6:	6a 00                	push   $0x0
  pushl $2
c0101ec8:	6a 02                	push   $0x2
  jmp __alltraps
c0101eca:	e9 c1 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ecf <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ecf:	6a 00                	push   $0x0
  pushl $3
c0101ed1:	6a 03                	push   $0x3
  jmp __alltraps
c0101ed3:	e9 b8 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ed8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ed8:	6a 00                	push   $0x0
  pushl $4
c0101eda:	6a 04                	push   $0x4
  jmp __alltraps
c0101edc:	e9 af ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ee1 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  pushl $5
c0101ee3:	6a 05                	push   $0x5
  jmp __alltraps
c0101ee5:	e9 a6 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101eea <vector6>:
.globl vector6
vector6:
  pushl $0
c0101eea:	6a 00                	push   $0x0
  pushl $6
c0101eec:	6a 06                	push   $0x6
  jmp __alltraps
c0101eee:	e9 9d ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ef3 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $7
c0101ef5:	6a 07                	push   $0x7
  jmp __alltraps
c0101ef7:	e9 94 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101efc <vector8>:
.globl vector8
vector8:
  pushl $8
c0101efc:	6a 08                	push   $0x8
  jmp __alltraps
c0101efe:	e9 8d ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f03 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f03:	6a 09                	push   $0x9
  jmp __alltraps
c0101f05:	e9 86 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f0a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f0a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f0c:	e9 7f ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f11 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f11:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f13:	e9 78 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f18 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f18:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f1a:	e9 71 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f1f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f1f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f21:	e9 6a ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f26 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f26:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f28:	e9 63 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f2d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $15
c0101f2f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f31:	e9 5a ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f36 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $16
c0101f38:	6a 10                	push   $0x10
  jmp __alltraps
c0101f3a:	e9 51 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f3f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f3f:	6a 11                	push   $0x11
  jmp __alltraps
c0101f41:	e9 4a ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f46 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $18
c0101f48:	6a 12                	push   $0x12
  jmp __alltraps
c0101f4a:	e9 41 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f4f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $19
c0101f51:	6a 13                	push   $0x13
  jmp __alltraps
c0101f53:	e9 38 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f58 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $20
c0101f5a:	6a 14                	push   $0x14
  jmp __alltraps
c0101f5c:	e9 2f ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f61 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $21
c0101f63:	6a 15                	push   $0x15
  jmp __alltraps
c0101f65:	e9 26 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f6a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $22
c0101f6c:	6a 16                	push   $0x16
  jmp __alltraps
c0101f6e:	e9 1d ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f73 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $23
c0101f75:	6a 17                	push   $0x17
  jmp __alltraps
c0101f77:	e9 14 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f7c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $24
c0101f7e:	6a 18                	push   $0x18
  jmp __alltraps
c0101f80:	e9 0b ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f85 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $25
c0101f87:	6a 19                	push   $0x19
  jmp __alltraps
c0101f89:	e9 02 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f8e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $26
c0101f90:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f92:	e9 f9 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101f97 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $27
c0101f99:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f9b:	e9 f0 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fa0 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $28
c0101fa2:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fa4:	e9 e7 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fa9 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $29
c0101fab:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fad:	e9 de fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fb2 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $30
c0101fb4:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fb6:	e9 d5 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fbb <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $31
c0101fbd:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fbf:	e9 cc fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fc4 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $32
c0101fc6:	6a 20                	push   $0x20
  jmp __alltraps
c0101fc8:	e9 c3 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fcd <vector33>:
.globl vector33
vector33:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $33
c0101fcf:	6a 21                	push   $0x21
  jmp __alltraps
c0101fd1:	e9 ba fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fd6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $34
c0101fd8:	6a 22                	push   $0x22
  jmp __alltraps
c0101fda:	e9 b1 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fdf <vector35>:
.globl vector35
vector35:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $35
c0101fe1:	6a 23                	push   $0x23
  jmp __alltraps
c0101fe3:	e9 a8 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fe8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $36
c0101fea:	6a 24                	push   $0x24
  jmp __alltraps
c0101fec:	e9 9f fe ff ff       	jmp    c0101e90 <__alltraps>

c0101ff1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $37
c0101ff3:	6a 25                	push   $0x25
  jmp __alltraps
c0101ff5:	e9 96 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101ffa <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $38
c0101ffc:	6a 26                	push   $0x26
  jmp __alltraps
c0101ffe:	e9 8d fe ff ff       	jmp    c0101e90 <__alltraps>

c0102003 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $39
c0102005:	6a 27                	push   $0x27
  jmp __alltraps
c0102007:	e9 84 fe ff ff       	jmp    c0101e90 <__alltraps>

c010200c <vector40>:
.globl vector40
vector40:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $40
c010200e:	6a 28                	push   $0x28
  jmp __alltraps
c0102010:	e9 7b fe ff ff       	jmp    c0101e90 <__alltraps>

c0102015 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $41
c0102017:	6a 29                	push   $0x29
  jmp __alltraps
c0102019:	e9 72 fe ff ff       	jmp    c0101e90 <__alltraps>

c010201e <vector42>:
.globl vector42
vector42:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $42
c0102020:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102022:	e9 69 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102027 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $43
c0102029:	6a 2b                	push   $0x2b
  jmp __alltraps
c010202b:	e9 60 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102030 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $44
c0102032:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102034:	e9 57 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102039 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $45
c010203b:	6a 2d                	push   $0x2d
  jmp __alltraps
c010203d:	e9 4e fe ff ff       	jmp    c0101e90 <__alltraps>

c0102042 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $46
c0102044:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102046:	e9 45 fe ff ff       	jmp    c0101e90 <__alltraps>

c010204b <vector47>:
.globl vector47
vector47:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $47
c010204d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010204f:	e9 3c fe ff ff       	jmp    c0101e90 <__alltraps>

c0102054 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $48
c0102056:	6a 30                	push   $0x30
  jmp __alltraps
c0102058:	e9 33 fe ff ff       	jmp    c0101e90 <__alltraps>

c010205d <vector49>:
.globl vector49
vector49:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $49
c010205f:	6a 31                	push   $0x31
  jmp __alltraps
c0102061:	e9 2a fe ff ff       	jmp    c0101e90 <__alltraps>

c0102066 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $50
c0102068:	6a 32                	push   $0x32
  jmp __alltraps
c010206a:	e9 21 fe ff ff       	jmp    c0101e90 <__alltraps>

c010206f <vector51>:
.globl vector51
vector51:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $51
c0102071:	6a 33                	push   $0x33
  jmp __alltraps
c0102073:	e9 18 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102078 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $52
c010207a:	6a 34                	push   $0x34
  jmp __alltraps
c010207c:	e9 0f fe ff ff       	jmp    c0101e90 <__alltraps>

c0102081 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $53
c0102083:	6a 35                	push   $0x35
  jmp __alltraps
c0102085:	e9 06 fe ff ff       	jmp    c0101e90 <__alltraps>

c010208a <vector54>:
.globl vector54
vector54:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $54
c010208c:	6a 36                	push   $0x36
  jmp __alltraps
c010208e:	e9 fd fd ff ff       	jmp    c0101e90 <__alltraps>

c0102093 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $55
c0102095:	6a 37                	push   $0x37
  jmp __alltraps
c0102097:	e9 f4 fd ff ff       	jmp    c0101e90 <__alltraps>

c010209c <vector56>:
.globl vector56
vector56:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $56
c010209e:	6a 38                	push   $0x38
  jmp __alltraps
c01020a0:	e9 eb fd ff ff       	jmp    c0101e90 <__alltraps>

c01020a5 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $57
c01020a7:	6a 39                	push   $0x39
  jmp __alltraps
c01020a9:	e9 e2 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020ae <vector58>:
.globl vector58
vector58:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $58
c01020b0:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020b2:	e9 d9 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020b7 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $59
c01020b9:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020bb:	e9 d0 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020c0 <vector60>:
.globl vector60
vector60:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $60
c01020c2:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020c4:	e9 c7 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020c9 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $61
c01020cb:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020cd:	e9 be fd ff ff       	jmp    c0101e90 <__alltraps>

c01020d2 <vector62>:
.globl vector62
vector62:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $62
c01020d4:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020d6:	e9 b5 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020db <vector63>:
.globl vector63
vector63:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $63
c01020dd:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020df:	e9 ac fd ff ff       	jmp    c0101e90 <__alltraps>

c01020e4 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $64
c01020e6:	6a 40                	push   $0x40
  jmp __alltraps
c01020e8:	e9 a3 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020ed <vector65>:
.globl vector65
vector65:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $65
c01020ef:	6a 41                	push   $0x41
  jmp __alltraps
c01020f1:	e9 9a fd ff ff       	jmp    c0101e90 <__alltraps>

c01020f6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $66
c01020f8:	6a 42                	push   $0x42
  jmp __alltraps
c01020fa:	e9 91 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020ff <vector67>:
.globl vector67
vector67:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $67
c0102101:	6a 43                	push   $0x43
  jmp __alltraps
c0102103:	e9 88 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102108 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $68
c010210a:	6a 44                	push   $0x44
  jmp __alltraps
c010210c:	e9 7f fd ff ff       	jmp    c0101e90 <__alltraps>

c0102111 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $69
c0102113:	6a 45                	push   $0x45
  jmp __alltraps
c0102115:	e9 76 fd ff ff       	jmp    c0101e90 <__alltraps>

c010211a <vector70>:
.globl vector70
vector70:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $70
c010211c:	6a 46                	push   $0x46
  jmp __alltraps
c010211e:	e9 6d fd ff ff       	jmp    c0101e90 <__alltraps>

c0102123 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $71
c0102125:	6a 47                	push   $0x47
  jmp __alltraps
c0102127:	e9 64 fd ff ff       	jmp    c0101e90 <__alltraps>

c010212c <vector72>:
.globl vector72
vector72:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $72
c010212e:	6a 48                	push   $0x48
  jmp __alltraps
c0102130:	e9 5b fd ff ff       	jmp    c0101e90 <__alltraps>

c0102135 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $73
c0102137:	6a 49                	push   $0x49
  jmp __alltraps
c0102139:	e9 52 fd ff ff       	jmp    c0101e90 <__alltraps>

c010213e <vector74>:
.globl vector74
vector74:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $74
c0102140:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102142:	e9 49 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102147 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $75
c0102149:	6a 4b                	push   $0x4b
  jmp __alltraps
c010214b:	e9 40 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102150 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $76
c0102152:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102154:	e9 37 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102159 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $77
c010215b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010215d:	e9 2e fd ff ff       	jmp    c0101e90 <__alltraps>

c0102162 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $78
c0102164:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102166:	e9 25 fd ff ff       	jmp    c0101e90 <__alltraps>

c010216b <vector79>:
.globl vector79
vector79:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $79
c010216d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010216f:	e9 1c fd ff ff       	jmp    c0101e90 <__alltraps>

c0102174 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $80
c0102176:	6a 50                	push   $0x50
  jmp __alltraps
c0102178:	e9 13 fd ff ff       	jmp    c0101e90 <__alltraps>

c010217d <vector81>:
.globl vector81
vector81:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $81
c010217f:	6a 51                	push   $0x51
  jmp __alltraps
c0102181:	e9 0a fd ff ff       	jmp    c0101e90 <__alltraps>

c0102186 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $82
c0102188:	6a 52                	push   $0x52
  jmp __alltraps
c010218a:	e9 01 fd ff ff       	jmp    c0101e90 <__alltraps>

c010218f <vector83>:
.globl vector83
vector83:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $83
c0102191:	6a 53                	push   $0x53
  jmp __alltraps
c0102193:	e9 f8 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102198 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $84
c010219a:	6a 54                	push   $0x54
  jmp __alltraps
c010219c:	e9 ef fc ff ff       	jmp    c0101e90 <__alltraps>

c01021a1 <vector85>:
.globl vector85
vector85:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $85
c01021a3:	6a 55                	push   $0x55
  jmp __alltraps
c01021a5:	e9 e6 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021aa <vector86>:
.globl vector86
vector86:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $86
c01021ac:	6a 56                	push   $0x56
  jmp __alltraps
c01021ae:	e9 dd fc ff ff       	jmp    c0101e90 <__alltraps>

c01021b3 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $87
c01021b5:	6a 57                	push   $0x57
  jmp __alltraps
c01021b7:	e9 d4 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021bc <vector88>:
.globl vector88
vector88:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $88
c01021be:	6a 58                	push   $0x58
  jmp __alltraps
c01021c0:	e9 cb fc ff ff       	jmp    c0101e90 <__alltraps>

c01021c5 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $89
c01021c7:	6a 59                	push   $0x59
  jmp __alltraps
c01021c9:	e9 c2 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021ce <vector90>:
.globl vector90
vector90:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $90
c01021d0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021d2:	e9 b9 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021d7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $91
c01021d9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021db:	e9 b0 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021e0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $92
c01021e2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021e4:	e9 a7 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021e9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $93
c01021eb:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021ed:	e9 9e fc ff ff       	jmp    c0101e90 <__alltraps>

c01021f2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $94
c01021f4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021f6:	e9 95 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021fb <vector95>:
.globl vector95
vector95:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $95
c01021fd:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021ff:	e9 8c fc ff ff       	jmp    c0101e90 <__alltraps>

c0102204 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $96
c0102206:	6a 60                	push   $0x60
  jmp __alltraps
c0102208:	e9 83 fc ff ff       	jmp    c0101e90 <__alltraps>

c010220d <vector97>:
.globl vector97
vector97:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $97
c010220f:	6a 61                	push   $0x61
  jmp __alltraps
c0102211:	e9 7a fc ff ff       	jmp    c0101e90 <__alltraps>

c0102216 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $98
c0102218:	6a 62                	push   $0x62
  jmp __alltraps
c010221a:	e9 71 fc ff ff       	jmp    c0101e90 <__alltraps>

c010221f <vector99>:
.globl vector99
vector99:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $99
c0102221:	6a 63                	push   $0x63
  jmp __alltraps
c0102223:	e9 68 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102228 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $100
c010222a:	6a 64                	push   $0x64
  jmp __alltraps
c010222c:	e9 5f fc ff ff       	jmp    c0101e90 <__alltraps>

c0102231 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $101
c0102233:	6a 65                	push   $0x65
  jmp __alltraps
c0102235:	e9 56 fc ff ff       	jmp    c0101e90 <__alltraps>

c010223a <vector102>:
.globl vector102
vector102:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $102
c010223c:	6a 66                	push   $0x66
  jmp __alltraps
c010223e:	e9 4d fc ff ff       	jmp    c0101e90 <__alltraps>

c0102243 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $103
c0102245:	6a 67                	push   $0x67
  jmp __alltraps
c0102247:	e9 44 fc ff ff       	jmp    c0101e90 <__alltraps>

c010224c <vector104>:
.globl vector104
vector104:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $104
c010224e:	6a 68                	push   $0x68
  jmp __alltraps
c0102250:	e9 3b fc ff ff       	jmp    c0101e90 <__alltraps>

c0102255 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $105
c0102257:	6a 69                	push   $0x69
  jmp __alltraps
c0102259:	e9 32 fc ff ff       	jmp    c0101e90 <__alltraps>

c010225e <vector106>:
.globl vector106
vector106:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $106
c0102260:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102262:	e9 29 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102267 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $107
c0102269:	6a 6b                	push   $0x6b
  jmp __alltraps
c010226b:	e9 20 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102270 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $108
c0102272:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102274:	e9 17 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102279 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $109
c010227b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010227d:	e9 0e fc ff ff       	jmp    c0101e90 <__alltraps>

c0102282 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $110
c0102284:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102286:	e9 05 fc ff ff       	jmp    c0101e90 <__alltraps>

c010228b <vector111>:
.globl vector111
vector111:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $111
c010228d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010228f:	e9 fc fb ff ff       	jmp    c0101e90 <__alltraps>

c0102294 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $112
c0102296:	6a 70                	push   $0x70
  jmp __alltraps
c0102298:	e9 f3 fb ff ff       	jmp    c0101e90 <__alltraps>

c010229d <vector113>:
.globl vector113
vector113:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $113
c010229f:	6a 71                	push   $0x71
  jmp __alltraps
c01022a1:	e9 ea fb ff ff       	jmp    c0101e90 <__alltraps>

c01022a6 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $114
c01022a8:	6a 72                	push   $0x72
  jmp __alltraps
c01022aa:	e9 e1 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022af <vector115>:
.globl vector115
vector115:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $115
c01022b1:	6a 73                	push   $0x73
  jmp __alltraps
c01022b3:	e9 d8 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022b8 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $116
c01022ba:	6a 74                	push   $0x74
  jmp __alltraps
c01022bc:	e9 cf fb ff ff       	jmp    c0101e90 <__alltraps>

c01022c1 <vector117>:
.globl vector117
vector117:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $117
c01022c3:	6a 75                	push   $0x75
  jmp __alltraps
c01022c5:	e9 c6 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022ca <vector118>:
.globl vector118
vector118:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $118
c01022cc:	6a 76                	push   $0x76
  jmp __alltraps
c01022ce:	e9 bd fb ff ff       	jmp    c0101e90 <__alltraps>

c01022d3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $119
c01022d5:	6a 77                	push   $0x77
  jmp __alltraps
c01022d7:	e9 b4 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022dc <vector120>:
.globl vector120
vector120:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $120
c01022de:	6a 78                	push   $0x78
  jmp __alltraps
c01022e0:	e9 ab fb ff ff       	jmp    c0101e90 <__alltraps>

c01022e5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $121
c01022e7:	6a 79                	push   $0x79
  jmp __alltraps
c01022e9:	e9 a2 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022ee <vector122>:
.globl vector122
vector122:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $122
c01022f0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022f2:	e9 99 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022f7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $123
c01022f9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022fb:	e9 90 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102300 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $124
c0102302:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102304:	e9 87 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102309 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $125
c010230b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010230d:	e9 7e fb ff ff       	jmp    c0101e90 <__alltraps>

c0102312 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $126
c0102314:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102316:	e9 75 fb ff ff       	jmp    c0101e90 <__alltraps>

c010231b <vector127>:
.globl vector127
vector127:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $127
c010231d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010231f:	e9 6c fb ff ff       	jmp    c0101e90 <__alltraps>

c0102324 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $128
c0102326:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010232b:	e9 60 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102330 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $129
c0102332:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102337:	e9 54 fb ff ff       	jmp    c0101e90 <__alltraps>

c010233c <vector130>:
.globl vector130
vector130:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $130
c010233e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102343:	e9 48 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102348 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $131
c010234a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010234f:	e9 3c fb ff ff       	jmp    c0101e90 <__alltraps>

c0102354 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $132
c0102356:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010235b:	e9 30 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102360 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $133
c0102362:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102367:	e9 24 fb ff ff       	jmp    c0101e90 <__alltraps>

c010236c <vector134>:
.globl vector134
vector134:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $134
c010236e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102373:	e9 18 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102378 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $135
c010237a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010237f:	e9 0c fb ff ff       	jmp    c0101e90 <__alltraps>

c0102384 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $136
c0102386:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010238b:	e9 00 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102390 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $137
c0102392:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102397:	e9 f4 fa ff ff       	jmp    c0101e90 <__alltraps>

c010239c <vector138>:
.globl vector138
vector138:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $138
c010239e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023a3:	e9 e8 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023a8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $139
c01023aa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023af:	e9 dc fa ff ff       	jmp    c0101e90 <__alltraps>

c01023b4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $140
c01023b6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023bb:	e9 d0 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023c0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $141
c01023c2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023c7:	e9 c4 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023cc <vector142>:
.globl vector142
vector142:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $142
c01023ce:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023d3:	e9 b8 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023d8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $143
c01023da:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023df:	e9 ac fa ff ff       	jmp    c0101e90 <__alltraps>

c01023e4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $144
c01023e6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023eb:	e9 a0 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023f0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $145
c01023f2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023f7:	e9 94 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023fc <vector146>:
.globl vector146
vector146:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $146
c01023fe:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102403:	e9 88 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102408 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $147
c010240a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010240f:	e9 7c fa ff ff       	jmp    c0101e90 <__alltraps>

c0102414 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $148
c0102416:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010241b:	e9 70 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102420 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $149
c0102422:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102427:	e9 64 fa ff ff       	jmp    c0101e90 <__alltraps>

c010242c <vector150>:
.globl vector150
vector150:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $150
c010242e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102433:	e9 58 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102438 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $151
c010243a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010243f:	e9 4c fa ff ff       	jmp    c0101e90 <__alltraps>

c0102444 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $152
c0102446:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010244b:	e9 40 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102450 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $153
c0102452:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102457:	e9 34 fa ff ff       	jmp    c0101e90 <__alltraps>

c010245c <vector154>:
.globl vector154
vector154:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $154
c010245e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102463:	e9 28 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102468 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $155
c010246a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010246f:	e9 1c fa ff ff       	jmp    c0101e90 <__alltraps>

c0102474 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $156
c0102476:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010247b:	e9 10 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102480 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $157
c0102482:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102487:	e9 04 fa ff ff       	jmp    c0101e90 <__alltraps>

c010248c <vector158>:
.globl vector158
vector158:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $158
c010248e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102493:	e9 f8 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102498 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $159
c010249a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010249f:	e9 ec f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024a4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $160
c01024a6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024ab:	e9 e0 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024b0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $161
c01024b2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024b7:	e9 d4 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024bc <vector162>:
.globl vector162
vector162:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $162
c01024be:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024c3:	e9 c8 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024c8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $163
c01024ca:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024cf:	e9 bc f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024d4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $164
c01024d6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024db:	e9 b0 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024e0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $165
c01024e2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024e7:	e9 a4 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024ec <vector166>:
.globl vector166
vector166:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $166
c01024ee:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024f3:	e9 98 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024f8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $167
c01024fa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024ff:	e9 8c f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102504 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $168
c0102506:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010250b:	e9 80 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102510 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $169
c0102512:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102517:	e9 74 f9 ff ff       	jmp    c0101e90 <__alltraps>

c010251c <vector170>:
.globl vector170
vector170:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $170
c010251e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102523:	e9 68 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102528 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $171
c010252a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010252f:	e9 5c f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102534 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $172
c0102536:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010253b:	e9 50 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102540 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $173
c0102542:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102547:	e9 44 f9 ff ff       	jmp    c0101e90 <__alltraps>

c010254c <vector174>:
.globl vector174
vector174:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $174
c010254e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102553:	e9 38 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102558 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $175
c010255a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010255f:	e9 2c f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102564 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $176
c0102566:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010256b:	e9 20 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102570 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $177
c0102572:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102577:	e9 14 f9 ff ff       	jmp    c0101e90 <__alltraps>

c010257c <vector178>:
.globl vector178
vector178:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $178
c010257e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102583:	e9 08 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102588 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $179
c010258a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010258f:	e9 fc f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102594 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $180
c0102596:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010259b:	e9 f0 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025a0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $181
c01025a2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025a7:	e9 e4 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025ac <vector182>:
.globl vector182
vector182:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $182
c01025ae:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025b3:	e9 d8 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025b8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $183
c01025ba:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025bf:	e9 cc f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025c4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $184
c01025c6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025cb:	e9 c0 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025d0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $185
c01025d2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025d7:	e9 b4 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025dc <vector186>:
.globl vector186
vector186:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $186
c01025de:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025e3:	e9 a8 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025e8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $187
c01025ea:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025ef:	e9 9c f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025f4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $188
c01025f6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025fb:	e9 90 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102600 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $189
c0102602:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102607:	e9 84 f8 ff ff       	jmp    c0101e90 <__alltraps>

c010260c <vector190>:
.globl vector190
vector190:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $190
c010260e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102613:	e9 78 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102618 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $191
c010261a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010261f:	e9 6c f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102624 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $192
c0102626:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010262b:	e9 60 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102630 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $193
c0102632:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102637:	e9 54 f8 ff ff       	jmp    c0101e90 <__alltraps>

c010263c <vector194>:
.globl vector194
vector194:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $194
c010263e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102643:	e9 48 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102648 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $195
c010264a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010264f:	e9 3c f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102654 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $196
c0102656:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010265b:	e9 30 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102660 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $197
c0102662:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102667:	e9 24 f8 ff ff       	jmp    c0101e90 <__alltraps>

c010266c <vector198>:
.globl vector198
vector198:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $198
c010266e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102673:	e9 18 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102678 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $199
c010267a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010267f:	e9 0c f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102684 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $200
c0102686:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010268b:	e9 00 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102690 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $201
c0102692:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102697:	e9 f4 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010269c <vector202>:
.globl vector202
vector202:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $202
c010269e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026a3:	e9 e8 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026a8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $203
c01026aa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026af:	e9 dc f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026b4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $204
c01026b6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026bb:	e9 d0 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026c0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $205
c01026c2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026c7:	e9 c4 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026cc <vector206>:
.globl vector206
vector206:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $206
c01026ce:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026d3:	e9 b8 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026d8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $207
c01026da:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026df:	e9 ac f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026e4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $208
c01026e6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026eb:	e9 a0 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026f0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $209
c01026f2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026f7:	e9 94 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026fc <vector210>:
.globl vector210
vector210:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $210
c01026fe:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102703:	e9 88 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102708 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $211
c010270a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010270f:	e9 7c f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102714 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $212
c0102716:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010271b:	e9 70 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102720 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $213
c0102722:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102727:	e9 64 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010272c <vector214>:
.globl vector214
vector214:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $214
c010272e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102733:	e9 58 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102738 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $215
c010273a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010273f:	e9 4c f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102744 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $216
c0102746:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010274b:	e9 40 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102750 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $217
c0102752:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102757:	e9 34 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010275c <vector218>:
.globl vector218
vector218:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $218
c010275e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102763:	e9 28 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102768 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $219
c010276a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010276f:	e9 1c f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102774 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $220
c0102776:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010277b:	e9 10 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102780 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $221
c0102782:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102787:	e9 04 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010278c <vector222>:
.globl vector222
vector222:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $222
c010278e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102793:	e9 f8 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102798 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $223
c010279a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010279f:	e9 ec f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027a4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $224
c01027a6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027ab:	e9 e0 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027b0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $225
c01027b2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027b7:	e9 d4 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027bc <vector226>:
.globl vector226
vector226:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $226
c01027be:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027c3:	e9 c8 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027c8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $227
c01027ca:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027cf:	e9 bc f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027d4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $228
c01027d6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027db:	e9 b0 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027e0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $229
c01027e2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027e7:	e9 a4 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027ec <vector230>:
.globl vector230
vector230:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $230
c01027ee:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027f3:	e9 98 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027f8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $231
c01027fa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027ff:	e9 8c f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102804 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $232
c0102806:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010280b:	e9 80 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102810 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $233
c0102812:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102817:	e9 74 f6 ff ff       	jmp    c0101e90 <__alltraps>

c010281c <vector234>:
.globl vector234
vector234:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $234
c010281e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102823:	e9 68 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102828 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $235
c010282a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010282f:	e9 5c f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102834 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $236
c0102836:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010283b:	e9 50 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102840 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $237
c0102842:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102847:	e9 44 f6 ff ff       	jmp    c0101e90 <__alltraps>

c010284c <vector238>:
.globl vector238
vector238:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $238
c010284e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102853:	e9 38 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102858 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $239
c010285a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010285f:	e9 2c f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102864 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $240
c0102866:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010286b:	e9 20 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102870 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $241
c0102872:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102877:	e9 14 f6 ff ff       	jmp    c0101e90 <__alltraps>

c010287c <vector242>:
.globl vector242
vector242:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $242
c010287e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102883:	e9 08 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102888 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $243
c010288a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010288f:	e9 fc f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102894 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $244
c0102896:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010289b:	e9 f0 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028a0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $245
c01028a2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028a7:	e9 e4 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028ac <vector246>:
.globl vector246
vector246:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $246
c01028ae:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028b3:	e9 d8 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028b8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $247
c01028ba:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028bf:	e9 cc f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028c4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $248
c01028c6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028cb:	e9 c0 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028d0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $249
c01028d2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028d7:	e9 b4 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028dc <vector250>:
.globl vector250
vector250:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $250
c01028de:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028e3:	e9 a8 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028e8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $251
c01028ea:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028ef:	e9 9c f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028f4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $252
c01028f6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028fb:	e9 90 f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102900 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $253
c0102902:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102907:	e9 84 f5 ff ff       	jmp    c0101e90 <__alltraps>

c010290c <vector254>:
.globl vector254
vector254:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $254
c010290e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102913:	e9 78 f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102918 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $255
c010291a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010291f:	e9 6c f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102924 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102924:	55                   	push   %ebp
c0102925:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102927:	8b 55 08             	mov    0x8(%ebp),%edx
c010292a:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c010292f:	29 c2                	sub    %eax,%edx
c0102931:	89 d0                	mov    %edx,%eax
c0102933:	c1 f8 02             	sar    $0x2,%eax
c0102936:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010293c:	5d                   	pop    %ebp
c010293d:	c3                   	ret    

c010293e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010293e:	55                   	push   %ebp
c010293f:	89 e5                	mov    %esp,%ebp
c0102941:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102944:	8b 45 08             	mov    0x8(%ebp),%eax
c0102947:	89 04 24             	mov    %eax,(%esp)
c010294a:	e8 d5 ff ff ff       	call   c0102924 <page2ppn>
c010294f:	c1 e0 0c             	shl    $0xc,%eax
}
c0102952:	c9                   	leave  
c0102953:	c3                   	ret    

c0102954 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102954:	55                   	push   %ebp
c0102955:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102957:	8b 45 08             	mov    0x8(%ebp),%eax
c010295a:	8b 00                	mov    (%eax),%eax
}
c010295c:	5d                   	pop    %ebp
c010295d:	c3                   	ret    

c010295e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010295e:	55                   	push   %ebp
c010295f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102961:	8b 45 08             	mov    0x8(%ebp),%eax
c0102964:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102967:	89 10                	mov    %edx,(%eax)
}
c0102969:	5d                   	pop    %ebp
c010296a:	c3                   	ret    

c010296b <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010296b:	55                   	push   %ebp
c010296c:	89 e5                	mov    %esp,%ebp
c010296e:	83 ec 10             	sub    $0x10,%esp
c0102971:	c7 45 fc 70 99 11 c0 	movl   $0xc0119970,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102978:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010297b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010297e:	89 50 04             	mov    %edx,0x4(%eax)
c0102981:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102984:	8b 50 04             	mov    0x4(%eax),%edx
c0102987:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010298a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010298c:	c7 05 78 99 11 c0 00 	movl   $0x0,0xc0119978
c0102993:	00 00 00 
}
c0102996:	c9                   	leave  
c0102997:	c3                   	ret    

c0102998 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102998:	55                   	push   %ebp
c0102999:	89 e5                	mov    %esp,%ebp
c010299b:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010299e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01029a2:	75 24                	jne    c01029c8 <default_init_memmap+0x30>
c01029a4:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c01029ab:	c0 
c01029ac:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01029b3:	c0 
c01029b4:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01029bb:	00 
c01029bc:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01029c3:	e8 f8 e2 ff ff       	call   c0100cc0 <__panic>
    struct Page *p = base;
c01029c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01029cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//cprintf("base=%x\n",base);
    for (; p != base + n; p ++) {
c01029ce:	eb 7d                	jmp    c0102a4d <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d3:	83 c0 04             	add    $0x4,%eax
c01029d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01029dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029e6:	0f a3 10             	bt     %edx,(%eax)
c01029e9:	19 c0                	sbb    %eax,%eax
c01029eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01029ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029f2:	0f 95 c0             	setne  %al
c01029f5:	0f b6 c0             	movzbl %al,%eax
c01029f8:	85 c0                	test   %eax,%eax
c01029fa:	75 24                	jne    c0102a20 <default_init_memmap+0x88>
c01029fc:	c7 44 24 0c 81 69 10 	movl   $0xc0106981,0xc(%esp)
c0102a03:	c0 
c0102a04:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102a0b:	c0 
c0102a0c:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c0102a13:	00 
c0102a14:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102a1b:	e8 a0 e2 ff ff       	call   c0100cc0 <__panic>
        p->flags = p->property = 0;
c0102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a2d:	8b 50 08             	mov    0x8(%eax),%edx
c0102a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a33:	89 50 04             	mov    %edx,0x4(%eax)
	//ClearPageProperty(p);
	//ClearPageReserved(p);  
	set_page_ref(p, 0);
c0102a36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a3d:	00 
c0102a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a41:	89 04 24             	mov    %eax,(%esp)
c0102a44:	e8 15 ff ff ff       	call   c010295e <set_page_ref>
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
//cprintf("base=%x\n",base);
    for (; p != base + n; p ++) {
c0102a49:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a50:	89 d0                	mov    %edx,%eax
c0102a52:	c1 e0 02             	shl    $0x2,%eax
c0102a55:	01 d0                	add    %edx,%eax
c0102a57:	c1 e0 02             	shl    $0x2,%eax
c0102a5a:	89 c2                	mov    %eax,%edx
c0102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5f:	01 d0                	add    %edx,%eax
c0102a61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a64:	0f 85 66 ff ff ff    	jne    c01029d0 <default_init_memmap+0x38>
	//ClearPageProperty(p);
	//ClearPageReserved(p);  
	set_page_ref(p, 0);
	
    }
    base->property = n;
c0102a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a70:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a76:	83 c0 04             	add    $0x4,%eax
c0102a79:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a80:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a89:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102a8c:	8b 15 78 99 11 c0    	mov    0xc0119978,%edx
c0102a92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a95:	01 d0                	add    %edx,%eax
c0102a97:	a3 78 99 11 c0       	mov    %eax,0xc0119978
    list_add_before(&free_list, &(base->page_link));
c0102a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a9f:	83 c0 0c             	add    $0xc,%eax
c0102aa2:	c7 45 dc 70 99 11 c0 	movl   $0xc0119970,-0x24(%ebp)
c0102aa9:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102aac:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102aaf:	8b 00                	mov    (%eax),%eax
c0102ab1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102ab4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102ab7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102aba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102abd:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ac0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ac3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ac6:	89 10                	mov    %edx,(%eax)
c0102ac8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102acb:	8b 10                	mov    (%eax),%edx
c0102acd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ad0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ad3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ad6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ad9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102adf:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102ae2:	89 10                	mov    %edx,(%eax)
}
c0102ae4:	c9                   	leave  
c0102ae5:	c3                   	ret    

c0102ae6 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102ae6:	55                   	push   %ebp
c0102ae7:	89 e5                	mov    %esp,%ebp
c0102ae9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102aec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102af0:	75 24                	jne    c0102b16 <default_alloc_pages+0x30>
c0102af2:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c0102af9:	c0 
c0102afa:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102b01:	c0 
c0102b02:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
c0102b09:	00 
c0102b0a:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102b11:	e8 aa e1 ff ff       	call   c0100cc0 <__panic>
    if (n > nr_free) {
c0102b16:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c0102b1b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b1e:	73 0a                	jae    c0102b2a <default_alloc_pages+0x44>
        return NULL;
c0102b20:	b8 00 00 00 00       	mov    $0x0,%eax
c0102b25:	e9 78 01 00 00       	jmp    c0102ca2 <default_alloc_pages+0x1bc>
    }
    struct Page *page = NULL;
c0102b2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102b31:	c7 45 f0 70 99 11 c0 	movl   $0xc0119970,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102b38:	eb 1c                	jmp    c0102b56 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b3d:	83 e8 0c             	sub    $0xc,%eax
c0102b40:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c0102b43:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b46:	8b 40 08             	mov    0x8(%eax),%eax
c0102b49:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b4c:	72 08                	jb     c0102b56 <default_alloc_pages+0x70>
            page = p;
c0102b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102b54:	eb 18                	jmp    c0102b6e <default_alloc_pages+0x88>
c0102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b5f:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102b65:	81 7d f0 70 99 11 c0 	cmpl   $0xc0119970,-0x10(%ebp)
c0102b6c:	75 cc                	jne    c0102b3a <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102b72:	0f 84 27 01 00 00    	je     c0102c9f <default_alloc_pages+0x1b9>
	struct Page *p=page;
c0102b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (;p!=page+n;p++)
c0102b7e:	eb 0e                	jmp    c0102b8e <default_alloc_pages+0xa8>
		p->flags=1;	
c0102b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b83:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
            break;
        }
    }
    if (page != NULL) {
	struct Page *p=page;
	for (;p!=page+n;p++)
c0102b8a:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102b8e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b91:	89 d0                	mov    %edx,%eax
c0102b93:	c1 e0 02             	shl    $0x2,%eax
c0102b96:	01 d0                	add    %edx,%eax
c0102b98:	c1 e0 02             	shl    $0x2,%eax
c0102b9b:	89 c2                	mov    %eax,%edx
c0102b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba0:	01 d0                	add    %edx,%eax
c0102ba2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102ba5:	75 d9                	jne    c0102b80 <default_alloc_pages+0x9a>
		p->flags=1;	
	
        if (page->property > n) {
c0102ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102baa:	8b 40 08             	mov    0x8(%eax),%eax
c0102bad:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bb0:	0f 86 98 00 00 00    	jbe    c0102c4e <default_alloc_pages+0x168>
            struct Page *p = page + n;
c0102bb6:	8b 55 08             	mov    0x8(%ebp),%edx
c0102bb9:	89 d0                	mov    %edx,%eax
c0102bbb:	c1 e0 02             	shl    $0x2,%eax
c0102bbe:	01 d0                	add    %edx,%eax
c0102bc0:	c1 e0 02             	shl    $0x2,%eax
c0102bc3:	89 c2                	mov    %eax,%edx
c0102bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc8:	01 d0                	add    %edx,%eax
c0102bca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            p->property = page->property - n;
c0102bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bd0:	8b 40 08             	mov    0x8(%eax),%eax
c0102bd3:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bd6:	89 c2                	mov    %eax,%edx
c0102bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bdb:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&(page->page_link), &(p->page_link));
c0102bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102be1:	83 c0 0c             	add    $0xc,%eax
c0102be4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102be7:	83 c2 0c             	add    $0xc,%edx
c0102bea:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102bed:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102bf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102bf3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102bf6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bf9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102bfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102bff:	8b 40 04             	mov    0x4(%eax),%eax
c0102c02:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c05:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102c08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c0b:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102c0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c14:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102c17:	89 10                	mov    %edx,(%eax)
c0102c19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c1c:	8b 10                	mov    (%eax),%edx
c0102c1e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c21:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c24:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c27:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102c2a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c30:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c33:	89 10                	mov    %edx,(%eax)
	    SetPageProperty(p);
c0102c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c38:	83 c0 04             	add    $0x4,%eax
c0102c3b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102c42:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102c45:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102c48:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102c4b:	0f ab 10             	bts    %edx,(%eax)
    	}
	list_del(&(page->page_link));
c0102c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c51:	83 c0 0c             	add    $0xc,%eax
c0102c54:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102c57:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102c5a:	8b 40 04             	mov    0x4(%eax),%eax
c0102c5d:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102c60:	8b 12                	mov    (%edx),%edx
c0102c62:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c0102c65:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102c68:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102c6b:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c6e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c71:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c74:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102c77:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102c79:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c0102c7e:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c81:	a3 78 99 11 c0       	mov    %eax,0xc0119978
        ClearPageProperty(page);
c0102c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c89:	83 c0 04             	add    $0x4,%eax
c0102c8c:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0102c93:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c96:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c99:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102c9c:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102ca2:	c9                   	leave  
c0102ca3:	c3                   	ret    

c0102ca4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102ca4:	55                   	push   %ebp
c0102ca5:	89 e5                	mov    %esp,%ebp
c0102ca7:	81 ec a8 00 00 00    	sub    $0xa8,%esp
    assert(n > 0);
c0102cad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102cb1:	75 24                	jne    c0102cd7 <default_free_pages+0x33>
c0102cb3:	c7 44 24 0c 50 69 10 	movl   $0xc0106950,0xc(%esp)
c0102cba:	c0 
c0102cbb:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102cc2:	c0 
c0102cc3:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0102cca:	00 
c0102ccb:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102cd2:	e8 e9 df ff ff       	call   c0100cc0 <__panic>
    struct Page *p = base;
c0102cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102cdd:	e9 9d 00 00 00       	jmp    c0102d7f <default_free_pages+0xdb>
        assert(PageReserved(p) && !PageProperty(p));
c0102ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce5:	83 c0 04             	add    $0x4,%eax
c0102ce8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0102cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cf5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102cf8:	0f a3 10             	bt     %edx,(%eax)
c0102cfb:	19 c0                	sbb    %eax,%eax
c0102cfd:	89 45 dc             	mov    %eax,-0x24(%ebp)
    return oldbit != 0;
c0102d00:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0102d04:	0f 95 c0             	setne  %al
c0102d07:	0f b6 c0             	movzbl %al,%eax
c0102d0a:	85 c0                	test   %eax,%eax
c0102d0c:	74 2c                	je     c0102d3a <default_free_pages+0x96>
c0102d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d11:	83 c0 04             	add    $0x4,%eax
c0102d14:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
c0102d1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102d1e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d21:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102d24:	0f a3 10             	bt     %edx,(%eax)
c0102d27:	19 c0                	sbb    %eax,%eax
c0102d29:	89 45 d0             	mov    %eax,-0x30(%ebp)
    return oldbit != 0;
c0102d2c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0102d30:	0f 95 c0             	setne  %al
c0102d33:	0f b6 c0             	movzbl %al,%eax
c0102d36:	85 c0                	test   %eax,%eax
c0102d38:	74 24                	je     c0102d5e <default_free_pages+0xba>
c0102d3a:	c7 44 24 0c 94 69 10 	movl   $0xc0106994,0xc(%esp)
c0102d41:	c0 
c0102d42:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0102d49:	c0 
c0102d4a:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0102d51:	00 
c0102d52:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0102d59:	e8 62 df ff ff       	call   c0100cc0 <__panic>
        p->flags = 0;
c0102d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102d68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d6f:	00 
c0102d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d73:	89 04 24             	mov    %eax,(%esp)
c0102d76:	e8 e3 fb ff ff       	call   c010295e <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102d7b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d82:	89 d0                	mov    %edx,%eax
c0102d84:	c1 e0 02             	shl    $0x2,%eax
c0102d87:	01 d0                	add    %edx,%eax
c0102d89:	c1 e0 02             	shl    $0x2,%eax
c0102d8c:	89 c2                	mov    %eax,%edx
c0102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d91:	01 d0                	add    %edx,%eax
c0102d93:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d96:	0f 85 46 ff ff ff    	jne    c0102ce2 <default_free_pages+0x3e>
        assert(PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d9f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102da2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da8:	83 c0 04             	add    $0x4,%eax
c0102dab:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102db2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102db5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102db8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102dbb:	0f ab 10             	bts    %edx,(%eax)
c0102dbe:	c7 45 c4 70 99 11 c0 	movl   $0xc0119970,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102dc5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102dc8:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102dcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102dce:	e9 08 01 00 00       	jmp    c0102edb <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd6:	83 e8 0c             	sub    $0xc,%eax
c0102dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ddf:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0102de2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102de5:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dee:	8b 50 08             	mov    0x8(%eax),%edx
c0102df1:	89 d0                	mov    %edx,%eax
c0102df3:	c1 e0 02             	shl    $0x2,%eax
c0102df6:	01 d0                	add    %edx,%eax
c0102df8:	c1 e0 02             	shl    $0x2,%eax
c0102dfb:	89 c2                	mov    %eax,%edx
c0102dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e00:	01 d0                	add    %edx,%eax
c0102e02:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e05:	75 5a                	jne    c0102e61 <default_free_pages+0x1bd>
            base->property += p->property;
c0102e07:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0a:	8b 50 08             	mov    0x8(%eax),%edx
c0102e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e10:	8b 40 08             	mov    0x8(%eax),%eax
c0102e13:	01 c2                	add    %eax,%edx
c0102e15:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e18:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e1e:	83 c0 04             	add    $0x4,%eax
c0102e21:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0102e28:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e31:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e37:	83 c0 0c             	add    $0xc,%eax
c0102e3a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e3d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e40:	8b 40 04             	mov    0x4(%eax),%eax
c0102e43:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e46:	8b 12                	mov    (%edx),%edx
c0102e48:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0102e4b:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e4e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e51:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102e54:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e57:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e5a:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e5d:	89 10                	mov    %edx,(%eax)
c0102e5f:	eb 7a                	jmp    c0102edb <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e64:	8b 50 08             	mov    0x8(%eax),%edx
c0102e67:	89 d0                	mov    %edx,%eax
c0102e69:	c1 e0 02             	shl    $0x2,%eax
c0102e6c:	01 d0                	add    %edx,%eax
c0102e6e:	c1 e0 02             	shl    $0x2,%eax
c0102e71:	89 c2                	mov    %eax,%edx
c0102e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e76:	01 d0                	add    %edx,%eax
c0102e78:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e7b:	75 5e                	jne    c0102edb <default_free_pages+0x237>
            p->property += base->property;
c0102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e80:	8b 50 08             	mov    0x8(%eax),%edx
c0102e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e86:	8b 40 08             	mov    0x8(%eax),%eax
c0102e89:	01 c2                	add    %eax,%edx
c0102e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e8e:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e94:	83 c0 04             	add    $0x4,%eax
c0102e97:	c7 45 a8 01 00 00 00 	movl   $0x1,-0x58(%ebp)
c0102e9e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102ea1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102ea4:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102ea7:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ead:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb3:	83 c0 0c             	add    $0xc,%eax
c0102eb6:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102eb9:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102ebc:	8b 40 04             	mov    0x4(%eax),%eax
c0102ebf:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102ec2:	8b 12                	mov    (%edx),%edx
c0102ec4:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0102ec7:	89 45 98             	mov    %eax,-0x68(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102eca:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102ecd:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102ed0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102ed3:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102ed6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102ed9:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102edb:	81 7d f0 70 99 11 c0 	cmpl   $0xc0119970,-0x10(%ebp)
c0102ee2:	0f 85 eb fe ff ff    	jne    c0102dd3 <default_free_pages+0x12f>
            base = p;
            list_del(&(p->page_link));
        }
    }

    nr_free += n;
c0102ee8:	8b 15 78 99 11 c0    	mov    0xc0119978,%edx
c0102eee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ef1:	01 d0                	add    %edx,%eax
c0102ef3:	a3 78 99 11 c0       	mov    %eax,0xc0119978
    le = &free_list;
c0102ef8:	c7 45 f0 70 99 11 c0 	movl   $0xc0119970,-0x10(%ebp)
c0102eff:	c7 45 94 70 99 11 c0 	movl   $0xc0119970,-0x6c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102f06:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102f09:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int flag=0;
c0102f0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102f16:	eb 67                	jmp    c0102f7f <default_free_pages+0x2db>
    	p = le2page(le, page_link);
c0102f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f1b:	83 e8 0c             	sub    $0xc,%eax
c0102f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	list_entry_t *before_le = le;
c0102f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f24:	89 45 e8             	mov    %eax,-0x18(%ebp)
    	if (p > base) {
c0102f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f2a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102f2d:	76 50                	jbe    c0102f7f <default_free_pages+0x2db>
    		list_add_before(before_le, &(base->page_link));
c0102f2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f32:	8d 50 0c             	lea    0xc(%eax),%edx
c0102f35:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102f38:	89 45 90             	mov    %eax,-0x70(%ebp)
c0102f3b:	89 55 8c             	mov    %edx,-0x74(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102f3e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f41:	8b 00                	mov    (%eax),%eax
c0102f43:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102f46:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102f49:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102f4c:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102f4f:	89 45 80             	mov    %eax,-0x80(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102f52:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102f55:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102f58:	89 10                	mov    %edx,(%eax)
c0102f5a:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102f5d:	8b 10                	mov    (%eax),%edx
c0102f5f:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102f62:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102f65:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f68:	8b 55 80             	mov    -0x80(%ebp),%edx
c0102f6b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102f6e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102f71:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102f74:	89 10                	mov    %edx,(%eax)
    		flag = 1;
c0102f76:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
    		break;
c0102f7d:	eb 22                	jmp    c0102fa1 <default_free_pages+0x2fd>
c0102f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f82:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102f88:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102f8e:	8b 40 04             	mov    0x4(%eax),%eax

    nr_free += n;
    le = &free_list;
    le = list_next(&free_list);
    int flag=0;
    while ((le = list_next(le)) != &free_list) {
c0102f91:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f94:	81 7d f0 70 99 11 c0 	cmpl   $0xc0119970,-0x10(%ebp)
c0102f9b:	0f 85 77 ff ff ff    	jne    c0102f18 <default_free_pages+0x274>
    		list_add_before(before_le, &(base->page_link));
    		flag = 1;
    		break;
    	}
    }
    if (flag == 0)
c0102fa1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102fa5:	75 78                	jne    c010301f <default_free_pages+0x37b>
    	list_add_before(&free_list, &(base->page_link));
c0102fa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102faa:	83 c0 0c             	add    $0xc,%eax
c0102fad:	c7 85 78 ff ff ff 70 	movl   $0xc0119970,-0x88(%ebp)
c0102fb4:	99 11 c0 
c0102fb7:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102fbd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102fc3:	8b 00                	mov    (%eax),%eax
c0102fc5:	8b 95 74 ff ff ff    	mov    -0x8c(%ebp),%edx
c0102fcb:	89 95 70 ff ff ff    	mov    %edx,-0x90(%ebp)
c0102fd1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
c0102fd7:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102fdd:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102fe3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0102fe9:	8b 95 70 ff ff ff    	mov    -0x90(%ebp),%edx
c0102fef:	89 10                	mov    %edx,(%eax)
c0102ff1:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
c0102ff7:	8b 10                	mov    (%eax),%edx
c0102ff9:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
c0102fff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103002:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0103008:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
c010300e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103011:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
c0103017:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
c010301d:	89 10                	mov    %edx,(%eax)
}
c010301f:	c9                   	leave  
c0103020:	c3                   	ret    

c0103021 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103021:	55                   	push   %ebp
c0103022:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103024:	a1 78 99 11 c0       	mov    0xc0119978,%eax
}
c0103029:	5d                   	pop    %ebp
c010302a:	c3                   	ret    

c010302b <basic_check>:

static void
basic_check(void) {
c010302b:	55                   	push   %ebp
c010302c:	89 e5                	mov    %esp,%ebp
c010302e:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103031:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103038:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010303b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010303e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103041:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010304b:	e8 85 0e 00 00       	call   c0103ed5 <alloc_pages>
c0103050:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103053:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103057:	75 24                	jne    c010307d <basic_check+0x52>
c0103059:	c7 44 24 0c b8 69 10 	movl   $0xc01069b8,0xc(%esp)
c0103060:	c0 
c0103061:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103068:	c0 
c0103069:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103070:	00 
c0103071:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103078:	e8 43 dc ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010307d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103084:	e8 4c 0e 00 00       	call   c0103ed5 <alloc_pages>
c0103089:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010308c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103090:	75 24                	jne    c01030b6 <basic_check+0x8b>
c0103092:	c7 44 24 0c d4 69 10 	movl   $0xc01069d4,0xc(%esp)
c0103099:	c0 
c010309a:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01030a1:	c0 
c01030a2:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c01030a9:	00 
c01030aa:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01030b1:	e8 0a dc ff ff       	call   c0100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01030b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030bd:	e8 13 0e 00 00       	call   c0103ed5 <alloc_pages>
c01030c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01030c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030c9:	75 24                	jne    c01030ef <basic_check+0xc4>
c01030cb:	c7 44 24 0c f0 69 10 	movl   $0xc01069f0,0xc(%esp)
c01030d2:	c0 
c01030d3:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01030da:	c0 
c01030db:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01030e2:	00 
c01030e3:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01030ea:	e8 d1 db ff ff       	call   c0100cc0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01030ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01030f5:	74 10                	je     c0103107 <basic_check+0xdc>
c01030f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01030fd:	74 08                	je     c0103107 <basic_check+0xdc>
c01030ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103102:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103105:	75 24                	jne    c010312b <basic_check+0x100>
c0103107:	c7 44 24 0c 0c 6a 10 	movl   $0xc0106a0c,0xc(%esp)
c010310e:	c0 
c010310f:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103116:	c0 
c0103117:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c010311e:	00 
c010311f:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103126:	e8 95 db ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010312b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010312e:	89 04 24             	mov    %eax,(%esp)
c0103131:	e8 1e f8 ff ff       	call   c0102954 <page_ref>
c0103136:	85 c0                	test   %eax,%eax
c0103138:	75 1e                	jne    c0103158 <basic_check+0x12d>
c010313a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010313d:	89 04 24             	mov    %eax,(%esp)
c0103140:	e8 0f f8 ff ff       	call   c0102954 <page_ref>
c0103145:	85 c0                	test   %eax,%eax
c0103147:	75 0f                	jne    c0103158 <basic_check+0x12d>
c0103149:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010314c:	89 04 24             	mov    %eax,(%esp)
c010314f:	e8 00 f8 ff ff       	call   c0102954 <page_ref>
c0103154:	85 c0                	test   %eax,%eax
c0103156:	74 24                	je     c010317c <basic_check+0x151>
c0103158:	c7 44 24 0c 30 6a 10 	movl   $0xc0106a30,0xc(%esp)
c010315f:	c0 
c0103160:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103167:	c0 
c0103168:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010316f:	00 
c0103170:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103177:	e8 44 db ff ff       	call   c0100cc0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010317c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010317f:	89 04 24             	mov    %eax,(%esp)
c0103182:	e8 b7 f7 ff ff       	call   c010293e <page2pa>
c0103187:	8b 15 e0 98 11 c0    	mov    0xc01198e0,%edx
c010318d:	c1 e2 0c             	shl    $0xc,%edx
c0103190:	39 d0                	cmp    %edx,%eax
c0103192:	72 24                	jb     c01031b8 <basic_check+0x18d>
c0103194:	c7 44 24 0c 6c 6a 10 	movl   $0xc0106a6c,0xc(%esp)
c010319b:	c0 
c010319c:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01031a3:	c0 
c01031a4:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c01031ab:	00 
c01031ac:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01031b3:	e8 08 db ff ff       	call   c0100cc0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031bb:	89 04 24             	mov    %eax,(%esp)
c01031be:	e8 7b f7 ff ff       	call   c010293e <page2pa>
c01031c3:	8b 15 e0 98 11 c0    	mov    0xc01198e0,%edx
c01031c9:	c1 e2 0c             	shl    $0xc,%edx
c01031cc:	39 d0                	cmp    %edx,%eax
c01031ce:	72 24                	jb     c01031f4 <basic_check+0x1c9>
c01031d0:	c7 44 24 0c 89 6a 10 	movl   $0xc0106a89,0xc(%esp)
c01031d7:	c0 
c01031d8:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01031df:	c0 
c01031e0:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01031e7:	00 
c01031e8:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01031ef:	e8 cc da ff ff       	call   c0100cc0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01031f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031f7:	89 04 24             	mov    %eax,(%esp)
c01031fa:	e8 3f f7 ff ff       	call   c010293e <page2pa>
c01031ff:	8b 15 e0 98 11 c0    	mov    0xc01198e0,%edx
c0103205:	c1 e2 0c             	shl    $0xc,%edx
c0103208:	39 d0                	cmp    %edx,%eax
c010320a:	72 24                	jb     c0103230 <basic_check+0x205>
c010320c:	c7 44 24 0c a6 6a 10 	movl   $0xc0106aa6,0xc(%esp)
c0103213:	c0 
c0103214:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010321b:	c0 
c010321c:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103223:	00 
c0103224:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010322b:	e8 90 da ff ff       	call   c0100cc0 <__panic>

    list_entry_t free_list_store = free_list;
c0103230:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c0103235:	8b 15 74 99 11 c0    	mov    0xc0119974,%edx
c010323b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010323e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103241:	c7 45 e0 70 99 11 c0 	movl   $0xc0119970,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103248:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010324b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010324e:	89 50 04             	mov    %edx,0x4(%eax)
c0103251:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103254:	8b 50 04             	mov    0x4(%eax),%edx
c0103257:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010325a:	89 10                	mov    %edx,(%eax)
c010325c:	c7 45 dc 70 99 11 c0 	movl   $0xc0119970,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103263:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103266:	8b 40 04             	mov    0x4(%eax),%eax
c0103269:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010326c:	0f 94 c0             	sete   %al
c010326f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103272:	85 c0                	test   %eax,%eax
c0103274:	75 24                	jne    c010329a <basic_check+0x26f>
c0103276:	c7 44 24 0c c3 6a 10 	movl   $0xc0106ac3,0xc(%esp)
c010327d:	c0 
c010327e:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103285:	c0 
c0103286:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010328d:	00 
c010328e:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103295:	e8 26 da ff ff       	call   c0100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
c010329a:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c010329f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01032a2:	c7 05 78 99 11 c0 00 	movl   $0x0,0xc0119978
c01032a9:	00 00 00 

    assert(alloc_page() == NULL);
c01032ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032b3:	e8 1d 0c 00 00       	call   c0103ed5 <alloc_pages>
c01032b8:	85 c0                	test   %eax,%eax
c01032ba:	74 24                	je     c01032e0 <basic_check+0x2b5>
c01032bc:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c01032c3:	c0 
c01032c4:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01032cb:	c0 
c01032cc:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01032d3:	00 
c01032d4:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01032db:	e8 e0 d9 ff ff       	call   c0100cc0 <__panic>
    free_page(p0);
c01032e0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032e7:	00 
c01032e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032eb:	89 04 24             	mov    %eax,(%esp)
c01032ee:	e8 1a 0c 00 00       	call   c0103f0d <free_pages>
    free_page(p1);
c01032f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032fa:	00 
c01032fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032fe:	89 04 24             	mov    %eax,(%esp)
c0103301:	e8 07 0c 00 00       	call   c0103f0d <free_pages>
    free_page(p2);
c0103306:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010330d:	00 
c010330e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103311:	89 04 24             	mov    %eax,(%esp)
c0103314:	e8 f4 0b 00 00       	call   c0103f0d <free_pages>
    assert(nr_free == 3);
c0103319:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c010331e:	83 f8 03             	cmp    $0x3,%eax
c0103321:	74 24                	je     c0103347 <basic_check+0x31c>
c0103323:	c7 44 24 0c ef 6a 10 	movl   $0xc0106aef,0xc(%esp)
c010332a:	c0 
c010332b:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103332:	c0 
c0103333:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c010333a:	00 
c010333b:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103342:	e8 79 d9 ff ff       	call   c0100cc0 <__panic>
    assert((p0 = alloc_page()) != NULL);
c0103347:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010334e:	e8 82 0b 00 00       	call   c0103ed5 <alloc_pages>
c0103353:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103356:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010335a:	75 24                	jne    c0103380 <basic_check+0x355>
c010335c:	c7 44 24 0c b8 69 10 	movl   $0xc01069b8,0xc(%esp)
c0103363:	c0 
c0103364:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010336b:	c0 
c010336c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103373:	00 
c0103374:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010337b:	e8 40 d9 ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103380:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103387:	e8 49 0b 00 00       	call   c0103ed5 <alloc_pages>
c010338c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010338f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103393:	75 24                	jne    c01033b9 <basic_check+0x38e>
c0103395:	c7 44 24 0c d4 69 10 	movl   $0xc01069d4,0xc(%esp)
c010339c:	c0 
c010339d:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01033a4:	c0 
c01033a5:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01033ac:	00 
c01033ad:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01033b4:	e8 07 d9 ff ff       	call   c0100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01033b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033c0:	e8 10 0b 00 00       	call   c0103ed5 <alloc_pages>
c01033c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01033cc:	75 24                	jne    c01033f2 <basic_check+0x3c7>
c01033ce:	c7 44 24 0c f0 69 10 	movl   $0xc01069f0,0xc(%esp)
c01033d5:	c0 
c01033d6:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01033dd:	c0 
c01033de:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01033e5:	00 
c01033e6:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01033ed:	e8 ce d8 ff ff       	call   c0100cc0 <__panic>

    assert(alloc_page() == NULL);
c01033f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033f9:	e8 d7 0a 00 00       	call   c0103ed5 <alloc_pages>
c01033fe:	85 c0                	test   %eax,%eax
c0103400:	74 24                	je     c0103426 <basic_check+0x3fb>
c0103402:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c0103409:	c0 
c010340a:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103411:	c0 
c0103412:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103419:	00 
c010341a:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103421:	e8 9a d8 ff ff       	call   c0100cc0 <__panic>

    free_page(p0);
c0103426:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010342d:	00 
c010342e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103431:	89 04 24             	mov    %eax,(%esp)
c0103434:	e8 d4 0a 00 00       	call   c0103f0d <free_pages>
c0103439:	c7 45 d8 70 99 11 c0 	movl   $0xc0119970,-0x28(%ebp)
c0103440:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103443:	8b 40 04             	mov    0x4(%eax),%eax
c0103446:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103449:	0f 94 c0             	sete   %al
c010344c:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010344f:	85 c0                	test   %eax,%eax
c0103451:	74 24                	je     c0103477 <basic_check+0x44c>
c0103453:	c7 44 24 0c fc 6a 10 	movl   $0xc0106afc,0xc(%esp)
c010345a:	c0 
c010345b:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103462:	c0 
c0103463:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010346a:	00 
c010346b:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103472:	e8 49 d8 ff ff       	call   c0100cc0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103477:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010347e:	e8 52 0a 00 00       	call   c0103ed5 <alloc_pages>
c0103483:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103489:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010348c:	74 24                	je     c01034b2 <basic_check+0x487>
c010348e:	c7 44 24 0c 14 6b 10 	movl   $0xc0106b14,0xc(%esp)
c0103495:	c0 
c0103496:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010349d:	c0 
c010349e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01034a5:	00 
c01034a6:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01034ad:	e8 0e d8 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c01034b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034b9:	e8 17 0a 00 00       	call   c0103ed5 <alloc_pages>
c01034be:	85 c0                	test   %eax,%eax
c01034c0:	74 24                	je     c01034e6 <basic_check+0x4bb>
c01034c2:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c01034c9:	c0 
c01034ca:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01034d1:	c0 
c01034d2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01034d9:	00 
c01034da:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01034e1:	e8 da d7 ff ff       	call   c0100cc0 <__panic>

    assert(nr_free == 0);
c01034e6:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c01034eb:	85 c0                	test   %eax,%eax
c01034ed:	74 24                	je     c0103513 <basic_check+0x4e8>
c01034ef:	c7 44 24 0c 2d 6b 10 	movl   $0xc0106b2d,0xc(%esp)
c01034f6:	c0 
c01034f7:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01034fe:	c0 
c01034ff:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103506:	00 
c0103507:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010350e:	e8 ad d7 ff ff       	call   c0100cc0 <__panic>
    free_list = free_list_store;
c0103513:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103516:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103519:	a3 70 99 11 c0       	mov    %eax,0xc0119970
c010351e:	89 15 74 99 11 c0    	mov    %edx,0xc0119974
    nr_free = nr_free_store;
c0103524:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103527:	a3 78 99 11 c0       	mov    %eax,0xc0119978

    free_page(p);
c010352c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103533:	00 
c0103534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103537:	89 04 24             	mov    %eax,(%esp)
c010353a:	e8 ce 09 00 00       	call   c0103f0d <free_pages>
    free_page(p1);
c010353f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103546:	00 
c0103547:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010354a:	89 04 24             	mov    %eax,(%esp)
c010354d:	e8 bb 09 00 00       	call   c0103f0d <free_pages>
    free_page(p2);
c0103552:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103559:	00 
c010355a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010355d:	89 04 24             	mov    %eax,(%esp)
c0103560:	e8 a8 09 00 00       	call   c0103f0d <free_pages>
}
c0103565:	c9                   	leave  
c0103566:	c3                   	ret    

c0103567 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103567:	55                   	push   %ebp
c0103568:	89 e5                	mov    %esp,%ebp
c010356a:	53                   	push   %ebx
c010356b:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010357f:	c7 45 ec 70 99 11 c0 	movl   $0xc0119970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103586:	eb 6b                	jmp    c01035f3 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103588:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010358b:	83 e8 0c             	sub    $0xc,%eax
c010358e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103591:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103594:	83 c0 04             	add    $0x4,%eax
c0103597:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010359e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035a4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035a7:	0f a3 10             	bt     %edx,(%eax)
c01035aa:	19 c0                	sbb    %eax,%eax
c01035ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01035af:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01035b3:	0f 95 c0             	setne  %al
c01035b6:	0f b6 c0             	movzbl %al,%eax
c01035b9:	85 c0                	test   %eax,%eax
c01035bb:	75 24                	jne    c01035e1 <default_check+0x7a>
c01035bd:	c7 44 24 0c 3a 6b 10 	movl   $0xc0106b3a,0xc(%esp)
c01035c4:	c0 
c01035c5:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01035cc:	c0 
c01035cd:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01035d4:	00 
c01035d5:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01035dc:	e8 df d6 ff ff       	call   c0100cc0 <__panic>
        count ++, total += p->property;
c01035e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01035e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035e8:	8b 50 08             	mov    0x8(%eax),%edx
c01035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035ee:	01 d0                	add    %edx,%eax
c01035f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035fc:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01035ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103602:	81 7d ec 70 99 11 c0 	cmpl   $0xc0119970,-0x14(%ebp)
c0103609:	0f 85 79 ff ff ff    	jne    c0103588 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010360f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103612:	e8 28 09 00 00       	call   c0103f3f <nr_free_pages>
c0103617:	39 c3                	cmp    %eax,%ebx
c0103619:	74 24                	je     c010363f <default_check+0xd8>
c010361b:	c7 44 24 0c 4a 6b 10 	movl   $0xc0106b4a,0xc(%esp)
c0103622:	c0 
c0103623:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010362a:	c0 
c010362b:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103632:	00 
c0103633:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010363a:	e8 81 d6 ff ff       	call   c0100cc0 <__panic>
    basic_check();
c010363f:	e8 e7 f9 ff ff       	call   c010302b <basic_check>
    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103644:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010364b:	e8 85 08 00 00       	call   c0103ed5 <alloc_pages>
c0103650:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103653:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103657:	75 24                	jne    c010367d <default_check+0x116>
c0103659:	c7 44 24 0c 63 6b 10 	movl   $0xc0106b63,0xc(%esp)
c0103660:	c0 
c0103661:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103668:	c0 
c0103669:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103670:	00 
c0103671:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103678:	e8 43 d6 ff ff       	call   c0100cc0 <__panic>
    assert(!PageProperty(p0));
c010367d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103680:	83 c0 04             	add    $0x4,%eax
c0103683:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010368a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010368d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103690:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103693:	0f a3 10             	bt     %edx,(%eax)
c0103696:	19 c0                	sbb    %eax,%eax
c0103698:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010369b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010369f:	0f 95 c0             	setne  %al
c01036a2:	0f b6 c0             	movzbl %al,%eax
c01036a5:	85 c0                	test   %eax,%eax
c01036a7:	74 24                	je     c01036cd <default_check+0x166>
c01036a9:	c7 44 24 0c 6e 6b 10 	movl   $0xc0106b6e,0xc(%esp)
c01036b0:	c0 
c01036b1:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01036b8:	c0 
c01036b9:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01036c0:	00 
c01036c1:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01036c8:	e8 f3 d5 ff ff       	call   c0100cc0 <__panic>

    list_entry_t free_list_store = free_list;
c01036cd:	a1 70 99 11 c0       	mov    0xc0119970,%eax
c01036d2:	8b 15 74 99 11 c0    	mov    0xc0119974,%edx
c01036d8:	89 45 80             	mov    %eax,-0x80(%ebp)
c01036db:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01036de:	c7 45 b4 70 99 11 c0 	movl   $0xc0119970,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01036e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036e8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01036eb:	89 50 04             	mov    %edx,0x4(%eax)
c01036ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036f1:	8b 50 04             	mov    0x4(%eax),%edx
c01036f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01036f7:	89 10                	mov    %edx,(%eax)
c01036f9:	c7 45 b0 70 99 11 c0 	movl   $0xc0119970,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103700:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103703:	8b 40 04             	mov    0x4(%eax),%eax
c0103706:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103709:	0f 94 c0             	sete   %al
c010370c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010370f:	85 c0                	test   %eax,%eax
c0103711:	75 24                	jne    c0103737 <default_check+0x1d0>
c0103713:	c7 44 24 0c c3 6a 10 	movl   $0xc0106ac3,0xc(%esp)
c010371a:	c0 
c010371b:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103722:	c0 
c0103723:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010372a:	00 
c010372b:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103732:	e8 89 d5 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103737:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010373e:	e8 92 07 00 00       	call   c0103ed5 <alloc_pages>
c0103743:	85 c0                	test   %eax,%eax
c0103745:	74 24                	je     c010376b <default_check+0x204>
c0103747:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c010374e:	c0 
c010374f:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103756:	c0 
c0103757:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c010375e:	00 
c010375f:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103766:	e8 55 d5 ff ff       	call   c0100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
c010376b:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c0103770:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103773:	c7 05 78 99 11 c0 00 	movl   $0x0,0xc0119978
c010377a:	00 00 00 

    free_pages(p0 + 2, 3);
c010377d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103780:	83 c0 28             	add    $0x28,%eax
c0103783:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010378a:	00 
c010378b:	89 04 24             	mov    %eax,(%esp)
c010378e:	e8 7a 07 00 00       	call   c0103f0d <free_pages>
    assert(alloc_pages(4) == NULL);
c0103793:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010379a:	e8 36 07 00 00       	call   c0103ed5 <alloc_pages>
c010379f:	85 c0                	test   %eax,%eax
c01037a1:	74 24                	je     c01037c7 <default_check+0x260>
c01037a3:	c7 44 24 0c 80 6b 10 	movl   $0xc0106b80,0xc(%esp)
c01037aa:	c0 
c01037ab:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01037b2:	c0 
c01037b3:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c01037ba:	00 
c01037bb:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01037c2:	e8 f9 d4 ff ff       	call   c0100cc0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01037c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037ca:	83 c0 28             	add    $0x28,%eax
c01037cd:	83 c0 04             	add    $0x4,%eax
c01037d0:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01037d7:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037da:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01037dd:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01037e0:	0f a3 10             	bt     %edx,(%eax)
c01037e3:	19 c0                	sbb    %eax,%eax
c01037e5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01037e8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01037ec:	0f 95 c0             	setne  %al
c01037ef:	0f b6 c0             	movzbl %al,%eax
c01037f2:	85 c0                	test   %eax,%eax
c01037f4:	74 0e                	je     c0103804 <default_check+0x29d>
c01037f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037f9:	83 c0 28             	add    $0x28,%eax
c01037fc:	8b 40 08             	mov    0x8(%eax),%eax
c01037ff:	83 f8 03             	cmp    $0x3,%eax
c0103802:	74 24                	je     c0103828 <default_check+0x2c1>
c0103804:	c7 44 24 0c 98 6b 10 	movl   $0xc0106b98,0xc(%esp)
c010380b:	c0 
c010380c:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103813:	c0 
c0103814:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c010381b:	00 
c010381c:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103823:	e8 98 d4 ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103828:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010382f:	e8 a1 06 00 00       	call   c0103ed5 <alloc_pages>
c0103834:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103837:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010383b:	75 24                	jne    c0103861 <default_check+0x2fa>
c010383d:	c7 44 24 0c c4 6b 10 	movl   $0xc0106bc4,0xc(%esp)
c0103844:	c0 
c0103845:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c010384c:	c0 
c010384d:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c0103854:	00 
c0103855:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c010385c:	e8 5f d4 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103861:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103868:	e8 68 06 00 00       	call   c0103ed5 <alloc_pages>
c010386d:	85 c0                	test   %eax,%eax
c010386f:	74 24                	je     c0103895 <default_check+0x32e>
c0103871:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c0103878:	c0 
c0103879:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103880:	c0 
c0103881:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103888:	00 
c0103889:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103890:	e8 2b d4 ff ff       	call   c0100cc0 <__panic>
    assert(p0 + 2 == p1);
c0103895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103898:	83 c0 28             	add    $0x28,%eax
c010389b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010389e:	74 24                	je     c01038c4 <default_check+0x35d>
c01038a0:	c7 44 24 0c e2 6b 10 	movl   $0xc0106be2,0xc(%esp)
c01038a7:	c0 
c01038a8:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01038af:	c0 
c01038b0:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01038b7:	00 
c01038b8:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01038bf:	e8 fc d3 ff ff       	call   c0100cc0 <__panic>

    p2 = p0 + 1;
c01038c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038c7:	83 c0 14             	add    $0x14,%eax
c01038ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01038cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038d4:	00 
c01038d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038d8:	89 04 24             	mov    %eax,(%esp)
c01038db:	e8 2d 06 00 00       	call   c0103f0d <free_pages>
    free_pages(p1, 3);
c01038e0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01038e7:	00 
c01038e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01038eb:	89 04 24             	mov    %eax,(%esp)
c01038ee:	e8 1a 06 00 00       	call   c0103f0d <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01038f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038f6:	83 c0 04             	add    $0x4,%eax
c01038f9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103900:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103903:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103906:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103909:	0f a3 10             	bt     %edx,(%eax)
c010390c:	19 c0                	sbb    %eax,%eax
c010390e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103911:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103915:	0f 95 c0             	setne  %al
c0103918:	0f b6 c0             	movzbl %al,%eax
c010391b:	85 c0                	test   %eax,%eax
c010391d:	74 0b                	je     c010392a <default_check+0x3c3>
c010391f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103922:	8b 40 08             	mov    0x8(%eax),%eax
c0103925:	83 f8 01             	cmp    $0x1,%eax
c0103928:	74 24                	je     c010394e <default_check+0x3e7>
c010392a:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c0103931:	c0 
c0103932:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103939:	c0 
c010393a:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103941:	00 
c0103942:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103949:	e8 72 d3 ff ff       	call   c0100cc0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010394e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103951:	83 c0 04             	add    $0x4,%eax
c0103954:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010395b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010395e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103961:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103964:	0f a3 10             	bt     %edx,(%eax)
c0103967:	19 c0                	sbb    %eax,%eax
c0103969:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010396c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103970:	0f 95 c0             	setne  %al
c0103973:	0f b6 c0             	movzbl %al,%eax
c0103976:	85 c0                	test   %eax,%eax
c0103978:	74 0b                	je     c0103985 <default_check+0x41e>
c010397a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010397d:	8b 40 08             	mov    0x8(%eax),%eax
c0103980:	83 f8 03             	cmp    $0x3,%eax
c0103983:	74 24                	je     c01039a9 <default_check+0x442>
c0103985:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c010398c:	c0 
c010398d:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103994:	c0 
c0103995:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010399c:	00 
c010399d:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01039a4:	e8 17 d3 ff ff       	call   c0100cc0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01039a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039b0:	e8 20 05 00 00       	call   c0103ed5 <alloc_pages>
c01039b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01039b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039bb:	83 e8 14             	sub    $0x14,%eax
c01039be:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01039c1:	74 24                	je     c01039e7 <default_check+0x480>
c01039c3:	c7 44 24 0c 3e 6c 10 	movl   $0xc0106c3e,0xc(%esp)
c01039ca:	c0 
c01039cb:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01039da:	00 
c01039db:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c01039e2:	e8 d9 d2 ff ff       	call   c0100cc0 <__panic>
    free_page(p0);
c01039e7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039ee:	00 
c01039ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039f2:	89 04 24             	mov    %eax,(%esp)
c01039f5:	e8 13 05 00 00       	call   c0103f0d <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01039fa:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a01:	e8 cf 04 00 00       	call   c0103ed5 <alloc_pages>
c0103a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a0c:	83 c0 14             	add    $0x14,%eax
c0103a0f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a12:	74 24                	je     c0103a38 <default_check+0x4d1>
c0103a14:	c7 44 24 0c 5c 6c 10 	movl   $0xc0106c5c,0xc(%esp)
c0103a1b:	c0 
c0103a1c:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103a23:	c0 
c0103a24:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103a2b:	00 
c0103a2c:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103a33:	e8 88 d2 ff ff       	call   c0100cc0 <__panic>

    free_pages(p0, 2);
c0103a38:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103a3f:	00 
c0103a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a43:	89 04 24             	mov    %eax,(%esp)
c0103a46:	e8 c2 04 00 00       	call   c0103f0d <free_pages>
    free_page(p2);
c0103a4b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a52:	00 
c0103a53:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a56:	89 04 24             	mov    %eax,(%esp)
c0103a59:	e8 af 04 00 00       	call   c0103f0d <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103a5e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103a65:	e8 6b 04 00 00       	call   c0103ed5 <alloc_pages>
c0103a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103a71:	75 24                	jne    c0103a97 <default_check+0x530>
c0103a73:	c7 44 24 0c 7c 6c 10 	movl   $0xc0106c7c,0xc(%esp)
c0103a7a:	c0 
c0103a7b:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103a82:	c0 
c0103a83:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103a8a:	00 
c0103a8b:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103a92:	e8 29 d2 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a9e:	e8 32 04 00 00       	call   c0103ed5 <alloc_pages>
c0103aa3:	85 c0                	test   %eax,%eax
c0103aa5:	74 24                	je     c0103acb <default_check+0x564>
c0103aa7:	c7 44 24 0c da 6a 10 	movl   $0xc0106ada,0xc(%esp)
c0103aae:	c0 
c0103aaf:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103ab6:	c0 
c0103ab7:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103abe:	00 
c0103abf:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103ac6:	e8 f5 d1 ff ff       	call   c0100cc0 <__panic>

    assert(nr_free == 0);
c0103acb:	a1 78 99 11 c0       	mov    0xc0119978,%eax
c0103ad0:	85 c0                	test   %eax,%eax
c0103ad2:	74 24                	je     c0103af8 <default_check+0x591>
c0103ad4:	c7 44 24 0c 2d 6b 10 	movl   $0xc0106b2d,0xc(%esp)
c0103adb:	c0 
c0103adc:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103ae3:	c0 
c0103ae4:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103aeb:	00 
c0103aec:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103af3:	e8 c8 d1 ff ff       	call   c0100cc0 <__panic>
    nr_free = nr_free_store;
c0103af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103afb:	a3 78 99 11 c0       	mov    %eax,0xc0119978

    free_list = free_list_store;
c0103b00:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b03:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b06:	a3 70 99 11 c0       	mov    %eax,0xc0119970
c0103b0b:	89 15 74 99 11 c0    	mov    %edx,0xc0119974
    free_pages(p0, 5);
c0103b11:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b18:	00 
c0103b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b1c:	89 04 24             	mov    %eax,(%esp)
c0103b1f:	e8 e9 03 00 00       	call   c0103f0d <free_pages>

    le = &free_list;
c0103b24:	c7 45 ec 70 99 11 c0 	movl   $0xc0119970,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b2b:	eb 1d                	jmp    c0103b4a <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b30:	83 e8 0c             	sub    $0xc,%eax
c0103b33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103b36:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103b3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103b40:	8b 40 08             	mov    0x8(%eax),%eax
c0103b43:	29 c2                	sub    %eax,%edx
c0103b45:	89 d0                	mov    %edx,%eax
c0103b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b4d:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103b50:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103b53:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103b56:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b59:	81 7d ec 70 99 11 c0 	cmpl   $0xc0119970,-0x14(%ebp)
c0103b60:	75 cb                	jne    c0103b2d <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b66:	74 24                	je     c0103b8c <default_check+0x625>
c0103b68:	c7 44 24 0c 9a 6c 10 	movl   $0xc0106c9a,0xc(%esp)
c0103b6f:	c0 
c0103b70:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103b77:	c0 
c0103b78:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103b7f:	00 
c0103b80:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103b87:	e8 34 d1 ff ff       	call   c0100cc0 <__panic>
    assert(total == 0);
c0103b8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b90:	74 24                	je     c0103bb6 <default_check+0x64f>
c0103b92:	c7 44 24 0c a5 6c 10 	movl   $0xc0106ca5,0xc(%esp)
c0103b99:	c0 
c0103b9a:	c7 44 24 08 56 69 10 	movl   $0xc0106956,0x8(%esp)
c0103ba1:	c0 
c0103ba2:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103ba9:	00 
c0103baa:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103bb1:	e8 0a d1 ff ff       	call   c0100cc0 <__panic>
}
c0103bb6:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103bbc:	5b                   	pop    %ebx
c0103bbd:	5d                   	pop    %ebp
c0103bbe:	c3                   	ret    

c0103bbf <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103bbf:	55                   	push   %ebp
c0103bc0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103bc2:	8b 55 08             	mov    0x8(%ebp),%edx
c0103bc5:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0103bca:	29 c2                	sub    %eax,%edx
c0103bcc:	89 d0                	mov    %edx,%eax
c0103bce:	c1 f8 02             	sar    $0x2,%eax
c0103bd1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103bd7:	5d                   	pop    %ebp
c0103bd8:	c3                   	ret    

c0103bd9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103bd9:	55                   	push   %ebp
c0103bda:	89 e5                	mov    %esp,%ebp
c0103bdc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be2:	89 04 24             	mov    %eax,(%esp)
c0103be5:	e8 d5 ff ff ff       	call   c0103bbf <page2ppn>
c0103bea:	c1 e0 0c             	shl    $0xc,%eax
}
c0103bed:	c9                   	leave  
c0103bee:	c3                   	ret    

c0103bef <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103bef:	55                   	push   %ebp
c0103bf0:	89 e5                	mov    %esp,%ebp
c0103bf2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bf8:	c1 e8 0c             	shr    $0xc,%eax
c0103bfb:	89 c2                	mov    %eax,%edx
c0103bfd:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0103c02:	39 c2                	cmp    %eax,%edx
c0103c04:	72 1c                	jb     c0103c22 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c06:	c7 44 24 08 e0 6c 10 	movl   $0xc0106ce0,0x8(%esp)
c0103c0d:	c0 
c0103c0e:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c15:	00 
c0103c16:	c7 04 24 ff 6c 10 c0 	movl   $0xc0106cff,(%esp)
c0103c1d:	e8 9e d0 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c0103c22:	8b 0d 84 99 11 c0    	mov    0xc0119984,%ecx
c0103c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c2b:	c1 e8 0c             	shr    $0xc,%eax
c0103c2e:	89 c2                	mov    %eax,%edx
c0103c30:	89 d0                	mov    %edx,%eax
c0103c32:	c1 e0 02             	shl    $0x2,%eax
c0103c35:	01 d0                	add    %edx,%eax
c0103c37:	c1 e0 02             	shl    $0x2,%eax
c0103c3a:	01 c8                	add    %ecx,%eax
}
c0103c3c:	c9                   	leave  
c0103c3d:	c3                   	ret    

c0103c3e <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103c3e:	55                   	push   %ebp
c0103c3f:	89 e5                	mov    %esp,%ebp
c0103c41:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c47:	89 04 24             	mov    %eax,(%esp)
c0103c4a:	e8 8a ff ff ff       	call   c0103bd9 <page2pa>
c0103c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c55:	c1 e8 0c             	shr    $0xc,%eax
c0103c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c5b:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0103c60:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103c63:	72 23                	jb     c0103c88 <page2kva+0x4a>
c0103c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c68:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c6c:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c0103c73:	c0 
c0103c74:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103c7b:	00 
c0103c7c:	c7 04 24 ff 6c 10 c0 	movl   $0xc0106cff,(%esp)
c0103c83:	e8 38 d0 ff ff       	call   c0100cc0 <__panic>
c0103c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c8b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103c90:	c9                   	leave  
c0103c91:	c3                   	ret    

c0103c92 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103c92:	55                   	push   %ebp
c0103c93:	89 e5                	mov    %esp,%ebp
c0103c95:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103c98:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c9b:	83 e0 01             	and    $0x1,%eax
c0103c9e:	85 c0                	test   %eax,%eax
c0103ca0:	75 1c                	jne    c0103cbe <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ca2:	c7 44 24 08 34 6d 10 	movl   $0xc0106d34,0x8(%esp)
c0103ca9:	c0 
c0103caa:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103cb1:	00 
c0103cb2:	c7 04 24 ff 6c 10 c0 	movl   $0xc0106cff,(%esp)
c0103cb9:	e8 02 d0 ff ff       	call   c0100cc0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103cc6:	89 04 24             	mov    %eax,(%esp)
c0103cc9:	e8 21 ff ff ff       	call   c0103bef <pa2page>
}
c0103cce:	c9                   	leave  
c0103ccf:	c3                   	ret    

c0103cd0 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103cd0:	55                   	push   %ebp
c0103cd1:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cd6:	8b 00                	mov    (%eax),%eax
}
c0103cd8:	5d                   	pop    %ebp
c0103cd9:	c3                   	ret    

c0103cda <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103cda:	55                   	push   %ebp
c0103cdb:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ce3:	89 10                	mov    %edx,(%eax)
}
c0103ce5:	5d                   	pop    %ebp
c0103ce6:	c3                   	ret    

c0103ce7 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103ce7:	55                   	push   %ebp
c0103ce8:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ced:	8b 00                	mov    (%eax),%eax
c0103cef:	8d 50 01             	lea    0x1(%eax),%edx
c0103cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cf5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cfa:	8b 00                	mov    (%eax),%eax
}
c0103cfc:	5d                   	pop    %ebp
c0103cfd:	c3                   	ret    

c0103cfe <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103cfe:	55                   	push   %ebp
c0103cff:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d04:	8b 00                	mov    (%eax),%eax
c0103d06:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d09:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d0c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d11:	8b 00                	mov    (%eax),%eax
}
c0103d13:	5d                   	pop    %ebp
c0103d14:	c3                   	ret    

c0103d15 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103d15:	55                   	push   %ebp
c0103d16:	89 e5                	mov    %esp,%ebp
c0103d18:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103d1b:	9c                   	pushf  
c0103d1c:	58                   	pop    %eax
c0103d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103d23:	25 00 02 00 00       	and    $0x200,%eax
c0103d28:	85 c0                	test   %eax,%eax
c0103d2a:	74 0c                	je     c0103d38 <__intr_save+0x23>
        intr_disable();
c0103d2c:	e8 21 da ff ff       	call   c0101752 <intr_disable>
        return 1;
c0103d31:	b8 01 00 00 00       	mov    $0x1,%eax
c0103d36:	eb 05                	jmp    c0103d3d <__intr_save+0x28>
    }
    return 0;
c0103d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103d3d:	c9                   	leave  
c0103d3e:	c3                   	ret    

c0103d3f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103d3f:	55                   	push   %ebp
c0103d40:	89 e5                	mov    %esp,%ebp
c0103d42:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103d45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103d49:	74 05                	je     c0103d50 <__intr_restore+0x11>
        intr_enable();
c0103d4b:	e8 fc d9 ff ff       	call   c010174c <intr_enable>
    }
}
c0103d50:	c9                   	leave  
c0103d51:	c3                   	ret    

c0103d52 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103d52:	55                   	push   %ebp
c0103d53:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d58:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103d5b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d60:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103d62:	b8 23 00 00 00       	mov    $0x23,%eax
c0103d67:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103d69:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d6e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103d70:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d75:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103d77:	b8 10 00 00 00       	mov    $0x10,%eax
c0103d7c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103d7e:	ea 85 3d 10 c0 08 00 	ljmp   $0x8,$0xc0103d85
}
c0103d85:	5d                   	pop    %ebp
c0103d86:	c3                   	ret    

c0103d87 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103d87:	55                   	push   %ebp
c0103d88:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8d:	a3 04 99 11 c0       	mov    %eax,0xc0119904
}
c0103d92:	5d                   	pop    %ebp
c0103d93:	c3                   	ret    

c0103d94 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103d94:	55                   	push   %ebp
c0103d95:	89 e5                	mov    %esp,%ebp
c0103d97:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103d9a:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103d9f:	89 04 24             	mov    %eax,(%esp)
c0103da2:	e8 e0 ff ff ff       	call   c0103d87 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103da7:	66 c7 05 08 99 11 c0 	movw   $0x10,0xc0119908
c0103dae:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103db0:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103db7:	68 00 
c0103db9:	b8 00 99 11 c0       	mov    $0xc0119900,%eax
c0103dbe:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103dc4:	b8 00 99 11 c0       	mov    $0xc0119900,%eax
c0103dc9:	c1 e8 10             	shr    $0x10,%eax
c0103dcc:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103dd1:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103dd8:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ddb:	83 c8 09             	or     $0x9,%eax
c0103dde:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103de3:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103dea:	83 e0 ef             	and    $0xffffffef,%eax
c0103ded:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103df2:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103df9:	83 e0 9f             	and    $0xffffff9f,%eax
c0103dfc:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e01:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e08:	83 c8 80             	or     $0xffffff80,%eax
c0103e0b:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e10:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e17:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e1a:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e1f:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e26:	83 e0 ef             	and    $0xffffffef,%eax
c0103e29:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e2e:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e35:	83 e0 df             	and    $0xffffffdf,%eax
c0103e38:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e3d:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e44:	83 c8 40             	or     $0x40,%eax
c0103e47:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e4c:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103e53:	83 e0 7f             	and    $0x7f,%eax
c0103e56:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103e5b:	b8 00 99 11 c0       	mov    $0xc0119900,%eax
c0103e60:	c1 e8 18             	shr    $0x18,%eax
c0103e63:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103e68:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103e6f:	e8 de fe ff ff       	call   c0103d52 <lgdt>
c0103e74:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103e7a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103e7e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103e81:	c9                   	leave  
c0103e82:	c3                   	ret    

c0103e83 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103e83:	55                   	push   %ebp
c0103e84:	89 e5                	mov    %esp,%ebp
c0103e86:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103e89:	c7 05 7c 99 11 c0 c4 	movl   $0xc0106cc4,0xc011997c
c0103e90:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103e93:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0103e98:	8b 00                	mov    (%eax),%eax
c0103e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e9e:	c7 04 24 60 6d 10 c0 	movl   $0xc0106d60,(%esp)
c0103ea5:	e8 9d c4 ff ff       	call   c0100347 <cprintf>
    pmm_manager->init();
c0103eaa:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0103eaf:	8b 40 04             	mov    0x4(%eax),%eax
c0103eb2:	ff d0                	call   *%eax
}
c0103eb4:	c9                   	leave  
c0103eb5:	c3                   	ret    

c0103eb6 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103eb6:	55                   	push   %ebp
c0103eb7:	89 e5                	mov    %esp,%ebp
c0103eb9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103ebc:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0103ec1:	8b 40 08             	mov    0x8(%eax),%eax
c0103ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103ec7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ecb:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ece:	89 14 24             	mov    %edx,(%esp)
c0103ed1:	ff d0                	call   *%eax
}
c0103ed3:	c9                   	leave  
c0103ed4:	c3                   	ret    

c0103ed5 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103ed5:	55                   	push   %ebp
c0103ed6:	89 e5                	mov    %esp,%ebp
c0103ed8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ee2:	e8 2e fe ff ff       	call   c0103d15 <__intr_save>
c0103ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103eea:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0103eef:	8b 40 0c             	mov    0xc(%eax),%eax
c0103ef2:	8b 55 08             	mov    0x8(%ebp),%edx
c0103ef5:	89 14 24             	mov    %edx,(%esp)
c0103ef8:	ff d0                	call   *%eax
c0103efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f00:	89 04 24             	mov    %eax,(%esp)
c0103f03:	e8 37 fe ff ff       	call   c0103d3f <__intr_restore>
    return page;
c0103f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103f0b:	c9                   	leave  
c0103f0c:	c3                   	ret    

c0103f0d <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103f0d:	55                   	push   %ebp
c0103f0e:	89 e5                	mov    %esp,%ebp
c0103f10:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f13:	e8 fd fd ff ff       	call   c0103d15 <__intr_save>
c0103f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103f1b:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0103f20:	8b 40 10             	mov    0x10(%eax),%eax
c0103f23:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f26:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f2a:	8b 55 08             	mov    0x8(%ebp),%edx
c0103f2d:	89 14 24             	mov    %edx,(%esp)
c0103f30:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f35:	89 04 24             	mov    %eax,(%esp)
c0103f38:	e8 02 fe ff ff       	call   c0103d3f <__intr_restore>
}
c0103f3d:	c9                   	leave  
c0103f3e:	c3                   	ret    

c0103f3f <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103f3f:	55                   	push   %ebp
c0103f40:	89 e5                	mov    %esp,%ebp
c0103f42:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f45:	e8 cb fd ff ff       	call   c0103d15 <__intr_save>
c0103f4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103f4d:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c0103f52:	8b 40 14             	mov    0x14(%eax),%eax
c0103f55:	ff d0                	call   *%eax
c0103f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f5d:	89 04 24             	mov    %eax,(%esp)
c0103f60:	e8 da fd ff ff       	call   c0103d3f <__intr_restore>
    return ret;
c0103f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103f68:	c9                   	leave  
c0103f69:	c3                   	ret    

c0103f6a <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103f6a:	55                   	push   %ebp
c0103f6b:	89 e5                	mov    %esp,%ebp
c0103f6d:	57                   	push   %edi
c0103f6e:	56                   	push   %esi
c0103f6f:	53                   	push   %ebx
c0103f70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103f76:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103f7d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103f84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103f8b:	c7 04 24 77 6d 10 c0 	movl   $0xc0106d77,(%esp)
c0103f92:	e8 b0 c3 ff ff       	call   c0100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f97:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f9e:	e9 15 01 00 00       	jmp    c01040b8 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fa3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fa6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fa9:	89 d0                	mov    %edx,%eax
c0103fab:	c1 e0 02             	shl    $0x2,%eax
c0103fae:	01 d0                	add    %edx,%eax
c0103fb0:	c1 e0 02             	shl    $0x2,%eax
c0103fb3:	01 c8                	add    %ecx,%eax
c0103fb5:	8b 50 08             	mov    0x8(%eax),%edx
c0103fb8:	8b 40 04             	mov    0x4(%eax),%eax
c0103fbb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103fbe:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103fc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fc7:	89 d0                	mov    %edx,%eax
c0103fc9:	c1 e0 02             	shl    $0x2,%eax
c0103fcc:	01 d0                	add    %edx,%eax
c0103fce:	c1 e0 02             	shl    $0x2,%eax
c0103fd1:	01 c8                	add    %ecx,%eax
c0103fd3:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fd6:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103fdc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103fdf:	01 c8                	add    %ecx,%eax
c0103fe1:	11 da                	adc    %ebx,%edx
c0103fe3:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103fe6:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103fe9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fef:	89 d0                	mov    %edx,%eax
c0103ff1:	c1 e0 02             	shl    $0x2,%eax
c0103ff4:	01 d0                	add    %edx,%eax
c0103ff6:	c1 e0 02             	shl    $0x2,%eax
c0103ff9:	01 c8                	add    %ecx,%eax
c0103ffb:	83 c0 14             	add    $0x14,%eax
c0103ffe:	8b 00                	mov    (%eax),%eax
c0104000:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104006:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104009:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010400c:	83 c0 ff             	add    $0xffffffff,%eax
c010400f:	83 d2 ff             	adc    $0xffffffff,%edx
c0104012:	89 c6                	mov    %eax,%esi
c0104014:	89 d7                	mov    %edx,%edi
c0104016:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104019:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010401c:	89 d0                	mov    %edx,%eax
c010401e:	c1 e0 02             	shl    $0x2,%eax
c0104021:	01 d0                	add    %edx,%eax
c0104023:	c1 e0 02             	shl    $0x2,%eax
c0104026:	01 c8                	add    %ecx,%eax
c0104028:	8b 48 0c             	mov    0xc(%eax),%ecx
c010402b:	8b 58 10             	mov    0x10(%eax),%ebx
c010402e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104034:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104038:	89 74 24 14          	mov    %esi,0x14(%esp)
c010403c:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104040:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104043:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104046:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010404a:	89 54 24 10          	mov    %edx,0x10(%esp)
c010404e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104052:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104056:	c7 04 24 84 6d 10 c0 	movl   $0xc0106d84,(%esp)
c010405d:	e8 e5 c2 ff ff       	call   c0100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104062:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104065:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104068:	89 d0                	mov    %edx,%eax
c010406a:	c1 e0 02             	shl    $0x2,%eax
c010406d:	01 d0                	add    %edx,%eax
c010406f:	c1 e0 02             	shl    $0x2,%eax
c0104072:	01 c8                	add    %ecx,%eax
c0104074:	83 c0 14             	add    $0x14,%eax
c0104077:	8b 00                	mov    (%eax),%eax
c0104079:	83 f8 01             	cmp    $0x1,%eax
c010407c:	75 36                	jne    c01040b4 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010407e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104081:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104084:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104087:	77 2b                	ja     c01040b4 <page_init+0x14a>
c0104089:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010408c:	72 05                	jb     c0104093 <page_init+0x129>
c010408e:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104091:	73 21                	jae    c01040b4 <page_init+0x14a>
c0104093:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104097:	77 1b                	ja     c01040b4 <page_init+0x14a>
c0104099:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010409d:	72 09                	jb     c01040a8 <page_init+0x13e>
c010409f:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01040a6:	77 0c                	ja     c01040b4 <page_init+0x14a>
                maxpa = end;
c01040a8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01040ab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01040ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01040b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01040b4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01040b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040bb:	8b 00                	mov    (%eax),%eax
c01040bd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040c0:	0f 8f dd fe ff ff    	jg     c0103fa3 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01040c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040ca:	72 1d                	jb     c01040e9 <page_init+0x17f>
c01040cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01040d0:	77 09                	ja     c01040db <page_init+0x171>
c01040d2:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01040d9:	76 0e                	jbe    c01040e9 <page_init+0x17f>
        maxpa = KMEMSIZE;
c01040db:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01040e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01040e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01040ef:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01040f3:	c1 ea 0c             	shr    $0xc,%edx
c01040f6:	a3 e0 98 11 c0       	mov    %eax,0xc01198e0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01040fb:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104102:	b8 88 99 11 c0       	mov    $0xc0119988,%eax
c0104107:	8d 50 ff             	lea    -0x1(%eax),%edx
c010410a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010410d:	01 d0                	add    %edx,%eax
c010410f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104112:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104115:	ba 00 00 00 00       	mov    $0x0,%edx
c010411a:	f7 75 ac             	divl   -0x54(%ebp)
c010411d:	89 d0                	mov    %edx,%eax
c010411f:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104122:	29 c2                	sub    %eax,%edx
c0104124:	89 d0                	mov    %edx,%eax
c0104126:	a3 84 99 11 c0       	mov    %eax,0xc0119984

    for (i = 0; i < npage; i ++) {
c010412b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104132:	eb 2f                	jmp    c0104163 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0104134:	8b 0d 84 99 11 c0    	mov    0xc0119984,%ecx
c010413a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010413d:	89 d0                	mov    %edx,%eax
c010413f:	c1 e0 02             	shl    $0x2,%eax
c0104142:	01 d0                	add    %edx,%eax
c0104144:	c1 e0 02             	shl    $0x2,%eax
c0104147:	01 c8                	add    %ecx,%eax
c0104149:	83 c0 04             	add    $0x4,%eax
c010414c:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104153:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104156:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104159:	8b 55 90             	mov    -0x70(%ebp),%edx
c010415c:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c010415f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104163:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104166:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c010416b:	39 c2                	cmp    %eax,%edx
c010416d:	72 c5                	jb     c0104134 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c010416f:	8b 15 e0 98 11 c0    	mov    0xc01198e0,%edx
c0104175:	89 d0                	mov    %edx,%eax
c0104177:	c1 e0 02             	shl    $0x2,%eax
c010417a:	01 d0                	add    %edx,%eax
c010417c:	c1 e0 02             	shl    $0x2,%eax
c010417f:	89 c2                	mov    %eax,%edx
c0104181:	a1 84 99 11 c0       	mov    0xc0119984,%eax
c0104186:	01 d0                	add    %edx,%eax
c0104188:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010418b:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104192:	77 23                	ja     c01041b7 <page_init+0x24d>
c0104194:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104197:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010419b:	c7 44 24 08 b4 6d 10 	movl   $0xc0106db4,0x8(%esp)
c01041a2:	c0 
c01041a3:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01041aa:	00 
c01041ab:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01041b2:	e8 09 cb ff ff       	call   c0100cc0 <__panic>
c01041b7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01041ba:	05 00 00 00 40       	add    $0x40000000,%eax
c01041bf:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01041c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041c9:	e9 74 01 00 00       	jmp    c0104342 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01041ce:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041d4:	89 d0                	mov    %edx,%eax
c01041d6:	c1 e0 02             	shl    $0x2,%eax
c01041d9:	01 d0                	add    %edx,%eax
c01041db:	c1 e0 02             	shl    $0x2,%eax
c01041de:	01 c8                	add    %ecx,%eax
c01041e0:	8b 50 08             	mov    0x8(%eax),%edx
c01041e3:	8b 40 04             	mov    0x4(%eax),%eax
c01041e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01041e9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01041ec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041ef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041f2:	89 d0                	mov    %edx,%eax
c01041f4:	c1 e0 02             	shl    $0x2,%eax
c01041f7:	01 d0                	add    %edx,%eax
c01041f9:	c1 e0 02             	shl    $0x2,%eax
c01041fc:	01 c8                	add    %ecx,%eax
c01041fe:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104201:	8b 58 10             	mov    0x10(%eax),%ebx
c0104204:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104207:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010420a:	01 c8                	add    %ecx,%eax
c010420c:	11 da                	adc    %ebx,%edx
c010420e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104211:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104214:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104217:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010421a:	89 d0                	mov    %edx,%eax
c010421c:	c1 e0 02             	shl    $0x2,%eax
c010421f:	01 d0                	add    %edx,%eax
c0104221:	c1 e0 02             	shl    $0x2,%eax
c0104224:	01 c8                	add    %ecx,%eax
c0104226:	83 c0 14             	add    $0x14,%eax
c0104229:	8b 00                	mov    (%eax),%eax
c010422b:	83 f8 01             	cmp    $0x1,%eax
c010422e:	0f 85 0a 01 00 00    	jne    c010433e <page_init+0x3d4>
            if (begin < freemem) {
c0104234:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104237:	ba 00 00 00 00       	mov    $0x0,%edx
c010423c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010423f:	72 17                	jb     c0104258 <page_init+0x2ee>
c0104241:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104244:	77 05                	ja     c010424b <page_init+0x2e1>
c0104246:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104249:	76 0d                	jbe    c0104258 <page_init+0x2ee>
                begin = freemem;
c010424b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010424e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104251:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104258:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010425c:	72 1d                	jb     c010427b <page_init+0x311>
c010425e:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104262:	77 09                	ja     c010426d <page_init+0x303>
c0104264:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010426b:	76 0e                	jbe    c010427b <page_init+0x311>
                end = KMEMSIZE;
c010426d:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104274:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010427b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010427e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104281:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104284:	0f 87 b4 00 00 00    	ja     c010433e <page_init+0x3d4>
c010428a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010428d:	72 09                	jb     c0104298 <page_init+0x32e>
c010428f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104292:	0f 83 a6 00 00 00    	jae    c010433e <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104298:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010429f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01042a2:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01042a5:	01 d0                	add    %edx,%eax
c01042a7:	83 e8 01             	sub    $0x1,%eax
c01042aa:	89 45 98             	mov    %eax,-0x68(%ebp)
c01042ad:	8b 45 98             	mov    -0x68(%ebp),%eax
c01042b0:	ba 00 00 00 00       	mov    $0x0,%edx
c01042b5:	f7 75 9c             	divl   -0x64(%ebp)
c01042b8:	89 d0                	mov    %edx,%eax
c01042ba:	8b 55 98             	mov    -0x68(%ebp),%edx
c01042bd:	29 c2                	sub    %eax,%edx
c01042bf:	89 d0                	mov    %edx,%eax
c01042c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01042c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042c9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01042cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01042cf:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01042d2:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01042d5:	ba 00 00 00 00       	mov    $0x0,%edx
c01042da:	89 c7                	mov    %eax,%edi
c01042dc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01042e2:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01042e5:	89 d0                	mov    %edx,%eax
c01042e7:	83 e0 00             	and    $0x0,%eax
c01042ea:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01042ed:	8b 45 80             	mov    -0x80(%ebp),%eax
c01042f0:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01042f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01042f6:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01042f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01042fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042ff:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104302:	77 3a                	ja     c010433e <page_init+0x3d4>
c0104304:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104307:	72 05                	jb     c010430e <page_init+0x3a4>
c0104309:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010430c:	73 30                	jae    c010433e <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010430e:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104311:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104314:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104317:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010431a:	29 c8                	sub    %ecx,%eax
c010431c:	19 da                	sbb    %ebx,%edx
c010431e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104322:	c1 ea 0c             	shr    $0xc,%edx
c0104325:	89 c3                	mov    %eax,%ebx
c0104327:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010432a:	89 04 24             	mov    %eax,(%esp)
c010432d:	e8 bd f8 ff ff       	call   c0103bef <pa2page>
c0104332:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104336:	89 04 24             	mov    %eax,(%esp)
c0104339:	e8 78 fb ff ff       	call   c0103eb6 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010433e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104342:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104345:	8b 00                	mov    (%eax),%eax
c0104347:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010434a:	0f 8f 7e fe ff ff    	jg     c01041ce <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104350:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104356:	5b                   	pop    %ebx
c0104357:	5e                   	pop    %esi
c0104358:	5f                   	pop    %edi
c0104359:	5d                   	pop    %ebp
c010435a:	c3                   	ret    

c010435b <enable_paging>:

static void
enable_paging(void) {
c010435b:	55                   	push   %ebp
c010435c:	89 e5                	mov    %esp,%ebp
c010435e:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104361:	a1 80 99 11 c0       	mov    0xc0119980,%eax
c0104366:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104369:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010436c:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010436f:	0f 20 c0             	mov    %cr0,%eax
c0104372:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104375:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104378:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010437b:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104382:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104386:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104389:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010438c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010438f:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104392:	c9                   	leave  
c0104393:	c3                   	ret    

c0104394 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104394:	55                   	push   %ebp
c0104395:	89 e5                	mov    %esp,%ebp
c0104397:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010439a:	8b 45 14             	mov    0x14(%ebp),%eax
c010439d:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043a0:	31 d0                	xor    %edx,%eax
c01043a2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043a7:	85 c0                	test   %eax,%eax
c01043a9:	74 24                	je     c01043cf <boot_map_segment+0x3b>
c01043ab:	c7 44 24 0c e6 6d 10 	movl   $0xc0106de6,0xc(%esp)
c01043b2:	c0 
c01043b3:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c01043ba:	c0 
c01043bb:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01043c2:	00 
c01043c3:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01043ca:	e8 f1 c8 ff ff       	call   c0100cc0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01043cf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01043d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043d9:	25 ff 0f 00 00       	and    $0xfff,%eax
c01043de:	89 c2                	mov    %eax,%edx
c01043e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01043e3:	01 c2                	add    %eax,%edx
c01043e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043e8:	01 d0                	add    %edx,%eax
c01043ea:	83 e8 01             	sub    $0x1,%eax
c01043ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043f3:	ba 00 00 00 00       	mov    $0x0,%edx
c01043f8:	f7 75 f0             	divl   -0x10(%ebp)
c01043fb:	89 d0                	mov    %edx,%eax
c01043fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104400:	29 c2                	sub    %eax,%edx
c0104402:	89 d0                	mov    %edx,%eax
c0104404:	c1 e8 0c             	shr    $0xc,%eax
c0104407:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010440a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010440d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104410:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104413:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104418:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010441b:	8b 45 14             	mov    0x14(%ebp),%eax
c010441e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104424:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104429:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010442c:	eb 6b                	jmp    c0104499 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010442e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104435:	00 
c0104436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104439:	89 44 24 04          	mov    %eax,0x4(%esp)
c010443d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104440:	89 04 24             	mov    %eax,(%esp)
c0104443:	e8 cc 01 00 00       	call   c0104614 <get_pte>
c0104448:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010444b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010444f:	75 24                	jne    c0104475 <boot_map_segment+0xe1>
c0104451:	c7 44 24 0c 12 6e 10 	movl   $0xc0106e12,0xc(%esp)
c0104458:	c0 
c0104459:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104460:	c0 
c0104461:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104468:	00 
c0104469:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104470:	e8 4b c8 ff ff       	call   c0100cc0 <__panic>
        *ptep = pa | PTE_P | perm;
c0104475:	8b 45 18             	mov    0x18(%ebp),%eax
c0104478:	8b 55 14             	mov    0x14(%ebp),%edx
c010447b:	09 d0                	or     %edx,%eax
c010447d:	83 c8 01             	or     $0x1,%eax
c0104480:	89 c2                	mov    %eax,%edx
c0104482:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104485:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104487:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010448b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104492:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010449d:	75 8f                	jne    c010442e <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010449f:	c9                   	leave  
c01044a0:	c3                   	ret    

c01044a1 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01044a1:	55                   	push   %ebp
c01044a2:	89 e5                	mov    %esp,%ebp
c01044a4:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01044a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044ae:	e8 22 fa ff ff       	call   c0103ed5 <alloc_pages>
c01044b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01044b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044ba:	75 1c                	jne    c01044d8 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01044bc:	c7 44 24 08 1f 6e 10 	movl   $0xc0106e1f,0x8(%esp)
c01044c3:	c0 
c01044c4:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01044cb:	00 
c01044cc:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01044d3:	e8 e8 c7 ff ff       	call   c0100cc0 <__panic>
    }
    return page2kva(p);
c01044d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044db:	89 04 24             	mov    %eax,(%esp)
c01044de:	e8 5b f7 ff ff       	call   c0103c3e <page2kva>
}
c01044e3:	c9                   	leave  
c01044e4:	c3                   	ret    

c01044e5 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01044e5:	55                   	push   %ebp
c01044e6:	89 e5                	mov    %esp,%ebp
c01044e8:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01044eb:	e8 93 f9 ff ff       	call   c0103e83 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01044f0:	e8 75 fa ff ff       	call   c0103f6a <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01044f5:	e8 cd 04 00 00       	call   c01049c7 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01044fa:	e8 a2 ff ff ff       	call   c01044a1 <boot_alloc_page>
c01044ff:	a3 e4 98 11 c0       	mov    %eax,0xc01198e4
    memset(boot_pgdir, 0, PGSIZE);
c0104504:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104509:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104510:	00 
c0104511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104518:	00 
c0104519:	89 04 24             	mov    %eax,(%esp)
c010451c:	e8 62 1b 00 00       	call   c0106083 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104521:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104526:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104529:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104530:	77 23                	ja     c0104555 <pmm_init+0x70>
c0104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104535:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104539:	c7 44 24 08 b4 6d 10 	movl   $0xc0106db4,0x8(%esp)
c0104540:	c0 
c0104541:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104548:	00 
c0104549:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104550:	e8 6b c7 ff ff       	call   c0100cc0 <__panic>
c0104555:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104558:	05 00 00 00 40       	add    $0x40000000,%eax
c010455d:	a3 80 99 11 c0       	mov    %eax,0xc0119980

    check_pgdir();
c0104562:	e8 7e 04 00 00       	call   c01049e5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104567:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010456c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104572:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104577:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010457a:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104581:	77 23                	ja     c01045a6 <pmm_init+0xc1>
c0104583:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104586:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010458a:	c7 44 24 08 b4 6d 10 	movl   $0xc0106db4,0x8(%esp)
c0104591:	c0 
c0104592:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104599:	00 
c010459a:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01045a1:	e8 1a c7 ff ff       	call   c0100cc0 <__panic>
c01045a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a9:	05 00 00 00 40       	add    $0x40000000,%eax
c01045ae:	83 c8 03             	or     $0x3,%eax
c01045b1:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01045b3:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01045b8:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01045bf:	00 
c01045c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01045c7:	00 
c01045c8:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01045cf:	38 
c01045d0:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01045d7:	c0 
c01045d8:	89 04 24             	mov    %eax,(%esp)
c01045db:	e8 b4 fd ff ff       	call   c0104394 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01045e0:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01045e5:	8b 15 e4 98 11 c0    	mov    0xc01198e4,%edx
c01045eb:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01045f1:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01045f3:	e8 63 fd ff ff       	call   c010435b <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01045f8:	e8 97 f7 ff ff       	call   c0103d94 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01045fd:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104608:	e8 73 0a 00 00       	call   c0105080 <check_boot_pgdir>
    print_pgdir();
c010460d:	e8 00 0f 00 00       	call   c0105512 <print_pgdir>

}
c0104612:	c9                   	leave  
c0104613:	c3                   	ret    

c0104614 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104614:	55                   	push   %ebp
c0104615:	89 e5                	mov    %esp,%ebp
c0104617:	83 ec 48             	sub    $0x48,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission

            // (8) return page table entry

    pde_t *pdep = pgdir+PDX(la);
c010461a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010461d:	c1 e8 16             	shr    $0x16,%eax
c0104620:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104627:	8b 45 08             	mov    0x8(%ebp),%eax
c010462a:	01 d0                	add    %edx,%eax
c010462c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (((*pdep) & PTE_P)==0) {
c010462f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104632:	8b 00                	mov    (%eax),%eax
c0104634:	83 e0 01             	and    $0x1,%eax
c0104637:	85 c0                	test   %eax,%eax
c0104639:	0f 85 07 01 00 00    	jne    c0104746 <get_pte+0x132>
		if (create==0)
c010463f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104643:	75 0a                	jne    c010464f <get_pte+0x3b>
			return NULL;
c0104645:	b8 00 00 00 00       	mov    $0x0,%eax
c010464a:	e9 59 01 00 00       	jmp    c01047a8 <get_pte+0x194>
		struct Page *p = alloc_page();
c010464f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104656:	e8 7a f8 ff ff       	call   c0103ed5 <alloc_pages>
c010465b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		set_page_ref(p,1);
c010465e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104665:	00 
c0104666:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104669:	89 04 24             	mov    %eax,(%esp)
c010466c:	e8 69 f6 ff ff       	call   c0103cda <set_page_ref>
		*pdep =(page2pa(p) | PTE_P | PTE_W | PTE_U);
c0104671:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104674:	89 04 24             	mov    %eax,(%esp)
c0104677:	e8 5d f5 ff ff       	call   c0103bd9 <page2pa>
c010467c:	83 c8 07             	or     $0x7,%eax
c010467f:	89 c2                	mov    %eax,%edx
c0104681:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104684:	89 10                	mov    %edx,(%eax)
		memset(KADDR(page2pa(p)),0,PGSIZE);
c0104686:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104689:	89 04 24             	mov    %eax,(%esp)
c010468c:	e8 48 f5 ff ff       	call   c0103bd9 <page2pa>
c0104691:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104694:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104697:	c1 e8 0c             	shr    $0xc,%eax
c010469a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010469d:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c01046a2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01046a5:	72 23                	jb     c01046ca <get_pte+0xb6>
c01046a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046ae:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c01046b5:	c0 
c01046b6:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c01046bd:	00 
c01046be:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01046c5:	e8 f6 c5 ff ff       	call   c0100cc0 <__panic>
c01046ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046cd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01046d9:	00 
c01046da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046e1:	00 
c01046e2:	89 04 24             	mov    %eax,(%esp)
c01046e5:	e8 99 19 00 00       	call   c0106083 <memset>
		return KADDR(page2pa(p)) + PTX(la);
c01046ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ed:	89 04 24             	mov    %eax,(%esp)
c01046f0:	e8 e4 f4 ff ff       	call   c0103bd9 <page2pa>
c01046f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01046f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046fb:	c1 e8 0c             	shr    $0xc,%eax
c01046fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104701:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0104706:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104709:	72 23                	jb     c010472e <get_pte+0x11a>
c010470b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010470e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104712:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c0104719:	c0 
c010471a:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c0104721:	00 
c0104722:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104729:	e8 92 c5 ff ff       	call   c0100cc0 <__panic>
c010472e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104731:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104736:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104739:	c1 ea 0c             	shr    $0xc,%edx
c010473c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104742:	01 d0                	add    %edx,%eax
c0104744:	eb 62                	jmp    c01047a8 <get_pte+0x194>
    } else {
        pde_t *p = KADDR(PTE_ADDR(*pdep));
c0104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104749:	8b 00                	mov    (%eax),%eax
c010474b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104750:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104753:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104756:	c1 e8 0c             	shr    $0xc,%eax
c0104759:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010475c:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0104761:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104764:	72 23                	jb     c0104789 <get_pte+0x175>
c0104766:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104769:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010476d:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c0104774:	c0 
c0104775:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
c010477c:	00 
c010477d:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104784:	e8 37 c5 ff ff       	call   c0100cc0 <__panic>
c0104789:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010478c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104791:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		p = p+PTX(la);
c0104794:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104797:	c1 e8 0c             	shr    $0xc,%eax
c010479a:	25 ff 03 00 00       	and    $0x3ff,%eax
c010479f:	c1 e0 02             	shl    $0x2,%eax
c01047a2:	01 45 d4             	add    %eax,-0x2c(%ebp)
		return p;
c01047a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    }
}
c01047a8:	c9                   	leave  
c01047a9:	c3                   	ret    

c01047aa <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01047aa:	55                   	push   %ebp
c01047ab:	89 e5                	mov    %esp,%ebp
c01047ad:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047b7:	00 
c01047b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c2:	89 04 24             	mov    %eax,(%esp)
c01047c5:	e8 4a fe ff ff       	call   c0104614 <get_pte>
c01047ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01047cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01047d1:	74 08                	je     c01047db <get_page+0x31>
        *ptep_store = ptep;
c01047d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01047d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047d9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01047db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047df:	74 1b                	je     c01047fc <get_page+0x52>
c01047e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e4:	8b 00                	mov    (%eax),%eax
c01047e6:	83 e0 01             	and    $0x1,%eax
c01047e9:	85 c0                	test   %eax,%eax
c01047eb:	74 0f                	je     c01047fc <get_page+0x52>
        return pa2page(*ptep);
c01047ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f0:	8b 00                	mov    (%eax),%eax
c01047f2:	89 04 24             	mov    %eax,(%esp)
c01047f5:	e8 f5 f3 ff ff       	call   c0103bef <pa2page>
c01047fa:	eb 05                	jmp    c0104801 <get_page+0x57>
    }
    return NULL;
c01047fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104801:	c9                   	leave  
c0104802:	c3                   	ret    

c0104803 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104803:	55                   	push   %ebp
c0104804:	89 e5                	mov    %esp,%ebp
c0104806:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (ptep!=NULL) {
c0104809:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010480d:	74 5c                	je     c010486b <page_remove_pte+0x68>
		struct Page *page=pte2page(*ptep);
c010480f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104812:	8b 00                	mov    (%eax),%eax
c0104814:	89 04 24             	mov    %eax,(%esp)
c0104817:	e8 76 f4 ff ff       	call   c0103c92 <pte2page>
c010481c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		page_ref_dec(page);
c010481f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104822:	89 04 24             	mov    %eax,(%esp)
c0104825:	e8 d4 f4 ff ff       	call   c0103cfe <page_ref_dec>
		if (page->ref == 0) {
c010482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010482d:	8b 00                	mov    (%eax),%eax
c010482f:	85 c0                	test   %eax,%eax
c0104831:	75 26                	jne    c0104859 <page_remove_pte+0x56>
		   free_page(page);
c0104833:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010483a:	00 
c010483b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483e:	89 04 24             	mov    %eax,(%esp)
c0104841:	e8 c7 f6 ff ff       	call   c0103f0d <free_pages>
		   pte_t p = *ptep;
c0104846:	8b 45 10             	mov    0x10(%ebp),%eax
c0104849:	8b 00                	mov    (%eax),%eax
c010484b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		   *ptep  = p - PTE_P;
c010484e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104851:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104854:	8b 45 10             	mov    0x10(%ebp),%eax
c0104857:	89 10                	mov    %edx,(%eax)
		}
		tlb_invalidate(pgdir, la);
c0104859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010485c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104860:	8b 45 08             	mov    0x8(%ebp),%eax
c0104863:	89 04 24             	mov    %eax,(%esp)
c0104866:	e8 ff 00 00 00       	call   c010496a <tlb_invalidate>
    }
}
c010486b:	c9                   	leave  
c010486c:	c3                   	ret    

c010486d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010486d:	55                   	push   %ebp
c010486e:	89 e5                	mov    %esp,%ebp
c0104870:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104873:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010487a:	00 
c010487b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010487e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104882:	8b 45 08             	mov    0x8(%ebp),%eax
c0104885:	89 04 24             	mov    %eax,(%esp)
c0104888:	e8 87 fd ff ff       	call   c0104614 <get_pte>
c010488d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104894:	74 19                	je     c01048af <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104899:	89 44 24 08          	mov    %eax,0x8(%esp)
c010489d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a7:	89 04 24             	mov    %eax,(%esp)
c01048aa:	e8 54 ff ff ff       	call   c0104803 <page_remove_pte>
    }
}
c01048af:	c9                   	leave  
c01048b0:	c3                   	ret    

c01048b1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01048b1:	55                   	push   %ebp
c01048b2:	89 e5                	mov    %esp,%ebp
c01048b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01048b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01048be:	00 
c01048bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01048c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c9:	89 04 24             	mov    %eax,(%esp)
c01048cc:	e8 43 fd ff ff       	call   c0104614 <get_pte>
c01048d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01048d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048d8:	75 0a                	jne    c01048e4 <page_insert+0x33>
        return -E_NO_MEM;
c01048da:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01048df:	e9 84 00 00 00       	jmp    c0104968 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01048e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048e7:	89 04 24             	mov    %eax,(%esp)
c01048ea:	e8 f8 f3 ff ff       	call   c0103ce7 <page_ref_inc>
    if (*ptep & PTE_P) {
c01048ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048f2:	8b 00                	mov    (%eax),%eax
c01048f4:	83 e0 01             	and    $0x1,%eax
c01048f7:	85 c0                	test   %eax,%eax
c01048f9:	74 3e                	je     c0104939 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01048fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048fe:	8b 00                	mov    (%eax),%eax
c0104900:	89 04 24             	mov    %eax,(%esp)
c0104903:	e8 8a f3 ff ff       	call   c0103c92 <pte2page>
c0104908:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010490e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104911:	75 0d                	jne    c0104920 <page_insert+0x6f>
            page_ref_dec(page);
c0104913:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104916:	89 04 24             	mov    %eax,(%esp)
c0104919:	e8 e0 f3 ff ff       	call   c0103cfe <page_ref_dec>
c010491e:	eb 19                	jmp    c0104939 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104920:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104923:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104927:	8b 45 10             	mov    0x10(%ebp),%eax
c010492a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010492e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104931:	89 04 24             	mov    %eax,(%esp)
c0104934:	e8 ca fe ff ff       	call   c0104803 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010493c:	89 04 24             	mov    %eax,(%esp)
c010493f:	e8 95 f2 ff ff       	call   c0103bd9 <page2pa>
c0104944:	0b 45 14             	or     0x14(%ebp),%eax
c0104947:	83 c8 01             	or     $0x1,%eax
c010494a:	89 c2                	mov    %eax,%edx
c010494c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010494f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104951:	8b 45 10             	mov    0x10(%ebp),%eax
c0104954:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104958:	8b 45 08             	mov    0x8(%ebp),%eax
c010495b:	89 04 24             	mov    %eax,(%esp)
c010495e:	e8 07 00 00 00       	call   c010496a <tlb_invalidate>
    return 0;
c0104963:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104968:	c9                   	leave  
c0104969:	c3                   	ret    

c010496a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010496a:	55                   	push   %ebp
c010496b:	89 e5                	mov    %esp,%ebp
c010496d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104970:	0f 20 d8             	mov    %cr3,%eax
c0104973:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104976:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104979:	89 c2                	mov    %eax,%edx
c010497b:	8b 45 08             	mov    0x8(%ebp),%eax
c010497e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104981:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104988:	77 23                	ja     c01049ad <tlb_invalidate+0x43>
c010498a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010498d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104991:	c7 44 24 08 b4 6d 10 	movl   $0xc0106db4,0x8(%esp)
c0104998:	c0 
c0104999:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01049a0:	00 
c01049a1:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01049a8:	e8 13 c3 ff ff       	call   c0100cc0 <__panic>
c01049ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049b0:	05 00 00 00 40       	add    $0x40000000,%eax
c01049b5:	39 c2                	cmp    %eax,%edx
c01049b7:	75 0c                	jne    c01049c5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01049b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01049bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049c2:	0f 01 38             	invlpg (%eax)
    }
}
c01049c5:	c9                   	leave  
c01049c6:	c3                   	ret    

c01049c7 <check_alloc_page>:

static void
check_alloc_page(void) {
c01049c7:	55                   	push   %ebp
c01049c8:	89 e5                	mov    %esp,%ebp
c01049ca:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01049cd:	a1 7c 99 11 c0       	mov    0xc011997c,%eax
c01049d2:	8b 40 18             	mov    0x18(%eax),%eax
c01049d5:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01049d7:	c7 04 24 38 6e 10 c0 	movl   $0xc0106e38,(%esp)
c01049de:	e8 64 b9 ff ff       	call   c0100347 <cprintf>
}
c01049e3:	c9                   	leave  
c01049e4:	c3                   	ret    

c01049e5 <check_pgdir>:

static void
check_pgdir(void) {
c01049e5:	55                   	push   %ebp
c01049e6:	89 e5                	mov    %esp,%ebp
c01049e8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01049eb:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c01049f0:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01049f5:	76 24                	jbe    c0104a1b <check_pgdir+0x36>
c01049f7:	c7 44 24 0c 57 6e 10 	movl   $0xc0106e57,0xc(%esp)
c01049fe:	c0 
c01049ff:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104a06:	c0 
c0104a07:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104a0e:	00 
c0104a0f:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104a16:	e8 a5 c2 ff ff       	call   c0100cc0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104a1b:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104a20:	85 c0                	test   %eax,%eax
c0104a22:	74 0e                	je     c0104a32 <check_pgdir+0x4d>
c0104a24:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104a29:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a2e:	85 c0                	test   %eax,%eax
c0104a30:	74 24                	je     c0104a56 <check_pgdir+0x71>
c0104a32:	c7 44 24 0c 74 6e 10 	movl   $0xc0106e74,0xc(%esp)
c0104a39:	c0 
c0104a3a:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104a41:	c0 
c0104a42:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104a49:	00 
c0104a4a:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104a51:	e8 6a c2 ff ff       	call   c0100cc0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104a56:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a62:	00 
c0104a63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a6a:	00 
c0104a6b:	89 04 24             	mov    %eax,(%esp)
c0104a6e:	e8 37 fd ff ff       	call   c01047aa <get_page>
c0104a73:	85 c0                	test   %eax,%eax
c0104a75:	74 24                	je     c0104a9b <check_pgdir+0xb6>
c0104a77:	c7 44 24 0c ac 6e 10 	movl   $0xc0106eac,0xc(%esp)
c0104a7e:	c0 
c0104a7f:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104a86:	c0 
c0104a87:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104a8e:	00 
c0104a8f:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104a96:	e8 25 c2 ff ff       	call   c0100cc0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104aa2:	e8 2e f4 ff ff       	call   c0103ed5 <alloc_pages>
c0104aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104aaa:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104aaf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104ab6:	00 
c0104ab7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104abe:	00 
c0104abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ac2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ac6:	89 04 24             	mov    %eax,(%esp)
c0104ac9:	e8 e3 fd ff ff       	call   c01048b1 <page_insert>
c0104ace:	85 c0                	test   %eax,%eax
c0104ad0:	74 24                	je     c0104af6 <check_pgdir+0x111>
c0104ad2:	c7 44 24 0c d4 6e 10 	movl   $0xc0106ed4,0xc(%esp)
c0104ad9:	c0 
c0104ada:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104ae1:	c0 
c0104ae2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104ae9:	00 
c0104aea:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104af1:	e8 ca c1 ff ff       	call   c0100cc0 <__panic>
    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104af6:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104afb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b02:	00 
c0104b03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b0a:	00 
c0104b0b:	89 04 24             	mov    %eax,(%esp)
c0104b0e:	e8 01 fb ff ff       	call   c0104614 <get_pte>
c0104b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b1a:	75 24                	jne    c0104b40 <check_pgdir+0x15b>
c0104b1c:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104b23:	c0 
c0104b24:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104b2b:	c0 
c0104b2c:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104b33:	00 
c0104b34:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104b3b:	e8 80 c1 ff ff       	call   c0100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
c0104b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b43:	8b 00                	mov    (%eax),%eax
c0104b45:	89 04 24             	mov    %eax,(%esp)
c0104b48:	e8 a2 f0 ff ff       	call   c0103bef <pa2page>
c0104b4d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b50:	74 24                	je     c0104b76 <check_pgdir+0x191>
c0104b52:	c7 44 24 0c 2d 6f 10 	movl   $0xc0106f2d,0xc(%esp)
c0104b59:	c0 
c0104b5a:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104b61:	c0 
c0104b62:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104b69:	00 
c0104b6a:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104b71:	e8 4a c1 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p1) == 1);
c0104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b79:	89 04 24             	mov    %eax,(%esp)
c0104b7c:	e8 4f f1 ff ff       	call   c0103cd0 <page_ref>
c0104b81:	83 f8 01             	cmp    $0x1,%eax
c0104b84:	74 24                	je     c0104baa <check_pgdir+0x1c5>
c0104b86:	c7 44 24 0c 42 6f 10 	movl   $0xc0106f42,0xc(%esp)
c0104b8d:	c0 
c0104b8e:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104b95:	c0 
c0104b96:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104b9d:	00 
c0104b9e:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104ba5:	e8 16 c1 ff ff       	call   c0100cc0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104baa:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104baf:	8b 00                	mov    (%eax),%eax
c0104bb1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bbc:	c1 e8 0c             	shr    $0xc,%eax
c0104bbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104bc2:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0104bc7:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104bca:	72 23                	jb     c0104bef <check_pgdir+0x20a>
c0104bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bcf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104bd3:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c0104bda:	c0 
c0104bdb:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104be2:	00 
c0104be3:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104bea:	e8 d1 c0 ff ff       	call   c0100cc0 <__panic>
c0104bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104bf2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104bf7:	83 c0 04             	add    $0x4,%eax
c0104bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104bfd:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104c02:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c09:	00 
c0104c0a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c11:	00 
c0104c12:	89 04 24             	mov    %eax,(%esp)
c0104c15:	e8 fa f9 ff ff       	call   c0104614 <get_pte>
c0104c1a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104c1d:	74 24                	je     c0104c43 <check_pgdir+0x25e>
c0104c1f:	c7 44 24 0c 54 6f 10 	movl   $0xc0106f54,0xc(%esp)
c0104c26:	c0 
c0104c27:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104c2e:	c0 
c0104c2f:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104c36:	00 
c0104c37:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104c3e:	e8 7d c0 ff ff       	call   c0100cc0 <__panic>

    p2 = alloc_page();
c0104c43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c4a:	e8 86 f2 ff ff       	call   c0103ed5 <alloc_pages>
c0104c4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104c52:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104c57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104c5e:	00 
c0104c5f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c66:	00 
c0104c67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104c6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c6e:	89 04 24             	mov    %eax,(%esp)
c0104c71:	e8 3b fc ff ff       	call   c01048b1 <page_insert>
c0104c76:	85 c0                	test   %eax,%eax
c0104c78:	74 24                	je     c0104c9e <check_pgdir+0x2b9>
c0104c7a:	c7 44 24 0c 7c 6f 10 	movl   $0xc0106f7c,0xc(%esp)
c0104c81:	c0 
c0104c82:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104c89:	c0 
c0104c8a:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104c91:	00 
c0104c92:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104c99:	e8 22 c0 ff ff       	call   c0100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c9e:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104ca3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104caa:	00 
c0104cab:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cb2:	00 
c0104cb3:	89 04 24             	mov    %eax,(%esp)
c0104cb6:	e8 59 f9 ff ff       	call   c0104614 <get_pte>
c0104cbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104cc2:	75 24                	jne    c0104ce8 <check_pgdir+0x303>
c0104cc4:	c7 44 24 0c b4 6f 10 	movl   $0xc0106fb4,0xc(%esp)
c0104ccb:	c0 
c0104ccc:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104cd3:	c0 
c0104cd4:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104cdb:	00 
c0104cdc:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104ce3:	e8 d8 bf ff ff       	call   c0100cc0 <__panic>
    assert(*ptep & PTE_U);
c0104ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ceb:	8b 00                	mov    (%eax),%eax
c0104ced:	83 e0 04             	and    $0x4,%eax
c0104cf0:	85 c0                	test   %eax,%eax
c0104cf2:	75 24                	jne    c0104d18 <check_pgdir+0x333>
c0104cf4:	c7 44 24 0c e4 6f 10 	movl   $0xc0106fe4,0xc(%esp)
c0104cfb:	c0 
c0104cfc:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104d03:	c0 
c0104d04:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104d0b:	00 
c0104d0c:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104d13:	e8 a8 bf ff ff       	call   c0100cc0 <__panic>
    assert(*ptep & PTE_W);
c0104d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d1b:	8b 00                	mov    (%eax),%eax
c0104d1d:	83 e0 02             	and    $0x2,%eax
c0104d20:	85 c0                	test   %eax,%eax
c0104d22:	75 24                	jne    c0104d48 <check_pgdir+0x363>
c0104d24:	c7 44 24 0c f2 6f 10 	movl   $0xc0106ff2,0xc(%esp)
c0104d2b:	c0 
c0104d2c:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104d33:	c0 
c0104d34:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104d3b:	00 
c0104d3c:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104d43:	e8 78 bf ff ff       	call   c0100cc0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104d48:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104d4d:	8b 00                	mov    (%eax),%eax
c0104d4f:	83 e0 04             	and    $0x4,%eax
c0104d52:	85 c0                	test   %eax,%eax
c0104d54:	75 24                	jne    c0104d7a <check_pgdir+0x395>
c0104d56:	c7 44 24 0c 00 70 10 	movl   $0xc0107000,0xc(%esp)
c0104d5d:	c0 
c0104d5e:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104d65:	c0 
c0104d66:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104d6d:	00 
c0104d6e:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104d75:	e8 46 bf ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 1);
c0104d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d7d:	89 04 24             	mov    %eax,(%esp)
c0104d80:	e8 4b ef ff ff       	call   c0103cd0 <page_ref>
c0104d85:	83 f8 01             	cmp    $0x1,%eax
c0104d88:	74 24                	je     c0104dae <check_pgdir+0x3c9>
c0104d8a:	c7 44 24 0c 16 70 10 	movl   $0xc0107016,0xc(%esp)
c0104d91:	c0 
c0104d92:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104d99:	c0 
c0104d9a:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104da1:	00 
c0104da2:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104da9:	e8 12 bf ff ff       	call   c0100cc0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104dae:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104db3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104dba:	00 
c0104dbb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104dc2:	00 
c0104dc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104dc6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dca:	89 04 24             	mov    %eax,(%esp)
c0104dcd:	e8 df fa ff ff       	call   c01048b1 <page_insert>
c0104dd2:	85 c0                	test   %eax,%eax
c0104dd4:	74 24                	je     c0104dfa <check_pgdir+0x415>
c0104dd6:	c7 44 24 0c 28 70 10 	movl   $0xc0107028,0xc(%esp)
c0104ddd:	c0 
c0104dde:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104de5:	c0 
c0104de6:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104ded:	00 
c0104dee:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104df5:	e8 c6 be ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p1) == 2);
c0104dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dfd:	89 04 24             	mov    %eax,(%esp)
c0104e00:	e8 cb ee ff ff       	call   c0103cd0 <page_ref>
c0104e05:	83 f8 02             	cmp    $0x2,%eax
c0104e08:	74 24                	je     c0104e2e <check_pgdir+0x449>
c0104e0a:	c7 44 24 0c 54 70 10 	movl   $0xc0107054,0xc(%esp)
c0104e11:	c0 
c0104e12:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104e19:	c0 
c0104e1a:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104e21:	00 
c0104e22:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104e29:	e8 92 be ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0104e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e31:	89 04 24             	mov    %eax,(%esp)
c0104e34:	e8 97 ee ff ff       	call   c0103cd0 <page_ref>
c0104e39:	85 c0                	test   %eax,%eax
c0104e3b:	74 24                	je     c0104e61 <check_pgdir+0x47c>
c0104e3d:	c7 44 24 0c 66 70 10 	movl   $0xc0107066,0xc(%esp)
c0104e44:	c0 
c0104e45:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104e4c:	c0 
c0104e4d:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104e54:	00 
c0104e55:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104e5c:	e8 5f be ff ff       	call   c0100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104e61:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104e66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e6d:	00 
c0104e6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e75:	00 
c0104e76:	89 04 24             	mov    %eax,(%esp)
c0104e79:	e8 96 f7 ff ff       	call   c0104614 <get_pte>
c0104e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104e85:	75 24                	jne    c0104eab <check_pgdir+0x4c6>
c0104e87:	c7 44 24 0c b4 6f 10 	movl   $0xc0106fb4,0xc(%esp)
c0104e8e:	c0 
c0104e8f:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104e96:	c0 
c0104e97:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104e9e:	00 
c0104e9f:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104ea6:	e8 15 be ff ff       	call   c0100cc0 <__panic>
    assert(pa2page(*ptep) == p1);
c0104eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104eae:	8b 00                	mov    (%eax),%eax
c0104eb0:	89 04 24             	mov    %eax,(%esp)
c0104eb3:	e8 37 ed ff ff       	call   c0103bef <pa2page>
c0104eb8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ebb:	74 24                	je     c0104ee1 <check_pgdir+0x4fc>
c0104ebd:	c7 44 24 0c 2d 6f 10 	movl   $0xc0106f2d,0xc(%esp)
c0104ec4:	c0 
c0104ec5:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104ecc:	c0 
c0104ecd:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104ed4:	00 
c0104ed5:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104edc:	e8 df bd ff ff       	call   c0100cc0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ee4:	8b 00                	mov    (%eax),%eax
c0104ee6:	83 e0 04             	and    $0x4,%eax
c0104ee9:	85 c0                	test   %eax,%eax
c0104eeb:	74 24                	je     c0104f11 <check_pgdir+0x52c>
c0104eed:	c7 44 24 0c 78 70 10 	movl   $0xc0107078,0xc(%esp)
c0104ef4:	c0 
c0104ef5:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104efc:	c0 
c0104efd:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104f04:	00 
c0104f05:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104f0c:	e8 af bd ff ff       	call   c0100cc0 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104f11:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104f16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f1d:	00 
c0104f1e:	89 04 24             	mov    %eax,(%esp)
c0104f21:	e8 47 f9 ff ff       	call   c010486d <page_remove>
    assert(page_ref(p1) == 1);
c0104f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f29:	89 04 24             	mov    %eax,(%esp)
c0104f2c:	e8 9f ed ff ff       	call   c0103cd0 <page_ref>
c0104f31:	83 f8 01             	cmp    $0x1,%eax
c0104f34:	74 24                	je     c0104f5a <check_pgdir+0x575>
c0104f36:	c7 44 24 0c 42 6f 10 	movl   $0xc0106f42,0xc(%esp)
c0104f3d:	c0 
c0104f3e:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104f45:	c0 
c0104f46:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104f4d:	00 
c0104f4e:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104f55:	e8 66 bd ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0104f5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f5d:	89 04 24             	mov    %eax,(%esp)
c0104f60:	e8 6b ed ff ff       	call   c0103cd0 <page_ref>
c0104f65:	85 c0                	test   %eax,%eax
c0104f67:	74 24                	je     c0104f8d <check_pgdir+0x5a8>
c0104f69:	c7 44 24 0c 66 70 10 	movl   $0xc0107066,0xc(%esp)
c0104f70:	c0 
c0104f71:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104f78:	c0 
c0104f79:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104f80:	00 
c0104f81:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104f88:	e8 33 bd ff ff       	call   c0100cc0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104f8d:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0104f92:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104f99:	00 
c0104f9a:	89 04 24             	mov    %eax,(%esp)
c0104f9d:	e8 cb f8 ff ff       	call   c010486d <page_remove>
    assert(page_ref(p1) == 0);
c0104fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fa5:	89 04 24             	mov    %eax,(%esp)
c0104fa8:	e8 23 ed ff ff       	call   c0103cd0 <page_ref>
c0104fad:	85 c0                	test   %eax,%eax
c0104faf:	74 24                	je     c0104fd5 <check_pgdir+0x5f0>
c0104fb1:	c7 44 24 0c 8d 70 10 	movl   $0xc010708d,0xc(%esp)
c0104fb8:	c0 
c0104fb9:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104fc0:	c0 
c0104fc1:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104fc8:	00 
c0104fc9:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0104fd0:	e8 eb bc ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0104fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fd8:	89 04 24             	mov    %eax,(%esp)
c0104fdb:	e8 f0 ec ff ff       	call   c0103cd0 <page_ref>
c0104fe0:	85 c0                	test   %eax,%eax
c0104fe2:	74 24                	je     c0105008 <check_pgdir+0x623>
c0104fe4:	c7 44 24 0c 66 70 10 	movl   $0xc0107066,0xc(%esp)
c0104feb:	c0 
c0104fec:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0104ff3:	c0 
c0104ff4:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104ffb:	00 
c0104ffc:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0105003:	e8 b8 bc ff ff       	call   c0100cc0 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105008:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010500d:	8b 00                	mov    (%eax),%eax
c010500f:	89 04 24             	mov    %eax,(%esp)
c0105012:	e8 d8 eb ff ff       	call   c0103bef <pa2page>
c0105017:	89 04 24             	mov    %eax,(%esp)
c010501a:	e8 b1 ec ff ff       	call   c0103cd0 <page_ref>
c010501f:	83 f8 01             	cmp    $0x1,%eax
c0105022:	74 24                	je     c0105048 <check_pgdir+0x663>
c0105024:	c7 44 24 0c a0 70 10 	movl   $0xc01070a0,0xc(%esp)
c010502b:	c0 
c010502c:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0105033:	c0 
c0105034:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c010503b:	00 
c010503c:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0105043:	e8 78 bc ff ff       	call   c0100cc0 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105048:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010504d:	8b 00                	mov    (%eax),%eax
c010504f:	89 04 24             	mov    %eax,(%esp)
c0105052:	e8 98 eb ff ff       	call   c0103bef <pa2page>
c0105057:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010505e:	00 
c010505f:	89 04 24             	mov    %eax,(%esp)
c0105062:	e8 a6 ee ff ff       	call   c0103f0d <free_pages>
    boot_pgdir[0] = 0;
c0105067:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c010506c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105072:	c7 04 24 c6 70 10 c0 	movl   $0xc01070c6,(%esp)
c0105079:	e8 c9 b2 ff ff       	call   c0100347 <cprintf>
}
c010507e:	c9                   	leave  
c010507f:	c3                   	ret    

c0105080 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105080:	55                   	push   %ebp
c0105081:	89 e5                	mov    %esp,%ebp
c0105083:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105086:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010508d:	e9 ca 00 00 00       	jmp    c010515c <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105092:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105095:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105098:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010509b:	c1 e8 0c             	shr    $0xc,%eax
c010509e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050a1:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c01050a6:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01050a9:	72 23                	jb     c01050ce <check_boot_pgdir+0x4e>
c01050ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050b2:	c7 44 24 08 10 6d 10 	movl   $0xc0106d10,0x8(%esp)
c01050b9:	c0 
c01050ba:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c01050c1:	00 
c01050c2:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01050c9:	e8 f2 bb ff ff       	call   c0100cc0 <__panic>
c01050ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050d1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01050d6:	89 c2                	mov    %eax,%edx
c01050d8:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01050dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050e4:	00 
c01050e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01050e9:	89 04 24             	mov    %eax,(%esp)
c01050ec:	e8 23 f5 ff ff       	call   c0104614 <get_pte>
c01050f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01050f8:	75 24                	jne    c010511e <check_boot_pgdir+0x9e>
c01050fa:	c7 44 24 0c e0 70 10 	movl   $0xc01070e0,0xc(%esp)
c0105101:	c0 
c0105102:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0105109:	c0 
c010510a:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105111:	00 
c0105112:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0105119:	e8 a2 bb ff ff       	call   c0100cc0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010511e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105121:	8b 00                	mov    (%eax),%eax
c0105123:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105128:	89 c2                	mov    %eax,%edx
c010512a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010512d:	39 c2                	cmp    %eax,%edx
c010512f:	74 24                	je     c0105155 <check_boot_pgdir+0xd5>
c0105131:	c7 44 24 0c 1d 71 10 	movl   $0xc010711d,0xc(%esp)
c0105138:	c0 
c0105139:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0105140:	c0 
c0105141:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0105148:	00 
c0105149:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0105150:	e8 6b bb ff ff       	call   c0100cc0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105155:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010515c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010515f:	a1 e0 98 11 c0       	mov    0xc01198e0,%eax
c0105164:	39 c2                	cmp    %eax,%edx
c0105166:	0f 82 26 ff ff ff    	jb     c0105092 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010516c:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0105171:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105176:	8b 00                	mov    (%eax),%eax
c0105178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010517d:	89 c2                	mov    %eax,%edx
c010517f:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0105184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105187:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010518e:	77 23                	ja     c01051b3 <check_boot_pgdir+0x133>
c0105190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105193:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105197:	c7 44 24 08 b4 6d 10 	movl   $0xc0106db4,0x8(%esp)
c010519e:	c0 
c010519f:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c01051a6:	00 
c01051a7:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01051ae:	e8 0d bb ff ff       	call   c0100cc0 <__panic>
c01051b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051b6:	05 00 00 00 40       	add    $0x40000000,%eax
c01051bb:	39 c2                	cmp    %eax,%edx
c01051bd:	74 24                	je     c01051e3 <check_boot_pgdir+0x163>
c01051bf:	c7 44 24 0c 34 71 10 	movl   $0xc0107134,0xc(%esp)
c01051c6:	c0 
c01051c7:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c01051ce:	c0 
c01051cf:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c01051d6:	00 
c01051d7:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01051de:	e8 dd ba ff ff       	call   c0100cc0 <__panic>

    assert(boot_pgdir[0] == 0);
c01051e3:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01051e8:	8b 00                	mov    (%eax),%eax
c01051ea:	85 c0                	test   %eax,%eax
c01051ec:	74 24                	je     c0105212 <check_boot_pgdir+0x192>
c01051ee:	c7 44 24 0c 68 71 10 	movl   $0xc0107168,0xc(%esp)
c01051f5:	c0 
c01051f6:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c01051fd:	c0 
c01051fe:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105205:	00 
c0105206:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c010520d:	e8 ae ba ff ff       	call   c0100cc0 <__panic>

    struct Page *p;
    p = alloc_page();
c0105212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105219:	e8 b7 ec ff ff       	call   c0103ed5 <alloc_pages>
c010521e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105221:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c0105226:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010522d:	00 
c010522e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105235:	00 
c0105236:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105239:	89 54 24 04          	mov    %edx,0x4(%esp)
c010523d:	89 04 24             	mov    %eax,(%esp)
c0105240:	e8 6c f6 ff ff       	call   c01048b1 <page_insert>
c0105245:	85 c0                	test   %eax,%eax
c0105247:	74 24                	je     c010526d <check_boot_pgdir+0x1ed>
c0105249:	c7 44 24 0c 7c 71 10 	movl   $0xc010717c,0xc(%esp)
c0105250:	c0 
c0105251:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0105258:	c0 
c0105259:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105260:	00 
c0105261:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0105268:	e8 53 ba ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p) == 1);
c010526d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105270:	89 04 24             	mov    %eax,(%esp)
c0105273:	e8 58 ea ff ff       	call   c0103cd0 <page_ref>
c0105278:	83 f8 01             	cmp    $0x1,%eax
c010527b:	74 24                	je     c01052a1 <check_boot_pgdir+0x221>
c010527d:	c7 44 24 0c aa 71 10 	movl   $0xc01071aa,0xc(%esp)
c0105284:	c0 
c0105285:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c010528c:	c0 
c010528d:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105294:	00 
c0105295:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c010529c:	e8 1f ba ff ff       	call   c0100cc0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01052a1:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01052a6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01052ad:	00 
c01052ae:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01052b5:	00 
c01052b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052bd:	89 04 24             	mov    %eax,(%esp)
c01052c0:	e8 ec f5 ff ff       	call   c01048b1 <page_insert>
c01052c5:	85 c0                	test   %eax,%eax
c01052c7:	74 24                	je     c01052ed <check_boot_pgdir+0x26d>
c01052c9:	c7 44 24 0c bc 71 10 	movl   $0xc01071bc,0xc(%esp)
c01052d0:	c0 
c01052d1:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c01052d8:	c0 
c01052d9:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01052e0:	00 
c01052e1:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01052e8:	e8 d3 b9 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p) == 2);
c01052ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052f0:	89 04 24             	mov    %eax,(%esp)
c01052f3:	e8 d8 e9 ff ff       	call   c0103cd0 <page_ref>
c01052f8:	83 f8 02             	cmp    $0x2,%eax
c01052fb:	74 24                	je     c0105321 <check_boot_pgdir+0x2a1>
c01052fd:	c7 44 24 0c f3 71 10 	movl   $0xc01071f3,0xc(%esp)
c0105304:	c0 
c0105305:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c010530c:	c0 
c010530d:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105314:	00 
c0105315:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c010531c:	e8 9f b9 ff ff       	call   c0100cc0 <__panic>

    const char *str = "ucore: Hello world!!";
c0105321:	c7 45 dc 04 72 10 c0 	movl   $0xc0107204,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105328:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010532b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010532f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105336:	e8 6b 0a 00 00       	call   c0105da6 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010533b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105342:	00 
c0105343:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010534a:	e8 d4 0a 00 00       	call   c0105e23 <strcmp>
c010534f:	85 c0                	test   %eax,%eax
c0105351:	74 24                	je     c0105377 <check_boot_pgdir+0x2f7>
c0105353:	c7 44 24 0c 1c 72 10 	movl   $0xc010721c,0xc(%esp)
c010535a:	c0 
c010535b:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c0105362:	c0 
c0105363:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c010536a:	00 
c010536b:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c0105372:	e8 49 b9 ff ff       	call   c0100cc0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105377:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010537a:	89 04 24             	mov    %eax,(%esp)
c010537d:	e8 bc e8 ff ff       	call   c0103c3e <page2kva>
c0105382:	05 00 01 00 00       	add    $0x100,%eax
c0105387:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010538a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105391:	e8 b2 09 00 00       	call   c0105d48 <strlen>
c0105396:	85 c0                	test   %eax,%eax
c0105398:	74 24                	je     c01053be <check_boot_pgdir+0x33e>
c010539a:	c7 44 24 0c 54 72 10 	movl   $0xc0107254,0xc(%esp)
c01053a1:	c0 
c01053a2:	c7 44 24 08 fd 6d 10 	movl   $0xc0106dfd,0x8(%esp)
c01053a9:	c0 
c01053aa:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01053b1:	00 
c01053b2:	c7 04 24 d8 6d 10 c0 	movl   $0xc0106dd8,(%esp)
c01053b9:	e8 02 b9 ff ff       	call   c0100cc0 <__panic>

    free_page(p);
c01053be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053c5:	00 
c01053c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053c9:	89 04 24             	mov    %eax,(%esp)
c01053cc:	e8 3c eb ff ff       	call   c0103f0d <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01053d1:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01053d6:	8b 00                	mov    (%eax),%eax
c01053d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053dd:	89 04 24             	mov    %eax,(%esp)
c01053e0:	e8 0a e8 ff ff       	call   c0103bef <pa2page>
c01053e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053ec:	00 
c01053ed:	89 04 24             	mov    %eax,(%esp)
c01053f0:	e8 18 eb ff ff       	call   c0103f0d <free_pages>
    boot_pgdir[0] = 0;
c01053f5:	a1 e4 98 11 c0       	mov    0xc01198e4,%eax
c01053fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105400:	c7 04 24 78 72 10 c0 	movl   $0xc0107278,(%esp)
c0105407:	e8 3b af ff ff       	call   c0100347 <cprintf>
}
c010540c:	c9                   	leave  
c010540d:	c3                   	ret    

c010540e <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c010540e:	55                   	push   %ebp
c010540f:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105411:	8b 45 08             	mov    0x8(%ebp),%eax
c0105414:	83 e0 04             	and    $0x4,%eax
c0105417:	85 c0                	test   %eax,%eax
c0105419:	74 07                	je     c0105422 <perm2str+0x14>
c010541b:	b8 75 00 00 00       	mov    $0x75,%eax
c0105420:	eb 05                	jmp    c0105427 <perm2str+0x19>
c0105422:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105427:	a2 68 99 11 c0       	mov    %al,0xc0119968
    str[1] = 'r';
c010542c:	c6 05 69 99 11 c0 72 	movb   $0x72,0xc0119969
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105433:	8b 45 08             	mov    0x8(%ebp),%eax
c0105436:	83 e0 02             	and    $0x2,%eax
c0105439:	85 c0                	test   %eax,%eax
c010543b:	74 07                	je     c0105444 <perm2str+0x36>
c010543d:	b8 77 00 00 00       	mov    $0x77,%eax
c0105442:	eb 05                	jmp    c0105449 <perm2str+0x3b>
c0105444:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105449:	a2 6a 99 11 c0       	mov    %al,0xc011996a
    str[3] = '\0';
c010544e:	c6 05 6b 99 11 c0 00 	movb   $0x0,0xc011996b
    return str;
c0105455:	b8 68 99 11 c0       	mov    $0xc0119968,%eax
}
c010545a:	5d                   	pop    %ebp
c010545b:	c3                   	ret    

c010545c <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010545c:	55                   	push   %ebp
c010545d:	89 e5                	mov    %esp,%ebp
c010545f:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105462:	8b 45 10             	mov    0x10(%ebp),%eax
c0105465:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105468:	72 0a                	jb     c0105474 <get_pgtable_items+0x18>
        return 0;
c010546a:	b8 00 00 00 00       	mov    $0x0,%eax
c010546f:	e9 9c 00 00 00       	jmp    c0105510 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105474:	eb 04                	jmp    c010547a <get_pgtable_items+0x1e>
        start ++;
c0105476:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c010547a:	8b 45 10             	mov    0x10(%ebp),%eax
c010547d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105480:	73 18                	jae    c010549a <get_pgtable_items+0x3e>
c0105482:	8b 45 10             	mov    0x10(%ebp),%eax
c0105485:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010548c:	8b 45 14             	mov    0x14(%ebp),%eax
c010548f:	01 d0                	add    %edx,%eax
c0105491:	8b 00                	mov    (%eax),%eax
c0105493:	83 e0 01             	and    $0x1,%eax
c0105496:	85 c0                	test   %eax,%eax
c0105498:	74 dc                	je     c0105476 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010549a:	8b 45 10             	mov    0x10(%ebp),%eax
c010549d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054a0:	73 69                	jae    c010550b <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01054a2:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01054a6:	74 08                	je     c01054b0 <get_pgtable_items+0x54>
            *left_store = start;
c01054a8:	8b 45 18             	mov    0x18(%ebp),%eax
c01054ab:	8b 55 10             	mov    0x10(%ebp),%edx
c01054ae:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01054b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01054b3:	8d 50 01             	lea    0x1(%eax),%edx
c01054b6:	89 55 10             	mov    %edx,0x10(%ebp)
c01054b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054c0:	8b 45 14             	mov    0x14(%ebp),%eax
c01054c3:	01 d0                	add    %edx,%eax
c01054c5:	8b 00                	mov    (%eax),%eax
c01054c7:	83 e0 07             	and    $0x7,%eax
c01054ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01054cd:	eb 04                	jmp    c01054d3 <get_pgtable_items+0x77>
            start ++;
c01054cf:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01054d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01054d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054d9:	73 1d                	jae    c01054f8 <get_pgtable_items+0x9c>
c01054db:	8b 45 10             	mov    0x10(%ebp),%eax
c01054de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01054e8:	01 d0                	add    %edx,%eax
c01054ea:	8b 00                	mov    (%eax),%eax
c01054ec:	83 e0 07             	and    $0x7,%eax
c01054ef:	89 c2                	mov    %eax,%edx
c01054f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01054f4:	39 c2                	cmp    %eax,%edx
c01054f6:	74 d7                	je     c01054cf <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01054f8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054fc:	74 08                	je     c0105506 <get_pgtable_items+0xaa>
            *right_store = start;
c01054fe:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105501:	8b 55 10             	mov    0x10(%ebp),%edx
c0105504:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105506:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105509:	eb 05                	jmp    c0105510 <get_pgtable_items+0xb4>
    }
    return 0;
c010550b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105510:	c9                   	leave  
c0105511:	c3                   	ret    

c0105512 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105512:	55                   	push   %ebp
c0105513:	89 e5                	mov    %esp,%ebp
c0105515:	57                   	push   %edi
c0105516:	56                   	push   %esi
c0105517:	53                   	push   %ebx
c0105518:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010551b:	c7 04 24 98 72 10 c0 	movl   $0xc0107298,(%esp)
c0105522:	e8 20 ae ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
c0105527:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010552e:	e9 fa 00 00 00       	jmp    c010562d <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105533:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105536:	89 04 24             	mov    %eax,(%esp)
c0105539:	e8 d0 fe ff ff       	call   c010540e <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010553e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105541:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105544:	29 d1                	sub    %edx,%ecx
c0105546:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105548:	89 d6                	mov    %edx,%esi
c010554a:	c1 e6 16             	shl    $0x16,%esi
c010554d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105550:	89 d3                	mov    %edx,%ebx
c0105552:	c1 e3 16             	shl    $0x16,%ebx
c0105555:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105558:	89 d1                	mov    %edx,%ecx
c010555a:	c1 e1 16             	shl    $0x16,%ecx
c010555d:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105560:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105563:	29 d7                	sub    %edx,%edi
c0105565:	89 fa                	mov    %edi,%edx
c0105567:	89 44 24 14          	mov    %eax,0x14(%esp)
c010556b:	89 74 24 10          	mov    %esi,0x10(%esp)
c010556f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105573:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105577:	89 54 24 04          	mov    %edx,0x4(%esp)
c010557b:	c7 04 24 c9 72 10 c0 	movl   $0xc01072c9,(%esp)
c0105582:	e8 c0 ad ff ff       	call   c0100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105587:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010558a:	c1 e0 0a             	shl    $0xa,%eax
c010558d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105590:	eb 54                	jmp    c01055e6 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105595:	89 04 24             	mov    %eax,(%esp)
c0105598:	e8 71 fe ff ff       	call   c010540e <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010559d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01055a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01055a3:	29 d1                	sub    %edx,%ecx
c01055a5:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01055a7:	89 d6                	mov    %edx,%esi
c01055a9:	c1 e6 0c             	shl    $0xc,%esi
c01055ac:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055af:	89 d3                	mov    %edx,%ebx
c01055b1:	c1 e3 0c             	shl    $0xc,%ebx
c01055b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01055b7:	c1 e2 0c             	shl    $0xc,%edx
c01055ba:	89 d1                	mov    %edx,%ecx
c01055bc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01055bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01055c2:	29 d7                	sub    %edx,%edi
c01055c4:	89 fa                	mov    %edi,%edx
c01055c6:	89 44 24 14          	mov    %eax,0x14(%esp)
c01055ca:	89 74 24 10          	mov    %esi,0x10(%esp)
c01055ce:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01055d6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055da:	c7 04 24 e8 72 10 c0 	movl   $0xc01072e8,(%esp)
c01055e1:	e8 61 ad ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01055e6:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01055eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01055ee:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01055f1:	89 ce                	mov    %ecx,%esi
c01055f3:	c1 e6 0a             	shl    $0xa,%esi
c01055f6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01055f9:	89 cb                	mov    %ecx,%ebx
c01055fb:	c1 e3 0a             	shl    $0xa,%ebx
c01055fe:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105601:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105605:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105608:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010560c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105610:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105614:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105618:	89 1c 24             	mov    %ebx,(%esp)
c010561b:	e8 3c fe ff ff       	call   c010545c <get_pgtable_items>
c0105620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105623:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105627:	0f 85 65 ff ff ff    	jne    c0105592 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010562d:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105632:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105635:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105638:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010563c:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010563f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105643:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105647:	89 44 24 08          	mov    %eax,0x8(%esp)
c010564b:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105652:	00 
c0105653:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010565a:	e8 fd fd ff ff       	call   c010545c <get_pgtable_items>
c010565f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105662:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105666:	0f 85 c7 fe ff ff    	jne    c0105533 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010566c:	c7 04 24 0c 73 10 c0 	movl   $0xc010730c,(%esp)
c0105673:	e8 cf ac ff ff       	call   c0100347 <cprintf>
}
c0105678:	83 c4 4c             	add    $0x4c,%esp
c010567b:	5b                   	pop    %ebx
c010567c:	5e                   	pop    %esi
c010567d:	5f                   	pop    %edi
c010567e:	5d                   	pop    %ebp
c010567f:	c3                   	ret    

c0105680 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105680:	55                   	push   %ebp
c0105681:	89 e5                	mov    %esp,%ebp
c0105683:	56                   	push   %esi
c0105684:	53                   	push   %ebx
c0105685:	83 ec 60             	sub    $0x60,%esp
c0105688:	8b 45 10             	mov    0x10(%ebp),%eax
c010568b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010568e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105691:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105694:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105697:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010569a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010569d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01056a0:	8b 45 18             	mov    0x18(%ebp),%eax
c01056a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01056ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01056af:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01056b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01056b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01056b8:	89 d3                	mov    %edx,%ebx
c01056ba:	89 c6                	mov    %eax,%esi
c01056bc:	89 75 e0             	mov    %esi,-0x20(%ebp)
c01056bf:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c01056c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01056cc:	74 1c                	je     c01056ea <printnum+0x6a>
c01056ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056d1:	ba 00 00 00 00       	mov    $0x0,%edx
c01056d6:	f7 75 e4             	divl   -0x1c(%ebp)
c01056d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01056dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056df:	ba 00 00 00 00       	mov    $0x0,%edx
c01056e4:	f7 75 e4             	divl   -0x1c(%ebp)
c01056e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01056ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f0:	89 d6                	mov    %edx,%esi
c01056f2:	89 c3                	mov    %eax,%ebx
c01056f4:	89 f0                	mov    %esi,%eax
c01056f6:	89 da                	mov    %ebx,%edx
c01056f8:	f7 75 e4             	divl   -0x1c(%ebp)
c01056fb:	89 d3                	mov    %edx,%ebx
c01056fd:	89 c6                	mov    %eax,%esi
c01056ff:	89 75 e0             	mov    %esi,-0x20(%ebp)
c0105702:	89 5d dc             	mov    %ebx,-0x24(%ebp)
c0105705:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105708:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010570b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010570e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0105711:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105714:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105717:	89 c3                	mov    %eax,%ebx
c0105719:	89 d6                	mov    %edx,%esi
c010571b:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c010571e:	89 75 ec             	mov    %esi,-0x14(%ebp)
c0105721:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105724:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105727:	8b 45 18             	mov    0x18(%ebp),%eax
c010572a:	ba 00 00 00 00       	mov    $0x0,%edx
c010572f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105732:	77 56                	ja     c010578a <printnum+0x10a>
c0105734:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105737:	72 05                	jb     c010573e <printnum+0xbe>
c0105739:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010573c:	77 4c                	ja     c010578a <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
c010573e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105741:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105744:	8b 45 20             	mov    0x20(%ebp),%eax
c0105747:	89 44 24 18          	mov    %eax,0x18(%esp)
c010574b:	89 54 24 14          	mov    %edx,0x14(%esp)
c010574f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105752:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105756:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105759:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010575c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105760:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105764:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105767:	89 44 24 04          	mov    %eax,0x4(%esp)
c010576b:	8b 45 08             	mov    0x8(%ebp),%eax
c010576e:	89 04 24             	mov    %eax,(%esp)
c0105771:	e8 0a ff ff ff       	call   c0105680 <printnum>
c0105776:	eb 1c                	jmp    c0105794 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105778:	8b 45 0c             	mov    0xc(%ebp),%eax
c010577b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010577f:	8b 45 20             	mov    0x20(%ebp),%eax
c0105782:	89 04 24             	mov    %eax,(%esp)
c0105785:	8b 45 08             	mov    0x8(%ebp),%eax
c0105788:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010578a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010578e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105792:	7f e4                	jg     c0105778 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105794:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105797:	05 c0 73 10 c0       	add    $0xc01073c0,%eax
c010579c:	0f b6 00             	movzbl (%eax),%eax
c010579f:	0f be c0             	movsbl %al,%eax
c01057a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057a9:	89 04 24             	mov    %eax,(%esp)
c01057ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01057af:	ff d0                	call   *%eax
}
c01057b1:	83 c4 60             	add    $0x60,%esp
c01057b4:	5b                   	pop    %ebx
c01057b5:	5e                   	pop    %esi
c01057b6:	5d                   	pop    %ebp
c01057b7:	c3                   	ret    

c01057b8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01057b8:	55                   	push   %ebp
c01057b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01057bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01057bf:	7e 14                	jle    c01057d5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01057c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c4:	8b 00                	mov    (%eax),%eax
c01057c6:	8d 48 08             	lea    0x8(%eax),%ecx
c01057c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01057cc:	89 0a                	mov    %ecx,(%edx)
c01057ce:	8b 50 04             	mov    0x4(%eax),%edx
c01057d1:	8b 00                	mov    (%eax),%eax
c01057d3:	eb 30                	jmp    c0105805 <getuint+0x4d>
    }
    else if (lflag) {
c01057d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01057d9:	74 16                	je     c01057f1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01057db:	8b 45 08             	mov    0x8(%ebp),%eax
c01057de:	8b 00                	mov    (%eax),%eax
c01057e0:	8d 48 04             	lea    0x4(%eax),%ecx
c01057e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01057e6:	89 0a                	mov    %ecx,(%edx)
c01057e8:	8b 00                	mov    (%eax),%eax
c01057ea:	ba 00 00 00 00       	mov    $0x0,%edx
c01057ef:	eb 14                	jmp    c0105805 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01057f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f4:	8b 00                	mov    (%eax),%eax
c01057f6:	8d 48 04             	lea    0x4(%eax),%ecx
c01057f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01057fc:	89 0a                	mov    %ecx,(%edx)
c01057fe:	8b 00                	mov    (%eax),%eax
c0105800:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105805:	5d                   	pop    %ebp
c0105806:	c3                   	ret    

c0105807 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105807:	55                   	push   %ebp
c0105808:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010580a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010580e:	7e 14                	jle    c0105824 <getint+0x1d>
        return va_arg(*ap, long long);
c0105810:	8b 45 08             	mov    0x8(%ebp),%eax
c0105813:	8b 00                	mov    (%eax),%eax
c0105815:	8d 48 08             	lea    0x8(%eax),%ecx
c0105818:	8b 55 08             	mov    0x8(%ebp),%edx
c010581b:	89 0a                	mov    %ecx,(%edx)
c010581d:	8b 50 04             	mov    0x4(%eax),%edx
c0105820:	8b 00                	mov    (%eax),%eax
c0105822:	eb 30                	jmp    c0105854 <getint+0x4d>
    }
    else if (lflag) {
c0105824:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105828:	74 16                	je     c0105840 <getint+0x39>
        return va_arg(*ap, long);
c010582a:	8b 45 08             	mov    0x8(%ebp),%eax
c010582d:	8b 00                	mov    (%eax),%eax
c010582f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105832:	8b 55 08             	mov    0x8(%ebp),%edx
c0105835:	89 0a                	mov    %ecx,(%edx)
c0105837:	8b 00                	mov    (%eax),%eax
c0105839:	89 c2                	mov    %eax,%edx
c010583b:	c1 fa 1f             	sar    $0x1f,%edx
c010583e:	eb 14                	jmp    c0105854 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
c0105840:	8b 45 08             	mov    0x8(%ebp),%eax
c0105843:	8b 00                	mov    (%eax),%eax
c0105845:	8d 48 04             	lea    0x4(%eax),%ecx
c0105848:	8b 55 08             	mov    0x8(%ebp),%edx
c010584b:	89 0a                	mov    %ecx,(%edx)
c010584d:	8b 00                	mov    (%eax),%eax
c010584f:	89 c2                	mov    %eax,%edx
c0105851:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
c0105854:	5d                   	pop    %ebp
c0105855:	c3                   	ret    

c0105856 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105856:	55                   	push   %ebp
c0105857:	89 e5                	mov    %esp,%ebp
c0105859:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010585c:	8d 55 14             	lea    0x14(%ebp),%edx
c010585f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0105862:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
c0105864:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105867:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010586b:	8b 45 10             	mov    0x10(%ebp),%eax
c010586e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105872:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105875:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105879:	8b 45 08             	mov    0x8(%ebp),%eax
c010587c:	89 04 24             	mov    %eax,(%esp)
c010587f:	e8 02 00 00 00       	call   c0105886 <vprintfmt>
    va_end(ap);
}
c0105884:	c9                   	leave  
c0105885:	c3                   	ret    

c0105886 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105886:	55                   	push   %ebp
c0105887:	89 e5                	mov    %esp,%ebp
c0105889:	56                   	push   %esi
c010588a:	53                   	push   %ebx
c010588b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010588e:	eb 17                	jmp    c01058a7 <vprintfmt+0x21>
            if (ch == '\0') {
c0105890:	85 db                	test   %ebx,%ebx
c0105892:	0f 84 db 03 00 00    	je     c0105c73 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
c0105898:	8b 45 0c             	mov    0xc(%ebp),%eax
c010589b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010589f:	89 1c 24             	mov    %ebx,(%esp)
c01058a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a5:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058a7:	8b 45 10             	mov    0x10(%ebp),%eax
c01058aa:	0f b6 00             	movzbl (%eax),%eax
c01058ad:	0f b6 d8             	movzbl %al,%ebx
c01058b0:	83 fb 25             	cmp    $0x25,%ebx
c01058b3:	0f 95 c0             	setne  %al
c01058b6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01058ba:	84 c0                	test   %al,%al
c01058bc:	75 d2                	jne    c0105890 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01058be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01058c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01058c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01058cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01058d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058dc:	eb 04                	jmp    c01058e2 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
c01058de:	90                   	nop
c01058df:	eb 01                	jmp    c01058e2 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
c01058e1:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01058e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01058e5:	0f b6 00             	movzbl (%eax),%eax
c01058e8:	0f b6 d8             	movzbl %al,%ebx
c01058eb:	89 d8                	mov    %ebx,%eax
c01058ed:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01058f1:	83 e8 23             	sub    $0x23,%eax
c01058f4:	83 f8 55             	cmp    $0x55,%eax
c01058f7:	0f 87 45 03 00 00    	ja     c0105c42 <vprintfmt+0x3bc>
c01058fd:	8b 04 85 e4 73 10 c0 	mov    -0x3fef8c1c(,%eax,4),%eax
c0105904:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105906:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010590a:	eb d6                	jmp    c01058e2 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010590c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105910:	eb d0                	jmp    c01058e2 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105912:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010591c:	89 d0                	mov    %edx,%eax
c010591e:	c1 e0 02             	shl    $0x2,%eax
c0105921:	01 d0                	add    %edx,%eax
c0105923:	01 c0                	add    %eax,%eax
c0105925:	01 d8                	add    %ebx,%eax
c0105927:	83 e8 30             	sub    $0x30,%eax
c010592a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010592d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105930:	0f b6 00             	movzbl (%eax),%eax
c0105933:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105936:	83 fb 2f             	cmp    $0x2f,%ebx
c0105939:	7e 39                	jle    c0105974 <vprintfmt+0xee>
c010593b:	83 fb 39             	cmp    $0x39,%ebx
c010593e:	7f 34                	jg     c0105974 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105940:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105944:	eb d3                	jmp    c0105919 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105946:	8b 45 14             	mov    0x14(%ebp),%eax
c0105949:	8d 50 04             	lea    0x4(%eax),%edx
c010594c:	89 55 14             	mov    %edx,0x14(%ebp)
c010594f:	8b 00                	mov    (%eax),%eax
c0105951:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105954:	eb 1f                	jmp    c0105975 <vprintfmt+0xef>

        case '.':
            if (width < 0)
c0105956:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010595a:	79 82                	jns    c01058de <vprintfmt+0x58>
                width = 0;
c010595c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105963:	e9 76 ff ff ff       	jmp    c01058de <vprintfmt+0x58>

        case '#':
            altflag = 1;
c0105968:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010596f:	e9 6e ff ff ff       	jmp    c01058e2 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0105974:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0105975:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105979:	0f 89 62 ff ff ff    	jns    c01058e1 <vprintfmt+0x5b>
                width = precision, precision = -1;
c010597f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105982:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105985:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010598c:	e9 50 ff ff ff       	jmp    c01058e1 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105991:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105995:	e9 48 ff ff ff       	jmp    c01058e2 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010599a:	8b 45 14             	mov    0x14(%ebp),%eax
c010599d:	8d 50 04             	lea    0x4(%eax),%edx
c01059a0:	89 55 14             	mov    %edx,0x14(%ebp)
c01059a3:	8b 00                	mov    (%eax),%eax
c01059a5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059ac:	89 04 24             	mov    %eax,(%esp)
c01059af:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b2:	ff d0                	call   *%eax
            break;
c01059b4:	e9 b4 02 00 00       	jmp    c0105c6d <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01059b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01059bc:	8d 50 04             	lea    0x4(%eax),%edx
c01059bf:	89 55 14             	mov    %edx,0x14(%ebp)
c01059c2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01059c4:	85 db                	test   %ebx,%ebx
c01059c6:	79 02                	jns    c01059ca <vprintfmt+0x144>
                err = -err;
c01059c8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01059ca:	83 fb 06             	cmp    $0x6,%ebx
c01059cd:	7f 0b                	jg     c01059da <vprintfmt+0x154>
c01059cf:	8b 34 9d a4 73 10 c0 	mov    -0x3fef8c5c(,%ebx,4),%esi
c01059d6:	85 f6                	test   %esi,%esi
c01059d8:	75 23                	jne    c01059fd <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
c01059da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01059de:	c7 44 24 08 d1 73 10 	movl   $0xc01073d1,0x8(%esp)
c01059e5:	c0 
c01059e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f0:	89 04 24             	mov    %eax,(%esp)
c01059f3:	e8 5e fe ff ff       	call   c0105856 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01059f8:	e9 70 02 00 00       	jmp    c0105c6d <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01059fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105a01:	c7 44 24 08 da 73 10 	movl   $0xc01073da,0x8(%esp)
c0105a08:	c0 
c0105a09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a13:	89 04 24             	mov    %eax,(%esp)
c0105a16:	e8 3b fe ff ff       	call   c0105856 <printfmt>
            }
            break;
c0105a1b:	e9 4d 02 00 00       	jmp    c0105c6d <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105a20:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a23:	8d 50 04             	lea    0x4(%eax),%edx
c0105a26:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a29:	8b 30                	mov    (%eax),%esi
c0105a2b:	85 f6                	test   %esi,%esi
c0105a2d:	75 05                	jne    c0105a34 <vprintfmt+0x1ae>
                p = "(null)";
c0105a2f:	be dd 73 10 c0       	mov    $0xc01073dd,%esi
            }
            if (width > 0 && padc != '-') {
c0105a34:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a38:	7e 7c                	jle    c0105ab6 <vprintfmt+0x230>
c0105a3a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105a3e:	74 76                	je     c0105ab6 <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a40:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a4a:	89 34 24             	mov    %esi,(%esp)
c0105a4d:	e8 21 03 00 00       	call   c0105d73 <strnlen>
c0105a52:	89 da                	mov    %ebx,%edx
c0105a54:	29 c2                	sub    %eax,%edx
c0105a56:	89 d0                	mov    %edx,%eax
c0105a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a5b:	eb 17                	jmp    c0105a74 <vprintfmt+0x1ee>
                    putch(padc, putdat);
c0105a5d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105a61:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a64:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a68:	89 04 24             	mov    %eax,(%esp)
c0105a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a70:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a78:	7f e3                	jg     c0105a5d <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105a7a:	eb 3a                	jmp    c0105ab6 <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105a7c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105a80:	74 1f                	je     c0105aa1 <vprintfmt+0x21b>
c0105a82:	83 fb 1f             	cmp    $0x1f,%ebx
c0105a85:	7e 05                	jle    c0105a8c <vprintfmt+0x206>
c0105a87:	83 fb 7e             	cmp    $0x7e,%ebx
c0105a8a:	7e 15                	jle    c0105aa1 <vprintfmt+0x21b>
                    putch('?', putdat);
c0105a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a93:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9d:	ff d0                	call   *%eax
c0105a9f:	eb 0f                	jmp    c0105ab0 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
c0105aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa8:	89 1c 24             	mov    %ebx,(%esp)
c0105aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aae:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105ab0:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105ab4:	eb 01                	jmp    c0105ab7 <vprintfmt+0x231>
c0105ab6:	90                   	nop
c0105ab7:	0f b6 06             	movzbl (%esi),%eax
c0105aba:	0f be d8             	movsbl %al,%ebx
c0105abd:	85 db                	test   %ebx,%ebx
c0105abf:	0f 95 c0             	setne  %al
c0105ac2:	83 c6 01             	add    $0x1,%esi
c0105ac5:	84 c0                	test   %al,%al
c0105ac7:	74 29                	je     c0105af2 <vprintfmt+0x26c>
c0105ac9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105acd:	78 ad                	js     c0105a7c <vprintfmt+0x1f6>
c0105acf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ad7:	79 a3                	jns    c0105a7c <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105ad9:	eb 17                	jmp    c0105af2 <vprintfmt+0x26c>
                putch(' ', putdat);
c0105adb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ade:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ae2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aec:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105aee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105af2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105af6:	7f e3                	jg     c0105adb <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
c0105af8:	e9 70 01 00 00       	jmp    c0105c6d <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b04:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b07:	89 04 24             	mov    %eax,(%esp)
c0105b0a:	e8 f8 fc ff ff       	call   c0105807 <getint>
c0105b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b12:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b1b:	85 d2                	test   %edx,%edx
c0105b1d:	79 26                	jns    c0105b45 <vprintfmt+0x2bf>
                putch('-', putdat);
c0105b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b30:	ff d0                	call   *%eax
                num = -(long long)num;
c0105b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b38:	f7 d8                	neg    %eax
c0105b3a:	83 d2 00             	adc    $0x0,%edx
c0105b3d:	f7 da                	neg    %edx
c0105b3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b42:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105b45:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b4c:	e9 a8 00 00 00       	jmp    c0105bf9 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b54:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b58:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b5b:	89 04 24             	mov    %eax,(%esp)
c0105b5e:	e8 55 fc ff ff       	call   c01057b8 <getuint>
c0105b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b66:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105b69:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b70:	e9 84 00 00 00       	jmp    c0105bf9 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b7c:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b7f:	89 04 24             	mov    %eax,(%esp)
c0105b82:	e8 31 fc ff ff       	call   c01057b8 <getuint>
c0105b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105b8d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105b94:	eb 63                	jmp    c0105bf9 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
c0105b96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b9d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba7:	ff d0                	call   *%eax
            putch('x', putdat);
c0105ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bb0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105bb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bba:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105bbc:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bbf:	8d 50 04             	lea    0x4(%eax),%edx
c0105bc2:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bc5:	8b 00                	mov    (%eax),%eax
c0105bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105bd1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105bd8:	eb 1f                	jmp    c0105bf9 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be1:	8d 45 14             	lea    0x14(%ebp),%eax
c0105be4:	89 04 24             	mov    %eax,(%esp)
c0105be7:	e8 cc fb ff ff       	call   c01057b8 <getuint>
c0105bec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105bf9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c00:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105c04:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c07:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105c0b:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c12:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c15:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c19:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c27:	89 04 24             	mov    %eax,(%esp)
c0105c2a:	e8 51 fa ff ff       	call   c0105680 <printnum>
            break;
c0105c2f:	eb 3c                	jmp    c0105c6d <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105c31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c38:	89 1c 24             	mov    %ebx,(%esp)
c0105c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3e:	ff d0                	call   *%eax
            break;
c0105c40:	eb 2b                	jmp    c0105c6d <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105c42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c49:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c53:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105c55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c59:	eb 04                	jmp    c0105c5f <vprintfmt+0x3d9>
c0105c5b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c62:	83 e8 01             	sub    $0x1,%eax
c0105c65:	0f b6 00             	movzbl (%eax),%eax
c0105c68:	3c 25                	cmp    $0x25,%al
c0105c6a:	75 ef                	jne    c0105c5b <vprintfmt+0x3d5>
                /* do nothing */;
            break;
c0105c6c:	90                   	nop
        }
    }
c0105c6d:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c6e:	e9 34 fc ff ff       	jmp    c01058a7 <vprintfmt+0x21>
            if (ch == '\0') {
                return;
c0105c73:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105c74:	83 c4 40             	add    $0x40,%esp
c0105c77:	5b                   	pop    %ebx
c0105c78:	5e                   	pop    %esi
c0105c79:	5d                   	pop    %ebp
c0105c7a:	c3                   	ret    

c0105c7b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105c7b:	55                   	push   %ebp
c0105c7c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c81:	8b 40 08             	mov    0x8(%eax),%eax
c0105c84:	8d 50 01             	lea    0x1(%eax),%edx
c0105c87:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c90:	8b 10                	mov    (%eax),%edx
c0105c92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c95:	8b 40 04             	mov    0x4(%eax),%eax
c0105c98:	39 c2                	cmp    %eax,%edx
c0105c9a:	73 12                	jae    c0105cae <sprintputch+0x33>
        *b->buf ++ = ch;
c0105c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c9f:	8b 00                	mov    (%eax),%eax
c0105ca1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ca4:	88 10                	mov    %dl,(%eax)
c0105ca6:	8d 50 01             	lea    0x1(%eax),%edx
c0105ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cac:	89 10                	mov    %edx,(%eax)
    }
}
c0105cae:	5d                   	pop    %ebp
c0105caf:	c3                   	ret    

c0105cb0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105cb0:	55                   	push   %ebp
c0105cb1:	89 e5                	mov    %esp,%ebp
c0105cb3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105cb6:	8d 55 14             	lea    0x14(%ebp),%edx
c0105cb9:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0105cbc:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
c0105cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105cc5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd6:	89 04 24             	mov    %eax,(%esp)
c0105cd9:	e8 08 00 00 00       	call   c0105ce6 <vsnprintf>
c0105cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ce4:	c9                   	leave  
c0105ce5:	c3                   	ret    

c0105ce6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105ce6:	55                   	push   %ebp
c0105ce7:	89 e5                	mov    %esp,%ebp
c0105ce9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf5:	83 e8 01             	sub    $0x1,%eax
c0105cf8:	03 45 08             	add    0x8(%ebp),%eax
c0105cfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105d05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105d09:	74 0a                	je     c0105d15 <vsnprintf+0x2f>
c0105d0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d11:	39 c2                	cmp    %eax,%edx
c0105d13:	76 07                	jbe    c0105d1c <vsnprintf+0x36>
        return -E_INVAL;
c0105d15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105d1a:	eb 2a                	jmp    c0105d46 <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105d1c:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d23:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d26:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d31:	c7 04 24 7b 5c 10 c0 	movl   $0xc0105c7b,(%esp)
c0105d38:	e8 49 fb ff ff       	call   c0105886 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d40:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d46:	c9                   	leave  
c0105d47:	c3                   	ret    

c0105d48 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105d48:	55                   	push   %ebp
c0105d49:	89 e5                	mov    %esp,%ebp
c0105d4b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105d55:	eb 04                	jmp    c0105d5b <strlen+0x13>
        cnt ++;
c0105d57:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5e:	0f b6 00             	movzbl (%eax),%eax
c0105d61:	84 c0                	test   %al,%al
c0105d63:	0f 95 c0             	setne  %al
c0105d66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d6a:	84 c0                	test   %al,%al
c0105d6c:	75 e9                	jne    c0105d57 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105d71:	c9                   	leave  
c0105d72:	c3                   	ret    

c0105d73 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105d73:	55                   	push   %ebp
c0105d74:	89 e5                	mov    %esp,%ebp
c0105d76:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105d79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105d80:	eb 04                	jmp    c0105d86 <strnlen+0x13>
        cnt ++;
c0105d82:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105d86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d89:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105d8c:	73 13                	jae    c0105da1 <strnlen+0x2e>
c0105d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d91:	0f b6 00             	movzbl (%eax),%eax
c0105d94:	84 c0                	test   %al,%al
c0105d96:	0f 95 c0             	setne  %al
c0105d99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d9d:	84 c0                	test   %al,%al
c0105d9f:	75 e1                	jne    c0105d82 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105da1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105da4:	c9                   	leave  
c0105da5:	c3                   	ret    

c0105da6 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105da6:	55                   	push   %ebp
c0105da7:	89 e5                	mov    %esp,%ebp
c0105da9:	57                   	push   %edi
c0105daa:	56                   	push   %esi
c0105dab:	53                   	push   %ebx
c0105dac:	83 ec 24             	sub    $0x24,%esp
c0105daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105db5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105db8:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dc1:	89 d6                	mov    %edx,%esi
c0105dc3:	89 c3                	mov    %eax,%ebx
c0105dc5:	89 df                	mov    %ebx,%edi
c0105dc7:	ac                   	lods   %ds:(%esi),%al
c0105dc8:	aa                   	stos   %al,%es:(%edi)
c0105dc9:	84 c0                	test   %al,%al
c0105dcb:	75 fa                	jne    c0105dc7 <strcpy+0x21>
c0105dcd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105dd0:	89 fb                	mov    %edi,%ebx
c0105dd2:	89 75 e8             	mov    %esi,-0x18(%ebp)
c0105dd5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
c0105dd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105ddb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105de1:	83 c4 24             	add    $0x24,%esp
c0105de4:	5b                   	pop    %ebx
c0105de5:	5e                   	pop    %esi
c0105de6:	5f                   	pop    %edi
c0105de7:	5d                   	pop    %ebp
c0105de8:	c3                   	ret    

c0105de9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105de9:	55                   	push   %ebp
c0105dea:	89 e5                	mov    %esp,%ebp
c0105dec:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105def:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105df5:	eb 21                	jmp    c0105e18 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105df7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dfa:	0f b6 10             	movzbl (%eax),%edx
c0105dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e00:	88 10                	mov    %dl,(%eax)
c0105e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e05:	0f b6 00             	movzbl (%eax),%eax
c0105e08:	84 c0                	test   %al,%al
c0105e0a:	74 04                	je     c0105e10 <strncpy+0x27>
            src ++;
c0105e0c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105e10:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e14:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e1c:	75 d9                	jne    c0105df7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105e1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e21:	c9                   	leave  
c0105e22:	c3                   	ret    

c0105e23 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105e23:	55                   	push   %ebp
c0105e24:	89 e5                	mov    %esp,%ebp
c0105e26:	57                   	push   %edi
c0105e27:	56                   	push   %esi
c0105e28:	53                   	push   %ebx
c0105e29:	83 ec 24             	sub    $0x24,%esp
c0105e2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e35:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105e38:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e3e:	89 d6                	mov    %edx,%esi
c0105e40:	89 c3                	mov    %eax,%ebx
c0105e42:	89 df                	mov    %ebx,%edi
c0105e44:	ac                   	lods   %ds:(%esi),%al
c0105e45:	ae                   	scas   %es:(%edi),%al
c0105e46:	75 08                	jne    c0105e50 <strcmp+0x2d>
c0105e48:	84 c0                	test   %al,%al
c0105e4a:	75 f8                	jne    c0105e44 <strcmp+0x21>
c0105e4c:	31 c0                	xor    %eax,%eax
c0105e4e:	eb 04                	jmp    c0105e54 <strcmp+0x31>
c0105e50:	19 c0                	sbb    %eax,%eax
c0105e52:	0c 01                	or     $0x1,%al
c0105e54:	89 fb                	mov    %edi,%ebx
c0105e56:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105e59:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105e5f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0105e62:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105e65:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105e68:	83 c4 24             	add    $0x24,%esp
c0105e6b:	5b                   	pop    %ebx
c0105e6c:	5e                   	pop    %esi
c0105e6d:	5f                   	pop    %edi
c0105e6e:	5d                   	pop    %ebp
c0105e6f:	c3                   	ret    

c0105e70 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105e70:	55                   	push   %ebp
c0105e71:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105e73:	eb 0c                	jmp    c0105e81 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105e75:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105e79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e7d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105e81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e85:	74 1a                	je     c0105ea1 <strncmp+0x31>
c0105e87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8a:	0f b6 00             	movzbl (%eax),%eax
c0105e8d:	84 c0                	test   %al,%al
c0105e8f:	74 10                	je     c0105ea1 <strncmp+0x31>
c0105e91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e94:	0f b6 10             	movzbl (%eax),%edx
c0105e97:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e9a:	0f b6 00             	movzbl (%eax),%eax
c0105e9d:	38 c2                	cmp    %al,%dl
c0105e9f:	74 d4                	je     c0105e75 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ea5:	74 1a                	je     c0105ec1 <strncmp+0x51>
c0105ea7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eaa:	0f b6 00             	movzbl (%eax),%eax
c0105ead:	0f b6 d0             	movzbl %al,%edx
c0105eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eb3:	0f b6 00             	movzbl (%eax),%eax
c0105eb6:	0f b6 c0             	movzbl %al,%eax
c0105eb9:	89 d1                	mov    %edx,%ecx
c0105ebb:	29 c1                	sub    %eax,%ecx
c0105ebd:	89 c8                	mov    %ecx,%eax
c0105ebf:	eb 05                	jmp    c0105ec6 <strncmp+0x56>
c0105ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ec6:	5d                   	pop    %ebp
c0105ec7:	c3                   	ret    

c0105ec8 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105ec8:	55                   	push   %ebp
c0105ec9:	89 e5                	mov    %esp,%ebp
c0105ecb:	83 ec 04             	sub    $0x4,%esp
c0105ece:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ed1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ed4:	eb 14                	jmp    c0105eea <strchr+0x22>
        if (*s == c) {
c0105ed6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed9:	0f b6 00             	movzbl (%eax),%eax
c0105edc:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105edf:	75 05                	jne    c0105ee6 <strchr+0x1e>
            return (char *)s;
c0105ee1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee4:	eb 13                	jmp    c0105ef9 <strchr+0x31>
        }
        s ++;
c0105ee6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105eea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eed:	0f b6 00             	movzbl (%eax),%eax
c0105ef0:	84 c0                	test   %al,%al
c0105ef2:	75 e2                	jne    c0105ed6 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ef9:	c9                   	leave  
c0105efa:	c3                   	ret    

c0105efb <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105efb:	55                   	push   %ebp
c0105efc:	89 e5                	mov    %esp,%ebp
c0105efe:	83 ec 04             	sub    $0x4,%esp
c0105f01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f04:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f07:	eb 0f                	jmp    c0105f18 <strfind+0x1d>
        if (*s == c) {
c0105f09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0c:	0f b6 00             	movzbl (%eax),%eax
c0105f0f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105f12:	74 10                	je     c0105f24 <strfind+0x29>
            break;
        }
        s ++;
c0105f14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105f18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f1b:	0f b6 00             	movzbl (%eax),%eax
c0105f1e:	84 c0                	test   %al,%al
c0105f20:	75 e7                	jne    c0105f09 <strfind+0xe>
c0105f22:	eb 01                	jmp    c0105f25 <strfind+0x2a>
        if (*s == c) {
            break;
c0105f24:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105f25:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105f28:	c9                   	leave  
c0105f29:	c3                   	ret    

c0105f2a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105f2a:	55                   	push   %ebp
c0105f2b:	89 e5                	mov    %esp,%ebp
c0105f2d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105f30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105f37:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f3e:	eb 04                	jmp    c0105f44 <strtol+0x1a>
        s ++;
c0105f40:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f44:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f47:	0f b6 00             	movzbl (%eax),%eax
c0105f4a:	3c 20                	cmp    $0x20,%al
c0105f4c:	74 f2                	je     c0105f40 <strtol+0x16>
c0105f4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f51:	0f b6 00             	movzbl (%eax),%eax
c0105f54:	3c 09                	cmp    $0x9,%al
c0105f56:	74 e8                	je     c0105f40 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105f58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5b:	0f b6 00             	movzbl (%eax),%eax
c0105f5e:	3c 2b                	cmp    $0x2b,%al
c0105f60:	75 06                	jne    c0105f68 <strtol+0x3e>
        s ++;
c0105f62:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f66:	eb 15                	jmp    c0105f7d <strtol+0x53>
    }
    else if (*s == '-') {
c0105f68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f6b:	0f b6 00             	movzbl (%eax),%eax
c0105f6e:	3c 2d                	cmp    $0x2d,%al
c0105f70:	75 0b                	jne    c0105f7d <strtol+0x53>
        s ++, neg = 1;
c0105f72:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f76:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105f7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105f81:	74 06                	je     c0105f89 <strtol+0x5f>
c0105f83:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105f87:	75 24                	jne    c0105fad <strtol+0x83>
c0105f89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8c:	0f b6 00             	movzbl (%eax),%eax
c0105f8f:	3c 30                	cmp    $0x30,%al
c0105f91:	75 1a                	jne    c0105fad <strtol+0x83>
c0105f93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f96:	83 c0 01             	add    $0x1,%eax
c0105f99:	0f b6 00             	movzbl (%eax),%eax
c0105f9c:	3c 78                	cmp    $0x78,%al
c0105f9e:	75 0d                	jne    c0105fad <strtol+0x83>
        s += 2, base = 16;
c0105fa0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105fa4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105fab:	eb 2a                	jmp    c0105fd7 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105fad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fb1:	75 17                	jne    c0105fca <strtol+0xa0>
c0105fb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb6:	0f b6 00             	movzbl (%eax),%eax
c0105fb9:	3c 30                	cmp    $0x30,%al
c0105fbb:	75 0d                	jne    c0105fca <strtol+0xa0>
        s ++, base = 8;
c0105fbd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105fc1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105fc8:	eb 0d                	jmp    c0105fd7 <strtol+0xad>
    }
    else if (base == 0) {
c0105fca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fce:	75 07                	jne    c0105fd7 <strtol+0xad>
        base = 10;
c0105fd0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105fd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fda:	0f b6 00             	movzbl (%eax),%eax
c0105fdd:	3c 2f                	cmp    $0x2f,%al
c0105fdf:	7e 1b                	jle    c0105ffc <strtol+0xd2>
c0105fe1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fe4:	0f b6 00             	movzbl (%eax),%eax
c0105fe7:	3c 39                	cmp    $0x39,%al
c0105fe9:	7f 11                	jg     c0105ffc <strtol+0xd2>
            dig = *s - '0';
c0105feb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fee:	0f b6 00             	movzbl (%eax),%eax
c0105ff1:	0f be c0             	movsbl %al,%eax
c0105ff4:	83 e8 30             	sub    $0x30,%eax
c0105ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ffa:	eb 48                	jmp    c0106044 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105ffc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fff:	0f b6 00             	movzbl (%eax),%eax
c0106002:	3c 60                	cmp    $0x60,%al
c0106004:	7e 1b                	jle    c0106021 <strtol+0xf7>
c0106006:	8b 45 08             	mov    0x8(%ebp),%eax
c0106009:	0f b6 00             	movzbl (%eax),%eax
c010600c:	3c 7a                	cmp    $0x7a,%al
c010600e:	7f 11                	jg     c0106021 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0106010:	8b 45 08             	mov    0x8(%ebp),%eax
c0106013:	0f b6 00             	movzbl (%eax),%eax
c0106016:	0f be c0             	movsbl %al,%eax
c0106019:	83 e8 57             	sub    $0x57,%eax
c010601c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010601f:	eb 23                	jmp    c0106044 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0106021:	8b 45 08             	mov    0x8(%ebp),%eax
c0106024:	0f b6 00             	movzbl (%eax),%eax
c0106027:	3c 40                	cmp    $0x40,%al
c0106029:	7e 38                	jle    c0106063 <strtol+0x139>
c010602b:	8b 45 08             	mov    0x8(%ebp),%eax
c010602e:	0f b6 00             	movzbl (%eax),%eax
c0106031:	3c 5a                	cmp    $0x5a,%al
c0106033:	7f 2e                	jg     c0106063 <strtol+0x139>
            dig = *s - 'A' + 10;
c0106035:	8b 45 08             	mov    0x8(%ebp),%eax
c0106038:	0f b6 00             	movzbl (%eax),%eax
c010603b:	0f be c0             	movsbl %al,%eax
c010603e:	83 e8 37             	sub    $0x37,%eax
c0106041:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0106044:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106047:	3b 45 10             	cmp    0x10(%ebp),%eax
c010604a:	7d 16                	jge    c0106062 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
c010604c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106050:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106053:	0f af 45 10          	imul   0x10(%ebp),%eax
c0106057:	03 45 f4             	add    -0xc(%ebp),%eax
c010605a:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010605d:	e9 75 ff ff ff       	jmp    c0105fd7 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0106062:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0106063:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106067:	74 08                	je     c0106071 <strtol+0x147>
        *endptr = (char *) s;
c0106069:	8b 45 0c             	mov    0xc(%ebp),%eax
c010606c:	8b 55 08             	mov    0x8(%ebp),%edx
c010606f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0106071:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106075:	74 07                	je     c010607e <strtol+0x154>
c0106077:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010607a:	f7 d8                	neg    %eax
c010607c:	eb 03                	jmp    c0106081 <strtol+0x157>
c010607e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0106081:	c9                   	leave  
c0106082:	c3                   	ret    

c0106083 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0106083:	55                   	push   %ebp
c0106084:	89 e5                	mov    %esp,%ebp
c0106086:	57                   	push   %edi
c0106087:	56                   	push   %esi
c0106088:	53                   	push   %ebx
c0106089:	83 ec 24             	sub    $0x24,%esp
c010608c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010608f:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0106092:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
c0106096:	8b 55 08             	mov    0x8(%ebp),%edx
c0106099:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010609c:	88 45 ef             	mov    %al,-0x11(%ebp)
c010609f:	8b 45 10             	mov    0x10(%ebp),%eax
c01060a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01060a5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01060a8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01060ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01060af:	89 ce                	mov    %ecx,%esi
c01060b1:	89 d3                	mov    %edx,%ebx
c01060b3:	89 f1                	mov    %esi,%ecx
c01060b5:	89 df                	mov    %ebx,%edi
c01060b7:	f3 aa                	rep stos %al,%es:(%edi)
c01060b9:	89 fb                	mov    %edi,%ebx
c01060bb:	89 ce                	mov    %ecx,%esi
c01060bd:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c01060c0:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01060c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01060c6:	83 c4 24             	add    $0x24,%esp
c01060c9:	5b                   	pop    %ebx
c01060ca:	5e                   	pop    %esi
c01060cb:	5f                   	pop    %edi
c01060cc:	5d                   	pop    %ebp
c01060cd:	c3                   	ret    

c01060ce <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01060ce:	55                   	push   %ebp
c01060cf:	89 e5                	mov    %esp,%ebp
c01060d1:	57                   	push   %edi
c01060d2:	56                   	push   %esi
c01060d3:	53                   	push   %ebx
c01060d4:	83 ec 38             	sub    $0x38,%esp
c01060d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01060da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01060e6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01060e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060ec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01060ef:	73 4e                	jae    c010613f <memmove+0x71>
c01060f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01060f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01060fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106100:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106103:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106106:	89 c1                	mov    %eax,%ecx
c0106108:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010610b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010610e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106111:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0106114:	89 d7                	mov    %edx,%edi
c0106116:	89 c3                	mov    %eax,%ebx
c0106118:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010611b:	89 de                	mov    %ebx,%esi
c010611d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010611f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106122:	83 e1 03             	and    $0x3,%ecx
c0106125:	74 02                	je     c0106129 <memmove+0x5b>
c0106127:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106129:	89 f3                	mov    %esi,%ebx
c010612b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c010612e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0106131:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106134:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c0106137:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010613a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010613d:	eb 3b                	jmp    c010617a <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010613f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106142:	83 e8 01             	sub    $0x1,%eax
c0106145:	89 c2                	mov    %eax,%edx
c0106147:	03 55 ec             	add    -0x14(%ebp),%edx
c010614a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010614d:	83 e8 01             	sub    $0x1,%eax
c0106150:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0106153:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0106156:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0106159:	89 d6                	mov    %edx,%esi
c010615b:	89 c3                	mov    %eax,%ebx
c010615d:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0106160:	89 df                	mov    %ebx,%edi
c0106162:	fd                   	std    
c0106163:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106165:	fc                   	cld    
c0106166:	89 fb                	mov    %edi,%ebx
c0106168:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c010616b:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c010616e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0106171:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0106174:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0106177:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010617a:	83 c4 38             	add    $0x38,%esp
c010617d:	5b                   	pop    %ebx
c010617e:	5e                   	pop    %esi
c010617f:	5f                   	pop    %edi
c0106180:	5d                   	pop    %ebp
c0106181:	c3                   	ret    

c0106182 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0106182:	55                   	push   %ebp
c0106183:	89 e5                	mov    %esp,%ebp
c0106185:	57                   	push   %edi
c0106186:	56                   	push   %esi
c0106187:	53                   	push   %ebx
c0106188:	83 ec 24             	sub    $0x24,%esp
c010618b:	8b 45 08             	mov    0x8(%ebp),%eax
c010618e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106191:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106194:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106197:	8b 45 10             	mov    0x10(%ebp),%eax
c010619a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010619d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061a0:	89 c1                	mov    %eax,%ecx
c01061a2:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01061a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01061a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061ab:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c01061ae:	89 d7                	mov    %edx,%edi
c01061b0:	89 c3                	mov    %eax,%ebx
c01061b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01061b5:	89 de                	mov    %ebx,%esi
c01061b7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01061b9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01061bc:	83 e1 03             	and    $0x3,%ecx
c01061bf:	74 02                	je     c01061c3 <memcpy+0x41>
c01061c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01061c3:	89 f3                	mov    %esi,%ebx
c01061c5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c01061c8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01061cb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c01061ce:	89 7d e0             	mov    %edi,-0x20(%ebp)
c01061d1:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01061d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01061d7:	83 c4 24             	add    $0x24,%esp
c01061da:	5b                   	pop    %ebx
c01061db:	5e                   	pop    %esi
c01061dc:	5f                   	pop    %edi
c01061dd:	5d                   	pop    %ebp
c01061de:	c3                   	ret    

c01061df <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01061df:	55                   	push   %ebp
c01061e0:	89 e5                	mov    %esp,%ebp
c01061e2:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01061e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01061e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01061eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01061f1:	eb 32                	jmp    c0106225 <memcmp+0x46>
        if (*s1 != *s2) {
c01061f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01061f6:	0f b6 10             	movzbl (%eax),%edx
c01061f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01061fc:	0f b6 00             	movzbl (%eax),%eax
c01061ff:	38 c2                	cmp    %al,%dl
c0106201:	74 1a                	je     c010621d <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106203:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106206:	0f b6 00             	movzbl (%eax),%eax
c0106209:	0f b6 d0             	movzbl %al,%edx
c010620c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010620f:	0f b6 00             	movzbl (%eax),%eax
c0106212:	0f b6 c0             	movzbl %al,%eax
c0106215:	89 d1                	mov    %edx,%ecx
c0106217:	29 c1                	sub    %eax,%ecx
c0106219:	89 c8                	mov    %ecx,%eax
c010621b:	eb 1c                	jmp    c0106239 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c010621d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106221:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106229:	0f 95 c0             	setne  %al
c010622c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106230:	84 c0                	test   %al,%al
c0106232:	75 bf                	jne    c01061f3 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0106234:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106239:	c9                   	leave  
c010623a:	c3                   	ret    
