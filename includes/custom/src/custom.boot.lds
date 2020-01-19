OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)

/* Entry Point  */
ENTRY(Custom)

/* LPC2103 memory areas  */
MEMORY 
{
  boot (RX)       : ORIGIN = 0xc00    ,     LENGTH = 128   /* C-runtime booter */
  C_code (RX)     : ORIGIN = 0xc80    ,    LENGTH = 21k   /* space for C code */
  ram             : ORIGIN = 0x40001c00, LENGTH = 512    /* free RAM (less stack space) */
}

/* Global symbol _stack_end */
_stack_end = 0x40001FDC;

/* Output sections  */
SECTIONS
{
  .bootcode :
  {
    _sboot = .;    
    *(.boot)
    . = ALIGN(4);
    _eboot = .;     
  } > boot

         .text : {
                .stext = .;
                 . = ALIGN(4);
                 *(.text)
                 *(.text.*)
                 *(.rodata)
                 *(.rodata*)
                 . = ALIGN(4);
                 _etext = .;
         } >C_code
         .data : AT ( _etext ) {
                 . = ALIGN(4);
                 _sdata = .;
                 *(.data)
                 *(.data.*)
                 . = ALIGN(4);
                 _edata = .;

         } >ram
         .bss : {
                 . = ALIGN(4);
                 _sbss = .;
                 *(.bss)
                 *(COMMON)
                 . = ALIGN(4);
                 _ebss = .;
         } >ram


}
end = .;
