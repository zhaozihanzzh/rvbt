INCLUDE link-dwarf.ld
PROVIDE(_stext = 0x80000000); 
PROVIDE(_heap_size = 128K);
PROVIDE(_stack_size = 64K);
PROVIDE(_max_hart = 8);


OUTPUT_ARCH(riscv)

ENTRY(_start)



SECTIONS
{
	. = _stext;
	/* .text section */
	.text : {
		_text_start = .;
		*(.text.entry)
		*(.text .text.*)
		_text_end = .;
	}

	INCLUDE link-rvbt.ld
	/* .rodata section */
	.rodata : ALIGN(4) {
	_rodata_start = .;
		*(.rodata .rodata.*)
		. = ALIGN(4);
		_rodata_end = .;
	}


	/* .data section */
	.data : ALIGN(4) {
		_data_start = .;
		/* 
		 * Linker relaxation
		 * https://www.sifive.com/blog/all-aboard-part-3-linker-relaxation-in-riscv-toolchain 
		 */
		PROVIDE(__global_pointer$ = . + 0x800);
		*(.sdata .sdata.* .sdata2 .sdata2.*);
		*(.data .data.*);
		. = ALIGN(4);
		_data_end = .;
	}

	/* .bss section */
	.bss (NOLOAD) : ALIGN(4) {
		_bss_start = .;
		*(.sbss .bss .bss.*)
		. = ALIGN(4);
		_bss_end = .;
	}

	/* Machine Heap */
	.heap (NOLOAD) : ALIGN(4) {
		_heap_start = .;
		. += _heap_size;
		. = ALIGN(4);
		_heap_end = .;
	}

	/* Machine Stack */
	.stack (NOLOAD) : ALIGN(4) {
		_stack_start = .;
	}

	/DISCARD/ : {
		*(.eh_frame)
	}
}

