;;; 1�����룺 azprasm prog.asm -o prog.bin
;;; 2���ϴ��� �����帴λ֮����tare term��XMODENЭ���ϴ�prog.bin,�ΰ�һ����ť������ϴ�
;;;           �������ۺ�ʱ���ѽ������������loader16.mif����ΪROM��ʼ�����ļ�
;;; 3��ִ�У� ���������loaderͨ��������ɳ����ϴ������浽SPM�ڴ����ת��SPM�еĳ������ִ��
;;; ������ʼλ��
	LOCATE	0x20000000

;;; ���Ŷ���
GPIO_BASE_ADDR_H	EQU	0x8000		;GPIO Base Address High
GPIO_OUT_OFFSET		EQU	0x4			;GPIO Output Port Register Offset

;;; ����LED
	XORR	r0,r0,r0
	ORI		r0,r1,GPIO_BASE_ADDR_H	;GPIO Base Address����r1
	SHLLI	r1,r1,16				;����16λ,�����õ�ַ��λ
	ORI		r0,r2,0x2				;0x2����r2
	SHLLI	r2,r2,16				;r2����16λ�������ø�16λ��
	ORI		r2,r2,0x00aa			;����r2�ĵ�16λ��
	STW		r1,r2,GPIO_OUT_OFFSET	;r2��Ϊ�������д��GPIO Output Port���ܹ�18λ��

;;; ����ѭ��
LOOP:
	BE		r0,r0,LOOP				;����LOOP
	ANDR	r0,r0,r0				;NOP
