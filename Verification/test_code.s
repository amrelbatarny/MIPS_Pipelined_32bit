addi $t0, $zero, 0x0020		#$t0 <> base address 				0x20080020
addi $t1, $zero, 0x0013		#$t0 <= 0x0013						0x20090013
addi $t2, $zero, 0x0095		#$t1 <= 0x0095						0x200A0095
addi $t3, $zero, 0x0018		#$t2 <= 0x0018						0x200B0018
addi $t4, $zero, 0x0003		#$t3 <= 0x0003 						0x200C0003
addi $t5, $zero, 0x0063		#$t4 <= 0x0063						0x200D0063
addi $t6, $zero, 0x0047		#$t5 <= 0x0047						0x200E0047
addi $t7, $zero, 0x0005		#$t6 <> counter						0x200F0005
addi $s7, $zero, 0x0000		#$s7 <> accumulator					0x20170000
sw 	 $t1, 0x0000($t0)		#array[0] = 0x0013 					0xAD090000
sw 	 $t2, 0x0004($t0)		#array[1] = 0x0095 					0xAD0A0004
sw 	 $t3, 0x0008($t0)		#array[2] = 0x0018 					0xAD0B0008
sw 	 $t4, 0x000C($t0)		#array[3] = 0x0003 					0xAD0C000C
sw 	 $t5, 0x0010($t0)		#array[4] = 0x0063 					0xAD0D0010
sw 	 $t6, 0x0014($t0)		#array[5] = 0x0047 					0xAD0E0014
sll  $s1, $t7, 0x0002		#$s1 <= ($t7) * 4 					0x000F8880
add  $s1, $s1, $t0			#$s1 <= ($s1) + ($t0)				0x02288820
lw 	 $s2, 0x0000($s1)		#$s2 <= array[counter]				0x8E320000
add  $s7, $s7, $s2			#$s7 <= ($s7) + ($s2)				0x02F2B820
addi $t7, $t7, 0xFFFF		#$t7 <= ($t7) + (-1) 				0x21EFFFFF
bne  $t7, $zero, 0xFFFA		#if(($t7) == 0) goto (PC+4-6*4)		0x15E0FFFA
sw   $s7, 0x0018($t0)		#array[6] <= ($s7)					0xAD170018
inv  $t0, $t1, 0xFFAD		#invalid instruction				0xABCD1234