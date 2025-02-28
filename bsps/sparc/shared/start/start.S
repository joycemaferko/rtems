/**
 *  Common start code for SPARC.
 *
 *  This is based on the file srt0.s provided with the binary
 *  distribution of the SPARC Instruction Simulator (SIS) found
 *  at ftp://ftp.estec.esa.nl/pub/ws/wsd/erc32.
 */

/*
 *  COPYRIGHT (c) 1989-2011.
 *  On-Line Applications Research Corporation (OAR).
 *
 *  The license and distribution terms for this file may be
 *  found in the file LICENSE in this distribution or at
 *  http://www.rtems.org/license/LICENSE.
 */

#include <rtems/asm.h>
#include <rtems/score/percpu.h>
#include <bspopts.h>

#if defined(RTEMS_SMP) && defined(BSP_LEON3_SMP)
  #define START_LEON3_ENABLE_SMP
#endif

/*
 *  Unexpected trap will halt the processor by forcing it to error state
 */
#define BAD_TRAP \
  ta 0; \
  nop; \
  nop; \
  nop;

/*
 * System call optimized trap table entry
 */
#define FPDIS_TRAP(_handler)  \
  mov   %psr, %l0 ; \
  sethi %hi(_handler), %l4 ; \
  jmp   %l4+%lo(_handler); \
   sethi %hi(SPARC_PSR_EF_MASK), %l3

/*
 * System call optimized trap table entry
 */
#define IRQDIS_TRAP(_handler)  \
  mov   %psr, %l0 ; \
  sethi %hi(_handler), %l4 ; \
  jmp   %l4+%lo(_handler); \
   or   %l0, 0x0f00, %l3; ! Set PIL=0xf to disable IRQ

/*
 * System call optimized trap table entry
 */
#define IRQEN_TRAP(_handler)  \
  mov   %psr, %l0 ; \
  sethi %hi(_handler), %l4 ; \
  jmp   %l4+%lo(_handler); \
   andn %l0, 0xf00, %l3; ! Set PIL=0 to Enable IRQ

/*
 * Window Overflow optimized trap table entry
 */
#define WOTRAP(_vector, _handler)  \
  sethi %hi(_handler), %l4; \
  jmp   %l4+%lo(_handler); \
    save; \
  nop

/*
 * Window Underflow optimized trap table entry
 */
#define WUTRAP(_vector, _handler)  \
  mov   %wim, %l3 ; \
  sethi %hi(_handler), %l4 ; \
  jmp   %l4+%lo(_handler); \
   sll  %l3, 1, %l4 ! l4 = WIM << 1

/*
 *  Software trap. Treat as BAD_TRAP for the time being...
 */

#define SOFT_TRAP BAD_TRAP

  .section    ".text"
  PUBLIC(start)
  .global start

SYM(start):
#if SYM(start) != start
start:
#endif 

/*
 *  The trap table has to be the first code in a boot PROM.  But because
 *  the Memory Configuration comes up thinking we only have 4K of PROM, we
 *  cannot have a full trap table and still have room left over to
 *  reprogram the Memory Configuration register correctly.  This file
 *  uses an abbreviated trap which has every entry which might be used
 *  before RTEMS installs its own trap table.
 */

  PUBLIC(trap_table)
SYM(trap_table):

  RTRAP( 0, SYM(hard_reset) );                  ! 00 reset trap
  BAD_TRAP;                                     ! 01 instruction access
                                                !    exception
  BAD_TRAP;                                     ! 02 illegal instruction
  BAD_TRAP;                                     ! 03 privileged instruction
#if defined(SPARC_USE_LAZY_FP_SWITCH)
  FPDIS_TRAP(SYM(syscall_lazy_fp_switch));      ! 04 fp disabled
#else
  BAD_TRAP;                                     ! 04 fp disabled
#endif
  WOTRAP(5, SYM(window_overflow_trap_handler)); ! 05 window overflow
  WUTRAP(6, SYM(window_underflow_trap_handler));! 06 window underflow
  BAD_TRAP;                                     ! 07 memory address not aligned
  BAD_TRAP;                                     ! 08 fp exception
  BAD_TRAP;                                     ! 09 data access exception
  BAD_TRAP;                                     ! 0A tag overflow
  BAD_TRAP;                                     ! 0B undefined
  BAD_TRAP;                                     ! 0C undefined
  BAD_TRAP;                                     ! 0D undefined
  BAD_TRAP;                                     ! 0E undefined
  BAD_TRAP;                                     ! 0F undefined
  BAD_TRAP;                                     ! 10 undefined

  /*
   *  ERC32 defined traps
   */

  BAD_TRAP;                                     ! 11 masked errors
  BAD_TRAP;                                     ! 12 external 1
  BAD_TRAP;                                     ! 13 external 2
  BAD_TRAP;                                     ! 14 UART A RX/TX
  BAD_TRAP;                                     ! 15 UART B RX/TX
  BAD_TRAP;                                     ! 16 correctable memory error
  BAD_TRAP;                                     ! 17 UART error
  BAD_TRAP;                                     ! 18 DMA access error
  BAD_TRAP;                                     ! 19 DMA timeout
  BAD_TRAP;                                     ! 1A external 3
  BAD_TRAP;                                     ! 1B external 4
  BAD_TRAP;                                     ! 1C general purpose timer
  BAD_TRAP;                                     ! 1D real time clock
  BAD_TRAP;                                     ! 1E external 5
  BAD_TRAP;                                     ! 1F watchdog timeout

  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 20 - 23 undefined
  BAD_TRAP;                                     ! 24 cp_disabled
            BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 25 - 27 undefined
  BAD_TRAP;                                     ! 28 cp_exception
            BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 29 - 2B undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 2C - 2F undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 30 - 33 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 34 - 37 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 38 - 3B undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 3C - 3F undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 40 - 43 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 44 - 47 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 48 - 4B undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 4C - 4F undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 50 - 53 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 54 - 57 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 58 - 5B undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 5C - 5F undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 60 - 63 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 64 - 67 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 68 - 6B undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 6C - 6F undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 70 - 73 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 74 - 77 undefined
  BAD_TRAP; BAD_TRAP; BAD_TRAP; BAD_TRAP;       ! 78 - 7B undefined

/*
   This is a sad patch to make sure that we know where the
   MEC timer control register mirror is so we can stop the timers
   from an external debugger. It is needed because the control
   register is write-only. Trap 0x7C cannot occure in ERC32...
*/

	.global SYM(_ERC32_MEC_Timer_Control_Mirror), SYM(CLOCK_SPEED)

SYM(_ERC32_MEC_Timer_Control_Mirror):

  BAD_TRAP; BAD_TRAP;                           ! 7C - 7D undefined

SYM(CLOCK_SPEED):

  .word	0x0a, 0, 0, 0				! 7E (10 MHz default)

  BAD_TRAP; 					! 7F undefined

  /*
   *  Software traps
   *
   *  NOTE: At the risk of being redundant... this is not a full
   *        table.  The setjmp on the SPARC requires a window flush trap
   *        handler and RTEMS will preserve the entries that were
   *        installed before.
   */

  TRAP( 0x80, SYM(syscall) );                   ! 80 halt syscall SW trap
  SOFT_TRAP; SOFT_TRAP;                         ! 81 - 82
  TRAP( 0x83, SYM(window_flush_trap_handler) ); ! 83 flush windows SW trap

  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! 84 - 87
  SOFT_TRAP;                                    ! 88

  /*
   *  SW Trap 9-15 Reserved for Operating System
   *  
   *  SPARC_SWTRAP_IRQDIS
   *  SPARC_SWTRAP_IRQEN
   */
  IRQDIS_TRAP(SYM(syscall_irqdis));             ! 89 IRQ Disable syscall trap
  IRQEN_TRAP(SYM(syscall_irqen));               ! 8A IRQ Enable syscall trap
#if defined(SPARC_USE_SYNCHRONOUS_FP_SWITCH)
  IRQDIS_TRAP(SYM(syscall_irqdis_fp));          ! 8B IRQ disable
                                                ! and set PSR[EF] syscall trap
#else
  SOFT_TRAP;                                    ! 8B
#endif
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! 8C - 8F

  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! 90 - 93
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! 94 - 97
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! 98 - 9B
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! 9C - 9F
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! A0 - A3
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! A4 - A7
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! A8 - AB
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! AC - AF
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! B0 - B3
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! B4 - B7
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! B8 - BB
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! BC - BF
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! C0 - C3
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! C4 - C7
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! C8 - CB
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! CC - CF
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! D0 - D3
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! D4 - D7
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! D8 - DB
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! DC - DF
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! E0 - E3
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! E4 - E7
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! E8 - EB
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! EC - EF
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! F0 - F3
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! F4 - F7
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! F8 - FB
  SOFT_TRAP; SOFT_TRAP; SOFT_TRAP; SOFT_TRAP;   ! FC - FF

/*
 *  This is the hard reset code.
 */

#define PSR_INIT   0x10c0       /* Disable traps, set s and ps */
#define WIM_INIT   2

        PUBLIC(hard_reset)
SYM(hard_reset):

/* Common initialisation */

        set     SYM(trap_table), %g1    ! Initialize TBR
        mov     %g1, %tbr

        mov	%psr, %g1         	! Initialize WIM
	add	%g1, 1, %g2
	and	%g2, 0x7, %g2
	set	1, %g3
	sll	%g3, %g2, %g3
        mov     %g3, %wim

	or	%g1, 0xf20, %g1
        wr      %g1, %psr		! enable traps and disable ints

        nop
        nop
        nop

        mov     %sp, %o0 ! save end of usable RAM provided by the boot loader
        set     SYM(_Per_CPU_Information), %g6 ! set per-CPU control
        set     SYM(_ISR_Stack_size), %l0 ! get ISR stack size

#if defined(START_LEON3_ENABLE_SMP)
        rd      %asr17, %l7 ! get CPU identifier
        srl     %l7, LEON3_ASR17_PROCESSOR_INDEX_SHIFT, %l7
        add     %l7, 1, %l1 ! get ISR stack offset for this CPU
        smul    %l1, %l0, %l0
        sll     %l7, PER_CPU_CONTROL_SIZE_LOG2, %l2 ! per-CPU for this CPU
        add     %g6, %l2, %g6
#endif
        set     SYM(_ISR_Stack_area_begin), %sp ! set stack pointer
        add     %sp, %l0, %sp
        andn    %sp, CPU_STACK_ALIGNMENT - 1, %sp
        sub     %sp, SPARC_MINIMUM_STACK_FRAME_SIZE, %sp
        mov     %sp, %fp ! set frame pointer

#if defined(START_LEON3_ENABLE_SMP)
	/* If LEON3_Boot_Cpu < 0 then assign us as boot CPU and continue. */
        set     SYM(LEON3_Boot_Cpu), %l0
        ld      [%l0], %l1
        tst     %l1
	bneg	.Lbootcpu
	 nop

	call	SYM(bsp_start_on_secondary_processor) ! does not return
	 mov	%g6, %o0
.Lbootcpu:
	st	%l7, [%l0]
#endif

        /* clear the bss */

        sethi %hi(__bss_start), %g2     ! g2 = start of bss
        or    %g2,%lo(__bss_start),%g2

        sethi %hi(_end),%g3
        or    %g3,%lo(_end),%g3         ! g3 = end of bss
        mov   %g0,%g1                   ! so std has two zeros
.Lzerobss:
        std    %g0,[%g2]
        add    %g2,8,%g2
        cmp    %g2,%g3
        bleu,a .Lzerobss
        nop

        call    SYM(_SPARC_Memory_initialize)
         nop ! o0 = end of usable RAM provided by the boot loader

        call    SYM(boot_card)          ! does not return
         mov    %g0, %o0                ! command line

/* end of file */
