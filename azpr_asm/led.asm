;;; ���Ŷ���(��Դ�����ļ���ANSI����)
GPIO_BASE_ADDR_H	EQU	0x8000		;GPIO Base Address High
GPIO_OUT_OFFSET		EQU	0x4			;GPIO Output Port Register Offset

;;; ����LED
	XORR	r0,r0,r0
	ORI		r0,r1,GPIO_BASE_ADDR_H	;��GPIO Base Address��16λ����r1
	SHLLI	r1,r1,16				;����16λ
	ORI		r0,r2,0x2				;�������r2�ĸ�16λ
	SHLLI	r2,r2,16				;����16λ
	ORI		r2,r2,0x00aa			;�������r2�ĵ�16λ
	STW		r1,r2,GPIO_OUT_OFFSET	;�������д��GPIO Output Port

;;; ����ѭ��
LOOP:
	BE		r0,r0,LOOP				;�˻ص�LOOP
	ANDR	r0,r0,r0				;NOP�ղ���
