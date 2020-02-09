900 rem "Fill screen with random characters"
1000 a = 8*256
1010 vpoke 0,a,random() and 255
1015 vpoke 0,a+1,random() and 15
1020 a = a + 2
1030 if a <> 44*256 then 1010
1100 vpoke 1,510,42
1110 x = vpeek(1,510)
1200 stop


