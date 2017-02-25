;--------------------
; Unsigned Compares
;--------------------
; CP	reg,	reg
;--------------------
cp		x,	y
brsh 	(x >= y)

cp		y,	x
brsh	(x <= y)

cp		x,	y
brlo	(x < y)

cp		y,	x
brlo	(x > y)
;----------------------
; CPI	reg,	const
;----------------------
cpi		x,	K
brsh 	(x >= K)

cpi		x,	K+1
brlo	(x <= K)

cpi		x,	K
brlo	(x < K)

cpi		x,	K+1
brsh 	(x > K)

;--------------------
; Signed Compares
;--------------------
; CP	reg,	reg
;--------------------
cp		x,	y
brge 	(x >= y)

cp		y,	x
brge	(x <= y)

cp		x,	y
brlt	(x < y)

cp		y,	x
brlt	(x > y)
;----------------------
; CPI	reg,	const
;----------------------
cpi		x,	K
brge 	(x >= K)

cpi		x,	K+1
brlt	(x <= K)

cpi		x,	K
brlt	(x < K)

cpi		x,	K+1
brge 	(x > K)