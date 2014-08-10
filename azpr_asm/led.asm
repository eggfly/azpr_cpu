;;; 1�����룺azprasm led.asm -o led.bin --coe led.coe
;;; 2���ֹ���Xilinx FPGA��coe�ļ�ת��ΪAltera FPGA��mif��ʽ��ΪROM��ʼ�������ļ� sprom16.mif
;;; 3���������ۺ�ʱ����sprom16.mif��ΪROM�ĳ�ʼ�������ļ�

;;; ���Ŷ���(��Դ�����ļ���ANSI����)
GPIO_BASE_ADDR_H	EQU	0x8000		;GPIO Base Address High
GPIO_OUT_OFFSET		EQU	0x4			;GPIO Output Port Register Offset

;;; ����LED
	XORR	r0,r0,r0
	ORI		r0,r1,GPIO_BASE_ADDR_H	;��GPIO Base Address����r1
	SHLLI	r1,r1,16				;����16λ,��GPIO Base Address��16λ����r1
	ORI		r0,r2,0x2				;�������r2��ֵ
	SHLLI	r2,r2,16				;����16λ�����������r2�ĸ�16λ
	ORI		r2,r2,0x00aa			;�������r2�ĵ�16λ��ֵ
	STW		r1,r2,GPIO_OUT_OFFSET	;�������r2д��GPIO Output Port

;;; ����ѭ��
LOOP:
	BE		r0,r0,LOOP				;�˻ص�LOOP
	ANDR	r0,r0,r0				;NOP�ղ���
