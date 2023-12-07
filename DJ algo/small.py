bot=[0,5,1,6,7,8,9]
s_i = 0

for num in range(6):  
    print(bot)  
    small = bot[0]
    for a in range(7):
        if bot[a] < small:
            small = bot[a]
            s_i = a
    print("small value is",small)
    print("small value index",s_i)
    bot[s_i]=12
