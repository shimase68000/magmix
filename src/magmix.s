****************************************************
*
*	mag mix
*
****************************************************

	.include	iocscall.mac
	.include	doscall.mac

****************************************************
	.text

start:
	lea	$10(a0),a0
	sub.l	a0,a1
	move.l	a1,-(sp)
	move.l	a0,-(sp)

	bsr	getparameter

	DOS	_SETBLOCK
	addq.l	#8,sp

	lea	file1(pc),a5
	bsr	putcg

	clr.l	-(sp)
	DOS	_SUPER
	addq.l	#4,sp
	move.l	d0,susp

	bsr	check_crtmode
	bsr	storegram
	tst.b	palsw
	beq	j0
	bsr	getpal
j0
	move.l	susp,-(sp)
	DOS	_SUPER
	addq.l	#4,sp

	lea	file2(pc),a5
	bsr	putcg

	clr.l	-(sp)
	DOS	_SUPER
	addq.l	#4,sp
	move.l	d0,susp

	bsr	check_crtmode
	bsr	margedata
	tst.b	palsw
	beq	j1
	bsr	putpal
j1
	move.l	susp,-(sp)
	DOS	_SUPER
	addq.l	#4,sp

	DOS	_EXIT

*--------------------------------------------------------

susp	ds.l	1

**********************************************************
*	check crt mode
**********************************************************
check_crtmode
	move.w	$E80028,d0
	and.w	#$0300,d0
	bne	crtmode_error
	rts

*********************************************************
*	get pal
*********************************************************
getpal
	bsr	vwait

	lea	$E82000,a0
	lea	palbuf(pc),a1
	moveq	#16-1,d0
getpal1
	move.w	(a0)+,(a1)+
	dbra	d0,getpal1

	rts

*********************************************************
*	put pal
*********************************************************
putpal
	bsr	vwait

	lea	$E82000,a0
	lea	palbuf(pc),a1
	moveq	#16-1,d0
putpal1
	move.w	(a1)+,(a0)+
	dbra	d0,putpal1

	rts

***************************************************
*	垂直帰線期間を待つ
***************************************************
vwait
	btst.b	#4,$E88001
	beq	vwait
vwait1
	btst.b	#4,$E88001
	bne	vwait1

	rts

*********************************************************
*	marge data
*********************************************************
margedata
	lea	$C0_0000,a0
	lea	grambuffer(pc),a1
	lea	colnum(pc),a3
	move.l	#512*1024,d0

margedata1
	move.b	(a1)+,d1
	move.b	d1,d2
	lsr.b	#4,d1

	move.l	a3,a2
colmask1_1
	move.b	(a2)+,d3
	bmi	colmask1_3
	cmp.b	d3,d1
	bne	colmask1_1
colmask1_2
	addq.l	#2,a0
	bra	colmask1_4
colmask1_3
	move.w	d1,(a0)+
colmask1_4

	move.b	d2,d1
	and.b	#$F,d1

	move.l	a3,a2
colmask2_1
	move.b	(a2)+,d3
	bmi	colmask2_3
	cmp.b	d3,d1
	bne	colmask2_1
colmask2_2
	addq.l	#2,a0
	bra	colmask2_4
colmask2_3
	move.w	d1,(a0)+
colmask2_4

	subq.l	#1,d0
	bne	margedata1

	rts

*********************************************************
*	store gram
*********************************************************
storegram
	lea	$C0_0000,a0
	lea	grambuffer(pc),a1
	move.l	#512*1024/4,d0

storegram1
	move.w	(a0)+,d1
	lsl.w	#4,d1
	or.w	(a0)+,d1
	move.b	d1,(a1)+

	move.w	(a0)+,d1
	lsl.w	#4,d1
	or.w	(a0)+,d1
	move.b	d1,(a1)+

	move.w	(a0)+,d1
	lsl.w	#4,d1
	or.w	(a0)+,d1
	move.b	d1,(a1)+

	move.w	(a0)+,d1
	lsl.w	#4,d1
	or.w	(a0)+,d1
	move.b	d1,(a1)+

	subq.l	#1,d0
	bne	storegram1

	rts

*********************************************************
*	putcg
*********************************************************
putcg
	lea	defaultcommand(pc),a6

	pea	envbuf(pc)
	clr.l	-(sp)
	pea	env(pc)
	DOS	_GETENV
	lea	12(sp),sp

	tst.l	d0
	bmi	putcg1

	lea	envbuf(pc),a6

putcg1
	lea	fil(pc),a1
putcg1_1
	move.b	(a6)+,(a1)+
	bne	putcg1_1

	move.b	#' ',-1(a1)

putcg1_2
	move.b	(a5)+,(a1)+
	bne	putcg1_2

	clr.l	-(sp)
	pea	p1(pc)
	pea	fil(pc)
	move.w	#2,-(sp)
	DOS	_EXEC
	lea	14(sp),sp

	tst.l	d0
	bne	proc_notfound

	clr.l	-(sp)
	pea	p1(pc)
	pea	fil(pc)
	move.w	#0,-(sp)
	DOS	_EXEC
	lea	14(sp),sp

	tst.l	d0
	bne	proc_error

	rts

*********************************************************
*	get parameter
*********************************************************
getparameter
	move.b	(a2)+,d0	* 
	beq	non_para

	lea	colnum(pc),a0
	lea	file1(pc),a1

	move.b	#$FF,(a0)

getpara
	move.b	(a2)+,d0
	beq	para_end
	cmp.b	#'/',d0
	beq	getpara1
	cmp.b	#'-',d0
	beq	getpara1
getpara0
	tst.b	(a1)
	bne	para_error
getpara0_1
	move.b	d0,(a1)+
	move.b	(a2)+,d0
	beq	para_end
	cmp.b	#$20,d0
	bhi	getpara0_1

	clr.b	(a1)			* end mark

	lea	file2(pc),a1
	bra	getpara

getpara1
	move.b	(a2)+,d0
	beq	para_end

	cmp.b	#'h',d0
	beq	para_help
	cmp.b	#'H',d0
	beq	para_help
	cmp.b	#'?',d0
	beq	para_help

	cmp.b	#$30,d0
	bcs	getpara

	cmp.b	#$60,d0
	bcs	getpara1_1
	sub.b	#$20,d0
getpara1_1
	cmp.b	#'P',d0
	bne	getpara1_3
	move.b	#-1,palsw
	bra	getpara1

getpara1_3
	cmp.b	#'0',d0		* 0..9 ?
	bcs	para_error
	cmp.b	#'9',d0
	bhi	getpara1_2
	sub.b	#'0',d0
	move.b	d0,(a0)+
	bra	getpara1

getpara1_2
	cmp.b	#'A',d0		* A..Z ?
	bcs	para_error
	cmp.b	#'F',d0
	bhi	para_error
	sub.b	#'A'-10,d0
	move.b	d0,(a0)+
	bra	getpara1

para_end
	move.b	#$FF,(a0)
	rts

*********************************************************
non_para
para_help
	pea	mes0(pc)
	DOS	_PRINT
	DOS	_EXIT

*--------------------------------------------------------
para_error
	pea	mes1(pc)
	DOS	_PRINT
	DOS	_EXIT

*--------------------------------------------------------
proc_notfound
	pea	mes2(pc)
	DOS	_PRINT
	DOS	_EXIT

*--------------------------------------------------------
proc_error
	pea	mes3(pc)
	DOS	_PRINT
	DOS	_EXIT

*--------------------------------------------------------
crtmode_error
	pea	mes4(pc)
	DOS	_PRINT
	DOS	_EXIT

*--------------------------------------------------------

mes0	.dc.b	'MAG MIXER version 0.06 Copyright 1993 UG.',13,10
	.dc.b	'usage: MAGMIX /color[p] upper_file lower_file',13,10
	.dc.b	'switch: /p   upper_file のパレットを使用する',13,10,13,10
	.dc.b	'実行ファイルは環境変数 magmix を参照します。',13,10,0
mes1	.dc.b	'パラメータが異常です。',13,10,0
mes2	.dc.b	'実行ファイルが見つかりません。',13,10,0
mes3	.dc.b	'エラーが発生しました。作業を中断します。',13,10,0
mes4	.dc.b	'画面モードが違います。（16色モードのみ対応）',13,10,0

*********************************************************

		.data

env		.dc.b	'magmix',0
defaultcommand	.dc.b	'magl /r0 /c',0

		.bss

palbuf		.ds.w	16
palsw		.dc.b	0
colnum		.ds.b	16+1

file1		.ds.b	128
file2		.ds.b	128
fil		.ds.b	256

envbuf		.ds.b	256
p1		.ds.b	256
grambuffer	.ds.b	512*1024



