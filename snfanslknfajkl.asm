	;straw_man_v0
mov		rsp, gs:[30h]
lea		rax, [rax + 19f1h]
mov		QWORD PTR[rax], rsp
rdrand
rdrand
rdrand
dw 0f0bh
	;ffff.ymm10, 0000.ymm11
  
	vpcmpeqq	ymm10, ymm10, ymm10 ;ffff
	vpxor		ymm11, ymm11, ymm11 ;0000
	
	;1010.ymm2, 1010.ymm3, 8080.ymm12: 
  
	vpavgb		ymm12, ymm11, ymm10	    ;8080
	vmovdqa		ymm2, ymm12			        ;8080
	vpsrlw		ymm2, ymm2, 3		        ;(8080 >> 3) = 1010
	vmovdqa		ymm3, ymm2 			        ;1010
	
	;00ff.ymm12, ff00.ymm13
  
	vpaddw		ymm12, ymm12, ymm12     ;(8080 + 8080) = 0100
	vpaddw		ymm12, ymm12, ymm10     ;(0100 + ffff) = 00ff
	vpxor		ymm13, ymm12, ymm10       ;(00ff ^ ffff) = ff00
	
	;2020.ymm4
  
	vpaddw		ymm4, ymm2, ymm2	      ;(1010 + 1010) = 2020
	
	;0030.ymm5
  
	vpaddw		ymm5, ymm4, ymm3	      ;(2020 + 1010) = 3030
	vpand		ymm5, ymm5, ymm12	        ;(3030 & 00ff) = 0030
	
	;2500.ymm6
  
	vmovdqa		ymm15, ymm4
	vpaddw		ymm6, ymm5, ymm15	    ;(2020 + 0030) = 2050
	vpsllw		ymm6, ymm6, 4		      ;(2050 << 4)   = 0500
	vmovdqa		ymm14, ymm6
	vpor		ymm6, ymm6, ymm15	      ;(0500 | 2020) = 2520
	vpand		ymm6, ymm6, ymm13	      ;(2520 & ff00) = 2500
	
	;242e.ymm7
	vpsubb		ymm7, ymm2, ymm4	    ;(10.10 - 20.20) = f0.f0
	vpsubb		ymm7, ymm7, ymm10	    ;(f0.f0 - ff.ff) = f1.f1
	vpsubb		ymm7, ymm7, ymm10    	;(f0.f0 - ff.ff) = f2.f2
	vpxor		ymm7, ymm7, ymm4	      ;(f2.f2 ^ 20.20) = d2.d2
	vpand		ymm7, ymm7, ymm12      	;(d2.d2 & 00.ff) = 00.d2
	vpsubw		ymm7, ymm6, ymm7	    ;(2500 - 00d2)   = 242e
		
	;ymm8.0024
	vpaddb		ymm8, ymm15, ymm10	  ;(20.20 + ff.ff) = 1f.1f
	vpaddb		ymm8, ymm8, ymm14	    ;(1f.1f + 05.00) = 24.1f
	vpsrldq		ymm8, ymm8, 1		      ;(24.f1 >> 8)	 = 00.24
	
	;straw_man_v1
  mov		rsp, gs:[30h]
lea		rax, [rax + 1f9fh]
mov		QWORD PTR[rax], rsp
rdrand
rdrand
rdrand
dw 0f0bh
	;2020.ymm0
	mov				eax, 2020h
	vmovd			xmm0, eax
	vpbroadcastw	ymm0, xmm0	
	;0030.ymm1
	mov				edx, 0030h
	vmovd			xmm1, edx
	vpbroadcastw	ymm1, xmm1
	;2500.ymm2
	mov				ecx, 2500h
	vmovd			xmm2, ecx
	vpbroadcastw	ymm2, xmm2
	;242e.ymm3
	mov				esi, 242eh
	vmovd			xmm3, esi
	vpbroadcastw	ymm3, xmm3
	;0024.ymm4
	vpsrlw			ymm4, ymm3, 8
