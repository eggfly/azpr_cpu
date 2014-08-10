;;;   ���ڳ�������� V1.0
;;; 1�����룺azprasm loader.asm -o loader.bin --coe loader.coe
;;; 2���ֹ���Xilinx FPGA��coe�ļ�ת��ΪAltera FPGA��mif��ʽ��ΪROM��ʼ�������ļ�loader16.mif
;;; 3���������ۺ�ʱ����loader16.mif��ΪROM�ĳ�ʼ�������ļ�

UART_BASE_ADDR_H	EQU		0x6000		;UART Base Address High
UART_STATUS_OFFSET	EQU		0x0			;UART Status Register Offset
UART_DATA_OFFSET	EQU		0x4			;UART Data Register Offset
UART_RX_INTR_MASK	EQU		0x1			;UART Receive Interrupt
UART_TX_INTR_MASK	EQU		0x2			;UART Receive Interrupt

GPIO_BASE_ADDR_H	EQU		0x8000		;GPIO Base Address High
GPIO_IN_OFFSET		EQU		0x0			;GPIO Input Port Register Offset
GPIO_OUT_OFFSET		EQU		0x4			;GPIO Output Port Register Offset

SPM_BASE_ADDR_H		EQU		0x2000		;SPM Base Address High

XMODEM_SOH			EQU		0x1			;Start Of Heading
XMODEM_EOT			EQU		0x4			;End Of Transmission
XMODEM_ACK			EQU		0x6			;ACKnowlege
XMODEM_NAK			EQU		0x15		;Negative AcKnowlege
XMODEM_DATA_SIZE	EQU		128


	XORR	r0,r0,r0

	ORI		r0,r1,high(CLEAR_BUFFER)	;��٥�CLEAR_BUFFER����λ16�ӥåȤ�r1�˥��å�
	SHLLI	r1,r1,16
	ORI		r1,r1,low(CLEAR_BUFFER)		;��٥�CLEAR_BUFFER����λ16�ӥåȤ�r1�˥��å�

	ORI		r0,r2,high(SEND_BYTE)		;��٥�SEND_BYTE����λ16�ӥåȤ�r2�˥��å�
	SHLLI	r2,r2,16
	ORI		r2,r2,low(SEND_BYTE)		;��٥�SEND_BYTE����λ16�ӥåȤ�r2�˥��å�

	ORI		r0,r3,high(RECV_BYTE)		;��٥�RECV_BYTE����λ16�ӥåȤ�r3�˥��å�
	SHLLI	r3,r3,16
	ORI		r3,r3,low(RECV_BYTE)		;��٥�RECV_BYTE����λ16�ӥåȤ�r3�˥��å�

	ORI 	r0,r4,high(WAIT_PUSH_SW)	;��٥�WAIT_PUSH_SW����λ16�ӥåȤ�r4�˥��å�
	SHLLI	r4,r4,16
	ORI		r4,r4,low(WAIT_PUSH_SW)		;��٥�WAIT_PUSH_SW����λ16�ӥåȤ�r4�˥��å�

;;; UART�ΥХåե����ꥢ
	CALL	r1							;CLEAR_BUFFER���ӳ���
	ANDR	r0,r0,r0					;NOP

	ORI		r0,r20,GPIO_BASE_ADDR_H		;GPIO Base Address��λ16�ӥåȤ�r20�˥��å�
	SHLLI	r20,r20,16					;16�ӥå��󥷥ե�
	ORI		r0,r21,0x2					;�����ǩ`������λ16�ӥåȤ�r21�˥��å�
	SHLLI	r21,r21,16					;16�ӥå��󥷥ե�
	ORI		r21,r21,0xFFFF				;�����ǩ`������λ16�ӥåȤ�r21�˥��å�
	STW		r20,r21,GPIO_OUT_OFFSET		;GPIO Output Port�˳����ǩ`��������z��

;; Wait Push Switch
	CALL	r4
	ANDR	r0, r0, r0

;; NAK����
	ORI		r0,r16,XMODEM_NAK			;r16��NAK�򥻥å�
	CALL	r2							;SEND_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP

	XORR	r5,r5,r5
;; �֥�å������^�����Ť���
;; ���Ŵ���
RECV_HEADER:
	CALL	r3							;RECV_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP

;; ���ťǩ`��
	ORI		r0,r6,XMODEM_SOH			;r6��SOH�򥻥å�
	BE		r16,r6,RECV_SOH
	ANDR	r0,r0,r0					;NOP

;; EOT
;; ACK����
	ORI		r0,r16,XMODEM_ACK			;r16��ACK�򥻥å�
	CALL	r2							;SEND_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP

;; jump to spm
	ORI		r0,r6,SPM_BASE_ADDR_H		;SPM Base Address��λ16�ӥåȤ�r6�˥��å�
	SHLLI	r6,r6,16

	JMP		r6							;SPM�Υץ�����g�Ф���
	ANDR	r0,r0,r0					;NOP

;; SOH
RECV_SOH:
;; BN����
	CALL	r3							;RECV_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP
	ORR		r0,r16,r7					;r7�����ťǩ`��BN�򥻥å�

;; BNC����
	CALL	r3							;RECV_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP
	ORR		r0,r16,r8					;r8�����ťǩ`��BNC�򥻥å�

	ORI		r0,r9,XMODEM_DATA_SIZE
	XORR	r10,r10,r10					;r10�򥯥ꥢ
	XORR	r11,r11,r11					;r11�򥯥ꥢ

;; 1�֥�å�����
; byte0
READ_BYTE0:
	CALL	r3							;RECV_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP
	ADDUR	r11,r16,r11
	SHLLI	r16,r16,24					;24bit�󥷥ե�
	ORR		r0,r16,r12

; byte1
	CALL	r3							;RECV_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP
	ADDUR	r11,r16,r11
	SHLLI	r16,r16,16					;16bit�󥷥ե�
	ORR		r12,r16,r12

; byte2
	CALL	r3							;RECV_BYTE���ӳ���
	ORR		r0,r0,r0					;NOP
	ADDUR	r11,r16,r11
	SHLLI	r16,r16,8					;8bit�󥷥ե�
	ORR		r12,r16,r12

; byte3
	CALL	r3							;RECV_BYTE���ӳ���
	ORR		r0,r0,r0					;NOP
	ADDUR	r11,r16,r11
	ORR		r12,r16,r12

; write memory
	ORI		r0,r13,SPM_BASE_ADDR_H		;SPM Base Address��λ16�ӥåȤ�r13�˥��å�
	SHLLI	r13,r13,16

	SHLLI	r5,r14,7
	ADDUR	r14,r10,r14
	ADDUR	r14,r13,r13
	STW		r13,r12,0

	ADDUI	r10,r10,4
	BNE		r10,r9,READ_BYTE0
	ANDR	r0,r0,r0					;NOP

;; CS����
	CALL	r3							;RECV_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP
	ORR		r0,r16,r12

;; Error Check
	ADDUR	r7,r8,r7
	ORI		r0,r13,0xFF					;r13��0xFF�򥻥å�
	BNE		r7,r13,SEND_NAK				;BN+BNC��0xFF�Ǥʤ����NAK����
	ANDR	r0,r0,r0					;NOP

	ANDI	r11,r11,0xFF				;r11��0xFF�򥻥å�
	BNE		r12,r11,SEND_NAK			;check sum����������
	ANDR	r0,r0,r0					;NOP

;; ACK����
SEND_ACK:
	ORI		r0,r16,XMODEM_ACK			;r16��ACK�򥻥å�
	CALL	r2							;SEND_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP
	ADDUI	r5,r5,1
	BNE		r0,r0,RETURN_RECV_HEADER
	ANDR	r0,r0,r0					;NOP

;; NAK����
SEND_NAK:
	ORI		r0,r16,XMODEM_NAK			;r16��NAK�򥻥å�
	CALL	r2							;SEND_BYTE���ӳ���
	ANDR	r0,r0,r0					;NOP

;; RECV_HEADER�ˑ���
RETURN_RECV_HEADER:
	BE		r0,r0,RECV_HEADER
	ANDR	r0,r0,r0					;NOP

CLEAR_BUFFER:
	ORI		r0,r16,UART_BASE_ADDR_H		;UART Base Address��λ16�ӥåȤ�r16�˥��å�
	SHLLI	r16,r16,16

_CHECK_UART_STATUS:
	LDW		r16,r17,UART_STATUS_OFFSET	;STATUS��ȡ��

	ANDI	r17,r17,UART_RX_INTR_MASK
	BE		r0,r17,_CLEAR_BUFFER_RETURN	;Receive Interrupt bit�����äƤ����_CLEAR_BUFFER_RETURN��g��
	ANDR	r0,r0,r0					;NOP

_READ_DATA:
	LDW		r16,r17,UART_DATA_OFFSET	;���ťǩ`�����i��ǥХåե��򥯥ꥢ����

	LDW		r16,r17,UART_STATUS_OFFSET	;STATUS��ȡ��
	XORI	r17,r17,UART_RX_INTR_MASK
	STW		r6,r17,UART_STATUS_OFFSET	;Receive Interrupt bit�򥯥ꥢ

	BNE		r0,r0,_CHECK_UART_STATUS	;_CHECK_UART_STATUS�ˑ���
	ANDR	r0,r0,r0					;NOP
_CLEAR_BUFFER_RETURN:
	JMP		r31							;���ӳ���Ԫ�ˑ���
	ANDR	r0,r0,r0					;NOP


SEND_BYTE:
	ORI		r0,r17,UART_BASE_ADDR_H		;UART Base Address��λ16�ӥåȤ�r17�˥��å�
	SHLLI	r17,r17,16
	STW		r17,r16,UART_DATA_OFFSET	;r16�����Ť���

_WAIT_SEND_DONE:
	LDW		r17,r18,UART_STATUS_OFFSET	;STATUS��ȡ��
	ANDI	r18,r18,UART_TX_INTR_MASK
	BE		r0,r18,_WAIT_SEND_DONE		;Transmit Interrupt bit�����äƤ��ʤ����_WAIT_SEND_DONE��g��
	ANDR	r0,r0,r0					;NOP

	LDW		r17,r18,UART_STATUS_OFFSET	;STATUS��ȡ��
	XORI	r18,r18,UART_TX_INTR_MASK
	STW		r17,r18,UART_STATUS_OFFSET	;Transmit Interrupt bit�򥯥ꥢ

	JMP		r31							;���ӳ���Ԫ�ˑ���
	ANDR	r0,r0,r0					;NOP

RECV_BYTE:
	ORI		r0,r17,UART_BASE_ADDR_H		;UART Base Address��λ16�ӥåȤ�r17�˥��å�
	SHLLI	r17,r17,16

	LDW		r17,r18,UART_STATUS_OFFSET	;STATUS��ȡ��
	ANDI	r18,r18,UART_RX_INTR_MASK
	BE		r0,r18,RECV_BYTE			;Receive Interrupt bit�����äƤ����RECV_BYTE��g��
	ANDR	r0,r0,r0					;NOP

	LDW		r17,r16,UART_DATA_OFFSET	;���ťǩ`�����i��

	LDW		r17,r18,UART_STATUS_OFFSET	;STATUS��ȡ��
	XORI	r18,r18,UART_RX_INTR_MASK
	STW		r17,r18,UART_STATUS_OFFSET	;Receive Interrupt bit�򥯥ꥢ

	JMP		r31							;���ӳ���Ԫ�ˑ���
	ANDR	r0,r0,r0					;NOP

WAIT_PUSH_SW:
	ORI		r0,r16,GPIO_BASE_ADDR_H
	SHLLI	r16,r16,16
_WAIT_PUSH_SW_ON:
	LDW		r16,r17,GPIO_IN_OFFSET
	BE		r0,r17,_WAIT_PUSH_SW_ON
	ANDR	r0,r0,r0					;NOP
_WAIT_PUSH_SW_OFF:
	LDW		r16,r17,GPIO_IN_OFFSET
	BNE		r0,r17,_WAIT_PUSH_SW_OFF
	ANDR	r0,r0,r0					;NOP
_WAIT_PUSH_SW_RETURN:
	JMP		r31
	ANDR	r0,r0,r0					;NOP
