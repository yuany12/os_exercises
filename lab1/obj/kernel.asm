
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 9d 32 00 00       	call   1032c9 <memset>

    cons_init();                // init the console
  10002c:	e8 26 15 00 00       	call   101557 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 60 34 10 00 	movl   $0x103460,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 7c 34 10 00 	movl   $0x10347c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 b5 28 00 00       	call   10290f <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3b 16 00 00       	call   10169a <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 8d 17 00 00       	call   1017f1 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 e1 0c 00 00       	call   100d4a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 9a 15 00 00       	call   101608 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 ea 0b 00 00       	call   100c7c <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 81 34 10 00 	movl   $0x103481,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 8f 34 10 00 	movl   $0x10348f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 9d 34 10 00 	movl   $0x10349d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 ab 34 10 00 	movl   $0x1034ab,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 b9 34 10 00 	movl   $0x1034b9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 c8 34 10 00 	movl   $0x1034c8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 07 35 10 00 	movl   $0x103507,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 b3 12 00 00       	call   101583 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 d5 27 00 00       	call   102ae2 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 3a 12 00 00       	call   101583 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 07 12 00 00       	call   1015ac <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 0c 35 10 00    	movl   $0x10350c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 0c 35 10 00 	movl   $0x10350c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 6c 3d 10 00 	movl   $0x103d6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 88 b4 10 00 	movl   $0x10b488,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 89 b4 10 00 	movl   $0x10b489,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 61 d4 10 00 	movl   $0x10d461,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 7b 2a 00 00       	call   10313d <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 16 35 10 00 	movl   $0x103516,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 2f 35 10 00 	movl   $0x10352f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 52 34 10 	movl   $0x103452,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 47 35 10 00 	movl   $0x103547,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 5f 35 10 00 	movl   $0x10355f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 77 35 10 00 	movl   $0x103577,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 90 35 10 00 	movl   $0x103590,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 ba 35 10 00 	movl   $0x1035ba,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 d6 35 10 00 	movl   $0x1035d6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  10099b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip=read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	e9 80 00 00 00       	jmp    100a35 <print_stackframe+0xa5>
		cprintf("ebp:0x%08x  eip:0x%08x arg:", ebp, eip);
  1009b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c3:	c7 04 24 e8 35 10 00 	movl   $0x1035e8,(%esp)
  1009ca:	e8 43 f9 ff ff       	call   100312 <cprintf>

		int j;
		for (j=0;j<4;j++)
  1009cf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009d6:	eb 26                	jmp    1009fe <print_stackframe+0x6e>
			cprintf("0x%08x ",*(uint32_t*)(ebp+4*j+8));
  1009d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009db:	c1 e0 02             	shl    $0x2,%eax
  1009de:	89 c2                	mov    %eax,%edx
  1009e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e3:	01 d0                	add    %edx,%eax
  1009e5:	83 c0 08             	add    $0x8,%eax
  1009e8:	8b 00                	mov    (%eax),%eax
  1009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ee:	c7 04 24 04 36 10 00 	movl   $0x103604,(%esp)
  1009f5:	e8 18 f9 ff ff       	call   100312 <cprintf>
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
		cprintf("ebp:0x%08x  eip:0x%08x arg:", ebp, eip);

		int j;
		for (j=0;j<4;j++)
  1009fa:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  1009fe:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a02:	7e d4                	jle    1009d8 <print_stackframe+0x48>
			cprintf("0x%08x ",*(uint32_t*)(ebp+4*j+8));
		cprintf("\n");
  100a04:	c7 04 24 0c 36 10 00 	movl   $0x10360c,(%esp)
  100a0b:	e8 02 f9 ff ff       	call   100312 <cprintf>
		print_debuginfo(eip-1);
  100a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a13:	83 e8 01             	sub    $0x1,%eax
  100a16:	89 04 24             	mov    %eax,(%esp)
  100a19:	e8 be fe ff ff       	call   1008dc <print_debuginfo>
		eip=*(uint32_t*)(ebp+4);
  100a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a21:	83 c0 04             	add    $0x4,%eax
  100a24:	8b 00                	mov    (%eax),%eax
  100a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp=*(uint32_t*)(ebp);
  100a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2c:	8b 00                	mov    (%eax),%eax
  100a2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp=read_ebp();
	uint32_t eip=read_eip();
	int i;
	for (i=0; i<STACKFRAME_DEPTH; i++) {
  100a31:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a35:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a39:	0f 8e 76 ff ff ff    	jle    1009b5 <print_stackframe+0x25>
		print_debuginfo(eip-1);
		eip=*(uint32_t*)(ebp+4);
		ebp=*(uint32_t*)(ebp);
	}

}
  100a3f:	c9                   	leave  
  100a40:	c3                   	ret    

00100a41 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a41:	55                   	push   %ebp
  100a42:	89 e5                	mov    %esp,%ebp
  100a44:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a4e:	eb 0c                	jmp    100a5c <parse+0x1b>
            *buf ++ = '\0';
  100a50:	8b 45 08             	mov    0x8(%ebp),%eax
  100a53:	8d 50 01             	lea    0x1(%eax),%edx
  100a56:	89 55 08             	mov    %edx,0x8(%ebp)
  100a59:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5f:	0f b6 00             	movzbl (%eax),%eax
  100a62:	84 c0                	test   %al,%al
  100a64:	74 1d                	je     100a83 <parse+0x42>
  100a66:	8b 45 08             	mov    0x8(%ebp),%eax
  100a69:	0f b6 00             	movzbl (%eax),%eax
  100a6c:	0f be c0             	movsbl %al,%eax
  100a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a73:	c7 04 24 90 36 10 00 	movl   $0x103690,(%esp)
  100a7a:	e8 8b 26 00 00       	call   10310a <strchr>
  100a7f:	85 c0                	test   %eax,%eax
  100a81:	75 cd                	jne    100a50 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a83:	8b 45 08             	mov    0x8(%ebp),%eax
  100a86:	0f b6 00             	movzbl (%eax),%eax
  100a89:	84 c0                	test   %al,%al
  100a8b:	75 02                	jne    100a8f <parse+0x4e>
            break;
  100a8d:	eb 67                	jmp    100af6 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a8f:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a93:	75 14                	jne    100aa9 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a95:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a9c:	00 
  100a9d:	c7 04 24 95 36 10 00 	movl   $0x103695,(%esp)
  100aa4:	e8 69 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aac:	8d 50 01             	lea    0x1(%eax),%edx
  100aaf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ab2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100abc:	01 c2                	add    %eax,%edx
  100abe:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac1:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ac3:	eb 04                	jmp    100ac9 <parse+0x88>
            buf ++;
  100ac5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  100acc:	0f b6 00             	movzbl (%eax),%eax
  100acf:	84 c0                	test   %al,%al
  100ad1:	74 1d                	je     100af0 <parse+0xaf>
  100ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad6:	0f b6 00             	movzbl (%eax),%eax
  100ad9:	0f be c0             	movsbl %al,%eax
  100adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae0:	c7 04 24 90 36 10 00 	movl   $0x103690,(%esp)
  100ae7:	e8 1e 26 00 00       	call   10310a <strchr>
  100aec:	85 c0                	test   %eax,%eax
  100aee:	74 d5                	je     100ac5 <parse+0x84>
            buf ++;
        }
    }
  100af0:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af1:	e9 66 ff ff ff       	jmp    100a5c <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100af9:	c9                   	leave  
  100afa:	c3                   	ret    

00100afb <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100afb:	55                   	push   %ebp
  100afc:	89 e5                	mov    %esp,%ebp
  100afe:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b01:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	89 04 24             	mov    %eax,(%esp)
  100b0e:	e8 2e ff ff ff       	call   100a41 <parse>
  100b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b1a:	75 0a                	jne    100b26 <runcmd+0x2b>
        return 0;
  100b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  100b21:	e9 85 00 00 00       	jmp    100bab <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b2d:	eb 5c                	jmp    100b8b <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b2f:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b35:	89 d0                	mov    %edx,%eax
  100b37:	01 c0                	add    %eax,%eax
  100b39:	01 d0                	add    %edx,%eax
  100b3b:	c1 e0 02             	shl    $0x2,%eax
  100b3e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b43:	8b 00                	mov    (%eax),%eax
  100b45:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b49:	89 04 24             	mov    %eax,(%esp)
  100b4c:	e8 1a 25 00 00       	call   10306b <strcmp>
  100b51:	85 c0                	test   %eax,%eax
  100b53:	75 32                	jne    100b87 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b58:	89 d0                	mov    %edx,%eax
  100b5a:	01 c0                	add    %eax,%eax
  100b5c:	01 d0                	add    %edx,%eax
  100b5e:	c1 e0 02             	shl    $0x2,%eax
  100b61:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b66:	8b 40 08             	mov    0x8(%eax),%eax
  100b69:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b6c:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b72:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b76:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b79:	83 c2 04             	add    $0x4,%edx
  100b7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b80:	89 0c 24             	mov    %ecx,(%esp)
  100b83:	ff d0                	call   *%eax
  100b85:	eb 24                	jmp    100bab <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b87:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8e:	83 f8 02             	cmp    $0x2,%eax
  100b91:	76 9c                	jbe    100b2f <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b93:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9a:	c7 04 24 b3 36 10 00 	movl   $0x1036b3,(%esp)
  100ba1:	e8 6c f7 ff ff       	call   100312 <cprintf>
    return 0;
  100ba6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bab:	c9                   	leave  
  100bac:	c3                   	ret    

00100bad <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bad:	55                   	push   %ebp
  100bae:	89 e5                	mov    %esp,%ebp
  100bb0:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bb3:	c7 04 24 cc 36 10 00 	movl   $0x1036cc,(%esp)
  100bba:	e8 53 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bbf:	c7 04 24 f4 36 10 00 	movl   $0x1036f4,(%esp)
  100bc6:	e8 47 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bcb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bcf:	74 0b                	je     100bdc <kmonitor+0x2f>
        print_trapframe(tf);
  100bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd4:	89 04 24             	mov    %eax,(%esp)
  100bd7:	e8 c9 0d 00 00       	call   1019a5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bdc:	c7 04 24 19 37 10 00 	movl   $0x103719,(%esp)
  100be3:	e8 21 f6 ff ff       	call   100209 <readline>
  100be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bef:	74 18                	je     100c09 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bfb:	89 04 24             	mov    %eax,(%esp)
  100bfe:	e8 f8 fe ff ff       	call   100afb <runcmd>
  100c03:	85 c0                	test   %eax,%eax
  100c05:	79 02                	jns    100c09 <kmonitor+0x5c>
                break;
  100c07:	eb 02                	jmp    100c0b <kmonitor+0x5e>
            }
        }
    }
  100c09:	eb d1                	jmp    100bdc <kmonitor+0x2f>
}
  100c0b:	c9                   	leave  
  100c0c:	c3                   	ret    

00100c0d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c0d:	55                   	push   %ebp
  100c0e:	89 e5                	mov    %esp,%ebp
  100c10:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c1a:	eb 3f                	jmp    100c5b <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1f:	89 d0                	mov    %edx,%eax
  100c21:	01 c0                	add    %eax,%eax
  100c23:	01 d0                	add    %edx,%eax
  100c25:	c1 e0 02             	shl    $0x2,%eax
  100c28:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c2d:	8b 48 04             	mov    0x4(%eax),%ecx
  100c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c33:	89 d0                	mov    %edx,%eax
  100c35:	01 c0                	add    %eax,%eax
  100c37:	01 d0                	add    %edx,%eax
  100c39:	c1 e0 02             	shl    $0x2,%eax
  100c3c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c41:	8b 00                	mov    (%eax),%eax
  100c43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4b:	c7 04 24 1d 37 10 00 	movl   $0x10371d,(%esp)
  100c52:	e8 bb f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c57:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5e:	83 f8 02             	cmp    $0x2,%eax
  100c61:	76 b9                	jbe    100c1c <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c68:	c9                   	leave  
  100c69:	c3                   	ret    

00100c6a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c6a:	55                   	push   %ebp
  100c6b:	89 e5                	mov    %esp,%ebp
  100c6d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c70:	e8 d1 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7a:	c9                   	leave  
  100c7b:	c3                   	ret    

00100c7c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c7c:	55                   	push   %ebp
  100c7d:	89 e5                	mov    %esp,%ebp
  100c7f:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c82:	e8 09 fd ff ff       	call   100990 <print_stackframe>
    return 0;
  100c87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8c:	c9                   	leave  
  100c8d:	c3                   	ret    

00100c8e <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c8e:	55                   	push   %ebp
  100c8f:	89 e5                	mov    %esp,%ebp
  100c91:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c94:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100c99:	85 c0                	test   %eax,%eax
  100c9b:	74 02                	je     100c9f <__panic+0x11>
        goto panic_dead;
  100c9d:	eb 48                	jmp    100ce7 <__panic+0x59>
    }
    is_panic = 1;
  100c9f:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100ca6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ca9:	8d 45 14             	lea    0x14(%ebp),%eax
  100cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cbd:	c7 04 24 26 37 10 00 	movl   $0x103726,(%esp)
  100cc4:	e8 49 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd0:	8b 45 10             	mov    0x10(%ebp),%eax
  100cd3:	89 04 24             	mov    %eax,(%esp)
  100cd6:	e8 04 f6 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cdb:	c7 04 24 42 37 10 00 	movl   $0x103742,(%esp)
  100ce2:	e8 2b f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100ce7:	e8 22 09 00 00       	call   10160e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100cf3:	e8 b5 fe ff ff       	call   100bad <kmonitor>
    }
  100cf8:	eb f2                	jmp    100cec <__panic+0x5e>

00100cfa <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100cfa:	55                   	push   %ebp
  100cfb:	89 e5                	mov    %esp,%ebp
  100cfd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d00:	8d 45 14             	lea    0x14(%ebp),%eax
  100d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d09:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d14:	c7 04 24 44 37 10 00 	movl   $0x103744,(%esp)
  100d1b:	e8 f2 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d27:	8b 45 10             	mov    0x10(%ebp),%eax
  100d2a:	89 04 24             	mov    %eax,(%esp)
  100d2d:	e8 ad f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d32:	c7 04 24 42 37 10 00 	movl   $0x103742,(%esp)
  100d39:	e8 d4 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d3e:	c9                   	leave  
  100d3f:	c3                   	ret    

00100d40 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d40:	55                   	push   %ebp
  100d41:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d43:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d48:	5d                   	pop    %ebp
  100d49:	c3                   	ret    

00100d4a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d4a:	55                   	push   %ebp
  100d4b:	89 e5                	mov    %esp,%ebp
  100d4d:	83 ec 28             	sub    $0x28,%esp
  100d50:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d56:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d5a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d5e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d62:	ee                   	out    %al,(%dx)
  100d63:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d69:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d6d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d71:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d75:	ee                   	out    %al,(%dx)
  100d76:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d7c:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d88:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d89:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d90:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d93:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100d9a:	e8 73 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100d9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100da6:	e8 c1 08 00 00       	call   10166c <pic_enable>
}
  100dab:	c9                   	leave  
  100dac:	c3                   	ret    

00100dad <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dad:	55                   	push   %ebp
  100dae:	89 e5                	mov    %esp,%ebp
  100db0:	83 ec 10             	sub    $0x10,%esp
  100db3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dbd:	89 c2                	mov    %eax,%edx
  100dbf:	ec                   	in     (%dx),%al
  100dc0:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dc3:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dc9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dcd:	89 c2                	mov    %eax,%edx
  100dcf:	ec                   	in     (%dx),%al
  100dd0:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dd3:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dd9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ddd:	89 c2                	mov    %eax,%edx
  100ddf:	ec                   	in     (%dx),%al
  100de0:	88 45 f5             	mov    %al,-0xb(%ebp)
  100de3:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100de9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ded:	89 c2                	mov    %eax,%edx
  100def:	ec                   	in     (%dx),%al
  100df0:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100df3:	c9                   	leave  
  100df4:	c3                   	ret    

00100df5 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100df5:	55                   	push   %ebp
  100df6:	89 e5                	mov    %esp,%ebp
  100df8:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dfb:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e05:	0f b7 00             	movzwl (%eax),%eax
  100e08:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e17:	0f b7 00             	movzwl (%eax),%eax
  100e1a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e1e:	74 12                	je     100e32 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e20:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e27:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e2e:	b4 03 
  100e30:	eb 13                	jmp    100e45 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e35:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e39:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e3c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e43:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e45:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e4c:	0f b7 c0             	movzwl %ax,%eax
  100e4f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e53:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e57:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e5b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e5f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e60:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e67:	83 c0 01             	add    $0x1,%eax
  100e6a:	0f b7 c0             	movzwl %ax,%eax
  100e6d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e71:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e75:	89 c2                	mov    %eax,%edx
  100e77:	ec                   	in     (%dx),%al
  100e78:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e7b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e7f:	0f b6 c0             	movzbl %al,%eax
  100e82:	c1 e0 08             	shl    $0x8,%eax
  100e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e88:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8f:	0f b7 c0             	movzwl %ax,%eax
  100e92:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e96:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e9a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e9e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ea2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ea3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eaa:	83 c0 01             	add    $0x1,%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb4:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100eb8:	89 c2                	mov    %eax,%edx
  100eba:	ec                   	in     (%dx),%al
  100ebb:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ebe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ec2:	0f b6 c0             	movzbl %al,%eax
  100ec5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ecb:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed9:	c9                   	leave  
  100eda:	c3                   	ret    

00100edb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100edb:	55                   	push   %ebp
  100edc:	89 e5                	mov    %esp,%ebp
  100ede:	83 ec 48             	sub    $0x48,%esp
  100ee1:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ee7:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eeb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100eef:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ef3:	ee                   	out    %al,(%dx)
  100ef4:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100efa:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100efe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f06:	ee                   	out    %al,(%dx)
  100f07:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f0d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f11:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f15:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f19:	ee                   	out    %al,(%dx)
  100f1a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f20:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f24:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f28:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f2c:	ee                   	out    %al,(%dx)
  100f2d:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f33:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f37:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
  100f40:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f46:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f4a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f4e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f52:	ee                   	out    %al,(%dx)
  100f53:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f59:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f5d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f61:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f65:	ee                   	out    %al,(%dx)
  100f66:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f6c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f70:	89 c2                	mov    %eax,%edx
  100f72:	ec                   	in     (%dx),%al
  100f73:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f76:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f7a:	3c ff                	cmp    $0xff,%al
  100f7c:	0f 95 c0             	setne  %al
  100f7f:	0f b6 c0             	movzbl %al,%eax
  100f82:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f87:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f91:	89 c2                	mov    %eax,%edx
  100f93:	ec                   	in     (%dx),%al
  100f94:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f97:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f9d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fa1:	89 c2                	mov    %eax,%edx
  100fa3:	ec                   	in     (%dx),%al
  100fa4:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fac:	85 c0                	test   %eax,%eax
  100fae:	74 0c                	je     100fbc <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fb0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fb7:	e8 b0 06 00 00       	call   10166c <pic_enable>
    }
}
  100fbc:	c9                   	leave  
  100fbd:	c3                   	ret    

00100fbe <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fbe:	55                   	push   %ebp
  100fbf:	89 e5                	mov    %esp,%ebp
  100fc1:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fcb:	eb 09                	jmp    100fd6 <lpt_putc_sub+0x18>
        delay();
  100fcd:	e8 db fd ff ff       	call   100dad <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fdc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fe0:	89 c2                	mov    %eax,%edx
  100fe2:	ec                   	in     (%dx),%al
  100fe3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fea:	84 c0                	test   %al,%al
  100fec:	78 09                	js     100ff7 <lpt_putc_sub+0x39>
  100fee:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff5:	7e d6                	jle    100fcd <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffa:	0f b6 c0             	movzbl %al,%eax
  100ffd:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101003:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101006:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10100a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10100e:	ee                   	out    %al,(%dx)
  10100f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101015:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101019:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101021:	ee                   	out    %al,(%dx)
  101022:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101028:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10102c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101030:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101034:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101035:	c9                   	leave  
  101036:	c3                   	ret    

00101037 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101037:	55                   	push   %ebp
  101038:	89 e5                	mov    %esp,%ebp
  10103a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10103d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101041:	74 0d                	je     101050 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101043:	8b 45 08             	mov    0x8(%ebp),%eax
  101046:	89 04 24             	mov    %eax,(%esp)
  101049:	e8 70 ff ff ff       	call   100fbe <lpt_putc_sub>
  10104e:	eb 24                	jmp    101074 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101050:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101057:	e8 62 ff ff ff       	call   100fbe <lpt_putc_sub>
        lpt_putc_sub(' ');
  10105c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101063:	e8 56 ff ff ff       	call   100fbe <lpt_putc_sub>
        lpt_putc_sub('\b');
  101068:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10106f:	e8 4a ff ff ff       	call   100fbe <lpt_putc_sub>
    }
}
  101074:	c9                   	leave  
  101075:	c3                   	ret    

00101076 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101076:	55                   	push   %ebp
  101077:	89 e5                	mov    %esp,%ebp
  101079:	53                   	push   %ebx
  10107a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10107d:	8b 45 08             	mov    0x8(%ebp),%eax
  101080:	b0 00                	mov    $0x0,%al
  101082:	85 c0                	test   %eax,%eax
  101084:	75 07                	jne    10108d <cga_putc+0x17>
        c |= 0x0700;
  101086:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10108d:	8b 45 08             	mov    0x8(%ebp),%eax
  101090:	0f b6 c0             	movzbl %al,%eax
  101093:	83 f8 0a             	cmp    $0xa,%eax
  101096:	74 4c                	je     1010e4 <cga_putc+0x6e>
  101098:	83 f8 0d             	cmp    $0xd,%eax
  10109b:	74 57                	je     1010f4 <cga_putc+0x7e>
  10109d:	83 f8 08             	cmp    $0x8,%eax
  1010a0:	0f 85 88 00 00 00    	jne    10112e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010a6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ad:	66 85 c0             	test   %ax,%ax
  1010b0:	74 30                	je     1010e2 <cga_putc+0x6c>
            crt_pos --;
  1010b2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b9:	83 e8 01             	sub    $0x1,%eax
  1010bc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010c2:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010c7:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010ce:	0f b7 d2             	movzwl %dx,%edx
  1010d1:	01 d2                	add    %edx,%edx
  1010d3:	01 c2                	add    %eax,%edx
  1010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d8:	b0 00                	mov    $0x0,%al
  1010da:	83 c8 20             	or     $0x20,%eax
  1010dd:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010e0:	eb 72                	jmp    101154 <cga_putc+0xde>
  1010e2:	eb 70                	jmp    101154 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010e4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010eb:	83 c0 50             	add    $0x50,%eax
  1010ee:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f4:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010fb:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101102:	0f b7 c1             	movzwl %cx,%eax
  101105:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10110b:	c1 e8 10             	shr    $0x10,%eax
  10110e:	89 c2                	mov    %eax,%edx
  101110:	66 c1 ea 06          	shr    $0x6,%dx
  101114:	89 d0                	mov    %edx,%eax
  101116:	c1 e0 02             	shl    $0x2,%eax
  101119:	01 d0                	add    %edx,%eax
  10111b:	c1 e0 04             	shl    $0x4,%eax
  10111e:	29 c1                	sub    %eax,%ecx
  101120:	89 ca                	mov    %ecx,%edx
  101122:	89 d8                	mov    %ebx,%eax
  101124:	29 d0                	sub    %edx,%eax
  101126:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10112c:	eb 26                	jmp    101154 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101134:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10113b:	8d 50 01             	lea    0x1(%eax),%edx
  10113e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101145:	0f b7 c0             	movzwl %ax,%eax
  101148:	01 c0                	add    %eax,%eax
  10114a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10114d:	8b 45 08             	mov    0x8(%ebp),%eax
  101150:	66 89 02             	mov    %ax,(%edx)
        break;
  101153:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101154:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10115f:	76 5b                	jbe    1011bc <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101161:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101166:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10116c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101171:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101178:	00 
  101179:	89 54 24 04          	mov    %edx,0x4(%esp)
  10117d:	89 04 24             	mov    %eax,(%esp)
  101180:	e8 83 21 00 00       	call   103308 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101185:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10118c:	eb 15                	jmp    1011a3 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10118e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101196:	01 d2                	add    %edx,%edx
  101198:	01 d0                	add    %edx,%eax
  10119a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011a3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011aa:	7e e2                	jle    10118e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ac:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b3:	83 e8 50             	sub    $0x50,%eax
  1011b6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011bc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011c3:	0f b7 c0             	movzwl %ax,%eax
  1011c6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011ca:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011ce:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011d2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011d6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011de:	66 c1 e8 08          	shr    $0x8,%ax
  1011e2:	0f b6 c0             	movzbl %al,%eax
  1011e5:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011ec:	83 c2 01             	add    $0x1,%edx
  1011ef:	0f b7 d2             	movzwl %dx,%edx
  1011f2:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011f6:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011f9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011fd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101201:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101202:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101209:	0f b7 c0             	movzwl %ax,%eax
  10120c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101210:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101214:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101218:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10121c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10121d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101224:	0f b6 c0             	movzbl %al,%eax
  101227:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10122e:	83 c2 01             	add    $0x1,%edx
  101231:	0f b7 d2             	movzwl %dx,%edx
  101234:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101238:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10123b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10123f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101243:	ee                   	out    %al,(%dx)
}
  101244:	83 c4 34             	add    $0x34,%esp
  101247:	5b                   	pop    %ebx
  101248:	5d                   	pop    %ebp
  101249:	c3                   	ret    

0010124a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10124a:	55                   	push   %ebp
  10124b:	89 e5                	mov    %esp,%ebp
  10124d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101250:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101257:	eb 09                	jmp    101262 <serial_putc_sub+0x18>
        delay();
  101259:	e8 4f fb ff ff       	call   100dad <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10125e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101262:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101268:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10126c:	89 c2                	mov    %eax,%edx
  10126e:	ec                   	in     (%dx),%al
  10126f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101272:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101276:	0f b6 c0             	movzbl %al,%eax
  101279:	83 e0 20             	and    $0x20,%eax
  10127c:	85 c0                	test   %eax,%eax
  10127e:	75 09                	jne    101289 <serial_putc_sub+0x3f>
  101280:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101287:	7e d0                	jle    101259 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101289:	8b 45 08             	mov    0x8(%ebp),%eax
  10128c:	0f b6 c0             	movzbl %al,%eax
  10128f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101295:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101298:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10129c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012a0:	ee                   	out    %al,(%dx)
}
  1012a1:	c9                   	leave  
  1012a2:	c3                   	ret    

001012a3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012a3:	55                   	push   %ebp
  1012a4:	89 e5                	mov    %esp,%ebp
  1012a6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012a9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012ad:	74 0d                	je     1012bc <serial_putc+0x19>
        serial_putc_sub(c);
  1012af:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b2:	89 04 24             	mov    %eax,(%esp)
  1012b5:	e8 90 ff ff ff       	call   10124a <serial_putc_sub>
  1012ba:	eb 24                	jmp    1012e0 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012bc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012c3:	e8 82 ff ff ff       	call   10124a <serial_putc_sub>
        serial_putc_sub(' ');
  1012c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012cf:	e8 76 ff ff ff       	call   10124a <serial_putc_sub>
        serial_putc_sub('\b');
  1012d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012db:	e8 6a ff ff ff       	call   10124a <serial_putc_sub>
    }
}
  1012e0:	c9                   	leave  
  1012e1:	c3                   	ret    

001012e2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012e2:	55                   	push   %ebp
  1012e3:	89 e5                	mov    %esp,%ebp
  1012e5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012e8:	eb 33                	jmp    10131d <cons_intr+0x3b>
        if (c != 0) {
  1012ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012ee:	74 2d                	je     10131d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012f5:	8d 50 01             	lea    0x1(%eax),%edx
  1012f8:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101301:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101307:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10130c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101311:	75 0a                	jne    10131d <cons_intr+0x3b>
                cons.wpos = 0;
  101313:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10131a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10131d:	8b 45 08             	mov    0x8(%ebp),%eax
  101320:	ff d0                	call   *%eax
  101322:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101325:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101329:	75 bf                	jne    1012ea <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10132b:	c9                   	leave  
  10132c:	c3                   	ret    

0010132d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10132d:	55                   	push   %ebp
  10132e:	89 e5                	mov    %esp,%ebp
  101330:	83 ec 10             	sub    $0x10,%esp
  101333:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101339:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10133d:	89 c2                	mov    %eax,%edx
  10133f:	ec                   	in     (%dx),%al
  101340:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101343:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101347:	0f b6 c0             	movzbl %al,%eax
  10134a:	83 e0 01             	and    $0x1,%eax
  10134d:	85 c0                	test   %eax,%eax
  10134f:	75 07                	jne    101358 <serial_proc_data+0x2b>
        return -1;
  101351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101356:	eb 2a                	jmp    101382 <serial_proc_data+0x55>
  101358:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10135e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101362:	89 c2                	mov    %eax,%edx
  101364:	ec                   	in     (%dx),%al
  101365:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101368:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10136c:	0f b6 c0             	movzbl %al,%eax
  10136f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101372:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101376:	75 07                	jne    10137f <serial_proc_data+0x52>
        c = '\b';
  101378:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10137f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101382:	c9                   	leave  
  101383:	c3                   	ret    

00101384 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101384:	55                   	push   %ebp
  101385:	89 e5                	mov    %esp,%ebp
  101387:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10138a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10138f:	85 c0                	test   %eax,%eax
  101391:	74 0c                	je     10139f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101393:	c7 04 24 2d 13 10 00 	movl   $0x10132d,(%esp)
  10139a:	e8 43 ff ff ff       	call   1012e2 <cons_intr>
    }
}
  10139f:	c9                   	leave  
  1013a0:	c3                   	ret    

001013a1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013a1:	55                   	push   %ebp
  1013a2:	89 e5                	mov    %esp,%ebp
  1013a4:	83 ec 38             	sub    $0x38,%esp
  1013a7:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ad:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013b1:	89 c2                	mov    %eax,%edx
  1013b3:	ec                   	in     (%dx),%al
  1013b4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013bb:	0f b6 c0             	movzbl %al,%eax
  1013be:	83 e0 01             	and    $0x1,%eax
  1013c1:	85 c0                	test   %eax,%eax
  1013c3:	75 0a                	jne    1013cf <kbd_proc_data+0x2e>
        return -1;
  1013c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ca:	e9 59 01 00 00       	jmp    101528 <kbd_proc_data+0x187>
  1013cf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013d9:	89 c2                	mov    %eax,%edx
  1013db:	ec                   	in     (%dx),%al
  1013dc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013df:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013e3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013ea:	75 17                	jne    101403 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013ec:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f1:	83 c8 40             	or     $0x40,%eax
  1013f4:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f9:	b8 00 00 00 00       	mov    $0x0,%eax
  1013fe:	e9 25 01 00 00       	jmp    101528 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101403:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101407:	84 c0                	test   %al,%al
  101409:	79 47                	jns    101452 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10140b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101410:	83 e0 40             	and    $0x40,%eax
  101413:	85 c0                	test   %eax,%eax
  101415:	75 09                	jne    101420 <kbd_proc_data+0x7f>
  101417:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141b:	83 e0 7f             	and    $0x7f,%eax
  10141e:	eb 04                	jmp    101424 <kbd_proc_data+0x83>
  101420:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101424:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101427:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101432:	83 c8 40             	or     $0x40,%eax
  101435:	0f b6 c0             	movzbl %al,%eax
  101438:	f7 d0                	not    %eax
  10143a:	89 c2                	mov    %eax,%edx
  10143c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101441:	21 d0                	and    %edx,%eax
  101443:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101448:	b8 00 00 00 00       	mov    $0x0,%eax
  10144d:	e9 d6 00 00 00       	jmp    101528 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101452:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101457:	83 e0 40             	and    $0x40,%eax
  10145a:	85 c0                	test   %eax,%eax
  10145c:	74 11                	je     10146f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10145e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101462:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101467:	83 e0 bf             	and    $0xffffffbf,%eax
  10146a:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10146f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101473:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10147a:	0f b6 d0             	movzbl %al,%edx
  10147d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101482:	09 d0                	or     %edx,%eax
  101484:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101489:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148d:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101494:	0f b6 d0             	movzbl %al,%edx
  101497:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149c:	31 d0                	xor    %edx,%eax
  10149e:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014a3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a8:	83 e0 03             	and    $0x3,%eax
  1014ab:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b6:	01 d0                	add    %edx,%eax
  1014b8:	0f b6 00             	movzbl (%eax),%eax
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014c1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c6:	83 e0 08             	and    $0x8,%eax
  1014c9:	85 c0                	test   %eax,%eax
  1014cb:	74 22                	je     1014ef <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014cd:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014d1:	7e 0c                	jle    1014df <kbd_proc_data+0x13e>
  1014d3:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d7:	7f 06                	jg     1014df <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d9:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014dd:	eb 10                	jmp    1014ef <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014df:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014e3:	7e 0a                	jle    1014ef <kbd_proc_data+0x14e>
  1014e5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e9:	7f 04                	jg     1014ef <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014eb:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014ef:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f4:	f7 d0                	not    %eax
  1014f6:	83 e0 06             	and    $0x6,%eax
  1014f9:	85 c0                	test   %eax,%eax
  1014fb:	75 28                	jne    101525 <kbd_proc_data+0x184>
  1014fd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101504:	75 1f                	jne    101525 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101506:	c7 04 24 7d 37 10 00 	movl   $0x10377d,(%esp)
  10150d:	e8 00 ee ff ff       	call   100312 <cprintf>
  101512:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101518:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101520:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101524:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101525:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101528:	c9                   	leave  
  101529:	c3                   	ret    

0010152a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10152a:	55                   	push   %ebp
  10152b:	89 e5                	mov    %esp,%ebp
  10152d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101530:	c7 04 24 a1 13 10 00 	movl   $0x1013a1,(%esp)
  101537:	e8 a6 fd ff ff       	call   1012e2 <cons_intr>
}
  10153c:	c9                   	leave  
  10153d:	c3                   	ret    

0010153e <kbd_init>:

static void
kbd_init(void) {
  10153e:	55                   	push   %ebp
  10153f:	89 e5                	mov    %esp,%ebp
  101541:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101544:	e8 e1 ff ff ff       	call   10152a <kbd_intr>
    pic_enable(IRQ_KBD);
  101549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101550:	e8 17 01 00 00       	call   10166c <pic_enable>
}
  101555:	c9                   	leave  
  101556:	c3                   	ret    

00101557 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101557:	55                   	push   %ebp
  101558:	89 e5                	mov    %esp,%ebp
  10155a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10155d:	e8 93 f8 ff ff       	call   100df5 <cga_init>
    serial_init();
  101562:	e8 74 f9 ff ff       	call   100edb <serial_init>
    kbd_init();
  101567:	e8 d2 ff ff ff       	call   10153e <kbd_init>
    if (!serial_exists) {
  10156c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101571:	85 c0                	test   %eax,%eax
  101573:	75 0c                	jne    101581 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101575:	c7 04 24 89 37 10 00 	movl   $0x103789,(%esp)
  10157c:	e8 91 ed ff ff       	call   100312 <cprintf>
    }
}
  101581:	c9                   	leave  
  101582:	c3                   	ret    

00101583 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101583:	55                   	push   %ebp
  101584:	89 e5                	mov    %esp,%ebp
  101586:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101589:	8b 45 08             	mov    0x8(%ebp),%eax
  10158c:	89 04 24             	mov    %eax,(%esp)
  10158f:	e8 a3 fa ff ff       	call   101037 <lpt_putc>
    cga_putc(c);
  101594:	8b 45 08             	mov    0x8(%ebp),%eax
  101597:	89 04 24             	mov    %eax,(%esp)
  10159a:	e8 d7 fa ff ff       	call   101076 <cga_putc>
    serial_putc(c);
  10159f:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a2:	89 04 24             	mov    %eax,(%esp)
  1015a5:	e8 f9 fc ff ff       	call   1012a3 <serial_putc>
}
  1015aa:	c9                   	leave  
  1015ab:	c3                   	ret    

001015ac <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ac:	55                   	push   %ebp
  1015ad:	89 e5                	mov    %esp,%ebp
  1015af:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015b2:	e8 cd fd ff ff       	call   101384 <serial_intr>
    kbd_intr();
  1015b7:	e8 6e ff ff ff       	call   10152a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015bc:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015c2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015c7:	39 c2                	cmp    %eax,%edx
  1015c9:	74 36                	je     101601 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015cb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d0:	8d 50 01             	lea    0x1(%eax),%edx
  1015d3:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015d9:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015e0:	0f b6 c0             	movzbl %al,%eax
  1015e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015e6:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015eb:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015f0:	75 0a                	jne    1015fc <cons_getc+0x50>
            cons.rpos = 0;
  1015f2:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015f9:	00 00 00 
        }
        return c;
  1015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015ff:	eb 05                	jmp    101606 <cons_getc+0x5a>
    }
    return 0;
  101601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101606:	c9                   	leave  
  101607:	c3                   	ret    

00101608 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101608:	55                   	push   %ebp
  101609:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10160b:	fb                   	sti    
    sti();
}
  10160c:	5d                   	pop    %ebp
  10160d:	c3                   	ret    

0010160e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10160e:	55                   	push   %ebp
  10160f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101611:	fa                   	cli    
    cli();
}
  101612:	5d                   	pop    %ebp
  101613:	c3                   	ret    

00101614 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101614:	55                   	push   %ebp
  101615:	89 e5                	mov    %esp,%ebp
  101617:	83 ec 14             	sub    $0x14,%esp
  10161a:	8b 45 08             	mov    0x8(%ebp),%eax
  10161d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101621:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101625:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10162b:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101630:	85 c0                	test   %eax,%eax
  101632:	74 36                	je     10166a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101634:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101638:	0f b6 c0             	movzbl %al,%eax
  10163b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101641:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101644:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101648:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10164c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10164d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101651:	66 c1 e8 08          	shr    $0x8,%ax
  101655:	0f b6 c0             	movzbl %al,%eax
  101658:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10165e:	88 45 f9             	mov    %al,-0x7(%ebp)
  101661:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101665:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101669:	ee                   	out    %al,(%dx)
    }
}
  10166a:	c9                   	leave  
  10166b:	c3                   	ret    

0010166c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10166c:	55                   	push   %ebp
  10166d:	89 e5                	mov    %esp,%ebp
  10166f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101672:	8b 45 08             	mov    0x8(%ebp),%eax
  101675:	ba 01 00 00 00       	mov    $0x1,%edx
  10167a:	89 c1                	mov    %eax,%ecx
  10167c:	d3 e2                	shl    %cl,%edx
  10167e:	89 d0                	mov    %edx,%eax
  101680:	f7 d0                	not    %eax
  101682:	89 c2                	mov    %eax,%edx
  101684:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168b:	21 d0                	and    %edx,%eax
  10168d:	0f b7 c0             	movzwl %ax,%eax
  101690:	89 04 24             	mov    %eax,(%esp)
  101693:	e8 7c ff ff ff       	call   101614 <pic_setmask>
}
  101698:	c9                   	leave  
  101699:	c3                   	ret    

0010169a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10169a:	55                   	push   %ebp
  10169b:	89 e5                	mov    %esp,%ebp
  10169d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016a0:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016a7:	00 00 00 
  1016aa:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016b0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016b4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016b8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016bc:	ee                   	out    %al,(%dx)
  1016bd:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016c3:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016cb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016cf:	ee                   	out    %al,(%dx)
  1016d0:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016d6:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016da:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016de:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016e2:	ee                   	out    %al,(%dx)
  1016e3:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016e9:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016ed:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016f1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016f5:	ee                   	out    %al,(%dx)
  1016f6:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016fc:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101700:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101704:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
  101709:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10170f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101713:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101717:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10171b:	ee                   	out    %al,(%dx)
  10171c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101722:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101726:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10172a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10172e:	ee                   	out    %al,(%dx)
  10172f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101735:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101739:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10173d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101741:	ee                   	out    %al,(%dx)
  101742:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101748:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10174c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101750:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10175b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10175f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101763:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10176e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101772:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101776:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101781:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101785:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101789:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101794:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101798:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10179c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017a7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017ab:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017af:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017bb:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017bf:	74 12                	je     1017d3 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017c1:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c8:	0f b7 c0             	movzwl %ax,%eax
  1017cb:	89 04 24             	mov    %eax,(%esp)
  1017ce:	e8 41 fe ff ff       	call   101614 <pic_setmask>
    }
}
  1017d3:	c9                   	leave  
  1017d4:	c3                   	ret    

001017d5 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017d5:	55                   	push   %ebp
  1017d6:	89 e5                	mov    %esp,%ebp
  1017d8:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017db:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017e2:	00 
  1017e3:	c7 04 24 c0 37 10 00 	movl   $0x1037c0,(%esp)
  1017ea:	e8 23 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017ef:	c9                   	leave  
  1017f0:	c3                   	ret    

001017f1 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017f1:	55                   	push   %ebp
  1017f2:	89 e5                	mov    %esp,%ebp
  1017f4:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];

	int i;
	for (i=0; i<256; i++)
  1017f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017fe:	e9 c3 00 00 00       	jmp    1018c6 <idt_init+0xd5>
		SETGATE(idt[i], 0, 8, __vectors[i], 0);
  101803:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101806:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10180d:	89 c2                	mov    %eax,%edx
  10180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101812:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101819:	00 
  10181a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181d:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101824:	00 08 00 
  101827:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182a:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101831:	00 
  101832:	83 e2 e0             	and    $0xffffffe0,%edx
  101835:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10183c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101846:	00 
  101847:	83 e2 1f             	and    $0x1f,%edx
  10184a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101851:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101854:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10185b:	00 
  10185c:	83 e2 f0             	and    $0xfffffff0,%edx
  10185f:	83 ca 0e             	or     $0xe,%edx
  101862:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101873:	00 
  101874:	83 e2 ef             	and    $0xffffffef,%edx
  101877:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10187e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101881:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101888:	00 
  101889:	83 e2 9f             	and    $0xffffff9f,%edx
  10188c:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101893:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101896:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189d:	00 
  10189e:	83 ca 80             	or     $0xffffff80,%edx
  1018a1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ab:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018b2:	c1 e8 10             	shr    $0x10,%eax
  1018b5:	89 c2                	mov    %eax,%edx
  1018b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ba:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018c1:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];

	int i;
	for (i=0; i<256; i++)
  1018c2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018c6:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018cd:	0f 8e 30 ff ff ff    	jle    101803 <idt_init+0x12>
		SETGATE(idt[i], 0, 8, __vectors[i], 0);

	SETGATE(idt[T_SYSCALL], 1, 8, __vectors[T_SYSCALL],3);
  1018d3:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  1018d8:	66 a3 a0 f4 10 00    	mov    %ax,0x10f4a0
  1018de:	66 c7 05 a2 f4 10 00 	movw   $0x8,0x10f4a2
  1018e5:	08 00 
  1018e7:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  1018ee:	83 e0 e0             	and    $0xffffffe0,%eax
  1018f1:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  1018f6:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  1018fd:	83 e0 1f             	and    $0x1f,%eax
  101900:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101905:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  10190c:	83 c8 0f             	or     $0xf,%eax
  10190f:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101914:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  10191b:	83 e0 ef             	and    $0xffffffef,%eax
  10191e:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101923:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  10192a:	83 c8 60             	or     $0x60,%eax
  10192d:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101932:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101939:	83 c8 80             	or     $0xffffff80,%eax
  10193c:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101941:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101946:	c1 e8 10             	shr    $0x10,%eax
  101949:	66 a3 a6 f4 10 00    	mov    %ax,0x10f4a6
  10194f:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101956:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101959:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  10195c:	c9                   	leave  
  10195d:	c3                   	ret    

0010195e <trapname>:

static const char *
trapname(int trapno) {
  10195e:	55                   	push   %ebp
  10195f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101961:	8b 45 08             	mov    0x8(%ebp),%eax
  101964:	83 f8 13             	cmp    $0x13,%eax
  101967:	77 0c                	ja     101975 <trapname+0x17>
        return excnames[trapno];
  101969:	8b 45 08             	mov    0x8(%ebp),%eax
  10196c:	8b 04 85 20 3b 10 00 	mov    0x103b20(,%eax,4),%eax
  101973:	eb 18                	jmp    10198d <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101975:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101979:	7e 0d                	jle    101988 <trapname+0x2a>
  10197b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10197f:	7f 07                	jg     101988 <trapname+0x2a>
        return "Hardware Interrupt";
  101981:	b8 ca 37 10 00       	mov    $0x1037ca,%eax
  101986:	eb 05                	jmp    10198d <trapname+0x2f>
    }
    return "(unknown trap)";
  101988:	b8 dd 37 10 00       	mov    $0x1037dd,%eax
}
  10198d:	5d                   	pop    %ebp
  10198e:	c3                   	ret    

0010198f <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10198f:	55                   	push   %ebp
  101990:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101992:	8b 45 08             	mov    0x8(%ebp),%eax
  101995:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101999:	66 83 f8 08          	cmp    $0x8,%ax
  10199d:	0f 94 c0             	sete   %al
  1019a0:	0f b6 c0             	movzbl %al,%eax
}
  1019a3:	5d                   	pop    %ebp
  1019a4:	c3                   	ret    

001019a5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019a5:	55                   	push   %ebp
  1019a6:	89 e5                	mov    %esp,%ebp
  1019a8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019b2:	c7 04 24 1e 38 10 00 	movl   $0x10381e,(%esp)
  1019b9:	e8 54 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019be:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c1:	89 04 24             	mov    %eax,(%esp)
  1019c4:	e8 a1 01 00 00       	call   101b6a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cc:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019d0:	0f b7 c0             	movzwl %ax,%eax
  1019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d7:	c7 04 24 2f 38 10 00 	movl   $0x10382f,(%esp)
  1019de:	e8 2f e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  1019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1019ea:	0f b7 c0             	movzwl %ax,%eax
  1019ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f1:	c7 04 24 42 38 10 00 	movl   $0x103842,(%esp)
  1019f8:	e8 15 e9 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101a00:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a04:	0f b7 c0             	movzwl %ax,%eax
  101a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a0b:	c7 04 24 55 38 10 00 	movl   $0x103855,(%esp)
  101a12:	e8 fb e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a17:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a1e:	0f b7 c0             	movzwl %ax,%eax
  101a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a25:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  101a2c:	e8 e1 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	8b 40 30             	mov    0x30(%eax),%eax
  101a37:	89 04 24             	mov    %eax,(%esp)
  101a3a:	e8 1f ff ff ff       	call   10195e <trapname>
  101a3f:	8b 55 08             	mov    0x8(%ebp),%edx
  101a42:	8b 52 30             	mov    0x30(%edx),%edx
  101a45:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a49:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a4d:	c7 04 24 7b 38 10 00 	movl   $0x10387b,(%esp)
  101a54:	e8 b9 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a59:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5c:	8b 40 34             	mov    0x34(%eax),%eax
  101a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a63:	c7 04 24 8d 38 10 00 	movl   $0x10388d,(%esp)
  101a6a:	e8 a3 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a72:	8b 40 38             	mov    0x38(%eax),%eax
  101a75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a79:	c7 04 24 9c 38 10 00 	movl   $0x10389c,(%esp)
  101a80:	e8 8d e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101a85:	8b 45 08             	mov    0x8(%ebp),%eax
  101a88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a8c:	0f b7 c0             	movzwl %ax,%eax
  101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a93:	c7 04 24 ab 38 10 00 	movl   $0x1038ab,(%esp)
  101a9a:	e8 73 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 40             	mov    0x40(%eax),%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 be 38 10 00 	movl   $0x1038be,(%esp)
  101ab0:	e8 5d e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101abc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ac3:	eb 3e                	jmp    101b03 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	8b 50 40             	mov    0x40(%eax),%edx
  101acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101ace:	21 d0                	and    %edx,%eax
  101ad0:	85 c0                	test   %eax,%eax
  101ad2:	74 28                	je     101afc <print_trapframe+0x157>
  101ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ad7:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101ade:	85 c0                	test   %eax,%eax
  101ae0:	74 1a                	je     101afc <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ae5:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af0:	c7 04 24 cd 38 10 00 	movl   $0x1038cd,(%esp)
  101af7:	e8 16 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101afc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b00:	d1 65 f0             	shll   -0x10(%ebp)
  101b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b06:	83 f8 17             	cmp    $0x17,%eax
  101b09:	76 ba                	jbe    101ac5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 40 40             	mov    0x40(%eax),%eax
  101b11:	25 00 30 00 00       	and    $0x3000,%eax
  101b16:	c1 e8 0c             	shr    $0xc,%eax
  101b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1d:	c7 04 24 d1 38 10 00 	movl   $0x1038d1,(%esp)
  101b24:	e8 e9 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b29:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2c:	89 04 24             	mov    %eax,(%esp)
  101b2f:	e8 5b fe ff ff       	call   10198f <trap_in_kernel>
  101b34:	85 c0                	test   %eax,%eax
  101b36:	75 30                	jne    101b68 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b38:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3b:	8b 40 44             	mov    0x44(%eax),%eax
  101b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b42:	c7 04 24 da 38 10 00 	movl   $0x1038da,(%esp)
  101b49:	e8 c4 e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b51:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b55:	0f b7 c0             	movzwl %ax,%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 e9 38 10 00 	movl   $0x1038e9,(%esp)
  101b63:	e8 aa e7 ff ff       	call   100312 <cprintf>
    }
}
  101b68:	c9                   	leave  
  101b69:	c3                   	ret    

00101b6a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b6a:	55                   	push   %ebp
  101b6b:	89 e5                	mov    %esp,%ebp
  101b6d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b70:	8b 45 08             	mov    0x8(%ebp),%eax
  101b73:	8b 00                	mov    (%eax),%eax
  101b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b79:	c7 04 24 fc 38 10 00 	movl   $0x1038fc,(%esp)
  101b80:	e8 8d e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101b85:	8b 45 08             	mov    0x8(%ebp),%eax
  101b88:	8b 40 04             	mov    0x4(%eax),%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 0b 39 10 00 	movl   $0x10390b,(%esp)
  101b96:	e8 77 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9e:	8b 40 08             	mov    0x8(%eax),%eax
  101ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba5:	c7 04 24 1a 39 10 00 	movl   $0x10391a,(%esp)
  101bac:	e8 61 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb4:	8b 40 0c             	mov    0xc(%eax),%eax
  101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbb:	c7 04 24 29 39 10 00 	movl   $0x103929,(%esp)
  101bc2:	e8 4b e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bca:	8b 40 10             	mov    0x10(%eax),%eax
  101bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd1:	c7 04 24 38 39 10 00 	movl   $0x103938,(%esp)
  101bd8:	e8 35 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	8b 40 14             	mov    0x14(%eax),%eax
  101be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be7:	c7 04 24 47 39 10 00 	movl   $0x103947,(%esp)
  101bee:	e8 1f e7 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf6:	8b 40 18             	mov    0x18(%eax),%eax
  101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfd:	c7 04 24 56 39 10 00 	movl   $0x103956,(%esp)
  101c04:	e8 09 e7 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c13:	c7 04 24 65 39 10 00 	movl   $0x103965,(%esp)
  101c1a:	e8 f3 e6 ff ff       	call   100312 <cprintf>
}
  101c1f:	c9                   	leave  
  101c20:	c3                   	ret    

00101c21 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c21:	55                   	push   %ebp
  101c22:	89 e5                	mov    %esp,%ebp
  101c24:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c27:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2a:	8b 40 30             	mov    0x30(%eax),%eax
  101c2d:	83 f8 2f             	cmp    $0x2f,%eax
  101c30:	77 1d                	ja     101c4f <trap_dispatch+0x2e>
  101c32:	83 f8 2e             	cmp    $0x2e,%eax
  101c35:	0f 83 f2 00 00 00    	jae    101d2d <trap_dispatch+0x10c>
  101c3b:	83 f8 21             	cmp    $0x21,%eax
  101c3e:	74 73                	je     101cb3 <trap_dispatch+0x92>
  101c40:	83 f8 24             	cmp    $0x24,%eax
  101c43:	74 48                	je     101c8d <trap_dispatch+0x6c>
  101c45:	83 f8 20             	cmp    $0x20,%eax
  101c48:	74 13                	je     101c5d <trap_dispatch+0x3c>
  101c4a:	e9 a6 00 00 00       	jmp    101cf5 <trap_dispatch+0xd4>
  101c4f:	83 e8 78             	sub    $0x78,%eax
  101c52:	83 f8 01             	cmp    $0x1,%eax
  101c55:	0f 87 9a 00 00 00    	ja     101cf5 <trap_dispatch+0xd4>
  101c5b:	eb 7c                	jmp    101cd9 <trap_dispatch+0xb8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
		ticks++;
  101c5d:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c62:	83 c0 01             	add    $0x1,%eax
  101c65:	a3 08 f9 10 00       	mov    %eax,0x10f908
		if (ticks==TICK_NUM)
  101c6a:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c6f:	83 f8 64             	cmp    $0x64,%eax
  101c72:	75 14                	jne    101c88 <trap_dispatch+0x67>
		{
			ticks=0;
  101c74:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101c7b:	00 00 00 
			print_ticks();
  101c7e:	e8 52 fb ff ff       	call   1017d5 <print_ticks>
		}
        break;
  101c83:	e9 a6 00 00 00       	jmp    101d2e <trap_dispatch+0x10d>
  101c88:	e9 a1 00 00 00       	jmp    101d2e <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101c8d:	e8 1a f9 ff ff       	call   1015ac <cons_getc>
  101c92:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101c95:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101c99:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101c9d:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca5:	c7 04 24 74 39 10 00 	movl   $0x103974,(%esp)
  101cac:	e8 61 e6 ff ff       	call   100312 <cprintf>
        break;
  101cb1:	eb 7b                	jmp    101d2e <trap_dispatch+0x10d>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101cb3:	e8 f4 f8 ff ff       	call   1015ac <cons_getc>
  101cb8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cbb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cbf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cc3:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccb:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  101cd2:	e8 3b e6 ff ff       	call   100312 <cprintf>
        break;
  101cd7:	eb 55                	jmp    101d2e <trap_dispatch+0x10d>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101cd9:	c7 44 24 08 95 39 10 	movl   $0x103995,0x8(%esp)
  101ce0:	00 
  101ce1:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101ce8:	00 
  101ce9:	c7 04 24 a5 39 10 00 	movl   $0x1039a5,(%esp)
  101cf0:	e8 99 ef ff ff       	call   100c8e <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101cfc:	0f b7 c0             	movzwl %ax,%eax
  101cff:	83 e0 03             	and    $0x3,%eax
  101d02:	85 c0                	test   %eax,%eax
  101d04:	75 28                	jne    101d2e <trap_dispatch+0x10d>
            print_trapframe(tf);
  101d06:	8b 45 08             	mov    0x8(%ebp),%eax
  101d09:	89 04 24             	mov    %eax,(%esp)
  101d0c:	e8 94 fc ff ff       	call   1019a5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d11:	c7 44 24 08 b6 39 10 	movl   $0x1039b6,0x8(%esp)
  101d18:	00 
  101d19:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101d20:	00 
  101d21:	c7 04 24 a5 39 10 00 	movl   $0x1039a5,(%esp)
  101d28:	e8 61 ef ff ff       	call   100c8e <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d2d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d2e:	c9                   	leave  
  101d2f:	c3                   	ret    

00101d30 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d30:	55                   	push   %ebp
  101d31:	89 e5                	mov    %esp,%ebp
  101d33:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d36:	8b 45 08             	mov    0x8(%ebp),%eax
  101d39:	89 04 24             	mov    %eax,(%esp)
  101d3c:	e8 e0 fe ff ff       	call   101c21 <trap_dispatch>
    print_ticks();
  101d41:	e8 8f fa ff ff       	call   1017d5 <print_ticks>
}
  101d46:	c9                   	leave  
  101d47:	c3                   	ret    

00101d48 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d48:	1e                   	push   %ds
    pushl %es
  101d49:	06                   	push   %es
    pushl %fs
  101d4a:	0f a0                	push   %fs
    pushl %gs
  101d4c:	0f a8                	push   %gs
    pushal
  101d4e:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d4f:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d54:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d56:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d58:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d59:	e8 d2 ff ff ff       	call   101d30 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d5e:	5c                   	pop    %esp

00101d5f <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d5f:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d60:	0f a9                	pop    %gs
    popl %fs
  101d62:	0f a1                	pop    %fs
    popl %es
  101d64:	07                   	pop    %es
    popl %ds
  101d65:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d66:	83 c4 08             	add    $0x8,%esp
    iret
  101d69:	cf                   	iret   

00101d6a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $0
  101d6c:	6a 00                	push   $0x0
  jmp __alltraps
  101d6e:	e9 d5 ff ff ff       	jmp    101d48 <__alltraps>

00101d73 <vector1>:
.globl vector1
vector1:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $1
  101d75:	6a 01                	push   $0x1
  jmp __alltraps
  101d77:	e9 cc ff ff ff       	jmp    101d48 <__alltraps>

00101d7c <vector2>:
.globl vector2
vector2:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $2
  101d7e:	6a 02                	push   $0x2
  jmp __alltraps
  101d80:	e9 c3 ff ff ff       	jmp    101d48 <__alltraps>

00101d85 <vector3>:
.globl vector3
vector3:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $3
  101d87:	6a 03                	push   $0x3
  jmp __alltraps
  101d89:	e9 ba ff ff ff       	jmp    101d48 <__alltraps>

00101d8e <vector4>:
.globl vector4
vector4:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $4
  101d90:	6a 04                	push   $0x4
  jmp __alltraps
  101d92:	e9 b1 ff ff ff       	jmp    101d48 <__alltraps>

00101d97 <vector5>:
.globl vector5
vector5:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $5
  101d99:	6a 05                	push   $0x5
  jmp __alltraps
  101d9b:	e9 a8 ff ff ff       	jmp    101d48 <__alltraps>

00101da0 <vector6>:
.globl vector6
vector6:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $6
  101da2:	6a 06                	push   $0x6
  jmp __alltraps
  101da4:	e9 9f ff ff ff       	jmp    101d48 <__alltraps>

00101da9 <vector7>:
.globl vector7
vector7:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $7
  101dab:	6a 07                	push   $0x7
  jmp __alltraps
  101dad:	e9 96 ff ff ff       	jmp    101d48 <__alltraps>

00101db2 <vector8>:
.globl vector8
vector8:
  pushl $8
  101db2:	6a 08                	push   $0x8
  jmp __alltraps
  101db4:	e9 8f ff ff ff       	jmp    101d48 <__alltraps>

00101db9 <vector9>:
.globl vector9
vector9:
  pushl $9
  101db9:	6a 09                	push   $0x9
  jmp __alltraps
  101dbb:	e9 88 ff ff ff       	jmp    101d48 <__alltraps>

00101dc0 <vector10>:
.globl vector10
vector10:
  pushl $10
  101dc0:	6a 0a                	push   $0xa
  jmp __alltraps
  101dc2:	e9 81 ff ff ff       	jmp    101d48 <__alltraps>

00101dc7 <vector11>:
.globl vector11
vector11:
  pushl $11
  101dc7:	6a 0b                	push   $0xb
  jmp __alltraps
  101dc9:	e9 7a ff ff ff       	jmp    101d48 <__alltraps>

00101dce <vector12>:
.globl vector12
vector12:
  pushl $12
  101dce:	6a 0c                	push   $0xc
  jmp __alltraps
  101dd0:	e9 73 ff ff ff       	jmp    101d48 <__alltraps>

00101dd5 <vector13>:
.globl vector13
vector13:
  pushl $13
  101dd5:	6a 0d                	push   $0xd
  jmp __alltraps
  101dd7:	e9 6c ff ff ff       	jmp    101d48 <__alltraps>

00101ddc <vector14>:
.globl vector14
vector14:
  pushl $14
  101ddc:	6a 0e                	push   $0xe
  jmp __alltraps
  101dde:	e9 65 ff ff ff       	jmp    101d48 <__alltraps>

00101de3 <vector15>:
.globl vector15
vector15:
  pushl $0
  101de3:	6a 00                	push   $0x0
  pushl $15
  101de5:	6a 0f                	push   $0xf
  jmp __alltraps
  101de7:	e9 5c ff ff ff       	jmp    101d48 <__alltraps>

00101dec <vector16>:
.globl vector16
vector16:
  pushl $0
  101dec:	6a 00                	push   $0x0
  pushl $16
  101dee:	6a 10                	push   $0x10
  jmp __alltraps
  101df0:	e9 53 ff ff ff       	jmp    101d48 <__alltraps>

00101df5 <vector17>:
.globl vector17
vector17:
  pushl $17
  101df5:	6a 11                	push   $0x11
  jmp __alltraps
  101df7:	e9 4c ff ff ff       	jmp    101d48 <__alltraps>

00101dfc <vector18>:
.globl vector18
vector18:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $18
  101dfe:	6a 12                	push   $0x12
  jmp __alltraps
  101e00:	e9 43 ff ff ff       	jmp    101d48 <__alltraps>

00101e05 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e05:	6a 00                	push   $0x0
  pushl $19
  101e07:	6a 13                	push   $0x13
  jmp __alltraps
  101e09:	e9 3a ff ff ff       	jmp    101d48 <__alltraps>

00101e0e <vector20>:
.globl vector20
vector20:
  pushl $0
  101e0e:	6a 00                	push   $0x0
  pushl $20
  101e10:	6a 14                	push   $0x14
  jmp __alltraps
  101e12:	e9 31 ff ff ff       	jmp    101d48 <__alltraps>

00101e17 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $21
  101e19:	6a 15                	push   $0x15
  jmp __alltraps
  101e1b:	e9 28 ff ff ff       	jmp    101d48 <__alltraps>

00101e20 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $22
  101e22:	6a 16                	push   $0x16
  jmp __alltraps
  101e24:	e9 1f ff ff ff       	jmp    101d48 <__alltraps>

00101e29 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $23
  101e2b:	6a 17                	push   $0x17
  jmp __alltraps
  101e2d:	e9 16 ff ff ff       	jmp    101d48 <__alltraps>

00101e32 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $24
  101e34:	6a 18                	push   $0x18
  jmp __alltraps
  101e36:	e9 0d ff ff ff       	jmp    101d48 <__alltraps>

00101e3b <vector25>:
.globl vector25
vector25:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $25
  101e3d:	6a 19                	push   $0x19
  jmp __alltraps
  101e3f:	e9 04 ff ff ff       	jmp    101d48 <__alltraps>

00101e44 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $26
  101e46:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e48:	e9 fb fe ff ff       	jmp    101d48 <__alltraps>

00101e4d <vector27>:
.globl vector27
vector27:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $27
  101e4f:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e51:	e9 f2 fe ff ff       	jmp    101d48 <__alltraps>

00101e56 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $28
  101e58:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e5a:	e9 e9 fe ff ff       	jmp    101d48 <__alltraps>

00101e5f <vector29>:
.globl vector29
vector29:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $29
  101e61:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e63:	e9 e0 fe ff ff       	jmp    101d48 <__alltraps>

00101e68 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $30
  101e6a:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e6c:	e9 d7 fe ff ff       	jmp    101d48 <__alltraps>

00101e71 <vector31>:
.globl vector31
vector31:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $31
  101e73:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e75:	e9 ce fe ff ff       	jmp    101d48 <__alltraps>

00101e7a <vector32>:
.globl vector32
vector32:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $32
  101e7c:	6a 20                	push   $0x20
  jmp __alltraps
  101e7e:	e9 c5 fe ff ff       	jmp    101d48 <__alltraps>

00101e83 <vector33>:
.globl vector33
vector33:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $33
  101e85:	6a 21                	push   $0x21
  jmp __alltraps
  101e87:	e9 bc fe ff ff       	jmp    101d48 <__alltraps>

00101e8c <vector34>:
.globl vector34
vector34:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $34
  101e8e:	6a 22                	push   $0x22
  jmp __alltraps
  101e90:	e9 b3 fe ff ff       	jmp    101d48 <__alltraps>

00101e95 <vector35>:
.globl vector35
vector35:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $35
  101e97:	6a 23                	push   $0x23
  jmp __alltraps
  101e99:	e9 aa fe ff ff       	jmp    101d48 <__alltraps>

00101e9e <vector36>:
.globl vector36
vector36:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $36
  101ea0:	6a 24                	push   $0x24
  jmp __alltraps
  101ea2:	e9 a1 fe ff ff       	jmp    101d48 <__alltraps>

00101ea7 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $37
  101ea9:	6a 25                	push   $0x25
  jmp __alltraps
  101eab:	e9 98 fe ff ff       	jmp    101d48 <__alltraps>

00101eb0 <vector38>:
.globl vector38
vector38:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $38
  101eb2:	6a 26                	push   $0x26
  jmp __alltraps
  101eb4:	e9 8f fe ff ff       	jmp    101d48 <__alltraps>

00101eb9 <vector39>:
.globl vector39
vector39:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $39
  101ebb:	6a 27                	push   $0x27
  jmp __alltraps
  101ebd:	e9 86 fe ff ff       	jmp    101d48 <__alltraps>

00101ec2 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $40
  101ec4:	6a 28                	push   $0x28
  jmp __alltraps
  101ec6:	e9 7d fe ff ff       	jmp    101d48 <__alltraps>

00101ecb <vector41>:
.globl vector41
vector41:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $41
  101ecd:	6a 29                	push   $0x29
  jmp __alltraps
  101ecf:	e9 74 fe ff ff       	jmp    101d48 <__alltraps>

00101ed4 <vector42>:
.globl vector42
vector42:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $42
  101ed6:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ed8:	e9 6b fe ff ff       	jmp    101d48 <__alltraps>

00101edd <vector43>:
.globl vector43
vector43:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $43
  101edf:	6a 2b                	push   $0x2b
  jmp __alltraps
  101ee1:	e9 62 fe ff ff       	jmp    101d48 <__alltraps>

00101ee6 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $44
  101ee8:	6a 2c                	push   $0x2c
  jmp __alltraps
  101eea:	e9 59 fe ff ff       	jmp    101d48 <__alltraps>

00101eef <vector45>:
.globl vector45
vector45:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $45
  101ef1:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ef3:	e9 50 fe ff ff       	jmp    101d48 <__alltraps>

00101ef8 <vector46>:
.globl vector46
vector46:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $46
  101efa:	6a 2e                	push   $0x2e
  jmp __alltraps
  101efc:	e9 47 fe ff ff       	jmp    101d48 <__alltraps>

00101f01 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $47
  101f03:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f05:	e9 3e fe ff ff       	jmp    101d48 <__alltraps>

00101f0a <vector48>:
.globl vector48
vector48:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $48
  101f0c:	6a 30                	push   $0x30
  jmp __alltraps
  101f0e:	e9 35 fe ff ff       	jmp    101d48 <__alltraps>

00101f13 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $49
  101f15:	6a 31                	push   $0x31
  jmp __alltraps
  101f17:	e9 2c fe ff ff       	jmp    101d48 <__alltraps>

00101f1c <vector50>:
.globl vector50
vector50:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $50
  101f1e:	6a 32                	push   $0x32
  jmp __alltraps
  101f20:	e9 23 fe ff ff       	jmp    101d48 <__alltraps>

00101f25 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $51
  101f27:	6a 33                	push   $0x33
  jmp __alltraps
  101f29:	e9 1a fe ff ff       	jmp    101d48 <__alltraps>

00101f2e <vector52>:
.globl vector52
vector52:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $52
  101f30:	6a 34                	push   $0x34
  jmp __alltraps
  101f32:	e9 11 fe ff ff       	jmp    101d48 <__alltraps>

00101f37 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $53
  101f39:	6a 35                	push   $0x35
  jmp __alltraps
  101f3b:	e9 08 fe ff ff       	jmp    101d48 <__alltraps>

00101f40 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $54
  101f42:	6a 36                	push   $0x36
  jmp __alltraps
  101f44:	e9 ff fd ff ff       	jmp    101d48 <__alltraps>

00101f49 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $55
  101f4b:	6a 37                	push   $0x37
  jmp __alltraps
  101f4d:	e9 f6 fd ff ff       	jmp    101d48 <__alltraps>

00101f52 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $56
  101f54:	6a 38                	push   $0x38
  jmp __alltraps
  101f56:	e9 ed fd ff ff       	jmp    101d48 <__alltraps>

00101f5b <vector57>:
.globl vector57
vector57:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $57
  101f5d:	6a 39                	push   $0x39
  jmp __alltraps
  101f5f:	e9 e4 fd ff ff       	jmp    101d48 <__alltraps>

00101f64 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $58
  101f66:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f68:	e9 db fd ff ff       	jmp    101d48 <__alltraps>

00101f6d <vector59>:
.globl vector59
vector59:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $59
  101f6f:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f71:	e9 d2 fd ff ff       	jmp    101d48 <__alltraps>

00101f76 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $60
  101f78:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f7a:	e9 c9 fd ff ff       	jmp    101d48 <__alltraps>

00101f7f <vector61>:
.globl vector61
vector61:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $61
  101f81:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f83:	e9 c0 fd ff ff       	jmp    101d48 <__alltraps>

00101f88 <vector62>:
.globl vector62
vector62:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $62
  101f8a:	6a 3e                	push   $0x3e
  jmp __alltraps
  101f8c:	e9 b7 fd ff ff       	jmp    101d48 <__alltraps>

00101f91 <vector63>:
.globl vector63
vector63:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $63
  101f93:	6a 3f                	push   $0x3f
  jmp __alltraps
  101f95:	e9 ae fd ff ff       	jmp    101d48 <__alltraps>

00101f9a <vector64>:
.globl vector64
vector64:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $64
  101f9c:	6a 40                	push   $0x40
  jmp __alltraps
  101f9e:	e9 a5 fd ff ff       	jmp    101d48 <__alltraps>

00101fa3 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $65
  101fa5:	6a 41                	push   $0x41
  jmp __alltraps
  101fa7:	e9 9c fd ff ff       	jmp    101d48 <__alltraps>

00101fac <vector66>:
.globl vector66
vector66:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $66
  101fae:	6a 42                	push   $0x42
  jmp __alltraps
  101fb0:	e9 93 fd ff ff       	jmp    101d48 <__alltraps>

00101fb5 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $67
  101fb7:	6a 43                	push   $0x43
  jmp __alltraps
  101fb9:	e9 8a fd ff ff       	jmp    101d48 <__alltraps>

00101fbe <vector68>:
.globl vector68
vector68:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $68
  101fc0:	6a 44                	push   $0x44
  jmp __alltraps
  101fc2:	e9 81 fd ff ff       	jmp    101d48 <__alltraps>

00101fc7 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $69
  101fc9:	6a 45                	push   $0x45
  jmp __alltraps
  101fcb:	e9 78 fd ff ff       	jmp    101d48 <__alltraps>

00101fd0 <vector70>:
.globl vector70
vector70:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $70
  101fd2:	6a 46                	push   $0x46
  jmp __alltraps
  101fd4:	e9 6f fd ff ff       	jmp    101d48 <__alltraps>

00101fd9 <vector71>:
.globl vector71
vector71:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $71
  101fdb:	6a 47                	push   $0x47
  jmp __alltraps
  101fdd:	e9 66 fd ff ff       	jmp    101d48 <__alltraps>

00101fe2 <vector72>:
.globl vector72
vector72:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $72
  101fe4:	6a 48                	push   $0x48
  jmp __alltraps
  101fe6:	e9 5d fd ff ff       	jmp    101d48 <__alltraps>

00101feb <vector73>:
.globl vector73
vector73:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $73
  101fed:	6a 49                	push   $0x49
  jmp __alltraps
  101fef:	e9 54 fd ff ff       	jmp    101d48 <__alltraps>

00101ff4 <vector74>:
.globl vector74
vector74:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $74
  101ff6:	6a 4a                	push   $0x4a
  jmp __alltraps
  101ff8:	e9 4b fd ff ff       	jmp    101d48 <__alltraps>

00101ffd <vector75>:
.globl vector75
vector75:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $75
  101fff:	6a 4b                	push   $0x4b
  jmp __alltraps
  102001:	e9 42 fd ff ff       	jmp    101d48 <__alltraps>

00102006 <vector76>:
.globl vector76
vector76:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $76
  102008:	6a 4c                	push   $0x4c
  jmp __alltraps
  10200a:	e9 39 fd ff ff       	jmp    101d48 <__alltraps>

0010200f <vector77>:
.globl vector77
vector77:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $77
  102011:	6a 4d                	push   $0x4d
  jmp __alltraps
  102013:	e9 30 fd ff ff       	jmp    101d48 <__alltraps>

00102018 <vector78>:
.globl vector78
vector78:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $78
  10201a:	6a 4e                	push   $0x4e
  jmp __alltraps
  10201c:	e9 27 fd ff ff       	jmp    101d48 <__alltraps>

00102021 <vector79>:
.globl vector79
vector79:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $79
  102023:	6a 4f                	push   $0x4f
  jmp __alltraps
  102025:	e9 1e fd ff ff       	jmp    101d48 <__alltraps>

0010202a <vector80>:
.globl vector80
vector80:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $80
  10202c:	6a 50                	push   $0x50
  jmp __alltraps
  10202e:	e9 15 fd ff ff       	jmp    101d48 <__alltraps>

00102033 <vector81>:
.globl vector81
vector81:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $81
  102035:	6a 51                	push   $0x51
  jmp __alltraps
  102037:	e9 0c fd ff ff       	jmp    101d48 <__alltraps>

0010203c <vector82>:
.globl vector82
vector82:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $82
  10203e:	6a 52                	push   $0x52
  jmp __alltraps
  102040:	e9 03 fd ff ff       	jmp    101d48 <__alltraps>

00102045 <vector83>:
.globl vector83
vector83:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $83
  102047:	6a 53                	push   $0x53
  jmp __alltraps
  102049:	e9 fa fc ff ff       	jmp    101d48 <__alltraps>

0010204e <vector84>:
.globl vector84
vector84:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $84
  102050:	6a 54                	push   $0x54
  jmp __alltraps
  102052:	e9 f1 fc ff ff       	jmp    101d48 <__alltraps>

00102057 <vector85>:
.globl vector85
vector85:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $85
  102059:	6a 55                	push   $0x55
  jmp __alltraps
  10205b:	e9 e8 fc ff ff       	jmp    101d48 <__alltraps>

00102060 <vector86>:
.globl vector86
vector86:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $86
  102062:	6a 56                	push   $0x56
  jmp __alltraps
  102064:	e9 df fc ff ff       	jmp    101d48 <__alltraps>

00102069 <vector87>:
.globl vector87
vector87:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $87
  10206b:	6a 57                	push   $0x57
  jmp __alltraps
  10206d:	e9 d6 fc ff ff       	jmp    101d48 <__alltraps>

00102072 <vector88>:
.globl vector88
vector88:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $88
  102074:	6a 58                	push   $0x58
  jmp __alltraps
  102076:	e9 cd fc ff ff       	jmp    101d48 <__alltraps>

0010207b <vector89>:
.globl vector89
vector89:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $89
  10207d:	6a 59                	push   $0x59
  jmp __alltraps
  10207f:	e9 c4 fc ff ff       	jmp    101d48 <__alltraps>

00102084 <vector90>:
.globl vector90
vector90:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $90
  102086:	6a 5a                	push   $0x5a
  jmp __alltraps
  102088:	e9 bb fc ff ff       	jmp    101d48 <__alltraps>

0010208d <vector91>:
.globl vector91
vector91:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $91
  10208f:	6a 5b                	push   $0x5b
  jmp __alltraps
  102091:	e9 b2 fc ff ff       	jmp    101d48 <__alltraps>

00102096 <vector92>:
.globl vector92
vector92:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $92
  102098:	6a 5c                	push   $0x5c
  jmp __alltraps
  10209a:	e9 a9 fc ff ff       	jmp    101d48 <__alltraps>

0010209f <vector93>:
.globl vector93
vector93:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $93
  1020a1:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020a3:	e9 a0 fc ff ff       	jmp    101d48 <__alltraps>

001020a8 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $94
  1020aa:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020ac:	e9 97 fc ff ff       	jmp    101d48 <__alltraps>

001020b1 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $95
  1020b3:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020b5:	e9 8e fc ff ff       	jmp    101d48 <__alltraps>

001020ba <vector96>:
.globl vector96
vector96:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $96
  1020bc:	6a 60                	push   $0x60
  jmp __alltraps
  1020be:	e9 85 fc ff ff       	jmp    101d48 <__alltraps>

001020c3 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $97
  1020c5:	6a 61                	push   $0x61
  jmp __alltraps
  1020c7:	e9 7c fc ff ff       	jmp    101d48 <__alltraps>

001020cc <vector98>:
.globl vector98
vector98:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $98
  1020ce:	6a 62                	push   $0x62
  jmp __alltraps
  1020d0:	e9 73 fc ff ff       	jmp    101d48 <__alltraps>

001020d5 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $99
  1020d7:	6a 63                	push   $0x63
  jmp __alltraps
  1020d9:	e9 6a fc ff ff       	jmp    101d48 <__alltraps>

001020de <vector100>:
.globl vector100
vector100:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $100
  1020e0:	6a 64                	push   $0x64
  jmp __alltraps
  1020e2:	e9 61 fc ff ff       	jmp    101d48 <__alltraps>

001020e7 <vector101>:
.globl vector101
vector101:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $101
  1020e9:	6a 65                	push   $0x65
  jmp __alltraps
  1020eb:	e9 58 fc ff ff       	jmp    101d48 <__alltraps>

001020f0 <vector102>:
.globl vector102
vector102:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $102
  1020f2:	6a 66                	push   $0x66
  jmp __alltraps
  1020f4:	e9 4f fc ff ff       	jmp    101d48 <__alltraps>

001020f9 <vector103>:
.globl vector103
vector103:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $103
  1020fb:	6a 67                	push   $0x67
  jmp __alltraps
  1020fd:	e9 46 fc ff ff       	jmp    101d48 <__alltraps>

00102102 <vector104>:
.globl vector104
vector104:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $104
  102104:	6a 68                	push   $0x68
  jmp __alltraps
  102106:	e9 3d fc ff ff       	jmp    101d48 <__alltraps>

0010210b <vector105>:
.globl vector105
vector105:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $105
  10210d:	6a 69                	push   $0x69
  jmp __alltraps
  10210f:	e9 34 fc ff ff       	jmp    101d48 <__alltraps>

00102114 <vector106>:
.globl vector106
vector106:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $106
  102116:	6a 6a                	push   $0x6a
  jmp __alltraps
  102118:	e9 2b fc ff ff       	jmp    101d48 <__alltraps>

0010211d <vector107>:
.globl vector107
vector107:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $107
  10211f:	6a 6b                	push   $0x6b
  jmp __alltraps
  102121:	e9 22 fc ff ff       	jmp    101d48 <__alltraps>

00102126 <vector108>:
.globl vector108
vector108:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $108
  102128:	6a 6c                	push   $0x6c
  jmp __alltraps
  10212a:	e9 19 fc ff ff       	jmp    101d48 <__alltraps>

0010212f <vector109>:
.globl vector109
vector109:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $109
  102131:	6a 6d                	push   $0x6d
  jmp __alltraps
  102133:	e9 10 fc ff ff       	jmp    101d48 <__alltraps>

00102138 <vector110>:
.globl vector110
vector110:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $110
  10213a:	6a 6e                	push   $0x6e
  jmp __alltraps
  10213c:	e9 07 fc ff ff       	jmp    101d48 <__alltraps>

00102141 <vector111>:
.globl vector111
vector111:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $111
  102143:	6a 6f                	push   $0x6f
  jmp __alltraps
  102145:	e9 fe fb ff ff       	jmp    101d48 <__alltraps>

0010214a <vector112>:
.globl vector112
vector112:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $112
  10214c:	6a 70                	push   $0x70
  jmp __alltraps
  10214e:	e9 f5 fb ff ff       	jmp    101d48 <__alltraps>

00102153 <vector113>:
.globl vector113
vector113:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $113
  102155:	6a 71                	push   $0x71
  jmp __alltraps
  102157:	e9 ec fb ff ff       	jmp    101d48 <__alltraps>

0010215c <vector114>:
.globl vector114
vector114:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $114
  10215e:	6a 72                	push   $0x72
  jmp __alltraps
  102160:	e9 e3 fb ff ff       	jmp    101d48 <__alltraps>

00102165 <vector115>:
.globl vector115
vector115:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $115
  102167:	6a 73                	push   $0x73
  jmp __alltraps
  102169:	e9 da fb ff ff       	jmp    101d48 <__alltraps>

0010216e <vector116>:
.globl vector116
vector116:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $116
  102170:	6a 74                	push   $0x74
  jmp __alltraps
  102172:	e9 d1 fb ff ff       	jmp    101d48 <__alltraps>

00102177 <vector117>:
.globl vector117
vector117:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $117
  102179:	6a 75                	push   $0x75
  jmp __alltraps
  10217b:	e9 c8 fb ff ff       	jmp    101d48 <__alltraps>

00102180 <vector118>:
.globl vector118
vector118:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $118
  102182:	6a 76                	push   $0x76
  jmp __alltraps
  102184:	e9 bf fb ff ff       	jmp    101d48 <__alltraps>

00102189 <vector119>:
.globl vector119
vector119:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $119
  10218b:	6a 77                	push   $0x77
  jmp __alltraps
  10218d:	e9 b6 fb ff ff       	jmp    101d48 <__alltraps>

00102192 <vector120>:
.globl vector120
vector120:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $120
  102194:	6a 78                	push   $0x78
  jmp __alltraps
  102196:	e9 ad fb ff ff       	jmp    101d48 <__alltraps>

0010219b <vector121>:
.globl vector121
vector121:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $121
  10219d:	6a 79                	push   $0x79
  jmp __alltraps
  10219f:	e9 a4 fb ff ff       	jmp    101d48 <__alltraps>

001021a4 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $122
  1021a6:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021a8:	e9 9b fb ff ff       	jmp    101d48 <__alltraps>

001021ad <vector123>:
.globl vector123
vector123:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $123
  1021af:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021b1:	e9 92 fb ff ff       	jmp    101d48 <__alltraps>

001021b6 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $124
  1021b8:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021ba:	e9 89 fb ff ff       	jmp    101d48 <__alltraps>

001021bf <vector125>:
.globl vector125
vector125:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $125
  1021c1:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021c3:	e9 80 fb ff ff       	jmp    101d48 <__alltraps>

001021c8 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $126
  1021ca:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021cc:	e9 77 fb ff ff       	jmp    101d48 <__alltraps>

001021d1 <vector127>:
.globl vector127
vector127:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $127
  1021d3:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021d5:	e9 6e fb ff ff       	jmp    101d48 <__alltraps>

001021da <vector128>:
.globl vector128
vector128:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $128
  1021dc:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021e1:	e9 62 fb ff ff       	jmp    101d48 <__alltraps>

001021e6 <vector129>:
.globl vector129
vector129:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $129
  1021e8:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1021ed:	e9 56 fb ff ff       	jmp    101d48 <__alltraps>

001021f2 <vector130>:
.globl vector130
vector130:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $130
  1021f4:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1021f9:	e9 4a fb ff ff       	jmp    101d48 <__alltraps>

001021fe <vector131>:
.globl vector131
vector131:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $131
  102200:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102205:	e9 3e fb ff ff       	jmp    101d48 <__alltraps>

0010220a <vector132>:
.globl vector132
vector132:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $132
  10220c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102211:	e9 32 fb ff ff       	jmp    101d48 <__alltraps>

00102216 <vector133>:
.globl vector133
vector133:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $133
  102218:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10221d:	e9 26 fb ff ff       	jmp    101d48 <__alltraps>

00102222 <vector134>:
.globl vector134
vector134:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $134
  102224:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102229:	e9 1a fb ff ff       	jmp    101d48 <__alltraps>

0010222e <vector135>:
.globl vector135
vector135:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $135
  102230:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102235:	e9 0e fb ff ff       	jmp    101d48 <__alltraps>

0010223a <vector136>:
.globl vector136
vector136:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $136
  10223c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102241:	e9 02 fb ff ff       	jmp    101d48 <__alltraps>

00102246 <vector137>:
.globl vector137
vector137:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $137
  102248:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10224d:	e9 f6 fa ff ff       	jmp    101d48 <__alltraps>

00102252 <vector138>:
.globl vector138
vector138:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $138
  102254:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102259:	e9 ea fa ff ff       	jmp    101d48 <__alltraps>

0010225e <vector139>:
.globl vector139
vector139:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $139
  102260:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102265:	e9 de fa ff ff       	jmp    101d48 <__alltraps>

0010226a <vector140>:
.globl vector140
vector140:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $140
  10226c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102271:	e9 d2 fa ff ff       	jmp    101d48 <__alltraps>

00102276 <vector141>:
.globl vector141
vector141:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $141
  102278:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10227d:	e9 c6 fa ff ff       	jmp    101d48 <__alltraps>

00102282 <vector142>:
.globl vector142
vector142:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $142
  102284:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102289:	e9 ba fa ff ff       	jmp    101d48 <__alltraps>

0010228e <vector143>:
.globl vector143
vector143:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $143
  102290:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102295:	e9 ae fa ff ff       	jmp    101d48 <__alltraps>

0010229a <vector144>:
.globl vector144
vector144:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $144
  10229c:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022a1:	e9 a2 fa ff ff       	jmp    101d48 <__alltraps>

001022a6 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $145
  1022a8:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022ad:	e9 96 fa ff ff       	jmp    101d48 <__alltraps>

001022b2 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $146
  1022b4:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022b9:	e9 8a fa ff ff       	jmp    101d48 <__alltraps>

001022be <vector147>:
.globl vector147
vector147:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $147
  1022c0:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022c5:	e9 7e fa ff ff       	jmp    101d48 <__alltraps>

001022ca <vector148>:
.globl vector148
vector148:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $148
  1022cc:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022d1:	e9 72 fa ff ff       	jmp    101d48 <__alltraps>

001022d6 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $149
  1022d8:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022dd:	e9 66 fa ff ff       	jmp    101d48 <__alltraps>

001022e2 <vector150>:
.globl vector150
vector150:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $150
  1022e4:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1022e9:	e9 5a fa ff ff       	jmp    101d48 <__alltraps>

001022ee <vector151>:
.globl vector151
vector151:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $151
  1022f0:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1022f5:	e9 4e fa ff ff       	jmp    101d48 <__alltraps>

001022fa <vector152>:
.globl vector152
vector152:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $152
  1022fc:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102301:	e9 42 fa ff ff       	jmp    101d48 <__alltraps>

00102306 <vector153>:
.globl vector153
vector153:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $153
  102308:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10230d:	e9 36 fa ff ff       	jmp    101d48 <__alltraps>

00102312 <vector154>:
.globl vector154
vector154:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $154
  102314:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102319:	e9 2a fa ff ff       	jmp    101d48 <__alltraps>

0010231e <vector155>:
.globl vector155
vector155:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $155
  102320:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102325:	e9 1e fa ff ff       	jmp    101d48 <__alltraps>

0010232a <vector156>:
.globl vector156
vector156:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $156
  10232c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102331:	e9 12 fa ff ff       	jmp    101d48 <__alltraps>

00102336 <vector157>:
.globl vector157
vector157:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $157
  102338:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10233d:	e9 06 fa ff ff       	jmp    101d48 <__alltraps>

00102342 <vector158>:
.globl vector158
vector158:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $158
  102344:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102349:	e9 fa f9 ff ff       	jmp    101d48 <__alltraps>

0010234e <vector159>:
.globl vector159
vector159:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $159
  102350:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102355:	e9 ee f9 ff ff       	jmp    101d48 <__alltraps>

0010235a <vector160>:
.globl vector160
vector160:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $160
  10235c:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102361:	e9 e2 f9 ff ff       	jmp    101d48 <__alltraps>

00102366 <vector161>:
.globl vector161
vector161:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $161
  102368:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10236d:	e9 d6 f9 ff ff       	jmp    101d48 <__alltraps>

00102372 <vector162>:
.globl vector162
vector162:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $162
  102374:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102379:	e9 ca f9 ff ff       	jmp    101d48 <__alltraps>

0010237e <vector163>:
.globl vector163
vector163:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $163
  102380:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102385:	e9 be f9 ff ff       	jmp    101d48 <__alltraps>

0010238a <vector164>:
.globl vector164
vector164:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $164
  10238c:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102391:	e9 b2 f9 ff ff       	jmp    101d48 <__alltraps>

00102396 <vector165>:
.globl vector165
vector165:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $165
  102398:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10239d:	e9 a6 f9 ff ff       	jmp    101d48 <__alltraps>

001023a2 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $166
  1023a4:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023a9:	e9 9a f9 ff ff       	jmp    101d48 <__alltraps>

001023ae <vector167>:
.globl vector167
vector167:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $167
  1023b0:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023b5:	e9 8e f9 ff ff       	jmp    101d48 <__alltraps>

001023ba <vector168>:
.globl vector168
vector168:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $168
  1023bc:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023c1:	e9 82 f9 ff ff       	jmp    101d48 <__alltraps>

001023c6 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $169
  1023c8:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023cd:	e9 76 f9 ff ff       	jmp    101d48 <__alltraps>

001023d2 <vector170>:
.globl vector170
vector170:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $170
  1023d4:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023d9:	e9 6a f9 ff ff       	jmp    101d48 <__alltraps>

001023de <vector171>:
.globl vector171
vector171:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $171
  1023e0:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1023e5:	e9 5e f9 ff ff       	jmp    101d48 <__alltraps>

001023ea <vector172>:
.globl vector172
vector172:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $172
  1023ec:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1023f1:	e9 52 f9 ff ff       	jmp    101d48 <__alltraps>

001023f6 <vector173>:
.globl vector173
vector173:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $173
  1023f8:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1023fd:	e9 46 f9 ff ff       	jmp    101d48 <__alltraps>

00102402 <vector174>:
.globl vector174
vector174:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $174
  102404:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102409:	e9 3a f9 ff ff       	jmp    101d48 <__alltraps>

0010240e <vector175>:
.globl vector175
vector175:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $175
  102410:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102415:	e9 2e f9 ff ff       	jmp    101d48 <__alltraps>

0010241a <vector176>:
.globl vector176
vector176:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $176
  10241c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102421:	e9 22 f9 ff ff       	jmp    101d48 <__alltraps>

00102426 <vector177>:
.globl vector177
vector177:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $177
  102428:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10242d:	e9 16 f9 ff ff       	jmp    101d48 <__alltraps>

00102432 <vector178>:
.globl vector178
vector178:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $178
  102434:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102439:	e9 0a f9 ff ff       	jmp    101d48 <__alltraps>

0010243e <vector179>:
.globl vector179
vector179:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $179
  102440:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102445:	e9 fe f8 ff ff       	jmp    101d48 <__alltraps>

0010244a <vector180>:
.globl vector180
vector180:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $180
  10244c:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102451:	e9 f2 f8 ff ff       	jmp    101d48 <__alltraps>

00102456 <vector181>:
.globl vector181
vector181:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $181
  102458:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10245d:	e9 e6 f8 ff ff       	jmp    101d48 <__alltraps>

00102462 <vector182>:
.globl vector182
vector182:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $182
  102464:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102469:	e9 da f8 ff ff       	jmp    101d48 <__alltraps>

0010246e <vector183>:
.globl vector183
vector183:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $183
  102470:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102475:	e9 ce f8 ff ff       	jmp    101d48 <__alltraps>

0010247a <vector184>:
.globl vector184
vector184:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $184
  10247c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102481:	e9 c2 f8 ff ff       	jmp    101d48 <__alltraps>

00102486 <vector185>:
.globl vector185
vector185:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $185
  102488:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10248d:	e9 b6 f8 ff ff       	jmp    101d48 <__alltraps>

00102492 <vector186>:
.globl vector186
vector186:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $186
  102494:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102499:	e9 aa f8 ff ff       	jmp    101d48 <__alltraps>

0010249e <vector187>:
.globl vector187
vector187:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $187
  1024a0:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024a5:	e9 9e f8 ff ff       	jmp    101d48 <__alltraps>

001024aa <vector188>:
.globl vector188
vector188:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $188
  1024ac:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024b1:	e9 92 f8 ff ff       	jmp    101d48 <__alltraps>

001024b6 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $189
  1024b8:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024bd:	e9 86 f8 ff ff       	jmp    101d48 <__alltraps>

001024c2 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $190
  1024c4:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024c9:	e9 7a f8 ff ff       	jmp    101d48 <__alltraps>

001024ce <vector191>:
.globl vector191
vector191:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $191
  1024d0:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024d5:	e9 6e f8 ff ff       	jmp    101d48 <__alltraps>

001024da <vector192>:
.globl vector192
vector192:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $192
  1024dc:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024e1:	e9 62 f8 ff ff       	jmp    101d48 <__alltraps>

001024e6 <vector193>:
.globl vector193
vector193:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $193
  1024e8:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1024ed:	e9 56 f8 ff ff       	jmp    101d48 <__alltraps>

001024f2 <vector194>:
.globl vector194
vector194:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $194
  1024f4:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1024f9:	e9 4a f8 ff ff       	jmp    101d48 <__alltraps>

001024fe <vector195>:
.globl vector195
vector195:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $195
  102500:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102505:	e9 3e f8 ff ff       	jmp    101d48 <__alltraps>

0010250a <vector196>:
.globl vector196
vector196:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $196
  10250c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102511:	e9 32 f8 ff ff       	jmp    101d48 <__alltraps>

00102516 <vector197>:
.globl vector197
vector197:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $197
  102518:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10251d:	e9 26 f8 ff ff       	jmp    101d48 <__alltraps>

00102522 <vector198>:
.globl vector198
vector198:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $198
  102524:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102529:	e9 1a f8 ff ff       	jmp    101d48 <__alltraps>

0010252e <vector199>:
.globl vector199
vector199:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $199
  102530:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102535:	e9 0e f8 ff ff       	jmp    101d48 <__alltraps>

0010253a <vector200>:
.globl vector200
vector200:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $200
  10253c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102541:	e9 02 f8 ff ff       	jmp    101d48 <__alltraps>

00102546 <vector201>:
.globl vector201
vector201:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $201
  102548:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10254d:	e9 f6 f7 ff ff       	jmp    101d48 <__alltraps>

00102552 <vector202>:
.globl vector202
vector202:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $202
  102554:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102559:	e9 ea f7 ff ff       	jmp    101d48 <__alltraps>

0010255e <vector203>:
.globl vector203
vector203:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $203
  102560:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102565:	e9 de f7 ff ff       	jmp    101d48 <__alltraps>

0010256a <vector204>:
.globl vector204
vector204:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $204
  10256c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102571:	e9 d2 f7 ff ff       	jmp    101d48 <__alltraps>

00102576 <vector205>:
.globl vector205
vector205:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $205
  102578:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10257d:	e9 c6 f7 ff ff       	jmp    101d48 <__alltraps>

00102582 <vector206>:
.globl vector206
vector206:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $206
  102584:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102589:	e9 ba f7 ff ff       	jmp    101d48 <__alltraps>

0010258e <vector207>:
.globl vector207
vector207:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $207
  102590:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102595:	e9 ae f7 ff ff       	jmp    101d48 <__alltraps>

0010259a <vector208>:
.globl vector208
vector208:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $208
  10259c:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025a1:	e9 a2 f7 ff ff       	jmp    101d48 <__alltraps>

001025a6 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $209
  1025a8:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025ad:	e9 96 f7 ff ff       	jmp    101d48 <__alltraps>

001025b2 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $210
  1025b4:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025b9:	e9 8a f7 ff ff       	jmp    101d48 <__alltraps>

001025be <vector211>:
.globl vector211
vector211:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $211
  1025c0:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025c5:	e9 7e f7 ff ff       	jmp    101d48 <__alltraps>

001025ca <vector212>:
.globl vector212
vector212:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $212
  1025cc:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025d1:	e9 72 f7 ff ff       	jmp    101d48 <__alltraps>

001025d6 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $213
  1025d8:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025dd:	e9 66 f7 ff ff       	jmp    101d48 <__alltraps>

001025e2 <vector214>:
.globl vector214
vector214:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $214
  1025e4:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1025e9:	e9 5a f7 ff ff       	jmp    101d48 <__alltraps>

001025ee <vector215>:
.globl vector215
vector215:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $215
  1025f0:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1025f5:	e9 4e f7 ff ff       	jmp    101d48 <__alltraps>

001025fa <vector216>:
.globl vector216
vector216:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $216
  1025fc:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102601:	e9 42 f7 ff ff       	jmp    101d48 <__alltraps>

00102606 <vector217>:
.globl vector217
vector217:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $217
  102608:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10260d:	e9 36 f7 ff ff       	jmp    101d48 <__alltraps>

00102612 <vector218>:
.globl vector218
vector218:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $218
  102614:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102619:	e9 2a f7 ff ff       	jmp    101d48 <__alltraps>

0010261e <vector219>:
.globl vector219
vector219:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $219
  102620:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102625:	e9 1e f7 ff ff       	jmp    101d48 <__alltraps>

0010262a <vector220>:
.globl vector220
vector220:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $220
  10262c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102631:	e9 12 f7 ff ff       	jmp    101d48 <__alltraps>

00102636 <vector221>:
.globl vector221
vector221:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $221
  102638:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10263d:	e9 06 f7 ff ff       	jmp    101d48 <__alltraps>

00102642 <vector222>:
.globl vector222
vector222:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $222
  102644:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102649:	e9 fa f6 ff ff       	jmp    101d48 <__alltraps>

0010264e <vector223>:
.globl vector223
vector223:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $223
  102650:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102655:	e9 ee f6 ff ff       	jmp    101d48 <__alltraps>

0010265a <vector224>:
.globl vector224
vector224:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $224
  10265c:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102661:	e9 e2 f6 ff ff       	jmp    101d48 <__alltraps>

00102666 <vector225>:
.globl vector225
vector225:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $225
  102668:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10266d:	e9 d6 f6 ff ff       	jmp    101d48 <__alltraps>

00102672 <vector226>:
.globl vector226
vector226:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $226
  102674:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102679:	e9 ca f6 ff ff       	jmp    101d48 <__alltraps>

0010267e <vector227>:
.globl vector227
vector227:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $227
  102680:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102685:	e9 be f6 ff ff       	jmp    101d48 <__alltraps>

0010268a <vector228>:
.globl vector228
vector228:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $228
  10268c:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102691:	e9 b2 f6 ff ff       	jmp    101d48 <__alltraps>

00102696 <vector229>:
.globl vector229
vector229:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $229
  102698:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10269d:	e9 a6 f6 ff ff       	jmp    101d48 <__alltraps>

001026a2 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $230
  1026a4:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026a9:	e9 9a f6 ff ff       	jmp    101d48 <__alltraps>

001026ae <vector231>:
.globl vector231
vector231:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $231
  1026b0:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026b5:	e9 8e f6 ff ff       	jmp    101d48 <__alltraps>

001026ba <vector232>:
.globl vector232
vector232:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $232
  1026bc:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026c1:	e9 82 f6 ff ff       	jmp    101d48 <__alltraps>

001026c6 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $233
  1026c8:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026cd:	e9 76 f6 ff ff       	jmp    101d48 <__alltraps>

001026d2 <vector234>:
.globl vector234
vector234:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $234
  1026d4:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026d9:	e9 6a f6 ff ff       	jmp    101d48 <__alltraps>

001026de <vector235>:
.globl vector235
vector235:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $235
  1026e0:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1026e5:	e9 5e f6 ff ff       	jmp    101d48 <__alltraps>

001026ea <vector236>:
.globl vector236
vector236:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $236
  1026ec:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1026f1:	e9 52 f6 ff ff       	jmp    101d48 <__alltraps>

001026f6 <vector237>:
.globl vector237
vector237:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $237
  1026f8:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1026fd:	e9 46 f6 ff ff       	jmp    101d48 <__alltraps>

00102702 <vector238>:
.globl vector238
vector238:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $238
  102704:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102709:	e9 3a f6 ff ff       	jmp    101d48 <__alltraps>

0010270e <vector239>:
.globl vector239
vector239:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $239
  102710:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102715:	e9 2e f6 ff ff       	jmp    101d48 <__alltraps>

0010271a <vector240>:
.globl vector240
vector240:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $240
  10271c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102721:	e9 22 f6 ff ff       	jmp    101d48 <__alltraps>

00102726 <vector241>:
.globl vector241
vector241:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $241
  102728:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10272d:	e9 16 f6 ff ff       	jmp    101d48 <__alltraps>

00102732 <vector242>:
.globl vector242
vector242:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $242
  102734:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102739:	e9 0a f6 ff ff       	jmp    101d48 <__alltraps>

0010273e <vector243>:
.globl vector243
vector243:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $243
  102740:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102745:	e9 fe f5 ff ff       	jmp    101d48 <__alltraps>

0010274a <vector244>:
.globl vector244
vector244:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $244
  10274c:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102751:	e9 f2 f5 ff ff       	jmp    101d48 <__alltraps>

00102756 <vector245>:
.globl vector245
vector245:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $245
  102758:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10275d:	e9 e6 f5 ff ff       	jmp    101d48 <__alltraps>

00102762 <vector246>:
.globl vector246
vector246:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $246
  102764:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102769:	e9 da f5 ff ff       	jmp    101d48 <__alltraps>

0010276e <vector247>:
.globl vector247
vector247:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $247
  102770:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102775:	e9 ce f5 ff ff       	jmp    101d48 <__alltraps>

0010277a <vector248>:
.globl vector248
vector248:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $248
  10277c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102781:	e9 c2 f5 ff ff       	jmp    101d48 <__alltraps>

00102786 <vector249>:
.globl vector249
vector249:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $249
  102788:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10278d:	e9 b6 f5 ff ff       	jmp    101d48 <__alltraps>

00102792 <vector250>:
.globl vector250
vector250:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $250
  102794:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102799:	e9 aa f5 ff ff       	jmp    101d48 <__alltraps>

0010279e <vector251>:
.globl vector251
vector251:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $251
  1027a0:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027a5:	e9 9e f5 ff ff       	jmp    101d48 <__alltraps>

001027aa <vector252>:
.globl vector252
vector252:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $252
  1027ac:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027b1:	e9 92 f5 ff ff       	jmp    101d48 <__alltraps>

001027b6 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $253
  1027b8:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027bd:	e9 86 f5 ff ff       	jmp    101d48 <__alltraps>

001027c2 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $254
  1027c4:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027c9:	e9 7a f5 ff ff       	jmp    101d48 <__alltraps>

001027ce <vector255>:
.globl vector255
vector255:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $255
  1027d0:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027d5:	e9 6e f5 ff ff       	jmp    101d48 <__alltraps>

001027da <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1027da:	55                   	push   %ebp
  1027db:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1027dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1027e0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1027e3:	b8 23 00 00 00       	mov    $0x23,%eax
  1027e8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1027ea:	b8 23 00 00 00       	mov    $0x23,%eax
  1027ef:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1027f1:	b8 10 00 00 00       	mov    $0x10,%eax
  1027f6:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1027f8:	b8 10 00 00 00       	mov    $0x10,%eax
  1027fd:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1027ff:	b8 10 00 00 00       	mov    $0x10,%eax
  102804:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102806:	ea 0d 28 10 00 08 00 	ljmp   $0x8,$0x10280d
}
  10280d:	5d                   	pop    %ebp
  10280e:	c3                   	ret    

0010280f <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10280f:	55                   	push   %ebp
  102810:	89 e5                	mov    %esp,%ebp
  102812:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102815:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10281a:	05 00 04 00 00       	add    $0x400,%eax
  10281f:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102824:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10282b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10282d:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102834:	68 00 
  102836:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10283b:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102841:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102846:	c1 e8 10             	shr    $0x10,%eax
  102849:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10284e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102855:	83 e0 f0             	and    $0xfffffff0,%eax
  102858:	83 c8 09             	or     $0x9,%eax
  10285b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102860:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102867:	83 c8 10             	or     $0x10,%eax
  10286a:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10286f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102876:	83 e0 9f             	and    $0xffffff9f,%eax
  102879:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10287e:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102885:	83 c8 80             	or     $0xffffff80,%eax
  102888:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102894:	83 e0 f0             	and    $0xfffffff0,%eax
  102897:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10289c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028a3:	83 e0 ef             	and    $0xffffffef,%eax
  1028a6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ab:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028b2:	83 e0 df             	and    $0xffffffdf,%eax
  1028b5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028ba:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c1:	83 c8 40             	or     $0x40,%eax
  1028c4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028c9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d0:	83 e0 7f             	and    $0x7f,%eax
  1028d3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d8:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028dd:	c1 e8 18             	shr    $0x18,%eax
  1028e0:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1028e5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ec:	83 e0 ef             	and    $0xffffffef,%eax
  1028ef:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1028f4:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  1028fb:	e8 da fe ff ff       	call   1027da <lgdt>
  102900:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102906:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10290a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10290d:	c9                   	leave  
  10290e:	c3                   	ret    

0010290f <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10290f:	55                   	push   %ebp
  102910:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102912:	e8 f8 fe ff ff       	call   10280f <gdt_init>
}
  102917:	5d                   	pop    %ebp
  102918:	c3                   	ret    

00102919 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102919:	55                   	push   %ebp
  10291a:	89 e5                	mov    %esp,%ebp
  10291c:	83 ec 58             	sub    $0x58,%esp
  10291f:	8b 45 10             	mov    0x10(%ebp),%eax
  102922:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102925:	8b 45 14             	mov    0x14(%ebp),%eax
  102928:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10292b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10292e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102931:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102934:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102937:	8b 45 18             	mov    0x18(%ebp),%eax
  10293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10293d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102940:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102943:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102946:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10294c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10294f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102953:	74 1c                	je     102971 <printnum+0x58>
  102955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102958:	ba 00 00 00 00       	mov    $0x0,%edx
  10295d:	f7 75 e4             	divl   -0x1c(%ebp)
  102960:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102966:	ba 00 00 00 00       	mov    $0x0,%edx
  10296b:	f7 75 e4             	divl   -0x1c(%ebp)
  10296e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102971:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102977:	f7 75 e4             	divl   -0x1c(%ebp)
  10297a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10297d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102983:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102986:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102989:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10298c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10298f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102992:	8b 45 18             	mov    0x18(%ebp),%eax
  102995:	ba 00 00 00 00       	mov    $0x0,%edx
  10299a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10299d:	77 56                	ja     1029f5 <printnum+0xdc>
  10299f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029a2:	72 05                	jb     1029a9 <printnum+0x90>
  1029a4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029a7:	77 4c                	ja     1029f5 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029af:	8b 45 20             	mov    0x20(%ebp),%eax
  1029b2:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029b6:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029ba:	8b 45 18             	mov    0x18(%ebp),%eax
  1029bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d9:	89 04 24             	mov    %eax,(%esp)
  1029dc:	e8 38 ff ff ff       	call   102919 <printnum>
  1029e1:	eb 1c                	jmp    1029ff <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1029e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029ea:	8b 45 20             	mov    0x20(%ebp),%eax
  1029ed:	89 04 24             	mov    %eax,(%esp)
  1029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f3:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1029f5:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1029f9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1029fd:	7f e4                	jg     1029e3 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1029ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a02:	05 f0 3b 10 00       	add    $0x103bf0,%eax
  102a07:	0f b6 00             	movzbl (%eax),%eax
  102a0a:	0f be c0             	movsbl %al,%eax
  102a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a10:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a14:	89 04 24             	mov    %eax,(%esp)
  102a17:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1a:	ff d0                	call   *%eax
}
  102a1c:	c9                   	leave  
  102a1d:	c3                   	ret    

00102a1e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a1e:	55                   	push   %ebp
  102a1f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a21:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a25:	7e 14                	jle    102a3b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a27:	8b 45 08             	mov    0x8(%ebp),%eax
  102a2a:	8b 00                	mov    (%eax),%eax
  102a2c:	8d 48 08             	lea    0x8(%eax),%ecx
  102a2f:	8b 55 08             	mov    0x8(%ebp),%edx
  102a32:	89 0a                	mov    %ecx,(%edx)
  102a34:	8b 50 04             	mov    0x4(%eax),%edx
  102a37:	8b 00                	mov    (%eax),%eax
  102a39:	eb 30                	jmp    102a6b <getuint+0x4d>
    }
    else if (lflag) {
  102a3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a3f:	74 16                	je     102a57 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a41:	8b 45 08             	mov    0x8(%ebp),%eax
  102a44:	8b 00                	mov    (%eax),%eax
  102a46:	8d 48 04             	lea    0x4(%eax),%ecx
  102a49:	8b 55 08             	mov    0x8(%ebp),%edx
  102a4c:	89 0a                	mov    %ecx,(%edx)
  102a4e:	8b 00                	mov    (%eax),%eax
  102a50:	ba 00 00 00 00       	mov    $0x0,%edx
  102a55:	eb 14                	jmp    102a6b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a57:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5a:	8b 00                	mov    (%eax),%eax
  102a5c:	8d 48 04             	lea    0x4(%eax),%ecx
  102a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  102a62:	89 0a                	mov    %ecx,(%edx)
  102a64:	8b 00                	mov    (%eax),%eax
  102a66:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a6b:	5d                   	pop    %ebp
  102a6c:	c3                   	ret    

00102a6d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a6d:	55                   	push   %ebp
  102a6e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a70:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a74:	7e 14                	jle    102a8a <getint+0x1d>
        return va_arg(*ap, long long);
  102a76:	8b 45 08             	mov    0x8(%ebp),%eax
  102a79:	8b 00                	mov    (%eax),%eax
  102a7b:	8d 48 08             	lea    0x8(%eax),%ecx
  102a7e:	8b 55 08             	mov    0x8(%ebp),%edx
  102a81:	89 0a                	mov    %ecx,(%edx)
  102a83:	8b 50 04             	mov    0x4(%eax),%edx
  102a86:	8b 00                	mov    (%eax),%eax
  102a88:	eb 28                	jmp    102ab2 <getint+0x45>
    }
    else if (lflag) {
  102a8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a8e:	74 12                	je     102aa2 <getint+0x35>
        return va_arg(*ap, long);
  102a90:	8b 45 08             	mov    0x8(%ebp),%eax
  102a93:	8b 00                	mov    (%eax),%eax
  102a95:	8d 48 04             	lea    0x4(%eax),%ecx
  102a98:	8b 55 08             	mov    0x8(%ebp),%edx
  102a9b:	89 0a                	mov    %ecx,(%edx)
  102a9d:	8b 00                	mov    (%eax),%eax
  102a9f:	99                   	cltd   
  102aa0:	eb 10                	jmp    102ab2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa5:	8b 00                	mov    (%eax),%eax
  102aa7:	8d 48 04             	lea    0x4(%eax),%ecx
  102aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  102aad:	89 0a                	mov    %ecx,(%edx)
  102aaf:	8b 00                	mov    (%eax),%eax
  102ab1:	99                   	cltd   
    }
}
  102ab2:	5d                   	pop    %ebp
  102ab3:	c3                   	ret    

00102ab4 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ab4:	55                   	push   %ebp
  102ab5:	89 e5                	mov    %esp,%ebp
  102ab7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102aba:	8d 45 14             	lea    0x14(%ebp),%eax
  102abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  102aca:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad8:	89 04 24             	mov    %eax,(%esp)
  102adb:	e8 02 00 00 00       	call   102ae2 <vprintfmt>
    va_end(ap);
}
  102ae0:	c9                   	leave  
  102ae1:	c3                   	ret    

00102ae2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102ae2:	55                   	push   %ebp
  102ae3:	89 e5                	mov    %esp,%ebp
  102ae5:	56                   	push   %esi
  102ae6:	53                   	push   %ebx
  102ae7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102aea:	eb 18                	jmp    102b04 <vprintfmt+0x22>
            if (ch == '\0') {
  102aec:	85 db                	test   %ebx,%ebx
  102aee:	75 05                	jne    102af5 <vprintfmt+0x13>
                return;
  102af0:	e9 d1 03 00 00       	jmp    102ec6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102afc:	89 1c 24             	mov    %ebx,(%esp)
  102aff:	8b 45 08             	mov    0x8(%ebp),%eax
  102b02:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b04:	8b 45 10             	mov    0x10(%ebp),%eax
  102b07:	8d 50 01             	lea    0x1(%eax),%edx
  102b0a:	89 55 10             	mov    %edx,0x10(%ebp)
  102b0d:	0f b6 00             	movzbl (%eax),%eax
  102b10:	0f b6 d8             	movzbl %al,%ebx
  102b13:	83 fb 25             	cmp    $0x25,%ebx
  102b16:	75 d4                	jne    102aec <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b18:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b1c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b29:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b30:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b33:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b36:	8b 45 10             	mov    0x10(%ebp),%eax
  102b39:	8d 50 01             	lea    0x1(%eax),%edx
  102b3c:	89 55 10             	mov    %edx,0x10(%ebp)
  102b3f:	0f b6 00             	movzbl (%eax),%eax
  102b42:	0f b6 d8             	movzbl %al,%ebx
  102b45:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b48:	83 f8 55             	cmp    $0x55,%eax
  102b4b:	0f 87 44 03 00 00    	ja     102e95 <vprintfmt+0x3b3>
  102b51:	8b 04 85 14 3c 10 00 	mov    0x103c14(,%eax,4),%eax
  102b58:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b5a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b5e:	eb d6                	jmp    102b36 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b60:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b64:	eb d0                	jmp    102b36 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b6d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b70:	89 d0                	mov    %edx,%eax
  102b72:	c1 e0 02             	shl    $0x2,%eax
  102b75:	01 d0                	add    %edx,%eax
  102b77:	01 c0                	add    %eax,%eax
  102b79:	01 d8                	add    %ebx,%eax
  102b7b:	83 e8 30             	sub    $0x30,%eax
  102b7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102b81:	8b 45 10             	mov    0x10(%ebp),%eax
  102b84:	0f b6 00             	movzbl (%eax),%eax
  102b87:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102b8a:	83 fb 2f             	cmp    $0x2f,%ebx
  102b8d:	7e 0b                	jle    102b9a <vprintfmt+0xb8>
  102b8f:	83 fb 39             	cmp    $0x39,%ebx
  102b92:	7f 06                	jg     102b9a <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b94:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102b98:	eb d3                	jmp    102b6d <vprintfmt+0x8b>
            goto process_precision;
  102b9a:	eb 33                	jmp    102bcf <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102b9c:	8b 45 14             	mov    0x14(%ebp),%eax
  102b9f:	8d 50 04             	lea    0x4(%eax),%edx
  102ba2:	89 55 14             	mov    %edx,0x14(%ebp)
  102ba5:	8b 00                	mov    (%eax),%eax
  102ba7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102baa:	eb 23                	jmp    102bcf <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bb0:	79 0c                	jns    102bbe <vprintfmt+0xdc>
                width = 0;
  102bb2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bb9:	e9 78 ff ff ff       	jmp    102b36 <vprintfmt+0x54>
  102bbe:	e9 73 ff ff ff       	jmp    102b36 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bc3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bca:	e9 67 ff ff ff       	jmp    102b36 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102bcf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bd3:	79 12                	jns    102be7 <vprintfmt+0x105>
                width = precision, precision = -1;
  102bd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bdb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102be2:	e9 4f ff ff ff       	jmp    102b36 <vprintfmt+0x54>
  102be7:	e9 4a ff ff ff       	jmp    102b36 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102bec:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102bf0:	e9 41 ff ff ff       	jmp    102b36 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  102bf8:	8d 50 04             	lea    0x4(%eax),%edx
  102bfb:	89 55 14             	mov    %edx,0x14(%ebp)
  102bfe:	8b 00                	mov    (%eax),%eax
  102c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c03:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c07:	89 04 24             	mov    %eax,(%esp)
  102c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0d:	ff d0                	call   *%eax
            break;
  102c0f:	e9 ac 02 00 00       	jmp    102ec0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c14:	8b 45 14             	mov    0x14(%ebp),%eax
  102c17:	8d 50 04             	lea    0x4(%eax),%edx
  102c1a:	89 55 14             	mov    %edx,0x14(%ebp)
  102c1d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c1f:	85 db                	test   %ebx,%ebx
  102c21:	79 02                	jns    102c25 <vprintfmt+0x143>
                err = -err;
  102c23:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c25:	83 fb 06             	cmp    $0x6,%ebx
  102c28:	7f 0b                	jg     102c35 <vprintfmt+0x153>
  102c2a:	8b 34 9d d4 3b 10 00 	mov    0x103bd4(,%ebx,4),%esi
  102c31:	85 f6                	test   %esi,%esi
  102c33:	75 23                	jne    102c58 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c35:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c39:	c7 44 24 08 01 3c 10 	movl   $0x103c01,0x8(%esp)
  102c40:	00 
  102c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c48:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4b:	89 04 24             	mov    %eax,(%esp)
  102c4e:	e8 61 fe ff ff       	call   102ab4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c53:	e9 68 02 00 00       	jmp    102ec0 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c58:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c5c:	c7 44 24 08 0a 3c 10 	movl   $0x103c0a,0x8(%esp)
  102c63:	00 
  102c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6e:	89 04 24             	mov    %eax,(%esp)
  102c71:	e8 3e fe ff ff       	call   102ab4 <printfmt>
            }
            break;
  102c76:	e9 45 02 00 00       	jmp    102ec0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  102c7e:	8d 50 04             	lea    0x4(%eax),%edx
  102c81:	89 55 14             	mov    %edx,0x14(%ebp)
  102c84:	8b 30                	mov    (%eax),%esi
  102c86:	85 f6                	test   %esi,%esi
  102c88:	75 05                	jne    102c8f <vprintfmt+0x1ad>
                p = "(null)";
  102c8a:	be 0d 3c 10 00       	mov    $0x103c0d,%esi
            }
            if (width > 0 && padc != '-') {
  102c8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c93:	7e 3e                	jle    102cd3 <vprintfmt+0x1f1>
  102c95:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102c99:	74 38                	je     102cd3 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102c9b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102c9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ca5:	89 34 24             	mov    %esi,(%esp)
  102ca8:	e8 15 03 00 00       	call   102fc2 <strnlen>
  102cad:	29 c3                	sub    %eax,%ebx
  102caf:	89 d8                	mov    %ebx,%eax
  102cb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cb4:	eb 17                	jmp    102ccd <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102cb6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cc1:	89 04 24             	mov    %eax,(%esp)
  102cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc7:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cc9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ccd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cd1:	7f e3                	jg     102cb6 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102cd3:	eb 38                	jmp    102d0d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102cd5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102cd9:	74 1f                	je     102cfa <vprintfmt+0x218>
  102cdb:	83 fb 1f             	cmp    $0x1f,%ebx
  102cde:	7e 05                	jle    102ce5 <vprintfmt+0x203>
  102ce0:	83 fb 7e             	cmp    $0x7e,%ebx
  102ce3:	7e 15                	jle    102cfa <vprintfmt+0x218>
                    putch('?', putdat);
  102ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf6:	ff d0                	call   *%eax
  102cf8:	eb 0f                	jmp    102d09 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d01:	89 1c 24             	mov    %ebx,(%esp)
  102d04:	8b 45 08             	mov    0x8(%ebp),%eax
  102d07:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d09:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d0d:	89 f0                	mov    %esi,%eax
  102d0f:	8d 70 01             	lea    0x1(%eax),%esi
  102d12:	0f b6 00             	movzbl (%eax),%eax
  102d15:	0f be d8             	movsbl %al,%ebx
  102d18:	85 db                	test   %ebx,%ebx
  102d1a:	74 10                	je     102d2c <vprintfmt+0x24a>
  102d1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d20:	78 b3                	js     102cd5 <vprintfmt+0x1f3>
  102d22:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d2a:	79 a9                	jns    102cd5 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d2c:	eb 17                	jmp    102d45 <vprintfmt+0x263>
                putch(' ', putdat);
  102d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d35:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d41:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d49:	7f e3                	jg     102d2e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d4b:	e9 70 01 00 00       	jmp    102ec0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d57:	8d 45 14             	lea    0x14(%ebp),%eax
  102d5a:	89 04 24             	mov    %eax,(%esp)
  102d5d:	e8 0b fd ff ff       	call   102a6d <getint>
  102d62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d65:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d6e:	85 d2                	test   %edx,%edx
  102d70:	79 26                	jns    102d98 <vprintfmt+0x2b6>
                putch('-', putdat);
  102d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d79:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102d80:	8b 45 08             	mov    0x8(%ebp),%eax
  102d83:	ff d0                	call   *%eax
                num = -(long long)num;
  102d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d8b:	f7 d8                	neg    %eax
  102d8d:	83 d2 00             	adc    $0x0,%edx
  102d90:	f7 da                	neg    %edx
  102d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d95:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102d98:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102d9f:	e9 a8 00 00 00       	jmp    102e4c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102da4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dab:	8d 45 14             	lea    0x14(%ebp),%eax
  102dae:	89 04 24             	mov    %eax,(%esp)
  102db1:	e8 68 fc ff ff       	call   102a1e <getuint>
  102db6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102db9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102dbc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dc3:	e9 84 00 00 00       	jmp    102e4c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dcf:	8d 45 14             	lea    0x14(%ebp),%eax
  102dd2:	89 04 24             	mov    %eax,(%esp)
  102dd5:	e8 44 fc ff ff       	call   102a1e <getuint>
  102dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ddd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102de0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102de7:	eb 63                	jmp    102e4c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  102df0:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102df7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfa:	ff d0                	call   *%eax
            putch('x', putdat);
  102dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dff:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e03:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e0f:	8b 45 14             	mov    0x14(%ebp),%eax
  102e12:	8d 50 04             	lea    0x4(%eax),%edx
  102e15:	89 55 14             	mov    %edx,0x14(%ebp)
  102e18:	8b 00                	mov    (%eax),%eax
  102e1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e2b:	eb 1f                	jmp    102e4c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e34:	8d 45 14             	lea    0x14(%ebp),%eax
  102e37:	89 04 24             	mov    %eax,(%esp)
  102e3a:	e8 df fb ff ff       	call   102a1e <getuint>
  102e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e42:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e53:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e57:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e5a:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e68:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e6c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e77:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7a:	89 04 24             	mov    %eax,(%esp)
  102e7d:	e8 97 fa ff ff       	call   102919 <printnum>
            break;
  102e82:	eb 3c                	jmp    102ec0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e87:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8b:	89 1c 24             	mov    %ebx,(%esp)
  102e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e91:	ff d0                	call   *%eax
            break;
  102e93:	eb 2b                	jmp    102ec0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e9c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ea8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102eac:	eb 04                	jmp    102eb2 <vprintfmt+0x3d0>
  102eae:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  102eb5:	83 e8 01             	sub    $0x1,%eax
  102eb8:	0f b6 00             	movzbl (%eax),%eax
  102ebb:	3c 25                	cmp    $0x25,%al
  102ebd:	75 ef                	jne    102eae <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102ebf:	90                   	nop
        }
    }
  102ec0:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ec1:	e9 3e fc ff ff       	jmp    102b04 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ec6:	83 c4 40             	add    $0x40,%esp
  102ec9:	5b                   	pop    %ebx
  102eca:	5e                   	pop    %esi
  102ecb:	5d                   	pop    %ebp
  102ecc:	c3                   	ret    

00102ecd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102ecd:	55                   	push   %ebp
  102ece:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed3:	8b 40 08             	mov    0x8(%eax),%eax
  102ed6:	8d 50 01             	lea    0x1(%eax),%edx
  102ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102edc:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee2:	8b 10                	mov    (%eax),%edx
  102ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee7:	8b 40 04             	mov    0x4(%eax),%eax
  102eea:	39 c2                	cmp    %eax,%edx
  102eec:	73 12                	jae    102f00 <sprintputch+0x33>
        *b->buf ++ = ch;
  102eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef1:	8b 00                	mov    (%eax),%eax
  102ef3:	8d 48 01             	lea    0x1(%eax),%ecx
  102ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ef9:	89 0a                	mov    %ecx,(%edx)
  102efb:	8b 55 08             	mov    0x8(%ebp),%edx
  102efe:	88 10                	mov    %dl,(%eax)
    }
}
  102f00:	5d                   	pop    %ebp
  102f01:	c3                   	ret    

00102f02 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f02:	55                   	push   %ebp
  102f03:	89 e5                	mov    %esp,%ebp
  102f05:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f08:	8d 45 14             	lea    0x14(%ebp),%eax
  102f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f11:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f15:	8b 45 10             	mov    0x10(%ebp),%eax
  102f18:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f23:	8b 45 08             	mov    0x8(%ebp),%eax
  102f26:	89 04 24             	mov    %eax,(%esp)
  102f29:	e8 08 00 00 00       	call   102f36 <vsnprintf>
  102f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f34:	c9                   	leave  
  102f35:	c3                   	ret    

00102f36 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f36:	55                   	push   %ebp
  102f37:	89 e5                	mov    %esp,%ebp
  102f39:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f45:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f48:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4b:	01 d0                	add    %edx,%eax
  102f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f5b:	74 0a                	je     102f67 <vsnprintf+0x31>
  102f5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f63:	39 c2                	cmp    %eax,%edx
  102f65:	76 07                	jbe    102f6e <vsnprintf+0x38>
        return -E_INVAL;
  102f67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f6c:	eb 2a                	jmp    102f98 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  102f71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f75:	8b 45 10             	mov    0x10(%ebp),%eax
  102f78:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f7c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f83:	c7 04 24 cd 2e 10 00 	movl   $0x102ecd,(%esp)
  102f8a:	e8 53 fb ff ff       	call   102ae2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f92:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f98:	c9                   	leave  
  102f99:	c3                   	ret    

00102f9a <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102f9a:	55                   	push   %ebp
  102f9b:	89 e5                	mov    %esp,%ebp
  102f9d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fa0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fa7:	eb 04                	jmp    102fad <strlen+0x13>
        cnt ++;
  102fa9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fad:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb0:	8d 50 01             	lea    0x1(%eax),%edx
  102fb3:	89 55 08             	mov    %edx,0x8(%ebp)
  102fb6:	0f b6 00             	movzbl (%eax),%eax
  102fb9:	84 c0                	test   %al,%al
  102fbb:	75 ec                	jne    102fa9 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fc0:	c9                   	leave  
  102fc1:	c3                   	ret    

00102fc2 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102fc2:	55                   	push   %ebp
  102fc3:	89 e5                	mov    %esp,%ebp
  102fc5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102fcf:	eb 04                	jmp    102fd5 <strnlen+0x13>
        cnt ++;
  102fd1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102fd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102fd8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102fdb:	73 10                	jae    102fed <strnlen+0x2b>
  102fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe0:	8d 50 01             	lea    0x1(%eax),%edx
  102fe3:	89 55 08             	mov    %edx,0x8(%ebp)
  102fe6:	0f b6 00             	movzbl (%eax),%eax
  102fe9:	84 c0                	test   %al,%al
  102feb:	75 e4                	jne    102fd1 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ff0:	c9                   	leave  
  102ff1:	c3                   	ret    

00102ff2 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102ff2:	55                   	push   %ebp
  102ff3:	89 e5                	mov    %esp,%ebp
  102ff5:	57                   	push   %edi
  102ff6:	56                   	push   %esi
  102ff7:	83 ec 20             	sub    $0x20,%esp
  102ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  102ffd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103000:	8b 45 0c             	mov    0xc(%ebp),%eax
  103003:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103006:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10300c:	89 d1                	mov    %edx,%ecx
  10300e:	89 c2                	mov    %eax,%edx
  103010:	89 ce                	mov    %ecx,%esi
  103012:	89 d7                	mov    %edx,%edi
  103014:	ac                   	lods   %ds:(%esi),%al
  103015:	aa                   	stos   %al,%es:(%edi)
  103016:	84 c0                	test   %al,%al
  103018:	75 fa                	jne    103014 <strcpy+0x22>
  10301a:	89 fa                	mov    %edi,%edx
  10301c:	89 f1                	mov    %esi,%ecx
  10301e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103021:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103024:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103027:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10302a:	83 c4 20             	add    $0x20,%esp
  10302d:	5e                   	pop    %esi
  10302e:	5f                   	pop    %edi
  10302f:	5d                   	pop    %ebp
  103030:	c3                   	ret    

00103031 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103031:	55                   	push   %ebp
  103032:	89 e5                	mov    %esp,%ebp
  103034:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103037:	8b 45 08             	mov    0x8(%ebp),%eax
  10303a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10303d:	eb 21                	jmp    103060 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10303f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103042:	0f b6 10             	movzbl (%eax),%edx
  103045:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103048:	88 10                	mov    %dl,(%eax)
  10304a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10304d:	0f b6 00             	movzbl (%eax),%eax
  103050:	84 c0                	test   %al,%al
  103052:	74 04                	je     103058 <strncpy+0x27>
            src ++;
  103054:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103058:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10305c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103064:	75 d9                	jne    10303f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103066:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103069:	c9                   	leave  
  10306a:	c3                   	ret    

0010306b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10306b:	55                   	push   %ebp
  10306c:	89 e5                	mov    %esp,%ebp
  10306e:	57                   	push   %edi
  10306f:	56                   	push   %esi
  103070:	83 ec 20             	sub    $0x20,%esp
  103073:	8b 45 08             	mov    0x8(%ebp),%eax
  103076:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103079:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10307f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103085:	89 d1                	mov    %edx,%ecx
  103087:	89 c2                	mov    %eax,%edx
  103089:	89 ce                	mov    %ecx,%esi
  10308b:	89 d7                	mov    %edx,%edi
  10308d:	ac                   	lods   %ds:(%esi),%al
  10308e:	ae                   	scas   %es:(%edi),%al
  10308f:	75 08                	jne    103099 <strcmp+0x2e>
  103091:	84 c0                	test   %al,%al
  103093:	75 f8                	jne    10308d <strcmp+0x22>
  103095:	31 c0                	xor    %eax,%eax
  103097:	eb 04                	jmp    10309d <strcmp+0x32>
  103099:	19 c0                	sbb    %eax,%eax
  10309b:	0c 01                	or     $0x1,%al
  10309d:	89 fa                	mov    %edi,%edx
  10309f:	89 f1                	mov    %esi,%ecx
  1030a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030a4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030a7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030ad:	83 c4 20             	add    $0x20,%esp
  1030b0:	5e                   	pop    %esi
  1030b1:	5f                   	pop    %edi
  1030b2:	5d                   	pop    %ebp
  1030b3:	c3                   	ret    

001030b4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030b4:	55                   	push   %ebp
  1030b5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030b7:	eb 0c                	jmp    1030c5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030b9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030c1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c9:	74 1a                	je     1030e5 <strncmp+0x31>
  1030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ce:	0f b6 00             	movzbl (%eax),%eax
  1030d1:	84 c0                	test   %al,%al
  1030d3:	74 10                	je     1030e5 <strncmp+0x31>
  1030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d8:	0f b6 10             	movzbl (%eax),%edx
  1030db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030de:	0f b6 00             	movzbl (%eax),%eax
  1030e1:	38 c2                	cmp    %al,%dl
  1030e3:	74 d4                	je     1030b9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030e9:	74 18                	je     103103 <strncmp+0x4f>
  1030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ee:	0f b6 00             	movzbl (%eax),%eax
  1030f1:	0f b6 d0             	movzbl %al,%edx
  1030f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f7:	0f b6 00             	movzbl (%eax),%eax
  1030fa:	0f b6 c0             	movzbl %al,%eax
  1030fd:	29 c2                	sub    %eax,%edx
  1030ff:	89 d0                	mov    %edx,%eax
  103101:	eb 05                	jmp    103108 <strncmp+0x54>
  103103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103108:	5d                   	pop    %ebp
  103109:	c3                   	ret    

0010310a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10310a:	55                   	push   %ebp
  10310b:	89 e5                	mov    %esp,%ebp
  10310d:	83 ec 04             	sub    $0x4,%esp
  103110:	8b 45 0c             	mov    0xc(%ebp),%eax
  103113:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103116:	eb 14                	jmp    10312c <strchr+0x22>
        if (*s == c) {
  103118:	8b 45 08             	mov    0x8(%ebp),%eax
  10311b:	0f b6 00             	movzbl (%eax),%eax
  10311e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103121:	75 05                	jne    103128 <strchr+0x1e>
            return (char *)s;
  103123:	8b 45 08             	mov    0x8(%ebp),%eax
  103126:	eb 13                	jmp    10313b <strchr+0x31>
        }
        s ++;
  103128:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10312c:	8b 45 08             	mov    0x8(%ebp),%eax
  10312f:	0f b6 00             	movzbl (%eax),%eax
  103132:	84 c0                	test   %al,%al
  103134:	75 e2                	jne    103118 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103136:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10313b:	c9                   	leave  
  10313c:	c3                   	ret    

0010313d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10313d:	55                   	push   %ebp
  10313e:	89 e5                	mov    %esp,%ebp
  103140:	83 ec 04             	sub    $0x4,%esp
  103143:	8b 45 0c             	mov    0xc(%ebp),%eax
  103146:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103149:	eb 11                	jmp    10315c <strfind+0x1f>
        if (*s == c) {
  10314b:	8b 45 08             	mov    0x8(%ebp),%eax
  10314e:	0f b6 00             	movzbl (%eax),%eax
  103151:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103154:	75 02                	jne    103158 <strfind+0x1b>
            break;
  103156:	eb 0e                	jmp    103166 <strfind+0x29>
        }
        s ++;
  103158:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10315c:	8b 45 08             	mov    0x8(%ebp),%eax
  10315f:	0f b6 00             	movzbl (%eax),%eax
  103162:	84 c0                	test   %al,%al
  103164:	75 e5                	jne    10314b <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103166:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103169:	c9                   	leave  
  10316a:	c3                   	ret    

0010316b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10316b:	55                   	push   %ebp
  10316c:	89 e5                	mov    %esp,%ebp
  10316e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103171:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10317f:	eb 04                	jmp    103185 <strtol+0x1a>
        s ++;
  103181:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103185:	8b 45 08             	mov    0x8(%ebp),%eax
  103188:	0f b6 00             	movzbl (%eax),%eax
  10318b:	3c 20                	cmp    $0x20,%al
  10318d:	74 f2                	je     103181 <strtol+0x16>
  10318f:	8b 45 08             	mov    0x8(%ebp),%eax
  103192:	0f b6 00             	movzbl (%eax),%eax
  103195:	3c 09                	cmp    $0x9,%al
  103197:	74 e8                	je     103181 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103199:	8b 45 08             	mov    0x8(%ebp),%eax
  10319c:	0f b6 00             	movzbl (%eax),%eax
  10319f:	3c 2b                	cmp    $0x2b,%al
  1031a1:	75 06                	jne    1031a9 <strtol+0x3e>
        s ++;
  1031a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031a7:	eb 15                	jmp    1031be <strtol+0x53>
    }
    else if (*s == '-') {
  1031a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ac:	0f b6 00             	movzbl (%eax),%eax
  1031af:	3c 2d                	cmp    $0x2d,%al
  1031b1:	75 0b                	jne    1031be <strtol+0x53>
        s ++, neg = 1;
  1031b3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031b7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031c2:	74 06                	je     1031ca <strtol+0x5f>
  1031c4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031c8:	75 24                	jne    1031ee <strtol+0x83>
  1031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cd:	0f b6 00             	movzbl (%eax),%eax
  1031d0:	3c 30                	cmp    $0x30,%al
  1031d2:	75 1a                	jne    1031ee <strtol+0x83>
  1031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d7:	83 c0 01             	add    $0x1,%eax
  1031da:	0f b6 00             	movzbl (%eax),%eax
  1031dd:	3c 78                	cmp    $0x78,%al
  1031df:	75 0d                	jne    1031ee <strtol+0x83>
        s += 2, base = 16;
  1031e1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1031e5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1031ec:	eb 2a                	jmp    103218 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1031ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031f2:	75 17                	jne    10320b <strtol+0xa0>
  1031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f7:	0f b6 00             	movzbl (%eax),%eax
  1031fa:	3c 30                	cmp    $0x30,%al
  1031fc:	75 0d                	jne    10320b <strtol+0xa0>
        s ++, base = 8;
  1031fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103202:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103209:	eb 0d                	jmp    103218 <strtol+0xad>
    }
    else if (base == 0) {
  10320b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10320f:	75 07                	jne    103218 <strtol+0xad>
        base = 10;
  103211:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103218:	8b 45 08             	mov    0x8(%ebp),%eax
  10321b:	0f b6 00             	movzbl (%eax),%eax
  10321e:	3c 2f                	cmp    $0x2f,%al
  103220:	7e 1b                	jle    10323d <strtol+0xd2>
  103222:	8b 45 08             	mov    0x8(%ebp),%eax
  103225:	0f b6 00             	movzbl (%eax),%eax
  103228:	3c 39                	cmp    $0x39,%al
  10322a:	7f 11                	jg     10323d <strtol+0xd2>
            dig = *s - '0';
  10322c:	8b 45 08             	mov    0x8(%ebp),%eax
  10322f:	0f b6 00             	movzbl (%eax),%eax
  103232:	0f be c0             	movsbl %al,%eax
  103235:	83 e8 30             	sub    $0x30,%eax
  103238:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10323b:	eb 48                	jmp    103285 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10323d:	8b 45 08             	mov    0x8(%ebp),%eax
  103240:	0f b6 00             	movzbl (%eax),%eax
  103243:	3c 60                	cmp    $0x60,%al
  103245:	7e 1b                	jle    103262 <strtol+0xf7>
  103247:	8b 45 08             	mov    0x8(%ebp),%eax
  10324a:	0f b6 00             	movzbl (%eax),%eax
  10324d:	3c 7a                	cmp    $0x7a,%al
  10324f:	7f 11                	jg     103262 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103251:	8b 45 08             	mov    0x8(%ebp),%eax
  103254:	0f b6 00             	movzbl (%eax),%eax
  103257:	0f be c0             	movsbl %al,%eax
  10325a:	83 e8 57             	sub    $0x57,%eax
  10325d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103260:	eb 23                	jmp    103285 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103262:	8b 45 08             	mov    0x8(%ebp),%eax
  103265:	0f b6 00             	movzbl (%eax),%eax
  103268:	3c 40                	cmp    $0x40,%al
  10326a:	7e 3d                	jle    1032a9 <strtol+0x13e>
  10326c:	8b 45 08             	mov    0x8(%ebp),%eax
  10326f:	0f b6 00             	movzbl (%eax),%eax
  103272:	3c 5a                	cmp    $0x5a,%al
  103274:	7f 33                	jg     1032a9 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103276:	8b 45 08             	mov    0x8(%ebp),%eax
  103279:	0f b6 00             	movzbl (%eax),%eax
  10327c:	0f be c0             	movsbl %al,%eax
  10327f:	83 e8 37             	sub    $0x37,%eax
  103282:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103288:	3b 45 10             	cmp    0x10(%ebp),%eax
  10328b:	7c 02                	jl     10328f <strtol+0x124>
            break;
  10328d:	eb 1a                	jmp    1032a9 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  10328f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103293:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103296:	0f af 45 10          	imul   0x10(%ebp),%eax
  10329a:	89 c2                	mov    %eax,%edx
  10329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10329f:	01 d0                	add    %edx,%eax
  1032a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032a4:	e9 6f ff ff ff       	jmp    103218 <strtol+0xad>

    if (endptr) {
  1032a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032ad:	74 08                	je     1032b7 <strtol+0x14c>
        *endptr = (char *) s;
  1032af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b2:	8b 55 08             	mov    0x8(%ebp),%edx
  1032b5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032bb:	74 07                	je     1032c4 <strtol+0x159>
  1032bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032c0:	f7 d8                	neg    %eax
  1032c2:	eb 03                	jmp    1032c7 <strtol+0x15c>
  1032c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032c7:	c9                   	leave  
  1032c8:	c3                   	ret    

001032c9 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032c9:	55                   	push   %ebp
  1032ca:	89 e5                	mov    %esp,%ebp
  1032cc:	57                   	push   %edi
  1032cd:	83 ec 24             	sub    $0x24,%esp
  1032d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1032d6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1032da:	8b 55 08             	mov    0x8(%ebp),%edx
  1032dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1032e0:	88 45 f7             	mov    %al,-0x9(%ebp)
  1032e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1032e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1032e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1032ec:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1032f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1032f3:	89 d7                	mov    %edx,%edi
  1032f5:	f3 aa                	rep stos %al,%es:(%edi)
  1032f7:	89 fa                	mov    %edi,%edx
  1032f9:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1032fc:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1032ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103302:	83 c4 24             	add    $0x24,%esp
  103305:	5f                   	pop    %edi
  103306:	5d                   	pop    %ebp
  103307:	c3                   	ret    

00103308 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103308:	55                   	push   %ebp
  103309:	89 e5                	mov    %esp,%ebp
  10330b:	57                   	push   %edi
  10330c:	56                   	push   %esi
  10330d:	53                   	push   %ebx
  10330e:	83 ec 30             	sub    $0x30,%esp
  103311:	8b 45 08             	mov    0x8(%ebp),%eax
  103314:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103317:	8b 45 0c             	mov    0xc(%ebp),%eax
  10331a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10331d:	8b 45 10             	mov    0x10(%ebp),%eax
  103320:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103326:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103329:	73 42                	jae    10336d <memmove+0x65>
  10332b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10332e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103334:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103337:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10333a:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10333d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103340:	c1 e8 02             	shr    $0x2,%eax
  103343:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103345:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10334b:	89 d7                	mov    %edx,%edi
  10334d:	89 c6                	mov    %eax,%esi
  10334f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103351:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103354:	83 e1 03             	and    $0x3,%ecx
  103357:	74 02                	je     10335b <memmove+0x53>
  103359:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10335b:	89 f0                	mov    %esi,%eax
  10335d:	89 fa                	mov    %edi,%edx
  10335f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103362:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103365:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10336b:	eb 36                	jmp    1033a3 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10336d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103370:	8d 50 ff             	lea    -0x1(%eax),%edx
  103373:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103376:	01 c2                	add    %eax,%edx
  103378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  10337e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103381:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103387:	89 c1                	mov    %eax,%ecx
  103389:	89 d8                	mov    %ebx,%eax
  10338b:	89 d6                	mov    %edx,%esi
  10338d:	89 c7                	mov    %eax,%edi
  10338f:	fd                   	std    
  103390:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103392:	fc                   	cld    
  103393:	89 f8                	mov    %edi,%eax
  103395:	89 f2                	mov    %esi,%edx
  103397:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10339a:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10339d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033a3:	83 c4 30             	add    $0x30,%esp
  1033a6:	5b                   	pop    %ebx
  1033a7:	5e                   	pop    %esi
  1033a8:	5f                   	pop    %edi
  1033a9:	5d                   	pop    %ebp
  1033aa:	c3                   	ret    

001033ab <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033ab:	55                   	push   %ebp
  1033ac:	89 e5                	mov    %esp,%ebp
  1033ae:	57                   	push   %edi
  1033af:	56                   	push   %esi
  1033b0:	83 ec 20             	sub    $0x20,%esp
  1033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1033c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033c8:	c1 e8 02             	shr    $0x2,%eax
  1033cb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d3:	89 d7                	mov    %edx,%edi
  1033d5:	89 c6                	mov    %eax,%esi
  1033d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033d9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1033dc:	83 e1 03             	and    $0x3,%ecx
  1033df:	74 02                	je     1033e3 <memcpy+0x38>
  1033e1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033e3:	89 f0                	mov    %esi,%eax
  1033e5:	89 fa                	mov    %edi,%edx
  1033e7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1033ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1033ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1033f3:	83 c4 20             	add    $0x20,%esp
  1033f6:	5e                   	pop    %esi
  1033f7:	5f                   	pop    %edi
  1033f8:	5d                   	pop    %ebp
  1033f9:	c3                   	ret    

001033fa <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1033fa:	55                   	push   %ebp
  1033fb:	89 e5                	mov    %esp,%ebp
  1033fd:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103400:	8b 45 08             	mov    0x8(%ebp),%eax
  103403:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103406:	8b 45 0c             	mov    0xc(%ebp),%eax
  103409:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10340c:	eb 30                	jmp    10343e <memcmp+0x44>
        if (*s1 != *s2) {
  10340e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103411:	0f b6 10             	movzbl (%eax),%edx
  103414:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103417:	0f b6 00             	movzbl (%eax),%eax
  10341a:	38 c2                	cmp    %al,%dl
  10341c:	74 18                	je     103436 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10341e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103421:	0f b6 00             	movzbl (%eax),%eax
  103424:	0f b6 d0             	movzbl %al,%edx
  103427:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10342a:	0f b6 00             	movzbl (%eax),%eax
  10342d:	0f b6 c0             	movzbl %al,%eax
  103430:	29 c2                	sub    %eax,%edx
  103432:	89 d0                	mov    %edx,%eax
  103434:	eb 1a                	jmp    103450 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103436:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10343a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10343e:	8b 45 10             	mov    0x10(%ebp),%eax
  103441:	8d 50 ff             	lea    -0x1(%eax),%edx
  103444:	89 55 10             	mov    %edx,0x10(%ebp)
  103447:	85 c0                	test   %eax,%eax
  103449:	75 c3                	jne    10340e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10344b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103450:	c9                   	leave  
  103451:	c3                   	ret    
